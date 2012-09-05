########################################################################
# ModelSEED::MS::DB::GapgenSolution - This is the moose object corresponding to the GapgenSolution object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::GapgenSolution;
use ModelSEED::MS::BaseObject;
use ModelSEED::MS::GapgenSolutionReaction;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw', isa => 'ModelSEED::MS::GapgenFormulation', weak_ref => 1, type => 'parent', metaclass => 'Typed');


# ATTRIBUTES:
has uuid => (is => 'rw', isa => 'ModelSEED::uuid', printOrder => '0', lazy => 1, builder => '_build_uuid', type => 'attribute', metaclass => 'Typed');
has modDate => (is => 'rw', isa => 'Str', printOrder => '-1', lazy => 1, builder => '_build_modDate', type => 'attribute', metaclass => 'Typed');
has solutionCost => (is => 'rw', isa => 'Num', printOrder => '0', default => '1', type => 'attribute', metaclass => 'Typed');
has biomassSupplement_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has mediaRemoval_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has additionalKO_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');


# ANCESTOR:
has ancestor_uuid => (is => 'rw', isa => 'uuid', type => 'ancestor', metaclass => 'Typed');


# SUBOBJECTS:
has gapgenSolutionReactions => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(GapgenSolutionReaction)', metaclass => 'Typed', reader => '_gapgenSolutionReactions', printOrder => '-1');


# LINKS:
has biomassSupplements => (is => 'rw', isa => 'ArrayRef[ModelSEED::MS::ModelCompound]', type => 'link(Model,modelcompounds,biomassSupplement_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_biomassSupplements');
has mediaRemovals => (is => 'rw', isa => 'ArrayRef[ModelSEED::MS::ModelCompound]', type => 'link(Model,modelcompounds,mediaRemovals_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_mediaRemovals');
has additionalKOs => (is => 'rw', isa => 'ArrayRef[ModelSEED::MS::ModelReaction]', type => 'link(Model,modelreactions,additionalKO_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_additionalKOs');


# BUILDERS:
sub _build_uuid { return Data::UUID->new()->create_str(); }
sub _build_modDate { return DateTime->now()->datetime(); }
sub _build_biomassSupplements {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Model','modelcompounds',$self->biomassSupplement_uuids());
}
sub _build_mediaRemovals {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Model','modelcompounds',$self->mediaRemovals_uuids());
}
sub _build_additionalKOs {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Model','modelreactions',$self->additionalKO_uuids());
}


# CONSTANTS:
sub _type { return 'GapgenSolution'; }

my $attributes = [
          {
            'req' => 0,
            'printOrder' => 0,
            'name' => 'uuid',
            'type' => 'ModelSEED::uuid',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'modDate',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 0,
            'name' => 'solutionCost',
            'default' => '1',
            'type' => 'Num',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'biomassSupplement_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'mediaRemoval_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'additionalKO_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          }
        ];

my $attribute_map = {uuid => 0, modDate => 1, solutionCost => 2, biomassSupplement_uuids => 3, mediaRemoval_uuids => 4, additionalKO_uuids => 5};
sub _attributes {
  my ($self, $key) = @_;
  if (defined($key)) {
    my $ind = $attribute_map->{$key};
    if (defined($ind)) {
      return $attributes->[$ind];
    } else {
      return;
    }
  } else {
    return $attributes;
  }
}

my $subobjects = [
          {
            'printOrder' => -1,
            'name' => 'gapgenSolutionReactions',
            'type' => 'encompassed',
            'class' => 'GapgenSolutionReaction'
          }
        ];

my $subobject_map = {gapgenSolutionReactions => 0};
sub _subobjects {
  my ($self, $key) = @_;
  if (defined($key)) {
    my $ind = $subobject_map->{$key};
    if (defined($ind)) {
      return $subobjects->[$ind];
    } else {
      return;
    }
  } else {
    return $subobjects;
  }
}


# SUBOBJECT READERS:
around 'gapgenSolutionReactions' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('gapgenSolutionReactions');
};


__PACKAGE__->meta->make_immutable;
1;
