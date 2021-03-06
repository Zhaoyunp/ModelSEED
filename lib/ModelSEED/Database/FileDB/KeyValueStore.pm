package ModelSEED::Database::FileDB::KeyValueStore;

use Moose;
use namespace::autoclean;

use JSON::XS;
use File::Path qw(make_path);
#use File::stat; # for testing mod time
use Fcntl qw( :flock );
use IO::Compress::Gzip qw(gzip);
use IO::Uncompress::Gunzip qw(gunzip);
use Scalar::Util qw(looks_like_number);

# versioning used to distinguish changes in data format
my $DATA_VERSION = '0.50';

# TODO:
# * Figure out better way to handle delimiters (for querying into metadata: aliases.main)
#     - for now changed from '.' to '..' to avoid conflicts
# * Put index file back in memory (stored in moose object)
#     - test if changed via mod time and size
#     - should speed up data access (as long as index hasn't changed)
#     - would this work with the locking?
# * Check for .tmp file in BUILD, if it exists then the previous index was not saved
# * Make version updating atomic
#     - right now if a user cancels during an update the data could be corrupted
#     - maybe this will be ok if the individual updates create tmp files and overwrite
#        should probably not do this in the default transaction, but a custom one
#     - shouldn't be a problem until (or if) we ever need to update the data

my $INDEX_EXT = 'ind';
my $META_EXT  = 'met';
my $DATA_EXT  = 'dat';
my $LOCK_EXT  = 'lock';

# External attributes (configurable)
has directory => (is => 'rw', isa => 'Str', required => 1);
has filename  => (is => 'rw', isa => 'Str', default => 'database');
has is_new    => (is => 'rw', isa => 'Bool');

# Index Structure
#    {
#        ids => { $id => [start, end] }
#        end_pos => int
#        num_del => int
#        ordered_ids => [id, id, id, ...]
#    }

sub BUILD {
    my ($self) = @_;

    my $dir = $self->directory;
    unless (-d $dir) {
	make_path($dir);
    }
    my $file = $self->_get_file();

    my $ind = -f "$file.$INDEX_EXT";
    my $met = -f "$file.$META_EXT";
    my $dat = -f "$file.$DATA_EXT";

    if ($ind && $met && $dat) {
        $self->is_new(0);

	# all exist, check versioning
        $self->_perform_transaction({
            index => 'w',
            data  => 'w',
            meta  => 'w' }, \&_check_version);
    } elsif (!$ind && !$met && !$dat) {
	# new database
        $self->is_new(1);
	my $index = _initialize_index();

	# use a semaphore to lock the files
	open my $LOCK, ">", "$file.$LOCK_EXT" or die "$!";
	flock $LOCK, LOCK_EX or die "";

	open my $INDEX, ">", "$file.$INDEX_EXT" or die "";
	print $INDEX _encode($index);
	close $INDEX;

	open my $META, ">", "$file.$META_EXT" or die "";
	print $META _encode({});
	close $META;

	open my $DATA, ">", "$file.$DATA_EXT" or die;
	close $DATA;

	close $LOCK;
    } else {
	die "Corrupted database: $file";
    }
}

sub _initialize_index {
    return {
	end_pos      => 0,
	num_del      => 0,
	ids          => {},
	ordered_ids  => [],
        data_version => $DATA_VERSION
    };
}

sub _get_file {
    my ($self) = @_;

    return $self->directory . '/' . $self->filename;
}

sub _perform_transaction {
    my ($self, $files, $sub, @args) = @_;

    # determine which files are required and the mode to open
    my $index_mode = $files->{index};
    my $meta_mode  = $files->{meta};
    my $data_mode  = $files->{data};

    my $file = $self->_get_file();

    # use a semaphore file for locking
    open my $LOCK, ">", "$file.$LOCK_EXT" or die "Couldn't open file: $!";

    # if we're only reading, get a shared lock, otherwise get exclusive
    if ((!defined($index_mode) || $index_mode eq 'r') &&
	(!defined($meta_mode)  || $meta_mode eq 'r') &&
	(!defined($data_mode)  || $data_mode eq 'r')) {

	flock $LOCK, LOCK_SH or die "Couldn't lock file: $!";
    } else {
	flock $LOCK, LOCK_EX or die "Couldn't lock file: $!";
    }

    # check for errors if last transaction died
    # TODO: implement

    # check if rebuild died between two rename statements

    # if (-f "$file.$DATA_EXT.tmp") {
    #     if (-f "$file.$INDEX_EXT.tmp") {
    #         # both exist, roll back transaction by deleting
    #         unlink "$file.$DATA_EXT.tmp";
    #         unlink "$file.$INDEX_EXT.tmp";
    #     } else {
    #         # index tmp has been copied but data has not
    #         rename "$file.$DATA_EXT.tmp", "$file.$DATA_EXT";
    #     }
    # }

    my $sub_data = {};
    my ($index, $meta, $data);
    if (defined($index_mode)) {
	open my $INDEX, "<", "$file.$INDEX_EXT" or die "Couldn't open file: $!";
	$index = _decode(<$INDEX>);
	$sub_data->{index} = $index;
	close $INDEX;
    }

    if (defined($meta_mode)) {
	open my $META, "<", "$file.$META_EXT" or die "Couldn't open file: $!";
	$meta = _decode(<$META>);
	$sub_data->{meta} = $meta;
	close $META;
    }

    if (defined($data_mode)) {
	if ($data_mode eq 'r') {
	    open my $DATA, "<", "$file.$DATA_EXT" or die "Couldn't open file: $!";
	    binmode $DATA;
	    $data = $DATA;
	    $sub_data->{data} = $data;
	} elsif ($data_mode eq 'w') {
	    # open r/w, '+>' clobbers the file
	    open my $DATA, "+<", "$file.$DATA_EXT" or die "Couldn't open file: $!";
	    binmode $DATA;
	    $data = $DATA;
	    $sub_data->{data} = $data;
	}
    }

    my ($ret, $save) = $sub->($sub_data, @args);

    if (defined($data_mode)) {
	close $data;
    }

    # save files atomically by creating temp files and renaming
    if (defined($save)) {
	if ($save->{index}) {
	    if ($index_mode ne 'w') {
		die "Cannot write to index file, wrong permissions";
	    }

	    open my $INDEX_TEMP, ">", "$file.$INDEX_EXT.tmp" or die "Couldn't open file: $!";
	    print $INDEX_TEMP _encode($index);
	    close $INDEX_TEMP;
	    rename "$file.$INDEX_EXT.tmp", "$file.$INDEX_EXT";
	}

	if ($save->{meta}) {
	    if ($meta_mode ne 'w') {
		die "Cannot write to meta file, wrong permissions";
	    }

	    open my $META_TEMP, ">", "$file.$META_EXT.tmp" or die "Couldn't open file: $!";
	    print $META_TEMP _encode($meta);
	    close $META_TEMP;
	    rename "$file.$META_EXT.tmp", "$file.$META_EXT";
	}
    }

    close $LOCK;

    return $ret;
}

# check if the version of the data matches $DATA_VERSION
sub _check_version {
    my ($data, $id) = @_;

    my $ver = $data->{index}->{data_version};

    unless (defined($ver)) {
        $ver = '0';
    }

    if ($ver eq $DATA_VERSION) {
        return 1;
    } else {
        while ($ver ne $DATA_VERSION) {
            $ver = _update_data($ver, $data);

            if ($ver == -1) {
                # error with version number, throw error and exit
                die "Error, unknown version number encountered while updating data";
            }
        }
    }

    $data->{index}->{data_version} = $DATA_VERSION;

    return (1, { index => 1, meta => 1 });
}

# removes deleted objects from the data file
# this locks the database while rebuilding
# much duplicate logic here for locking, should be fixed
# with _perform_transaction rewrite

#sub rebuild_data {
#    my ($self) = @_;
#
#    # get locked filehandles for index and data files
#    my $file = $self->filename;
#
#    # use a semaphore to lock the files
#    open LOCK, ">$file.$LOCK_EXT" or die "";
#    flock LOCK, LOCK_EX or die "";
#
#    open INDEX, "<$file.$INDEX_EXT" or die "";
#    my $index = _decode(<INDEX>);
#    close INDEX;
#
#    if ($index->{num_del} == 0) {
#	# no need to rebuild
#	return 1;
#    }
#
#    open DATA, "<$file.$DATA_EXT" or die "";
#
#    # open INDEX_TEMP first
#    open INDEX_TEMP, ">$file.$INDEX_EXT.tmp" or die "";
#    open DATA_TEMP, ">$file.$DATA_EXT.tmp" or die "";
#
#    my $end = -1;
#    my $uuids = []; # new ordered uuid list
#    foreach my $uuid (@{$index->{ordered_uuids}}) {
#	if (defined($index->{uuid_index}->{$uuid})) {
#	    my $uuid_hash = $index->{uuid_index}->{$uuid};
#	    my $length = $uuid_hash->{end} - $uuid_hash->{start} + 1;
#
#	    # seek and read the object
#	    my $data;
#	    seek DATA, $uuid_hash->{start}, 0 or die "";
#	    read DATA, $data, $length;
#
#	    # set the new start and end positions
#	    $uuid_hash->{start} = $end + 1;
#	    $uuid_hash->{end} = $end + $length;
#
#	    # print object to temp file
#	    print DATA_TEMP $data;
#
#	    $end += $length;
#	    push(@$uuids, $uuid);
#	}
#    }
#
#    $end++;
#    $index->{num_del} = 0;
#    $index->{end_pos} = $end;
#    $index->{ordered_uuids} = $uuids;
#
#    close DATA;
#    close DATA_TEMP;
#
#    print INDEX_TEMP _encode($index);
#    close INDEX_TEMP;
#
#    # only point we could get corrupted is between next two statements
#    # in '_do_while_locked' check if .dat.tmp exists, but not .int.tmp
#    # if it does then indicates we failed here, so rename data
#    rename "$file.$INDEX_EXT.tmp", "$file.$INDEX_EXT";
#    rename "$file.$DATA_EXT.tmp", "$file.$DATA_EXT";
#
#    close LOCK;
#
#    return 1;
#}

sub has_object {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ index => 'r' },
				       \&_has_object, @args);
}

sub _has_object {
    my ($data, $id) = @_;

    if (defined($data->{index}->{ids}->{$id})) {
	return 1;
    } else {
	return 0;
    }
}

sub get_object {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ index => 'r', data => 'r' },
				       \&_get_object, @args);
}

sub _get_object {
    my ($data, $id) = @_;

    unless (_has_object($data, $id)) {
		return;
    }

    my $start = $data->{index}->{ids}->{$id}->[0];
    my $end   = $data->{index}->{ids}->{$id}->[1];
    # print $start.":".$end."\n";

    my $data_fh = $data->{data};
    my ($json_obj, $gzip_obj);
    seek $data_fh, $start, 0 or die "Couldn't seek file: $!";
    read $data_fh, $gzip_obj, ($end - $start + 1);
    gunzip \$gzip_obj => \$json_obj;
    return _decode($json_obj)
}

sub save_object {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ index => 'w', data => 'w', meta => 'w' },
				       \&_save_object, @args);
}

sub _save_object {
    my ($data, $id, $object, $is_overwrite) = @_;
	if (!$is_overwrite && _has_object($data, $id)) {
	    return 0;
    }
    my $json_obj;
    my $ref = ref($object);
    if ($ref eq 'ARRAY' || $ref eq 'HASH') {
	$json_obj = _encode($object);
    } else {
	$json_obj = $object;
    }

    my $gzip_obj;

    gzip \$json_obj => \$gzip_obj;

    my $data_fh = $data->{data};
    my $start = $data->{index}->{end_pos};
    seek $data_fh, $start, 0 or die "Couldn't seek file: $!";
    print $data_fh $gzip_obj;

    $data->{index}->{ids}->{$id} = [$start, $start + length($gzip_obj) - 1];
    push(@{$data->{index}->{ordered_ids}}, $id);
    $data->{index}->{end_pos} = $start + length($gzip_obj);

    $data->{meta}->{$id} = {};

    return (1, { index => 1, meta => 1 });
}

sub delete_object {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ index => 'w', meta => 'w' },
				       \&_delete_object, @args);
}

sub _delete_object {
    my ($data, $id) = @_;

    unless (_has_object($data, $id)) {
	return 0;
    }

    # should we rebuild the database every once in a while?
    delete $data->{index}->{ids}->{$id};
    $data->{index}->{num_del}++;

    delete $data->{meta}->{$id};

    return (1, { index => 1, meta => 1 });
}

sub get_metadata {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ meta => 'r' },
				       \&_get_metadata, @args);
}

sub _get_metadata {
    my ($data, $id, $selection) = @_;

    my $meta = $data->{meta}->{$id};
    unless (defined($meta)) {
	# no object with id
	return;
    }

    if (!defined($selection) || $selection eq "") {
	return $meta;
    }

    my @path = split(/\.\./, $selection);
    my $last = pop(@path);

    # search through hash for selection
    my $inner_hash = $meta;
    for (my $i=0; $i<scalar @path; $i++) {
	my $cur = $path[$i];
	unless (ref($inner_hash->{$cur}) eq 'HASH') {
	    return;
	}
	$inner_hash = $inner_hash->{$cur};
    }

    unless (exists($inner_hash->{$last})) {
	return;
    }

    return $inner_hash->{$last};
}

sub set_metadata {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ meta => 'w' },
				       \&_set_metadata, @args);
}

sub _set_metadata {
    my ($data, $id, $selection, $metadata) = @_;

    my $meta = $data->{meta}->{$id};
    unless (defined($meta)) {
	# no object with id
	return 0;
    }

    if (!defined($selection) || $selection eq "") {
	if (ref($metadata) eq "HASH") {
	    $data->{meta}->{$id} = $metadata;
	    return (1, { meta => 1 });
	} else {
	    return 0;
	}
    }

    my @path = split(/\.\./, $selection);
    my $last = pop(@path);
    my $inner_hash = $meta;
    for (my $i=0; $i<scalar @path; $i++) {
	my $cur = $path[$i];

	if (ref($inner_hash->{$cur}) ne 'HASH') {
	    $inner_hash->{$cur} = {};
	}
	$inner_hash = $inner_hash->{$cur};
    }

    $inner_hash->{$last} = $metadata;

    return (1, { meta => 1 });
}

sub remove_metadata {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ meta => 'w' },
				       \&_remove_metadata, @args);
}

sub _remove_metadata {
    my ($data, $id, $selection) = @_;

    my $meta = $data->{meta}->{$id};
    unless (defined($meta)) {
	# no object with id
	return 0;
    }

    if (!defined($selection) || $selection eq "") {
	$data->{meta}->{$id} = {};
	return (1, { meta => 1 });
    }

    my @path = split(/\.\./, $selection);
    my $last = pop(@path);
    my $inner_hash = $meta;
    for (my $i=0; $i<scalar @path; $i++) {
	my $cur = $path[$i];
	if (ref($inner_hash->{$cur}) ne 'HASH') {
	    return 0;
	}
	$inner_hash = $inner_hash->{$cur};
    }

    unless (exists($inner_hash->{$last})) {
	return 0;
    }

    delete $inner_hash->{$last};

    return (1, { meta => 1 });
}

sub find_objects {
    my ($self, @args) = @_;

    return $self->_perform_transaction({ meta => 'r' },
				       \&_find_objects, @args);
}

# reimplement
sub _find_objects {
    my ($data, $query) = @_;

    my $ids = [];

    if (!defined($query)) {
        $query = {};
    } elsif (ref($query) ne 'HASH') {
        return [];
    }

    # loop through object metadata
    foreach my $id (keys %{$data->{meta}}) {
        my $meta = $data->{meta}->{$id};
        my $match = 1;

        foreach my $field (keys %$query) {
            unless ($match) {
                last;
            }

            # check if it's nested
            my @path = split(/\.\./, $field);
            my $last = pop(@path);
            my $inner_hash = $meta;
            for (my $i=0; $i<scalar @path; $i++) {
                my $cur = $path[$i];
                if (ref($inner_hash->{$cur}) ne 'HASH') {
                    $match = 0;
                    last;
                }
                $inner_hash = $inner_hash->{$cur};
            }

            unless ($match && exists($inner_hash->{$last})) {
                $match = 0;
                last;
            }

            my $value = $inner_hash->{$last};

            # determine if value is string or number
            my $is_num = looks_like_number($value);

            # now check if it matched
            if (ref($query->{$field}) eq 'HASH') {
                # comparison
                my $multi_match = 1;
                foreach my $comp (keys %{$query->{$field}}) {
                    unless ($multi_match) {
                        last;
                    }

                    my $comp_to = $query->{$field}->{$comp};
                    if ($is_num) {
                        if ($comp eq '$gt') {
                            $multi_match = $value > $comp_to;
                        } elsif ($comp eq '$gte') {
                            $multi_match = $value >= $comp_to;
                        } elsif ($comp eq '$lt') {
                            $multi_match = $value < $comp_to;
                        } elsif ($comp eq '$lte') {
                            $multi_match = $value <= $comp_to;
                        }
                    } else {
                        if ($comp eq '$gt') {
                            $multi_match = $value gt $comp_to;
                        } elsif ($comp eq '$gte') {
                            $multi_match = $value ge $comp_to;
                        } elsif ($comp eq '$lt') {
                            $multi_match = $value lt $comp_to;
                        } elsif ($comp eq '$lte') {
                            $multi_match = $value le $comp_to;
                        }
                    }
                }

                if (!$multi_match) {
                    $match = 0;
                }
            } else {
                if ($is_num) {
                    if ($value != $query->{$field}) {
                        $match = 0;
                    }
                } else {
                    if ($value ne $query->{$field}) {
                        $match = 0;
                    }
                }
            }
        }

        if ($match) { # check query
            push(@$ids, $id);
        }
    }

    return $ids;
}

sub _sleep_test {
    my ($self, $time) = @_;

    $self->_do_while_locked(sub {
	my ($time, $index, $data_fh) = @_;
	my $sleep = sleep $time;
    }, $time);
}

sub _encode {
    my ($data) = @_;

    return encode_json($data);
}

sub _decode {
    my ($data) = @_;

    return decode_json($data);
}

# updates to data format go here
sub _update_data {
    my ($ver, $data) = @_;

    if ($ver eq '0') {
        # no changes to data format since creation of module
        return $DATA_VERSION;
    } else {
        return -1;
    }

    # example updates:
    #   between version 0 and 0.50 we didn't change anything
    #   between version 0.50 and 0.60 we changed index 'ids' to 'uuids',
    #   between version 0.60 and current version we edit the data
    #
    # if ($ver eq '0') {
    #     return '0.50';
    # } elsif ($ver eq '0.50') {
    #     my $index = $data->{index};
    #     $index->{uuids} = $index->{ids};
    #     delete $index->{ids};
    #     return '0.60';
    # } elsif ($ver eq '0.60') {
    #     # edit data here...
    #     return $DATA_VERSION;
    # } else {
    #     return -1;
    # }
}

no Moose;
__PACKAGE__->meta->make_immutable;
