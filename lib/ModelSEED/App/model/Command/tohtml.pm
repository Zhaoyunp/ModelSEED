package ModelSEED::App::model::Command::tohtml;
use strict;
use common::sense;
use ModelSEED::App::model;
use base 'ModelSEED::App::ModelBaseCommand';
use ModelSEED::utilities;
sub abstract { return "Prints a readable format for the object" }
sub usage_desc { return "model tohtml [model id]" }
sub options {
    return ();
}
sub sub_execute {
    my ($self, $opts, $args,$model) = @_;
	my $format = shift @$args;
    ModelSEED::utilities::error("Must specify format for model export") unless(defined($format));
    print $model->createHTML();
}

1;
