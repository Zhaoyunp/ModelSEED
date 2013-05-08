package ModelSEED::App::mseed::Command::createuser;
use strict;
use common::sense;
use Term::ReadKey;
use Module::Load;
use Try::Tiny;
use Data::Dumper;
use ModelSEED::utilities qw( config args verbose set_verbose translateArrayOptions);
use base 'ModelSEED::App::MSEEDBaseCommand';

sub abstract { return "Creates a local user account"; }

sub usage_desc { return "ms createuser [username] [options]"; }

sub options {
    return (
    	["firstname|f=s", "First name for user"],
        ["lastname|l=s", "Last name for user"],
        ["email|e=s", "Email for user"],
    	["password|p=s", "Provide password on command line"],
    );
}

sub sub_execute {
    my ($self, $opts, $args) = @_;
	my $username = shift @$args;
    if (!defined($username) || length($username) == 0) {
    	error("Must provide username!");
    }
    my $config = config();
    if (defined($config->queryObject("users",{login => $username}))) {
    	error("Specified username already exists!");
    }
    my $password;
    if (!defined($opts->{password})) {
	    print "Enter password: ";
	    ReadMode 2;
	    my $password = ReadLine 0;
	    ReadMode 0;
	    chomp($password);
	    print "\n";
    } else {
    	$password = $opts->{password};
    }
	if (!defined($password) || length($password) == 0) {
    	error("Must provide nonempty password!");
    }
    my $salt = join '', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64];
    $password = crypt($password, $salt);
    my $userdata = {
		login => $username,
		password => $password
    };
    my $items = [qw(firstname lastname email)];
    foreach my $item (@{$items}) {
    	if (defined($opts->{$item})) {
    		$userdata->{$item} = $opts->{$item};
    	}
    }
    $config->add("users",$userdata);
    if (!defined($opts->{dryrun})) {
		$config->save_to_file();
	}
    print "Successfully created user '$username'\n";
	return;
}

1;