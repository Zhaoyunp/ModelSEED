package ModelSEED::App::mseed::Command::createuser;
use strict;
use common::sense;

use Module::Load;
use Try::Tiny;
use Term::ReadKey;
use Class::Autouse qw(ModelSEED::Configuration);
use base 'App::Cmd::Command';

use Data::Dumper;

sub abstract { return "Creates a local user account"; }
sub usage_desc { return "ms createuser [username] [options]"; }
sub opt_spec {
    return (
        ["firstname|f=s", "First name for user"],
        ["lastname|l=s", "Last name for user"],
        ["email|e=s", "Email for user"],
        ["help|h|?", "Print this usage information"],
    );
}

sub execute {
    my ($self, $opts, $args) = @_;
    print($self->usage) && exit if $opts->{help};
    my $username = $args->[0];
    my $conf = ModelSEED::Configuration->new();
    if (!defined($username) || length($username) == 0) {
    	$self->usage_error("Must provide username!");
    } elsif (defined($conf->config->{users}->{$username})) {
    	#$self->usage_error("Specified username already exists!");
    }
    print "Enter password: ";
    ReadMode 2;
    my $password = ReadLine 0;
    ReadMode 0;
    chomp($password);
    print "\n";
	if (!defined($password) || length($password) == 0) {
    	$self->usage_error("Must provide nonempty password!");
    }
    my $salt = join '', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64];
    $password = crypt($password, $salt);
    # create a user object
    my $user = {
		login => $username,
		password => $password,
		firstname => $opts->{firstname},
		lastname => $opts->{lastname},
		email => $opts->{email}
    };
    $conf->config->{users}->{$username} = $user;
    $conf->save();

    print "Successfully created user '$username'\n";
}

1;
