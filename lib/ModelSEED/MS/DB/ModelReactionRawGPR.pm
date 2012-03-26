########################################################################
# ModelSEED::MS::DB::ModelReactionRawGPR - This is the moose object corresponding to the ModelReactionRawGPR object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-03-23T06:50:05
########################################################################
use strict;
use namespace::autoclean;
use ModelSEED::MS::BaseObject;
use ModelSEED::MS::ModelReaction;
package ModelSEED::MS::DB::ModelReactionRawGPR;
use Moose;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw',isa => 'ModelSEED::MS::ModelReaction', type => 'parent', metaclass => 'Typed',weak_ref => 1);


# ATTRIBUTES:
has model_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has modelreaction_uuid => ( is => 'rw', isa => 'ModelSEED::uuid', type => 'attribute', metaclass => 'Typed', required => 1 );
has isCustomGPR => ( is => 'rw', isa => 'Int', type => 'attribute', metaclass => 'Typed', default => '1' );
has rawGPR => ( is => 'rw', isa => 'Str', type => 'attribute', metaclass => 'Typed', default => 'UNKNOWN' );




# BUILDERS:


# CONSTANTS:
sub _type { return 'ModelReactionRawGPR'; }


__PACKAGE__->meta->make_immutable;
1;