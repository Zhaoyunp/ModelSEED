########################################################################
# ModelSEED::MS::DB::Media - This is the moose object corresponding to the Media object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::Media;
use ModelSEED::MS::BaseObject;
use ModelSEED::MS::MediaCompound;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw', isa => 'ModelSEED::MS::Biochemistry', weak_ref => 1, type => 'parent', metaclass => 'Typed');


# ATTRIBUTES:
has uuid => (is => 'rw', isa => 'ModelSEED::uuid', printOrder => '0', lazy => 1, builder => '_build_uuid', type => 'attribute', metaclass => 'Typed');
has modDate => (is => 'rw', isa => 'Str', printOrder => '-1', lazy => 1, builder => '_build_modDate', type => 'attribute', metaclass => 'Typed');
has isDefined => (is => 'rw', isa => 'Bool', printOrder => '4', default => '0', type => 'attribute', metaclass => 'Typed');
has isMinimal => (is => 'rw', isa => 'Bool', printOrder => '5', default => '0', type => 'attribute', metaclass => 'Typed');
has id => (is => 'rw', isa => 'Str', printOrder => '1', default => "", type => 'attribute', metaclass => 'Typed');
has name => (is => 'rw', isa => 'ModelSEED::varchar', printOrder => '2', default => '', type => 'attribute', metaclass => 'Typed');
has type => (is => 'rw', isa => 'Str', printOrder => '6', default => 'unknown', type => 'attribute', metaclass => 'Typed');


# ANCESTOR:
has ancestor_uuid => (is => 'rw', isa => 'uuid', type => 'ancestor', metaclass => 'Typed');


# SUBOBJECTS:
has mediacompounds => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(MediaCompound)', metaclass => 'Typed', reader => '_mediacompounds', printOrder => '-1');


# LINKS:


# BUILDERS:
sub _build_uuid { return Data::UUID->new()->create_str(); }
sub _build_modDate { return DateTime->now()->datetime(); }


# CONSTANTS:
sub _type { return 'Media'; }

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
            'printOrder' => 4,
            'name' => 'isDefined',
            'default' => '0',
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 5,
            'name' => 'isMinimal',
            'default' => '0',
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'len' => 32,
            'req' => 1,
            'printOrder' => 1,
            'name' => 'id',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 2,
            'name' => 'name',
            'default' => '',
            'type' => 'ModelSEED::varchar',
            'perm' => 'rw'
          },
          {
            'len' => 1,
            'req' => 0,
            'printOrder' => 6,
            'name' => 'type',
            'default' => 'unknown',
            'type' => 'Str',
            'perm' => 'rw'
          }
        ];

my $attribute_map = {uuid => 0, modDate => 1, isDefined => 2, isMinimal => 3, id => 4, name => 5, type => 6};
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

my $links = [];

my $link_map = {};
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
            'name' => 'mediacompounds',
            'type' => 'encompassed',
            'class' => 'MediaCompound'
          }
        ];

my $subobject_map = {mediacompounds => 0};
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
around 'mediacompounds' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('mediacompounds');
};


__PACKAGE__->meta->make_immutable;
1;
