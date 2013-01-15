########################################################################
# ModelSEED::MS::DB::FBAFormulation - This is the moose object corresponding to the FBAFormulation object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
package ModelSEED::MS::DB::FBAFormulation;
use ModelSEED::MS::IndexedObject;
use ModelSEED::MS::FBAObjectiveTerm;
use ModelSEED::MS::FBAConstraint;
use ModelSEED::MS::FBAReactionBound;
use ModelSEED::MS::FBACompoundBound;
use ModelSEED::MS::FBAResult;
use ModelSEED::MS::FBAPhenotypeSimulation;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::IndexedObject';


# PARENT:
has parent => (is => 'rw', isa => 'ModelSEED::Store', type => 'parent', metaclass => 'Typed');


# ATTRIBUTES:
has uuid => (is => 'rw', isa => 'ModelSEED::uuid', printOrder => '-1', lazy => 1, builder => '_build_uuid', type => 'attribute', metaclass => 'Typed');
has modDate => (is => 'rw', isa => 'Str', printOrder => '-1', lazy => 1, builder => '_build_modDate', type => 'attribute', metaclass => 'Typed');
has regulatorymodel_uuid => (is => 'rw', isa => 'Str', printOrder => '-1', type => 'attribute', metaclass => 'Typed');
has promModel_uuid => (is => 'rw', isa => 'Str', printOrder => '-1', type => 'attribute', metaclass => 'Typed');
has model_uuid => (is => 'rw', isa => 'Str', printOrder => '-1', required => 1, type => 'attribute', metaclass => 'Typed');
has media_uuid => (is => 'rw', isa => 'ModelSEED::uuid', printOrder => '-1', required => 1, type => 'attribute', metaclass => 'Typed');
has secondaryMedia_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has fva => (is => 'rw', isa => 'Bool', printOrder => '10', default => '0', type => 'attribute', metaclass => 'Typed');
has comboDeletions => (is => 'rw', isa => 'Int', printOrder => '11', default => '0', type => 'attribute', metaclass => 'Typed');
has fluxMinimization => (is => 'rw', isa => 'Bool', printOrder => '12', default => '0', type => 'attribute', metaclass => 'Typed');
has findMinimalMedia => (is => 'rw', isa => 'Bool', printOrder => '13', default => '0', type => 'attribute', metaclass => 'Typed');
has notes => (is => 'rw', isa => 'Str', printOrder => '-1', default => '', type => 'attribute', metaclass => 'Typed');
has expressionData_uuid => (is => 'rw', isa => 'Str', printOrder => '-1', type => 'attribute', metaclass => 'Typed');
has objectiveConstraintFraction => (is => 'rw', isa => 'ModelSEED::varchar', printOrder => '0', default => 'none', type => 'attribute', metaclass => 'Typed');
has allReversible => (is => 'rw', isa => 'Int', printOrder => '14', default => '0', type => 'attribute', metaclass => 'Typed');
has defaultMaxFlux => (is => 'rw', isa => 'Int', printOrder => '20', required => 1, default => '1000', type => 'attribute', metaclass => 'Typed');
has defaultMaxDrainFlux => (is => 'rw', isa => 'Int', printOrder => '22', required => 1, default => '1000', type => 'attribute', metaclass => 'Typed');
has defaultMinDrainFlux => (is => 'rw', isa => 'Int', printOrder => '21', required => 1, default => '-1000', type => 'attribute', metaclass => 'Typed');
has maximizeObjective => (is => 'rw', isa => 'Bool', printOrder => '-1', required => 1, default => '1', type => 'attribute', metaclass => 'Typed');
has decomposeReversibleFlux => (is => 'rw', isa => 'Bool', printOrder => '-1', default => '0', type => 'attribute', metaclass => 'Typed');
has decomposeReversibleDrainFlux => (is => 'rw', isa => 'Bool', printOrder => '-1', default => '0', type => 'attribute', metaclass => 'Typed');
has fluxUseVariables => (is => 'rw', isa => 'Bool', printOrder => '-1', default => '0', type => 'attribute', metaclass => 'Typed');
has drainfluxUseVariables => (is => 'rw', isa => 'Bool', printOrder => '-1', default => '0', type => 'attribute', metaclass => 'Typed');
has additionalCpd_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has geneKO_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has reactionKO_uuids => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has parameters => (is => 'rw', isa => 'HashRef', printOrder => '-1', default => sub{return {};}, type => 'attribute', metaclass => 'Typed');
has inputfiles => (is => 'rw', isa => 'HashRef', printOrder => '-1', default => sub{return {};}, type => 'attribute', metaclass => 'Typed');
has outputfiles => (is => 'rw', isa => 'ArrayRef', printOrder => '-1', default => sub{return [];}, type => 'attribute', metaclass => 'Typed');
has uptakeLimits => (is => 'rw', isa => 'HashRef', printOrder => '-1', default => sub{return {};}, type => 'attribute', metaclass => 'Typed');
has numberOfSolutions => (is => 'rw', isa => 'Int', printOrder => '23', default => '1', type => 'attribute', metaclass => 'Typed');
has simpleThermoConstraints => (is => 'rw', isa => 'Bool', printOrder => '15', default => '1', type => 'attribute', metaclass => 'Typed');
has thermodynamicConstraints => (is => 'rw', isa => 'Bool', printOrder => '16', default => '1', type => 'attribute', metaclass => 'Typed');
has noErrorThermodynamicConstraints => (is => 'rw', isa => 'Bool', printOrder => '17', default => '1', type => 'attribute', metaclass => 'Typed');
has minimizeErrorThermodynamicConstraints => (is => 'rw', isa => 'Bool', printOrder => '18', default => '1', type => 'attribute', metaclass => 'Typed');
has PROMKappa => (is => 'rw', isa => 'Num', printOrder => '19', default => '1', type => 'attribute', metaclass => 'Typed');


# ANCESTOR:
has ancestor_uuid => (is => 'rw', isa => 'uuid', type => 'ancestor', metaclass => 'Typed');


# SUBOBJECTS:
has fbaObjectiveTerms => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(FBAObjectiveTerm)', metaclass => 'Typed', reader => '_fbaObjectiveTerms', printOrder => '-1');
has fbaConstraints => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(FBAConstraint)', metaclass => 'Typed', reader => '_fbaConstraints', printOrder => '1');
has fbaReactionBounds => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(FBAReactionBound)', metaclass => 'Typed', reader => '_fbaReactionBounds', printOrder => '2');
has fbaCompoundBounds => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(FBACompoundBound)', metaclass => 'Typed', reader => '_fbaCompoundBounds', printOrder => '3');
has fbaResults => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'result(FBAResult)', metaclass => 'Typed', reader => '_fbaResults', printOrder => '5');
has fbaPhenotypeSimulations => (is => 'rw', isa => 'ArrayRef[HashRef]', default => sub { return []; }, type => 'encompassed(FBAPhenotypeSimulation)', metaclass => 'Typed', reader => '_fbaPhenotypeSimulations', printOrder => '4');


# LINKS:
has model => (is => 'rw', type => 'link(ModelSEED::Store,Model,model_uuid)', metaclass => 'Typed', lazy => 1, builder => '_build_model', clearer => 'clear_model', isa => 'ModelSEED::MS::Model');
has promModel => (is => 'rw', type => 'link(ModelSEED::Store,PROMModel,promModel_uuid)', metaclass => 'Typed', lazy => 1, builder => '_build_promModel', clearer => 'clear_promModel', isa => 'ModelSEED::MS::PROMModel');
has media => (is => 'rw', type => 'link(Biochemistry,media,media_uuid)', metaclass => 'Typed', lazy => 1, builder => '_build_media', clearer => 'clear_media', isa => 'ModelSEED::MS::Media', weak_ref => 1);
has geneKOs => (is => 'rw', type => 'link(Annotation,features,geneKO_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_geneKOs', clearer => 'clear_geneKOs', isa => 'ArrayRef');
has additionalCpds => (is => 'rw', type => 'link(Biochemistry,compounds,additionalCpd_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_additionalCpds', clearer => 'clear_additionalCpds', isa => 'ArrayRef');
has reactionKOs => (is => 'rw', type => 'link(Biochemistry,reactions,reactionKO_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_reactionKOs', clearer => 'clear_reactionKOs', isa => 'ArrayRef');
has secondaryMedia => (is => 'rw', type => 'link(Biochemistry,media,secondaryMedia_uuids)', metaclass => 'Typed', lazy => 1, builder => '_build_secondaryMedia', clearer => 'clear_secondaryMedia', isa => 'ArrayRef');


# BUILDERS:
sub _build_uuid { return Data::UUID->new()->create_str(); }
sub _build_modDate { return DateTime->now()->datetime(); }
sub _build_model {
  my ($self) = @_;
  return $self->getLinkedObject('ModelSEED::Store','Model',$self->model_uuid());
}
sub _build_promModel {
  my ($self) = @_;
  return $self->getLinkedObject('ModelSEED::Store','PROMModel',$self->promModel_uuid());
}
sub _build_media {
  my ($self) = @_;
  return $self->getLinkedObject('Biochemistry','media',$self->media_uuid());
}
sub _build_geneKOs {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Annotation','features',$self->geneKO_uuids());
}
sub _build_additionalCpds {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Biochemistry','compounds',$self->additionalCpd_uuids());
}
sub _build_reactionKOs {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Biochemistry','reactions',$self->reactionKO_uuids());
}
sub _build_secondaryMedia {
  my ($self) = @_;
  return $self->getLinkedObjectArray('Biochemistry','media',$self->secondaryMedia_uuids());
}


# CONSTANTS:
sub _type { return 'FBAFormulation'; }

my $attributes = [
          {
            'req' => 0,
            'printOrder' => -1,
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
            'printOrder' => -1,
            'name' => 'regulatorymodel_uuid',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'promModel_uuid',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 1,
            'printOrder' => -1,
            'name' => 'model_uuid',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 1,
            'printOrder' => -1,
            'name' => 'media_uuid',
            'type' => 'ModelSEED::uuid',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'secondaryMedia_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'printOrder' => 10,
            'name' => 'fva',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'printOrder' => 11,
            'name' => 'comboDeletions',
            'default' => 0,
            'type' => 'Int',
            'perm' => 'rw'
          },
          {
            'printOrder' => 12,
            'name' => 'fluxMinimization',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'printOrder' => 13,
            'name' => 'findMinimalMedia',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'notes',
            'default' => '',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'expressionData_uuid',
            'type' => 'Str',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 0,
            'name' => 'objectiveConstraintFraction',
            'default' => 'none',
            'type' => 'ModelSEED::varchar',
            'perm' => 'rw'
          },
          {
            'len' => 255,
            'req' => 0,
            'printOrder' => 14,
            'name' => 'allReversible',
            'default' => '0',
            'type' => 'Int',
            'perm' => 'rw'
          },
          {
            'req' => 1,
            'printOrder' => 20,
            'name' => 'defaultMaxFlux',
            'default' => 1000,
            'type' => 'Int',
            'perm' => 'rw'
          },
          {
            'req' => 1,
            'printOrder' => 22,
            'name' => 'defaultMaxDrainFlux',
            'default' => 1000,
            'type' => 'Int',
            'perm' => 'rw'
          },
          {
            'req' => 1,
            'printOrder' => 21,
            'name' => 'defaultMinDrainFlux',
            'default' => -1000,
            'type' => 'Int',
            'perm' => 'rw'
          },
          {
            'req' => 1,
            'printOrder' => -1,
            'name' => 'maximizeObjective',
            'default' => 1,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'len' => 32,
            'req' => 0,
            'printOrder' => -1,
            'name' => 'decomposeReversibleFlux',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'len' => 32,
            'req' => 0,
            'printOrder' => -1,
            'name' => 'decomposeReversibleDrainFlux',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'len' => 32,
            'req' => 0,
            'printOrder' => -1,
            'name' => 'fluxUseVariables',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'len' => 32,
            'req' => 0,
            'printOrder' => -1,
            'name' => 'drainfluxUseVariables',
            'default' => 0,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'additionalCpd_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'geneKO_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'reactionKO_uuids',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'parameters',
            'default' => 'sub{return {};}',
            'type' => 'HashRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'inputfiles',
            'default' => 'sub{return {};}',
            'type' => 'HashRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'outputfiles',
            'default' => 'sub{return [];}',
            'type' => 'ArrayRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => -1,
            'name' => 'uptakeLimits',
            'default' => 'sub{return {};}',
            'type' => 'HashRef',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 23,
            'name' => 'numberOfSolutions',
            'default' => 1,
            'type' => 'Int',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 15,
            'name' => 'simpleThermoConstraints',
            'default' => 1,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 16,
            'name' => 'thermodynamicConstraints',
            'default' => 1,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 17,
            'name' => 'noErrorThermodynamicConstraints',
            'default' => 1,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 18,
            'name' => 'minimizeErrorThermodynamicConstraints',
            'default' => 1,
            'type' => 'Bool',
            'perm' => 'rw'
          },
          {
            'req' => 0,
            'printOrder' => 19,
            'name' => 'PROMKappa',
            'default' => 1,
            'type' => 'Num',
            'perm' => 'rw'
          }
        ];

my $attribute_map = {uuid => 0, modDate => 1, regulatorymodel_uuid => 2, promModel_uuid => 3, model_uuid => 4, media_uuid => 5, secondaryMedia_uuids => 6, fva => 7, comboDeletions => 8, fluxMinimization => 9, findMinimalMedia => 10, notes => 11, expressionData_uuid => 12, objectiveConstraintFraction => 13, allReversible => 14, defaultMaxFlux => 15, defaultMaxDrainFlux => 16, defaultMinDrainFlux => 17, maximizeObjective => 18, decomposeReversibleFlux => 19, decomposeReversibleDrainFlux => 20, fluxUseVariables => 21, drainfluxUseVariables => 22, geneKO_uuids => 23, reactionKO_uuids => 24, parameters => 25, inputfiles => 26, outputfiles => 27, uptakeLimits => 28, numberOfSolutions => 29, simpleThermoConstraints => 30, thermodynamicConstraints => 31, noErrorThermodynamicConstraints => 32, minimizeErrorThermodynamicConstraints => 33, PROMKappa => 34};
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
            'attribute' => 'model_uuid',
            'weak' => 0,
            'parent' => 'ModelSEED::Store',
            'clearer' => 'clear_model',
            'name' => 'model',
            'class' => 'Model',
            'method' => 'Model'
          },
          {
            'attribute' => 'promModel_uuid',
            'weak' => 0,
            'parent' => 'ModelSEED::Store',
            'clearer' => 'clear_promModel',
            'name' => 'promModel',
            'class' => 'PROMModel',
            'method' => 'PROMModel'
          },
          {
            'attribute' => 'media_uuid',
            'parent' => 'Biochemistry',
            'clearer' => 'clear_media',
            'name' => 'media',
            'class' => 'media',
            'method' => 'media'
          },
          {
            'array' => 1,
            'attribute' => 'geneKO_uuids',
            'parent' => 'Annotation',
            'clearer' => 'clear_geneKOs',
            'name' => 'geneKOs',
            'class' => 'features',
            'method' => 'features'
          },
          {
            'array' => 1,
            'attribute' => 'additionalCpd_uuids',
            'parent' => 'Biochemistry',
            'clearer' => 'clear_additionalCpds',
            'name' => 'additionalCpds',
            'class' => 'compounds',
            'method' => 'compounds'
          },
          {
            'array' => 1,
            'attribute' => 'reactionKO_uuids',
            'parent' => 'Biochemistry',
            'clearer' => 'clear_reactionKOs',
            'name' => 'reactionKOs',
            'class' => 'reactions',
            'method' => 'reactions'
          },
          {
            'array' => 1,
            'attribute' => 'secondaryMedia_uuids',
            'parent' => 'Biochemistry',
            'clearer' => 'clear_secondaryMedia',
            'name' => 'secondaryMedia',
            'class' => 'media',
            'method' => 'media'
          }
        ];

my $link_map = {model => 0, promModel => 1, media => 2, geneKOs => 3, reactionKOs => 4, secondaryMedia => 5};
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
            'name' => 'fbaObjectiveTerms',
            'type' => 'encompassed',
            'class' => 'FBAObjectiveTerm'
          },
          {
            'printOrder' => 1,
            'name' => 'fbaConstraints',
            'type' => 'encompassed',
            'class' => 'FBAConstraint'
          },
          {
            'printOrder' => 2,
            'name' => 'fbaReactionBounds',
            'type' => 'encompassed',
            'class' => 'FBAReactionBound'
          },
          {
            'printOrder' => 3,
            'name' => 'fbaCompoundBounds',
            'type' => 'encompassed',
            'class' => 'FBACompoundBound'
          },
          {
            'printOrder' => 5,
            'name' => 'fbaResults',
            'type' => 'result',
            'class' => 'FBAResult'
          },
          {
            'printOrder' => 4,
            'name' => 'fbaPhenotypeSimulations',
            'type' => 'encompassed',
            'class' => 'FBAPhenotypeSimulation'
          }
        ];

my $subobject_map = {fbaObjectiveTerms => 0, fbaConstraints => 1, fbaReactionBounds => 2, fbaCompoundBounds => 3, fbaResults => 4, fbaPhenotypeSimulations => 5};
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
around 'fbaObjectiveTerms' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('fbaObjectiveTerms');
};
around 'fbaConstraints' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('fbaConstraints');
};
around 'fbaReactionBounds' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('fbaReactionBounds');
};
around 'fbaCompoundBounds' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('fbaCompoundBounds');
};
around 'fbaResults' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('fbaResults');
};
around 'fbaPhenotypeSimulations' => sub {
  my ($orig, $self) = @_;
  return $self->_build_all_objects('fbaPhenotypeSimulations');
};


__PACKAGE__->meta->make_immutable;
1;
