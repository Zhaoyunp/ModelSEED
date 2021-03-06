#!/usr/bin/perl 
use strict;
use warnings;
use Pod::Simple::Search;
use Pod::Select;
use File::Temp qw(tempfile);

my $usage = <<HEREDOC;
exportPodWiki export/directory

Reads from \@INC and finds packages beginning with ModelSEED::*
that contain POD documentation.  Converts that documentation to a
format good for the Github wiki and writes those files to
"export/directory". MANY files are inetntionally excluded.  See
code for details.

HEREDOC

my $dest   = shift @ARGV;
die $usage unless(defined($dest) && -d $dest);

# Ignore packages that match these regexes
my $ignores = [
    qr/::DB::.*/,                # DB implementation classes
    qr/::Scripts.*/,             # Scripts
    qr/::App.*/,                 # App hierarchy
    qr/::[a-z]/,                 # any non-class object
    qr/::ModelSEEDUtilities.*/,  # Utilities (Legacy)
    qr/[Uu]tilities/,               # anything with utilities
];
# Get the initial set
my $name2path = Pod::Simple::Search->new->limit_glob('ModelSEED::*')->survey;
# Filter out all ignores
foreach my $name (sort keys %$name2path ) {
    foreach my $ignore (@$ignores) {
        if($name =~ /$ignore/) {
            delete $name2path->{$name};
            last;
        }
    }
}
# Define the rename settings
my $name2rename = {};
foreach my $name ( keys %$name2path ) {
    my $rename = $name;
    $rename =~ s/::/-/g;
    $name2rename->{$name} = $rename;
}
# Print output for each package now
foreach my $name (keys %$name2path) {
    my $path = $name2path->{$name};
    # Get the raw POD
    my $parser = Pod::Select->new();
    my $tmpfile;
    {
        my $fh;
        ($fh, $tmpfile) = tempfile();
        close($fh);
    }
    $parser->parse_from_file($path, $tmpfile);
    open(my $fh, "<", $tmpfile);
    my $rows = processPackageLinks($fh, $name2rename);
    $rows = highlightSyntax($rows);
    $rows = cutHead1($rows);
    close($fh);
    my $finalPath = "$dest/".$name2rename->{$name}.".pod";
    unlink $finalPath;
    next unless(@$rows);
    open($fh, ">", $finalPath);
    print $fh @$rows;
    close($fh);
}

sub processPackageLinks {
    my ($filehandle, $packageConversions) = @_;
    my $rtv = [];
    while (<$filehandle>) {
        my $line = $_;
        my $newline = $line;
        while ($line =~ m/L<([^>]+)>/g) {
            my $oldLink = $&;
            $oldLink =~ s/\|//g;
            my ($text, $link) = split(/\|/, $1);
            if (!defined($link)) {
                $link = $text;
                $text = undef;
            }
            if(defined($packageConversions->{$link})) {
                $text = $link;
                $link = $packageConversions->{$link};
            }
            my $newLink;
            if($text) {
                $newLink = "[[$text|$link]]";
            } else {
                $newLink = "[[$link]]";
            }
            $newline =~ s/$oldLink/$newLink/;
        }
        push(@$rtv, $newline);
    }
    return $rtv;
}

sub highlightSyntax {
    my ($rows) = @_;
    my $out = [];
    my $l   = @$rows;
    my $prev;
    for(my $i=0; $i<$l; $i++) {
        if($rows->[$i] =~ /^(\s+)\S+/) {
            my $count = length $1;
            push(@$out, "```perl\n");
            while($rows->[$i] =~ /^\s{$count}/ && $i < $l) {
                push(@$out, $rows->[$i]);
                $i += 1;
            }
            $i -= 1 unless $i == $l;
            push(@$out, "```\n");
            push(@$out, "\n");
        } else {
            push(@$out, $rows->[$i]);
        }
    }
    return $out;
}

sub cutHead1 {
    my ($rows) = @_;
    my $out = [];
    foreach my $row (@$rows) {
        push(@$out, $row) unless $row =~ m/^=head1/;
    }
    return $out;
}

