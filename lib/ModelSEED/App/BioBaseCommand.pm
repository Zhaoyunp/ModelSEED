package ModelSEED::App::BioBaseCommand;
use strict;
use common::sense;
use base 'ModelSEED::App::BaseCommand';
use Class::Autouse qw(
    ModelSEED::MS::Biochemistry
);
sub parent_options {
    my ( $class, $app ) = @_;
    return (
	[ 'saveas=s' => "Save object with a new name" ],
        $class->options($app),
    );
}

sub class_execute {
    my ($self, $opts, $args) = @_;
    my $id = shift @$args;
	unless (defined($id)) {
        $self->usage_error("Must provide ID of biochemistry");
    }
    if ($id !~ m/^Biochemistry\//) {
    	$id = "Biochemistry/".$id;
    }
   	my $obj = $self->get_object({
   		type => "Biochemistry",
   		reference => $id,
   		store => $opts->{store}
   	});
    return $self->sub_execute($opts, $args,$obj);
}

sub save_bio {
	my ($self,$obj) = @_;
	my $ref = $obj->msStoreID();
    if ($self->opts()->{saveas}) {
    	my $newid = $self->opts()->{saveas};
    	$ref =~ s/\/[^\/]+$/\/$newid/;
    	ModelSEED::utilities::verbose("New alias set for bio:".$ref);
    }
    ModelSEED::utilities::verbose("Saving bio to:".$ref);
    $self->save_object({
	   	type => "Biochemistry",
	   	reference => $ref,
	   	store => $self->opts()->{store},
		object => $obj
    });
}

1;
