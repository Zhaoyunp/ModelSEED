package ModelSEED::App::mseed::Command::login;
use strict;
use common::sense;

use Module::Load;
use Try::Tiny;
use Term::ReadKey;
use Class::Autouse qw(
    ModelSEED::Configuration
    ModelSEED::Client::MSAccountManagement
);
use base 'App::Cmd::Command';

sub abstract { "Login as a user" }
sub usage { "%c COMMAND [username]" }
sub validate_args {
    my ($self, $opts, $args) = @_;
    $self->usage_error("Need to supply a username") unless @$args;
}
sub opt_spec { return (
        ["help|h|?", "Print this usage information"],
    );
}

sub execute {
    my ($self, $opts, $args) = @_;
    print($self->usage) && exit if $opts->{help};
    my $username = $args->[0];

    my $password;
    print "Enter password: ";
    if ($^O =~ m/^MSWin/) {
    	$password = <STDIN>;#Please don't remove this unless you've tested that it works in windows... readkey didn't work
    } else {
   		ReadMode 2;
    	$password = ReadLine 0;
    	ReadMode 0;
    	chomp($password);
    }
    print "\n";

    my $conf = ModelSEED::Configuration->new();
    my $users = $conf->config->{users};
    my $user;
    if (defined($users->{$username})) {
	$user = $users->{$username};

	unless ($self->check_password($user, $password)) {
	    print "Invalid password.\n";
	    exit;
	}
    } else {
	$user = $self->import_seed_account($username, $password, $conf);
    }

    $conf->config->{login} = {
	username => $username,
	password => $user->{password}
    };
    $conf->save();

    print "Successfully logged in as '$username'\n";
}

sub import_seed_account {
    my ($self, $username, $password, $conf) = @_;

    # get the user data
    my $svr = ModelSEED::Client::MSAccountManagement->new();

    my $output;
    try {
	$output = $svr->get_user_info({ username => $username });
    } catch {
	die "Error in communicating with SEED authorization service.";
    };

    if (defined($output->{error})) {
	print $output->{error}, "\n";
	exit;
    }

    # create a user object
    my $user = {
	login => $output->{username},
	password => $output->{password},
	firstname => $output->{firstname},
	lastname => $output->{lastname},
	email => $output->{email},
    };

    # check the password
    if (!$self->check_password($user, $password)) {
	print "Invalid password.\n";
	exit;
    }

    $conf->config->{users}->{$username} = $user;

    return $user;
}

sub check_password {
    my ($self, $user, $password) = @_;

    if (crypt($password, $user->{password}) eq $user->{password}) {
	return 1;
    } else {
	return 0;
    }
}

1;
