########################################################################
# ModelSEED::MS::DB::ModelReactionReagent - This is the moose object corresponding to the ModelReactionReagent object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::ModelReactionReagent;
use ModelSEED::MS::BaseObject;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::BaseObject';


# PARENT:
has parent => (is => 'rw', isa => 'ModelSEED::MS::ModelReaction', weak_ref => 1, type => 'parent', metaclass => 'Typed');


# ATTRIBUTES:
has modelcompound_uuid => (is => 'rw', isa => 'ModelSEED::uuid', printOrder => '0', required => 1, trigger => &_trigger_modelcompound_uuid, type => 'attribute', metaclass => 'Typed');
has coefficient => (is => 'rw', isa => 'Num', printOrder => '0', required => 1, type => 'attribute', metaclass => 'Typed');


# LINKS:
has modelcompound => (is => 'rw', type => 'link(Model,modelcompounds,modelcompound_uuid)', metaclass => 'Typed', lazy => 1, builder => '_build_modelcompound', clearer => 'clear_modelcompound', trigger => &_trigger_modelcompound, isa => 'ModelSEED::MS::ModelCompound', weak_ref => 1);


# BUILDERS:
sub _build_modelcompound {
  my ($self) = @_;
  return $self->getLinkedObject('Model','modelcompounds',$self->modelcompound_uuid());
}
sub _trigger_modelcompound {
   my ($self, $new, $old) = @_;
   $self->modelcompound_uuid( $new->uuid );
}
sub _trigger_modelcompound_uuid {
    my ($self, $new, $old) = @_;
    $self->clear_modelcompound if( $self->modelcompound->uuid ne $new );
}


# CONSTANTS:
sub _type { return 'ModelReactionReagent'; }

my $attributes = [
          {
            'len' => 36,
            'req' => 1,
            'printOrder' => 0,
            'name' => 'modelcompound_uuid',
            'type' => 'ModelSEED::uuid',
            'perm' => 'rw'
          },
          {
            'req' => 1,
            'printOrder' => 0,
            'name' => 'coefficient',
            'type' => 'Num',
            'perm' => 'rw'
          }
        ];

my $attribute_map = {modelcompound_uuid => 0, coefficient => 1};
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
            'attribute' => 'modelcompound_uuid',
            'parent' => 'Model',
            'clearer' => 'clear_modelcompound',
            'name' => 'modelcompound',
            'class' => 'modelcompounds',
            'method' => 'modelcompounds'
          }
        ];

my $link_map = {modelcompound => 0};
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

my $subobjects = [];

my $subobject_map = {};
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


__PACKAGE__->meta->make_immutable;
1;
