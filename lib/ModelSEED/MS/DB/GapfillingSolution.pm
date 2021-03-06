########################################################################
# ModelSEED::MS::DB::GapfillingSolution - This is the moose object corresponding to the GapfillingSolution object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::GapfillingSolution;
use ModelSEED::MS::BaseObject;
use ModelSEED::MS::GapfillingSolutionReaction;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw', isa => 'ModelSEED::MS::GapfillingFormulation', weak_ref => 1, type => 'parent', metaclass => 'Typed');


# ATTRIBUTES:
has uuid => (is => 'rw', isa => 'ModelSEED::uuid', printOrder => '0', lazy => 1, builder => '_build_uuid', type => 'attribute', metaclass => 'Typed');
has modDate => (is => 'rw', isa => 'Str', printOrder => '-1', lazy => 1, builder => '_build_modDate', type => 'attribute', metaclass => 'Typed');
has solutionCost => (is => 'rw', isa => 'Num', printOrder => '1', default => '1', type => 'attribute', metaclass => 'Typed');
has biomassRemoval_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has mediaSupplement_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has koRestore_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has integrated => (is => 'rw', isa => 'Bool', printOrder => '1', default => '0', type => 'attribute', metaclass => 'Typed');
has suboptimal => (is => 'rw', isa => 'Bool', printOrder => '1', default => '0', type => 'attribute', metaclass => 'Typed');


# ANCESTOR:
has ancestor_uuid => (is => 'rw', isa => 'uuid', type => 'ancestor', metaclass => 'Typed');


# SUBOBJECTS:
has gapfillingSolutionReactions => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(GapfillingSolutionReaction)', metaclass => 'Typed', reader => '_gapfillingSolutionReactions', printOrder => '-1');


# LINKS:
has biomassRemovals => (is => 'rw', type => 'link(Model,modelcompounds,biomassRemoval_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_biomassRemovals', clearer => 'clear_biomassRemovals', isa => 'ArrayRef');
has mediaSupplements => (is => 'rw', type => 'link(Model,modelcompounds,mediaSupplement_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_mediaSupplements', clearer => 'clear_mediaSupplements', isa => 'ArrayRef');
has koRestores => (is => 'rw', type => 'link(Model,modelreactions,koRestore_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_koRestores', clearer => 'clear_koRestores', isa => 'ArrayRef');


# BUILDERS:
sub _build_uuid { return Data::UUID->new()->create_str(); }
sub _build_modDate { return DateTime->now()->datetime(); }
sub _build_biomassRemovals {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Model','modelcompounds',$self->biomassRemoval_uuids());
}
sub _build_mediaSupplements {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Model','modelcompounds',$self->mediaSupplement_uuids());
}
sub _build_koRestores {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Model','modelreactions',$self->koRestore_uuids());
}


# CONSTANTS:
sub _type { return 'GapfillingSolution'; }

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
            'printOrder' => 1,
            'name' => 'solutionCost',
            'default' => '1',
            'type' => 'Num',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'biomassRemoval_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'mediaSupplement_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'koRestore_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 1,
            'name' => 'integrated',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 1,
            'name' => 'suboptimal',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          }
        ];

my $attribute_map = {uuid => 0, modDate => 1, solutionCost => 2, biomassRemoval_uuids => 3, mediaSupplement_uuids => 4, koRestore_uuids => 5, integrated => 6, suboptimal => 7};
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

my $links = [
          {
            'array' => 1,
            'attribute' => 'biomassRemoval_uuids',
            'parent' => 'Model',
            'clearer' => 'clear_biomassRemovals',
            'name' => 'biomassRemovals',
            'class' => 'modelcompounds',
            'method' => 'modelcompounds'
          },
          {
            'array' => 1,
            'attribute' => 'mediaSupplement_uuids',
            'parent' => 'Model',
            'clearer' => 'clear_mediaSupplements',
            'name' => 'mediaSupplements',
            'class' => 'modelcompounds',
            'method' => 'modelcompounds'
          },
          {
            'array' => 1,
            'attribute' => 'koRestore_uuids',
            'parent' => 'Model',
            'clearer' => 'clear_koRestores',
            'name' => 'koRestores',
            'class' => 'modelreactions',
            'method' => 'modelreactions'
          }
        ];

my $link_map = {biomassRemovals => 0, mediaSupplements => 1, koRestores => 2};
sub _links {
  my ($self, $key) = @_;
  if (defined($key)) {
    my $ind = $link_map->{$key};
    if (defined($ind)) {
      return $links->[$ind];
    } else {
      return;
    }
  } else {
    return $links;
  }
}

my $subobjects = [
          {
            'printOrder' => -1,
            'name' => 'gapfillingSolutionReactions',
            'type' => 'encompassed',
            'class' => 'GapfillingSolutionReaction'
          }
        ];

my $subobject_map = {gapfillingSolutionReactions => 0};
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
around 'gapfillingSolutionReactions' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('gapfillingSolutionReactions');
};


__PACKAGE__->meta->make_immutable;
1;
