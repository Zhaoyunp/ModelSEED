########################################################################
# ModelSEED::MS::DB::FBAReactionConstraint - This is the moose object corresponding to the FBAReactionConstraint object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-05-05T02:39:57
########################################################################
use strict;
use ModelSEED::MS::BaseObject;
package ModelSEED::MS::DB::FBAReactionConstraint;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::fbaformulation_uuid', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has reaction_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed' );
has variableType => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', required => 1 );
has max => ( is => 'rw', isa => 'Num', type => 'attribute', metaclass => 'Typed', default => '0' );
has min => ( is => 'rw', isa => 'Num', type => 'attribute', metaclass => 'Typed', default => '0' );




# LINKS:
has modelreaction => (is => 'rw',lazy => 1,builder => '_buildmodelreaction',isa => 'ModelSEED::MS::ModelReaction', type => 'link(Model,ModelReaction,uuid,modelreaction_uuid)', metaclass => 'Typed',weak_ref => 1);


# BUILDERS:
sub _buildmodelreaction {
	my ($self) = @_;
	return $self->getLinkedObject('Model','ModelReaction','uuid',$self->modelreaction_uuid());
}


# CONSTANTS:
sub _type { return 'FBAReactionConstraint'; }


__PACKAGE__->meta->make_immutable;
1;