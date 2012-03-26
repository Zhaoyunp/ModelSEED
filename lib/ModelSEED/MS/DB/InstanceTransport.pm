########################################################################
# ModelSEED::MS::DB::InstanceTransport - This is the moose object corresponding to the InstanceTransport object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-03-23T06:50:05
########################################################################
use strict;
use namespace::autoclean;
use ModelSEED::MS::BaseObject;
use ModelSEED::MS::ReactionInstance;
use ModelSEED::MS::Compound;
use ModelSEED::MS::Compartment;
package ModelSEED::MS::DB::InstanceTransport;
use Moose;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::ReactionInstance', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has reactioninstance_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has compound_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has compartment_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has compartmentIndex => ( is => 'rw', isa => 'Int', type => 'attribute', metaclass => 'Typed', required => 1 );
has coefficient => ( is => 'rw', isa => 'Int', type => 'attribute', metaclass => 'Typed', required => 1 );




# LINKS:
has compound => (is => 'rw',lazy => 1,builder => '_buildcompound',isa => 'ModelSEED::MS::Compound', type => 'link(Biochemistry,Compound,uuid,compound_uuid)', metaclass => 'Typed',weak_ref => 1);
has compartment => (is => 'rw',lazy => 1,builder => '_buildcompartment',isa => 'ModelSEED::MS::Compartment', type => 'link(Biochemistry,Compartment,uuid,compartment_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildcompound {
	my ($self) = @_;
	return $self->getLinkedObject('Biochemistry','Compound','uuid',$self->compound_uuid());
}
sub _buildcompartment {
	my ($self) = @_;
	return $self->getLinkedObject('Biochemistry','Compartment','uuid',$self->compartment_uuid());
}


# CONSTANTS:
sub _type { return 'InstanceTransport'; }


__PACKAGE__->meta->make_immutable;
1;