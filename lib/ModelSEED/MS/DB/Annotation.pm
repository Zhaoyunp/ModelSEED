########################################################################
# ModelSEED::MS::DB::Annotation - This is the moose object corresponding to the Annotation object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::Annotation;
use ModelSEED::MS::IndexedObject;
use ModelSEED::MS::Genome;
use ModelSEED::MS::Feature;
use ModelSEED::MS::SubsystemState;
use ModelSEED::MS::AliasSet;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::IndexedObject';


our $VERSION = 1;
# PARENT:
has parent => (is => 'rw', isa => 'Ref', weak_ref => 1, type => 'parent', metaclass => 'Typed');


# ATTRIBUTES:
has uuid => (is => 'rw', isa => 'ModelSEED::uuid', printOrder => '0', lazy => 1, builder => '_build_uuid', type => 'attribute', metaclass => 'Typed');
has defaultNameSpace => (is => 'rw', isa => 'Str', printOrder => '3', default => 'SEED', type => 'attribute', metaclass => 'Typed');
has modDate => (is => 'rw', isa => 'Str', printOrder => '-1', lazy => 1, builder => '_build_modDate', type => 'attribute', metaclass => 'Typed');
has name => (is => 'rw', isa => 'ModelSEED::varchar', printOrder => '1', default => '', type => 'attribute', metaclass => 'Typed');
has mapping_uuid => (is => 'rw', isa => 'Str', printOrder => '2', type => 'attribute', metaclass => 'Typed');
has forwardedLinks => (is => 'rw', isa => 'HashRef', printOrder => '-1', default => sub {return {};}, type => 'attribute', metaclass => 'Typed');


# ANCESTOR:
has ancestor_uuid => (is => 'rw', isa => 'uuid', type => 'ancestor', metaclass => 'Typed');


# SUBOBJECTS:
has genomes => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'child(Genome)', metaclass => 'Typed', reader => '_genomes', printOrder => '0');
has features => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'child(Feature)', metaclass => 'Typed', reader => '_features', printOrder => '1');
has subsystemStates => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'child(SubsystemState)', metaclass => 'Typed', reader => '_subsystemStates', printOrder => '2');
has aliasSets => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'child(AliasSet)', metaclass => 'Typed', reader => '_aliasSets', printOrder => '-1');


# LINKS:
has mapping => (is => 'rw', type => 'link(ModelSEED::Store,Mapping,mapping_uuid)', metaclass => 'Typed', lazy => 1, builder => '_build_mapping', clearer => 'clear_mapping', isa => 'ModelSEED::MS::Mapping');


# BUILDERS:
sub _build_uuid { return Data::UUID->new()->create_str(); }
sub _build_modDate { return DateTime->now()->datetime(); }
sub _build_mapping {
  my ($self) = @_;
  return $self->getLinkedObject('ModelSEED::Store','Mapping',$self->mapping_uuid());
}


# CONSTANTS:
sub __version__ { return $VERSION; }
sub _type { return 'Annotation'; }

my $attributes = [
          {
            'req' => 0,
            'printOrder' => 0,
            'name' => 'uuid',
            'type' => 'ModelSEED::uuid',
            'perm' => 'rw'
          },
          {
            'len' => 32,
            'req' => 0,
            'printOrder' => 3,
            'name' => 'defaultNameSpace',
            'default' => 'SEED',
            'type' => 'Str',
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
            'name' => 'name',
            'default' => '',
            'type' => 'ModelSEED::varchar',
            'perm' => 'rw'
          },
          {
            'printOrder' => 2,
            'name' => 'mapping_uuid',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'forwardedLinks',
            'default' => 'sub {return {};}',
            'type' => 'HashRef',
            'perm' => 'rw'
          }
        ];

my $attribute_map = {uuid => 0, defaultNameSpace => 1, modDate => 2, name => 3, mapping_uuid => 4, forwardedLinks => 5};
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
            'attribute' => 'mapping_uuid',
            'weak' => 0,
            'parent' => 'ModelSEED::Store',
            'clearer' => 'clear_mapping',
            'name' => 'mapping',
            'class' => 'Mapping',
            'method' => 'Mapping'
          }
        ];

my $link_map = {mapping => 0};
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
            'printOrder' => 0,
            'name' => 'genomes',
            'type' => 'child',
            'class' => 'Genome'
          },
          {
            'printOrder' => 1,
            'name' => 'features',
            'type' => 'child',
            'class' => 'Feature'
          },
          {
            'printOrder' => 2,
            'name' => 'subsystemStates',
            'type' => 'child',
            'class' => 'SubsystemState'
          },
          {
            'printOrder' => -1,
            'name' => 'aliasSets',
            'type' => 'child',
            'class' => 'AliasSet'
          }
        ];

my $subobject_map = {genomes => 0, features => 1, subsystemStates => 2, aliasSets => 3};
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
around 'genomes' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('genomes');
};
around 'features' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('features');
};
around 'subsystemStates' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('subsystemStates');
};
around 'aliasSets' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('aliasSets');
};


__PACKAGE__->meta->make_immutable;
1;
