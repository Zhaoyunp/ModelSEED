package ModelSEED::App::genome::Command::readable;
use strict;
use common::sense;
use base 'App::Cmd::Command';
use Class::Autouse qw(
    ModelSEED::Store
    ModelSEED::Auth::Factory
    ModelSEED::App::Helpers
);
sub abstract { return "Prints a readable format for the object" }
sub usage_desc { return "genome readable [< name | name]" }
sub opt_spec { return (
        ["help|h|?", "Print this usage information"],
    );
}
sub execute {
    my ($self, $opts, $args) = @_;
    print($self->usage) && exit if $opts->{help};
    my $auth  = ModelSEED::Auth::Factory->new->from_config;
    my $store = ModelSEED::Store->new(auth => $auth);
    my $helper = ModelSEED::App::Helpers->new();
    my ($annotation, $annoRef) = $helper->get_object("annotation", $args, $store);
    $self->usage_error("Must specify an annotation to use") unless(defined($annotation));
    print $annotation->toReadableString();
}
1;
