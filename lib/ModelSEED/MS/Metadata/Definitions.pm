use strict;

package ModelSEED::MS::Metadata::Definitions;

my $objectDefinitions = {};

$objectDefinitions->{Configuration} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'username',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "Public"
		},
		{
			name       => 'password',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'CPLEX_LICENCE',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
		},
		{
			name       => 'ERROR_DIR',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'MFATK_CACHE',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'MFATK_BIN',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		}
	],
	subobjects  => [
		{
			name       => "users",
			printOrder => -1,
			class      => "User",
			type       => "encompassed"
		},
		{
			name       => "stores",
			printOrder => -1,
			class      => "Store",
			type       => "encompassed"
		}
	],
	primarykeys => [qw(uuid)],
	links       => []
};

$objectDefinitions->{Store} = {
	parents    => ['Configuration'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'url',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'database',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'type',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1,
			default    => "workspace"
		},
		{
			name       => 'dbuser',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "root"
		},
		{
			name       => 'dbpassword',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		}
	],
	subobjects  => [],
	primarykeys => [qw(uuid name)],
	links       => []
};

$objectDefinitions->{User} = {
	parents    => ["Configuration"],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'login',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'password',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'email',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'firstname',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'lastname',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'primaryStoreName',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
	],
	subobjects         => [
		{
			name       => "userStores",
			printOrder => -1,
			class      => "UserStore",
			type       => "encompassed"
		}
	],
	primarykeys        => [qw(uuid login)],
	links              => [],
	reference_id_types => [qw(uuid)],
	version            => 1.0,
};

$objectDefinitions->{UserStore} = {
	parents    => ["User"],
	class      => 'indexed',
	attributes => [
		{
			name       => 'store_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'login',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'password',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'accountType',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'defaultMapping_ref',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'defaultBiochemistry_ref',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		}
	],
	subobjects         => [],
	primarykeys        => [qw(store_uuid)],
	links              => [
		{
			name      => "associatedStore",
			attribute => "store_uuid",
			parent    => "Configuration",
			method    => "stores",
			weak      => 0
		},
	],
	reference_id_types => [qw(uuid)],
	version            => 1.0,
};

$objectDefinitions->{FBAFormulation} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'regulatorymodel_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'promModel_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'model_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'media_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'secondaryMedia_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'fva',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Bool',
			default    => 0
		},
		{
			name       => 'comboDeletions',
			printOrder => 11,
			perm       => 'rw',
			type       => 'Int',
			default    => 0
		},
		{
			name       => 'fluxMinimization',
			printOrder => 12,
			perm       => 'rw',
			type       => 'Bool',
			default    => 0
		},
		{
			name       => 'findMinimalMedia',
			printOrder => 13,
			perm       => 'rw',
			type       => 'Bool',
			default    => 0
		},
		{
			name       => 'notes',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'expressionData_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'objectiveConstraintFraction',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "none"
		},
		{
			name       => 'allReversible',
			printOrder => 14,
			perm       => 'rw',
			type       => 'Int',
			len        => 255,
			req        => 0,
			default    => "0"
		},
		{
			name       => 'defaultMaxFlux',
			printOrder => 20,
			perm       => 'rw',
			type       => 'Int',
			req        => 1,
			default    => 1000
		},
		{
			name       => 'defaultMaxDrainFlux',
			printOrder => 22,
			perm       => 'rw',
			type       => 'Int',
			req        => 1,
			default    => 1000
		},
		{
			name       => 'defaultMinDrainFlux',
			printOrder => 21,
			perm       => 'rw',
			type       => 'Int',
			req        => 1,
			default    => -1000
		},
		{
			name       => 'maximizeObjective',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Bool',
			req        => 1,
			default    => 1
		},
		{
			name       => 'decomposeReversibleFlux',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Bool',
			len        => 32,
			req        => 0,
			default    => 0
		},
		{
			name       => 'decomposeReversibleDrainFlux',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Bool',
			len        => 32,
			req        => 0,
			default    => 0
		},
		{
			name       => 'fluxUseVariables',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Bool',
			len        => 32,
			req        => 0,
			default    => 0
		},
		{
			name       => 'drainfluxUseVariables',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Bool',
			len        => 32,
			req        => 0,
			default    => 0
		},
		{
			name       => 'additionalCpd_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'geneKO_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'reactionKO_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'parameters',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'inputfiles',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'outputfiles',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'uptakeLimits',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'numberOfSolutions',
			printOrder => 23,
			perm       => 'rw',
			type       => 'Int',
			req        => 0,
			default    => 1
		},
		{
			name       => 'simpleThermoConstraints',
			printOrder => 15,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 1
		},
		{
			name       => 'thermodynamicConstraints',
			printOrder => 16,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 1
		},
		{
			name       => 'noErrorThermodynamicConstraints',
			printOrder => 17,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 1
		},
		{
			name       => 'minimizeErrorThermodynamicConstraints',
			printOrder => 18,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 1
		},
		{
			name       => 'PROMKappa',
			printOrder => 19,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => 1
		},
	],
	subobjects => [
		{
			name       => "fbaObjectiveTerms",
			printOrder => -1,
			class      => "FBAObjectiveTerm",
			type       => "encompassed"
		},
		{
			name       => "fbaConstraints",
			printOrder => 1,
			class      => "FBAConstraint",
			type       => "encompassed"
		},
		{
			name       => "fbaReactionBounds",
			printOrder => 2,
			class      => "FBAReactionBound",
			type       => "encompassed"
		},
		{
			name       => "fbaCompoundBounds",
			printOrder => 3,
			class      => "FBACompoundBound",
			type       => "encompassed"
		},
		{
			name       => "fbaResults",
			printOrder => 5,
			class      => "FBAResult",
			type       => "result"
		},
		{
			name       => "fbaPhenotypeSimulations",
			printOrder => 4,
			class      => "FBAPhenotypeSimulation",
			type       => "encompassed"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "model",
			attribute => "model_uuid",
			parent    => "ModelSEED::Store",
			method    => "Model",
			weak      => 0
		},
		{
			name      => "promModel",
			attribute => "promModel_uuid",
			parent    => "ModelSEED::Store",
			method    => "PROMModel",
			weak      => 0
		},
		{
			name      => "media",
			attribute => "media_uuid",
			parent    => "Biochemistry",
			method    => "media"
		},
		{
			name      => "geneKOs",
			attribute => "geneKO_uuids",
			parent    => "Annotation",
			method    => "features",
			array     => 1
		},
		{
			name      => "additionalCpds",
			attribute => "additionalCpd_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			array     => 1
		},
		{
			name      => "reactionKOs",
			attribute => "reactionKO_uuids",
			parent    => "Biochemistry",
			method    => "reactions",
			array     => 1
		},
		{
			name      => "secondaryMedia",
			attribute => "secondaryMedia_uuids",
			parent    => "Biochemistry",
			method    => "media",
			array     => 1
		},
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{FBAConstraint} = {
	parents    => ['FBAFormulation'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'name',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'rhs',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'sign',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		}
	],
	subobjects => [
		{
			name       => "fbaConstraintVariables",
			printOrder => -1,
			class      => "FBAConstraintVariable",
			type       => "encompassed"
		},
	],
	primarykeys => [qw(name)],
	links       => []
};

$objectDefinitions->{FBAConstraintVariable} = {
	parents    => ['FBAConstraint'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'entity_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 1,
			req        => 0
		},
		{
			name       => 'entityType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'variableType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'coefficient',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw(atom)],
	links       => []
};

$objectDefinitions->{FBAReactionBound} = {
	parents    => ['FBAFormulation'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'modelreaction_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'variableType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'upperBound',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'lowerBound',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(reaction_uuid variableType)],
	links       => [
		{
			name      => "modelReaction",
			attribute => "modelreaction_uuid",
			parent    => "Model",
			method    => "modelreactions"
		},
	]
};

$objectDefinitions->{FBACompoundBound} = {
	parents    => ['FBAFormulation'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'modelcompound_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'variableType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'upperBound',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'lowerBound',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(reaction_uuid variableType)],
	links       => [
		{
			name      => "modelCompound",
			attribute => "modelcompound_uuid",
			parent    => "Model",
			method    => "modelcompounds"
		},
	]
};

$objectDefinitions->{FBAPhenotypeSimulation} = {
	parents    => ['FBAFormulation'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'label',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'pH',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'temperature',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'additionalCpd_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 1,
			default    => "sub{return [];}"
		},
		{
			name       => 'geneKO_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 1,
			default    => "sub{return [];}"
		},
		{
			name       => 'reactionKO_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 1,
			default    => "sub{return [];}"
		},
		{
			name       => 'media_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'observedGrowthFraction',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw(reaction_uuid variableType)],
	links       => [
		{
			name      => "media",
			attribute => "media_uuid",
			parent    => "Biochemistry",
			method    => "media"
		},
		{
			name      => "geneKOs",
			attribute => "geneKO_uuids",
			parent    => "Annotation",
			method    => "features",
			array     => 1
		},
		{
			name      => "reactionKOs",
			attribute => "reactionKO_uuids",
			parent    => "Biochemistry",
			method    => "reactions",
			array     => 1
		},
		{
			name      => "additionalCpds",
			attribute => "additionalCpd_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			array     => 1
		},
	]
};

$objectDefinitions->{FBAObjectiveTerm} = {
	parents    => ['FBAFormulation'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'entity_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 1,
			req        => 0
		},
		{
			name       => 'entityType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'variableType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'coefficient',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw(atom)],
	links       => []
};

$objectDefinitions->{FBAResult} = {
	parents    => ['FBAFormulation'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'notes',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'objectiveValue',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'outputfiles',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
	],
	subobjects => [
		{
			name       => "fbaCompoundVariables",
			printOrder => 2,
			class      => "FBACompoundVariable",
			type       => "encompassed"
		},
		{
			name       => "fbaReactionVariables",
			printOrder => 3,
			class      => "FBAReactionVariable",
			type       => "encompassed"
		},
		{
			name       => "fbaBiomassVariables",
			printOrder => 1,
			class      => "FBABiomassVariable",
			type       => "encompassed"
		},
		{
			name       => "fbaPhenotypeSimultationResults",
			printOrder => 6,
			class      => "FBAPhenotypeSimultationResult",
			type       => "encompassed"
		},
		{
			name       => "fbaPromResults",
			printOrder => 7,
			class      => "FBAPromResult",
			type       => "encompassed"
		},
		{
			name       => "fbaDeletionResults",
			printOrder => 4,
			class      => "FBADeletionResult",
			type       => "encompassed"
		},
		{
			name       => "minimalMediaResults",
			printOrder => 5,
			class      => "FBAMinimalMediaResult",
			type       => "encompassed"
		},
		{
			name       => "fbaMetaboliteProductionResults",
			printOrder => 0,
			class      => "FBAMetaboliteProductionResult",
			type       => "encompassed"
		}
	],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{FBACompoundVariable} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'modelcompound_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'variableType',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'class',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'lowerBound',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'upperBound',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'min',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'max',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'value',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw()],
	links       => [
		{
			name      => "modelcompound",
			attribute => "modelcompound_uuid",
			parent    => "Model",
			method    => "modelcompounds"
		},
	]
};

$objectDefinitions->{FBABiomassVariable} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'biomass_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'variableType',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 0
		},
		{
			name       => 'class',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'lowerBound',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'upperBound',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'min',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'max',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'value',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw()],
	links       => [
		{
			name      => "biomass",
			attribute => "biomass_uuid",
			parent    => "Model",
			method    => "biomasses"
		},
	]
};

$objectDefinitions->{FBAReactionVariable} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'modelreaction_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'variableType',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 0
		},
		{
			name       => 'class',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'lowerBound',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'upperBound',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'min',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'max',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
		{
			name       => 'value',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			len        => 1,
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw(modelfba_uuid modelcompound_uuid)],
	links       => [
		{
			name      => "modelreaction",
			attribute => "modelreaction_uuid",
			parent    => "Model",
			method    => "modelreactions"
		},
	]
};

$objectDefinitions->{FBAPhenotypeSimultationResult} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'simulatedGrowthFraction',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'simulatedGrowth',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'class',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 1
		},
		{
			name       => 'noGrowthCompounds',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'dependantReactions',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'dependantGenes',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'fluxes',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'fbaPhenotypeSimulation_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(fbaPhenotypeSimulation_uuid)],
	links       => [
		{
			name      => "fbaPhenotypeSimulation",
			attribute => "fbaPhenotypeSimulation_uuid",
			parent    => "FBAFormulation",
			method    => "fbaPhenotypeSimulations"
		},
	]
};

$objectDefinitions->{FBAPromResult} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'objectFraction',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'alpha',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'beta',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 1,
		},
	],
	subobjects  => [],
	primarykeys => [],
	links       => []
};

$objectDefinitions->{FBADeletionResult} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'geneko_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 1
		},
		{
			name       => 'growthFraction',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(geneko_uuids)],
	links       => [
		{
			name      => "genekos",
			attribute => "geneko_uuids",
			parent    => "Annotation",
			method    => "features",
			array     => 1
		},
	]
};

$objectDefinitions->{FBAMinimalMediaResult} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'minimalMedia_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'essentialNutrient_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 1
		},
		{
			name       => 'optionalNutrient_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(minimalMedia_uuid)],
	links       => [
		{
			name      => "minimalMedia",
			attribute => "minimalMedia_uuid",
			parent    => "Biochemistry",
			method    => "media"
		},
		{
			name      => "essentialNutrients",
			attribute => "essentialNutrient_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			array     => 1
		},
		{
			name      => "optionalNutrients",
			attribute => "optionalNutrient_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			array     => 1
		}
	]
};

$objectDefinitions->{FBAMetaboliteProductionResult} = {
	parents    => ['FBAResult'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'modelCompound_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'maximumProduction',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(minimalMedia_uuid)],
	links       => [
		{
			name      => "modelCompound",
			attribute => "modelCompound_uuid",
			parent    => "Model",
			method    => "modelcompounds"
		},
	]
};

$objectDefinitions->{GapgenFormulation} = {
	parents    => ['Ref'],
	class      => 'parent',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'fbaFormulation_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'model_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'mediaHypothesis',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'biomassHypothesis',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'gprHypothesis',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'reactionRemovalHypothesis',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'referenceMedia_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'timePerSolution',
			printOrder => 16,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		},
		{
			name       => 'totalTimeLimit',
			printOrder => 17,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		}
	],
	subobjects => [
		{
			name       => "gapgenSolutions",
			printOrder => 0,
			class      => "GapgenSolution",
			type       => "encompassed"
		}
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "model",
			attribute => "model_uuid",
			parent    => "ModelSEED::Store",
			method    => "Model",
			weak      => 0
		},
		{
			name      => "fbaFormulation",
			attribute => "fbaFormulation_uuid",
			parent    => "ModelSEED::Store",
			method    => "FBAFormulation",
			weak      => 0
		},
		{
			name      => "referenceMedia",
			attribute => "referenceMedia_uuid",
			parent    => "Biochemistry",
			method    => "media"
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{GapgenSolution} = {
	parents    => ['GapgenFormulation'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'solutionCost',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'biomassSupplement_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'mediaRemoval_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'additionalKO_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'integrated',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 0
		},
		{
			name       => 'suboptimal',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 0
		}
	],
	subobjects => [
		{
			name  => "gapgenSolutionReactions",
			class => "GapgenSolutionReaction",
			type  => "encompassed"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "biomassSupplements",
			attribute => "biomassSupplement_uuids",
			parent    => "Model",
			method    => "modelcompounds",
			array     => 1
		},
		{
			name      => "mediaRemovals",
			attribute => "mediaRemoval_uuids",
			parent    => "Model",
			method    => "modelcompounds",
			array     => 1
		},
		{
			name      => "additionalKOs",
			attribute => "additionalKO_uuids",
			parent    => "Model",
			method    => "modelreactions",
			array     => 1
		},
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{GapgenSolutionReaction} = {
	parents    => ['GapgenSolution'],
	class      => 'child',
	attributes => [
		{
			name       => 'modelreaction_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'direction',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "1"
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "modelreaction",
			attribute => "modelreaction_uuid",
			parent    => "Model",
			method    => "modelreactions"
		},
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{GapfillingFormulation} = {
	parents    => ['Ref'],
	class      => 'parent',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'fbaFormulation_uuid',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'model_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'mediaHypothesis',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'biomassHypothesis',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'gprHypothesis',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'reactionAdditionHypothesis',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'balancedReactionsOnly',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'guaranteedReaction_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'targetedreactions',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'blacklistedReaction_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'allowableCompartment_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'reactionActivationBonus',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'drainFluxMultiplier',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'directionalityMultiplier',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'deltaGMultiplier',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'noStructureMultiplier',
			printOrder => 11,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'noDeltaGMultiplier',
			printOrder => 12,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'biomassTransporterMultiplier',
			printOrder => 13,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'singleTransporterMultiplier',
			printOrder => 14,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'transporterMultiplier',
			printOrder => 15,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'timePerSolution',
			printOrder => 16,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		},
		{
			name       => 'totalTimeLimit',
			printOrder => 17,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		},
		{
			name       => 'completeGapfill',
			printOrder => 18,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		}
	],
	subobjects => [
		{
			name  => "gapfillingGeneCandidates",
			class => "GapfillingGeneCandidate",
			type  => "encompassed"
		},
		{
			name  => "reactionSetMultipliers",
			class => "ReactionSetMultiplier",
			type  => "encompassed"
		},
		{
			name       => "gapfillingSolutions",
			printOrder => 0,
			class      => "GapfillingSolution",
			type       => "encompassed"
		}
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "model",
			attribute => "model_uuid",
			parent    => "ModelSEED::Store",
			method    => "Model",
			weak      => 0
		},
		{
			name      => "fbaFormulation",
			attribute => "fbaFormulation_uuid",
			parent    => "ModelSEED::Store",
			method    => "FBAFormulation",
			weak      => 0
		},
		{
			name      => "guaranteedReactions",
			attribute => "guaranteedReaction_uuids",
			parent    => "Biochemistry",
			method    => "reactions",
			array     => 1
		},
		{
			name      => "blacklistedReactions",
			attribute => "blacklistedReaction_uuids",
			parent    => "Biochemistry",
			method    => "reactions",
			array     => 1
		},
		{
			name      => "allowableCompartments",
			attribute => "allowableCompartment_uuids",
			parent    => "Biochemistry",
			method    => "compartments",
			array     => 1
		}
	],
	reference_id_types => [qw(uuid)]
};

$objectDefinitions->{GapfillingSolution} = {
	parents    => ['GapfillingFormulation'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'solutionCost',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'biomassRemoval_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'mediaSupplement_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'koRestore_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'integrated',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 0
		},
		{
			name       => 'suboptimal',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => 0
		}
	],
	subobjects => [
		{
			name  => "gapfillingSolutionReactions",
			class => "GapfillingSolutionReaction",
			type  => "encompassed"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "biomassRemovals",
			attribute => "biomassRemoval_uuids",
			parent    => "Model",
			method    => "modelcompounds",
			array     => 1
		},
		{
			name      => "mediaSupplements",
			attribute => "mediaSupplement_uuids",
			parent    => "Model",
			method    => "modelcompounds",
			array     => 1
		},
		{
			name      => "koRestores",
			attribute => "koRestore_uuids",
			parent    => "Model",
			method    => "modelreactions",
			array     => 1
		},
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{GapfillingSolutionReaction} = {
	parents    => ['GapfillingSolution'],
	class      => 'child',
	attributes => [
		{
			name       => 'reaction_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'compartment_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'direction',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'candidateFeature_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
	],
	subobjects => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "reaction",
			attribute => "reaction_uuid",
			parent    => "Biochemistry",
			method    => "reactions"
		},
		{
			name      => "candidateFeatures",
			attribute => "candidateFeature_uuids",
			parent    => "Annotation",
			method    => "features",
			array     => 1
		},
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{GapfillingGeneCandidate} = {
	parents    => ['GapfillingFormulation'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'feature_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'ortholog_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'orthologGenome_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'similarityScore',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'distanceScore',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'role_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "feature",
			attribute => "feature_uuid",
			parent    => "Annotation",
			method    => "features"
		},
		{
			name      => "ortholog",
			attribute => "ortholog_uuid",
			parent    => "Annotation",
			method    => "features"
		},
		{
			name      => "orthologGenome",
			attribute => "orthogenome_uuid",
			parent    => "Annotation",
			method    => "genomes"
		},
		{
			name      => "role",
			attribute => "role_uuid",
			parent    => "Mapping",
			method    => "roles"
		}
	]
};

$objectDefinitions->{ReactionSetMultiplier} = {
	parents    => ['GapfillingFormulation'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'reactionset_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'reactionsetType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'multiplierType',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'description',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'multiplier',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "reactionset",
			attribute => "reactionset_uuid",
			parent    => "Biochemistry",
			method    => "reactionSets"
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{BiochemistryStructures} = {
	parents    => ["Ref"],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0,
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
		}
	],
	subobjects => [
		{
			name       => "structures",
			printOrder => 0,
			class      => "Structure",
			type       => "child"
		}
	],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid alias)],
	version            => 1.0,
};

$objectDefinitions->{Structure} = {
	parents    => ['BiochemistryStructures'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0,
		},
		{
			name       => 'data',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'cksum',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'type',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		}
	],
	subobjects  => [],
	primarykeys => [qw(type cksum compound_uuid)],
	links       => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{AliasSet} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #KEGG, GenBank, SEED, ModelSEED
		{
			name       => 'source',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #url or pubmed ID indicating where the alias set came from
		{
			name       => 'class',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #
		{
			name       => 'attribute',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #
		{
			name       => 'aliases',
			printOrder => 0,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}     #url or pubmed ID indicating where the alias set came from
	],
	subobjects         => [],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Biochemistry} = {
	parents    => ["Ref"],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0,
		},
		{
			name       => 'defaultNameSpace',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => "ModelSEED",
			description =>
"The name of an [[AliasSet|#wiki-AliasSet]] to use in aliasSets for reaction and compound ids",
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'biochemistryStructures_uuid',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
		},
		{
			name       => 'forwardedLinks',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}
	],
	subobjects => [
		{
			name       => "compartments",
			printOrder => 0,
			class      => "Compartment",
			type       => "child"
		},
		{
			name       => "compounds",
			printOrder => 3,
			class      => "Compound",
			type       => "child"
		},
		{
			name       => "reactions",
			printOrder => 4,
			class      => "Reaction",
			type       => "child"
		},
		{ name => "media", printOrder => 2, class => "Media", type => "child" },
		{ name => "compoundSets", class => "CompoundSet", type => "child" },
		{ name => "reactionSets", class => "ReactionSet", type => "child" },
		{ name => "stimuli", class => "Stimuli", type => "child" },
		{ name => "aliasSets",    class => "AliasSet",    type => "child" },
		{
			name        => "cues",
			printOrder  => 1,
			class       => "Cue",
			type        => "encompassed",
			description => "Structural cues for parts of compund structures",
		},
	],
	primarykeys        => [qw(uuid)],
	links              => [
		{
			name      => "biochemistrystructures",
			attribute => "biochemistryStructures_uuid",
			parent    => "ModelSEED::Store",
			method    => "BiochemistryStructures",
			weak      => 0
		}
	],
	reference_id_types => [qw(uuid alias)],
	version            => 2.0,
};

$objectDefinitions->{Stimuli} = {
	parents    => ["Biochemistry"],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0,
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1,
		},
		{
			name       => 'abbreviation',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
		},
		{
			name       => 'description',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
		},
		{
			name       => 'type',
			printOrder => 3,
			perm       => 'rw',
			type       => 'ModelSEED::stimulitype',
			req        => 1,
		},
		{
			name       => 'compound_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
		},
	],
	subobjects => [],
	primarykeys        => [qw(uuid)],
	links              => [
		{
			name      => "compounds",
			attribute => "compound_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			weak      => 0,
			array	  => 1
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{AliasSet} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #KEGG, GenBank, SEED, ModelSEED
		{
			name       => 'source',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #url or pubmed ID indicating where the alias set came from
		{
			name       => 'class',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #
		{
			name       => 'attribute',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},    #
		{
			name       => 'aliases',
			printOrder => 0,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}     #url or pubmed ID indicating where the alias set came from
	],
	subobjects         => [],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Compartment} = {
	parents    => ['Biochemistry'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 36,
			req        => 1,
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
		},
		{
			name       => 'id',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			len        => 2,
			req        => 1,
			description =>
"Single charachter identifer for the compartment, e.g. 'e' or 'c'.",
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "",
		},
		{
			name       => 'hierarchy',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Int',
			req        => 0,
			default    => "",
			description =>
"Index indicating the position of a compartment relative to other compartments. Extracellular is 0. A compartment contained within another compartment has an index that is +1 over the outer comaprtment.",
		},
	],
	subobjects         => [],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Cue} = {
	parents    => ['Biochemistry'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 36,
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'abbreviation',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'cksum',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'unchargedFormula',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'formula',
			printOrder => 3,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'mass',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'defaultCharge',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'deltaG',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'deltaGErr',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'smallMolecule',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0
		},
		{
			name       => 'priority',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		},
		{
			name       => 'structure_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		}
	],
	subobjects => [],
	primarykeys        => [qw(uuid)],
	links              => [
		{
			name      => "structure",
			attribute => "structure_uuid",
			parent    => "BiochemistryStructures",
			method    => "structures",
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Compound} = {
	alias      => "Biochemistry",
	parents    => ['Biochemistry'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 36,
			req        => 0
		},
		{
			name       => 'isCofactor',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Bool',
			default    => '0',
			req        => 0,
			description =>
"A boolean indicating if this compound is a universal cofactor (e.g. water/H+).",
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'abbreviation',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'cksum',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "",
			description =>
			  "A computed hash for the compound, not currently implemented",
		},
		{
			name       => 'unchargedFormula',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "",
			description =>
			  "Formula for compound if it does not have a ionic charge.",
		},
		{
			name        => 'formula',
			printOrder  => 3,
			perm        => 'rw',
			type        => 'ModelSEED::varchar',
			req         => 0,
			default     => "",
			description => "Formula for the compound at pH 7.",
		},
		{
			name        => 'mass',
			printOrder  => 4,
			perm        => 'rw',
			type        => 'Num',
			req         => 0,
			description => "Atomic mass of the compound",
		},
		{
			name        => 'defaultCharge',
			printOrder  => 5,
			perm        => 'rw',
			type        => 'Num',
			req         => 0,
			default     => 0,
			description => "Computed charge for compound at pH 7.",
		},
		{
			name       => 'deltaG',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			description =>
			  "Computed Gibbs free energy value for compound at pH 7.",
		},
		{
			name       => 'deltaGErr',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			description =>
			  "Error bound on Gibbs free energy compoutation for compound.",
		},
		{
			name       => 'abstractCompound_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0,
			description => "Reference to abstract compound of which this compound is a specific class.",
		},
		{
			name       => 'comprisedOfCompound_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			description => "Array of references to subcompounds that this compound is comprised of.",
		},
		{
			name       => 'structure_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			description => "Array of associated molecular structures",
			default    => "sub{return [];}"
		},
		{
			name       => 'cues',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			description => "Hash of cue uuids with cue coefficients as values",
			default    => "sub{return {};}"
		},
		{
			name       => 'pkas',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			description => "Hash of pKa values with atom numbers as values",
			default    => "sub{return {};}"
		},
		{
			name       => 'pkbs',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			description => "Hash of pKb values with atom numbers as values",
			default    => "sub{return {};}"
		}
	],
	subobjects => [],
	links       => [
		{
			name      => "abstractCompound",
			attribute => "abstractCompound_uuid",
			parent    => "Biochemistry",
			method    => "compounds",
            can_be_undef => 1,
		},
		{
			name      => "comprisedOfCompounds",
			attribute => "comprisedOfCompound_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			array     => 1
		},
		{
			name      => "structures",
			attribute => "structure_uuids",
			parent    => "BiochemistryStructures",
			method    => "structures",
			array     => 1
		}
	],
	primarykeys => [qw(uuid)],
	reference_id_types => [qw(uuid)]
};

$objectDefinitions->{Reaction} = {
	alias      => "Biochemistry",
	parents    => ['Biochemistry'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 36,
			req        => 0,
			description => 'Universal ID for reaction'
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name      => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'abbreviation',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'cksum',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'deltaG',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'deltaGErr',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'direction',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 0,
			default    => "="
		},
		{
			name       => 'thermoReversibility',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 0
		},
		{
			name       => 'defaultProtons',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'status',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'cues',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'abstractReaction_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0,
			description => 'Reference to abstract reaction of which this reaction is an example.'
		},
	],
	subobjects => [
		{ name => "reagents", class => "Reagent", type => "encompassed" },
	],
	primarykeys        => [qw(uuid)],
	links       => [
		{
			name      => "abstractReaction",
			attribute => "abstractReaction_uuid",
			parent    => "Biochemistry",
			method    => "reactions",
            can_be_undef => 1,
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Reagent} = {
	parents    => ['Reaction'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'compound_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 36,
			req        => 1
		},
		{
			name       => 'compartment_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 36,
			req        => 1
		},
		{
			name       => 'coefficient',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
		{
			name       => 'isCofactor',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
	],
	subobjects  => [],
	primarykeys => [qw(compound_uuid compartment_uuid)],
	links       => [
		{
			name      => "compound",
			attribute => "compound_uuid",
			parent    => "Biochemistry",
			method    => "compounds"
		},
		{
			name      => "compartment",
			attribute => "compartment_uuid",
			parent    => "Biochemistry",
			method    => "compartments"
		},
	]
};

$objectDefinitions->{Media} = {
	parents    => ['Biochemistry'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'isDefined',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'isMinimal',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'id',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'type',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 0,
			default    => "unknown"
		},
	],
	subobjects => [
		{
			name  => "mediacompounds",
			class => "MediaCompound",
			type  => "encompassed"
		},
	],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{MediaCompound} = {
	parents    => ['Media'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'compound_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'concentration',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0.001"
		},
		{
			name       => 'maxFlux',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "100"
		},
		{
			name       => 'minFlux',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "-100"
		},
	],
	subobjects  => [],
	primarykeys => [qw(media_uuid compound_uuid)],
	links       => [
		{
			name      => "compound",
			attribute => "compound_uuid",
			parent    => "Biochemistry",
			method    => "compounds"
		},
	]
};

$objectDefinitions->{CompoundSet} = {
	parents    => ['Biochemistry'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'id',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'class',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "unclassified"
		},
		{
			name       => 'type',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'compound_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
	],
	subobjects => [],
	primarykeys        => [qw(uuid)],
	links              => [
		{
			name      => "compounds",
			attribute => "compound_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			array     => 1
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{ReactionSet} = {
	parents    => ['Biochemistry'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'id',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'class',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "unclassified"
		},
		{
			name       => 'type',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'reaction_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
	],
	subobjects => [],
	primarykeys        => [qw(uuid)],
	links              => [
		{
			name      => "reactions",
			attribute => "reaction_uuids",
			parent    => "Biochemistry",
			method    => "reactions",
			array     => 1
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{PROMModel} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => ""
		},
		{
			name       => 'annotation_uuid',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'forwardedLinks',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}
	],
	subobjects => [
		{
			name       => "transcriptionFactorMaps",
			printOrder => 0,
			class      => "TranscriptionFactorMap",
			type       => "child"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "annotation",
			attribute => "annotation_uuid",
			parent    => "ModelSEED::Store",
			method    => "Annotation",
			weak      => 0
		}
	],
	reference_id_types => [qw(uuid alias)],
	version            => 2.0,
};

$objectDefinitions->{TranscriptionFactorMap} = {
	parents    => ['PROMModel'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'transcriptionFactor_uuid',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1,
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => ""
		},
	],
	subobjects => [
		{
			name       => "transcriptionFactorMapTargets",
			printOrder => 0,
			class      => "TranscriptionFactorMapTarget",
			type       => "encompassed"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "transcriptionFactor",
			attribute => "transcriptionFactor_uuid",
			parent    => "Annotation",
			method    => "features"
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{TranscriptionFactorMapTarget} = {
	parents    => ['TranscriptionFactorMap'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'target_uuid',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1,
		},
		{
			name       => 'tfOffProbability',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 1,
			default    => 1
		},
		{
			name       => 'tfOnProbability',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 1,
			default    => 1
		},
	],
	subobjects => [],
	primarykeys => [qw(target_uuid)],
	links       => [
		{
			name      => "target",
			attribute => "target_uuid",
			parent    => "Annotation",
			method    => "features"
		}
	],
	reference_id_types => [qw(target_uuid)],
};

$objectDefinitions->{RegulatoryModel} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'defaultNameSpace',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => "ModelSEED"
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => ""
		},
		{
			name       => 'type',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => "AutoModel"
		},
		{
			name       => 'mapping_uuid',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'annotation_uuid',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'forwardedLinks',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}
	],
	subobjects => [
		{
			name       => "regulatoryModelRegulons",
			printOrder => 3,
			class      => "RegulatoryModelRegulon",
			type       => "child"
		}
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "mapping",
			attribute => "mapping_uuid",
			parent    => "ModelSEED::Store",
			method    => "Mapping",
			weak      => 0
		},
		{
			name      => "annotation",
			attribute => "annotation_uuid",
			parent    => "ModelSEED::Store",
			method    => "Annotation",
			weak      => 0
		}
	],
	reference_id_types => [qw(uuid alias)],
	version            => 2.0,
};

$objectDefinitions->{RegulatoryModelRegulon} = {
	parents    => ['RegulatoryModel'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'notes',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1
		},
		{
			name       => 'abbreviation',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0
		},
		{
			name       => 'feature_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		}
	],
	subobjects => [
		{
			name       => "regulonStimuli",
			printOrder => 0,
			class      => "RegulonStimuli",
			type       => "child"
		}
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "features",
			attribute => "feature_uuids",
			parent    => "Annotation",
			method    => "features",
			array     => 1
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{RegulonStimuli} = {
	parents    => ['RegulatoryModelRegulon'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'stimuli_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'isInhibitor',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Bool',
			req        => 1
		},
		{
			name       => 'strength',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "-1"
		},
		{
			name       => 'minConcentration',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "-1"
		},
		{
			name       => 'maxConcentration',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "-1"
		},
		{
			name       => 'regulator_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		}
	],
	subobjects => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "stimuli",
			attribute => "stimuli_uuid",
			parent    => "Mapping",
			method    => "stimuli",
		},
		{
			name      => "regulators",
			attribute => "regulator_uuids",
			parent    => "Annotation",
			method    => "features",
			array     => 1
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Model} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'kbid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'source_id',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'source',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'defaultNameSpace',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => "ModelSEED"
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'id',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => ""
		},
		{
			name       => 'version',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Int',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'type',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => "Singlegenome"
		},
		{
			name       => 'status',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0
		},
		{
			name       => 'growth',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'current',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Int',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'mapping_uuid',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'biochemistry_uuid',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'annotation_uuid',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'Genome_wsid',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'MetagenomeAnno_wsid',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'ModelTemplate_wsid',
			printOrder => 10,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'fbaFormulation_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'integratedGapfilling_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'integratedGapfillingSolutions',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'unintegratedGapfilling_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'integratedGapgen_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'integratedGapgenSolutions',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'unintegratedGapgen_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'forwardedLinks',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}
	],
	subobjects => [
		{
			name       => "biomasses",
			printOrder => 0,
			class      => "Biomass",
			type       => "child"
		},
		{
			name       => "modelcompartments",
			printOrder => 1,
			class      => "ModelCompartment",
			type       => "child"
		},
		{
			name       => "modelcompounds",
			printOrder => 2,
			class      => "ModelCompound",
			type       => "child"
		},
		{
			name       => "modelreactions",
			printOrder => 3,
			class      => "ModelReaction",
			type       => "child"
		}
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "fbaFormulations",
			attribute => "fbaFormulation_uuids",
			parent    => "ModelSEED::Store",
			method    => "FBAFormulation",
			array     => 1
		},
		{
			name      => "unintegratedGapfillings",
			attribute => "unintegratedGapfilling_uuids",
			parent    => "ModelSEED::Store",
			method    => "GapfillingFormulation",
			array     => 1
		},
		{
			name      => "integratedGapfillings",
			attribute => "integratedGapfilling_uuids",
			parent    => "ModelSEED::Store",
			method    => "GapfillingFormulation",
			array     => 1
		},
		{
			name      => "unintegratedGapgens",
			attribute => "unintegratedGapgen_uuids",
			parent    => "ModelSEED::Store",
			method    => "GapgenFormulation",
			array     => 1
		},
		{
			name      => "integratedGapgens",
			attribute => "integratedGapgen_uuids",
			parent    => "ModelSEED::Store",
			method    => "GapgenFormulation",
			array     => 1
		},
		{
			name      => "biochemistry",
			attribute => "biochemistry_uuid",
			parent    => "ModelSEED::Store",
			method    => "Biochemistry",
			weak      => 0
		},
		{
			name      => "mapping",
			attribute => "mapping_uuid",
			parent    => "ModelSEED::Store",
			method    => "Mapping",
			weak      => 0
		},
		{
			name      => "annotation",
			attribute => "annotation_uuid",
			parent    => "ModelSEED::Store",
			method    => "Annotation",
			weak      => 0
		}
	],
	reference_id_types => [qw(uuid alias)],
	version            => 2.0,
};

$objectDefinitions->{Biomass} = {
	alias      => "Model",
	parents    => ['Model'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'id',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'other',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'dna',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0.05"
		},
		{
			name       => 'rna',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0.1"
		},
		{
			name       => 'protein',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0.5"
		},
		{
			name       => 'cellwall',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0.15"
		},
		{
			name       => 'lipid',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0.05"
		},
		{
			name       => 'cofactor',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0.15"
		},
		{
			name       => 'energy',
			printOrder => 9,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "40"
		},
	],
	subobjects => [
		{
			name  => "biomasscompounds",
			class => "BiomassCompound",
			type  => "encompassed"
		}
	],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{BiomassCompound} = {
	parents    => ['Biomass'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'modelcompound_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'coefficient',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(biomass_uuid modelcompound_uuid)],
	links       => [
		{
			name      => "modelcompound",
			attribute => "modelcompound_uuid",
			parent    => "Model",
			method    => "modelcompounds"
		},
	]
};

$objectDefinitions->{ModelCompartment} = {
	parents    => ['Model'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'compartment_uuid',
			printOrder => 5,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'compartmentIndex',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Int',
			req        => 1
		},
		{
			name       => 'label',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'pH',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "7"
		},
		{
			name       => 'potential',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "compartment",
			attribute => "compartment_uuid",
			parent    => "Biochemistry",
			method    => "compartments"
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{ModelCompound} = {
	parents    => ['Model'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'compound_uuid',
			printOrder => 6,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'charge',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'formula',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'modelcompartment_uuid',
			printOrder => 5,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(model_uuid uuid)],
	links       => [
		{
			name      => "compound",
			attribute => "compound_uuid",
			parent    => "Biochemistry",
			method    => "compounds"
		},
		{
			name      => "modelcompartment",
			attribute => "modelcompartment_uuid",
			parent    => "Model",
			method    => "modelcompartments"
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{ModelReaction} = {
	parents    => ['Model'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'reaction_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'direction',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 0,
			default    => "="
		},
		{
			name       => 'protons',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => 0
		},
		{
			name       => 'modelcompartment_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'probability',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			default	   => 1,
			req        => 0
		}
	],
	subobjects => [
		{
			name  => "modelReactionProteins",
			class => "ModelReactionProtein",
			type  => "encompassed"
		},
		{
			name  => "modelReactionReagents",
			class => "ModelReactionReagent",
			type  => "encompassed"
		},
	],
	primarykeys => [qw(model_uuid uuid)],
	links       => [
		{
			name      => "reaction",
			attribute => "reaction_uuid",
			parent    => "Biochemistry",
			method    => "reactions"
		},
		{
			name      => "modelcompartment",
			attribute => "modelcompartment_uuid",
			parent    => "Model",
			method    => "modelcompartments"
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{ModelReactionReagent} = {
	parents    => ['ModelReaction'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'modelcompound_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			len        => 36,
			req        => 1
		},
		{
			name       => 'coefficient',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(modelcompound_uuid)],
	links       => [
		{
			name      => "modelcompound",
			attribute => "modelcompound_uuid",
			parent    => "Model",
			method    => "modelcompounds"
		}
	]
};

$objectDefinitions->{ModelReactionProtein} = {
	parents    => ['ModelReaction'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'complex_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'note',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		}
	],
	subobjects => [
		{
			name  => "modelReactionProteinSubunits",
			class => "ModelReactionProteinSubunit",
			type  => "encompassed"
		},
	],
	primarykeys => [qw()],
	links       => [
		{
			name      => "complex",
			attribute => "complex_uuid",
			parent    => "Mapping",
			method    => "complexes"
		}
	]
};

$objectDefinitions->{ModelReactionProteinSubunit} = {
	parents    => ['ModelReactionProtein'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'role_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'triggering',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'optional',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Bool',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'note',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
	],
	subobjects => [
		{
			name  => "modelReactionProteinSubunitGenes",
			class => "ModelReactionProteinSubunitGene",
			type  => "encompassed"
		},
	],
	primarykeys => [qw()],
	links       => [
		{
			name      => "role",
			attribute => "role_uuid",
			parent    => "Mapping",
			method    => "roles"
		}
	]
};

$objectDefinitions->{ModelReactionProteinSubunitGene} = {
	parents    => ['ModelReactionProteinSubunit'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'feature_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw()],
	links       => [
		{
			name      => "feature",
			attribute => "feature_uuid",
			parent    => "Annotation",
			method    => "features"
		}
	]
};

$objectDefinitions->{Annotation} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'defaultNameSpace',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => "SEED"
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'mapping_uuid',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str'
		},
		{
			name       => 'forwardedLinks',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}
	],
	subobjects => [
		{
			name       => "genomes",
			printOrder => 0,
			class      => "Genome",
			type       => "child"
		},
		{
			name       => "features",
			printOrder => 1,
			class      => "Feature",
			type       => "child"
		},
		{
			name       => "subsystemStates",
			printOrder => 2,
			class      => "SubsystemState",
			type       => "child"
		},
		{ name => "aliasSets",    class => "AliasSet",    type => "child" }
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "mapping",
			attribute => "mapping_uuid",
			parent    => "ModelSEED::Store",
			method    => "Mapping",
			weak      => 0
		},
	],
	reference_id_types => [qw(uuid alias)],
	version            => 1.0,
};

$objectDefinitions->{Genome} = {
	parents    => ['Annotation'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'id',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'source',
			printOrder => 8,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1
		},
		{
			name       => 'class',
			printOrder => 3,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},    #gramPositive,gramNegative,archaea,eurkaryote
		{
			name       => 'taxonomy',
			printOrder => 4,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'cksum',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'size',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		},
		{
			name       => 'gc',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			req        => 0
		},
		{
			name       => 'etcType',
			printOrder => 7,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			len        => 1,
			req        => 0
		},    #aerobe,facultativeAnaerobe,obligateAnaerobe
	],
	subobjects         => [],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Feature} = {
	parents    => ['Annotation'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'id',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0
		},
		{
			name       => 'cksum',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'genome_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'start',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		},
		{
			name       => 'stop',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Int',
			req        => 0
		},
		{
			name       => 'contig',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'direction',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'sequence',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'type',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
	],
	subobjects => [
		{
			name  => "featureroles",
			class => "FeatureRole",
			type  => "encompassed"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "genome",
			attribute => "genome_uuid",
			parent    => "Annotation",
			method    => "genomes"
		},
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{FeatureRole} = {
	parents    => ['Feature'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'role_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'compartment',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			default    => "unknown"
		},
		{
			name       => 'comment',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			default    => ""
		},
		{
			name       => 'delimiter',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			default    => ""
		},
	],
	subobjects  => [],
	primarykeys => [qw(annotation_uuid feature_uuid role_uuid)],
	links       => [
		{
			name      => "role",
			attribute => "role_uuid",
			parent    => "Mapping",
			method    => "roles"
		},
	]
};

$objectDefinitions->{SubsystemState} = {
	parents    => ['Annotation'],
	class      => 'child',
	attributes => [
		{
			name       => 'roleset_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'variant',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		}
	],
	subobjects         => [],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Classifier} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 4,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'type',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'mapping_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
	],
	subobjects  => [
		{
			name       => "classifierRoles",
			printOrder => 0,
			class      => "ClassifierRole",
			type       => "child"
		},
		{
			name       => "classifierClassifications",
			printOrder => 0,
			class      => "ClassifierClassification",
			type       => "child"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "mapping",
			attribute => "mapping_uuid",
			parent    => "ModelSEED::Store",
			method    => "Mapping",
			weak      => 0
		},
	],
	reference_id_types => [qw(uuid alias)],
	version            => 1.0,
};

$objectDefinitions->{ClassifierClassification} = {
	parents    => ['Classifier'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0,
		},
		{
			name       => 'name',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1,
		},
		{
			name       => 'populationProbability',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 1,
		}
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => []
};

$objectDefinitions->{ClassifierRole} = {
	parents    => ['Classifier'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'classification_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'classificationProbabilities',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub{return {};}"
		},
		{
			name       => 'role_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "role",
			attribute => "role_uuid",
			parent    => "Mapping",
			method    => "roles"
		},
		{
			name      => "classifications",
			attribute => "classification_uuids",
			parent    => "Classifier",
			method    => "classifierClassifications",
			array => 1
		},
	]
};

$objectDefinitions->{ModelTemplate} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1
		},
		{
			name       => 'modelType',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1
		},
		{
			name       => 'domain',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 1
		},
		{
			name       => 'mapping_uuid',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
	],
	subobjects => [
		{
			name       => "templateReactions",
			printOrder => 0,
			class      => "TemplateReaction",
			type       => "child"
		},
		{
			name       => "templateBiomasses",
			printOrder => 0,
			class      => "TemplateBiomass",
			type       => "child"
		},
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "mapping",
			attribute => "mapping_uuid",
			parent    => "ModelSEED::Store",
			method    => "Mapping",
			weak      => 0
		}
	],
	reference_id_types => [qw(uuid alias)],
	version            => 1.0,
};

$objectDefinitions->{TemplateReaction} = {
	parents    => ['ModelTemplate'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'reaction_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'compartment_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'complex_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0
		},
		{
			name       => 'direction',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
		},
		{
			name       => 'type',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
		},
	],
	subobjects => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "reaction",
			attribute => "reaction_uuid",
			parent    => "Biochemistry",
			method    => "reactions",
			weak      => 1
		},
		{
			name      => "compartment",
			attribute => "compartment_uuid",
			parent    => "Biochemistry",
			method    => "compartments",
			weak      => 1
		},
		{
			name      => "complexes",
			attribute => "complex_uuids",
			parent    => "Mapping",
			method    => "complexes",
			weak      => 1,
			array	  => 1
		}
	],
};

$objectDefinitions->{TemplateBiomass} = {
	parents    => ['ModelTemplate'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1,
		},
		{
			name       => 'type',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "defaultGrowth"
		},
		{
			name       => 'other',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'dna',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'rna',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'protein',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'lipid',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'cellwall',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'cofactor',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'energy',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		}
	],
	subobjects => [
		{
			name  => "templateBiomassComponents",
			class => "TemplateBiomassComponent",
			type  => "child"
		},
	],
	primarykeys => [qw(uuid)],
	links       => []
};

$objectDefinitions->{TemplateBiomassComponent} = {
	parents    => ['TemplateBiomass'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'class',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'universal',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Bool',
			default    => 0
		},
		{
			name       => 'compound_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'compartment_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'linkedCompound_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'coefficientType',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'coefficient',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "1"
		},
		{
			name       => 'linkCoefficients',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
		{
			name       => 'classifierClassification_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'classifier_uuid',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "compound",
			attribute => "compound_uuid",
			parent    => "Biochemistry",
			method    => "compounds",
		},
		{
			name      => "compartment",
			attribute => "compartment_uuid",
			parent    => "Biochemistry",
			method    => "compartments",
		},
		{
			name      => "linkedCompounds",
			attribute => "linkedCompound_uuids",
			parent    => "Biochemistry",
			method    => "compounds",
			array => 1
		},
		{
			name      => "classifierClassification",
			attribute => "classifierClassification_uuid",
			parent    => "Classifier",
			method    => "classifierClassifications",
			array => 1
		},
		{
			name      => "classifier",
			attribute => "classifier_uuid",
			parent    => "ModelSEED::Store",
			method    => "Classifier",
			weak      => 0
		}
	]
};

$objectDefinitions->{Mapping} = {
	parents    => ['Ref'],
	class      => 'indexed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'defaultNameSpace',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 0,
			default    => "SEED"
		},
		{
			name       => 'biochemistry_uuid',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'forwardedLinks',
			printOrder => -1,
			perm       => 'rw',
			type       => 'HashRef',
			req        => 0,
			default    => "sub {return {};}"
		}
	],
	subobjects => [
		{
			name       => "universalReactions",
			printOrder => 0,
			class      => "UniversalReaction",
			type       => "child"
		},
		{
			name       => "biomassTemplates",
			printOrder => 1,
			class      => "BiomassTemplate",
			type       => "child"
		},
		{ name => "roles", printOrder => 2, class => "Role", type => "child" },
		{
			name       => "rolesets",
			printOrder => 3,
			class      => "RoleSet",
			type       => "child"
		},
		{
			name       => "complexes",
			printOrder => 4,
			class      => "Complex",
			type       => "child"
		},
		{
			name       => "mappingClassifiers",
			printOrder => 5,
			class      => "MappingClassifier",
			type       => "child"
		},
		{ name => "aliasSets", class => "AliasSet", type => "child" },
	],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "biochemistry",
			attribute => "biochemistry_uuid",
			parent    => "ModelSEED::Store",
			method    => "Biochemistry",
			weak      => 0
		}
	],
	reference_id_types => [qw(uuid alias)],
	version            => 2.0,
};

$objectDefinitions->{MappingClassifier} = {
	parents    => ['Mapping'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'name',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'type',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'classifer_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "classifier",
			attribute => "classifer_uuid",
			parent    => "ModelSEED::Store",
			method    => "Classifer",
			weak      => 0
		},
	]
};

$objectDefinitions->{UniversalReaction} = {
	parents    => ['Mapping'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'type',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Str',
			req        => 1
		},
		{
			name       => 'reaction_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "reaction",
			attribute => "reaction_uuid",
			parent    => "Biochemistry",
			method    => "reactions"
		},
	]
};

$objectDefinitions->{BiomassTemplate} = {
	parents    => ['Mapping'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'class',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'dna',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'rna',
			printOrder => 3,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'protein',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'lipid',
			printOrder => 5,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'cellwall',
			printOrder => 6,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'cofactor',
			printOrder => 7,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'energy',
			printOrder => 8,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		}
	],
	subobjects => [
		{
			name  => "biomassTemplateComponents",
			class => "BiomassTemplateComponent",
			type  => "child"
		},
	],
	primarykeys => [qw(uuid)],
	links       => []
};

$objectDefinitions->{BiomassTemplateComponent} = {
	parents    => ['BiomassTemplate'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'class',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'compound_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'coefficientType',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'coefficient',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Num',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'condition',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => "0"
		},
	],
	subobjects  => [],
	primarykeys => [qw(uuid)],
	links       => [
		{
			name      => "compound",
			attribute => "compound_uuid",
			parent    => "Biochemistry",
			method    => "compounds"
		},
	]
};

$objectDefinitions->{Role} = {
	alias      => "Mapping",
	parents    => ['Mapping'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0,
			default    => ""
		},
		{
			name       => 'seedfeature',
			printOrder => 2,
			perm       => 'rw',
			type       => 'Str',
			len        => 36,
			req        => 0
		}
	],
	subobjects         => [],
	primarykeys        => [qw(uuid)],
	links              => [],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{RoleSet} = {
	alias      => "Mapping",
	parents    => ['Mapping'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 3,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'class',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "unclassified"
		},
		{
			name       => 'subclass',
			printOrder => 2,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => "unclassified"
		},
		{
			name       => 'type',
			printOrder => 4,
			perm       => 'rw',
			type       => 'Str',
			len        => 32,
			req        => 1
		},
		{
			name       => 'role_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		}
	],
	subobjects => [],
	primarykeys        => [qw(uuid)],
	links              => [
		{
			name      => "roles",
			attribute => "role_uuids",
			parent    => "Mapping",
			method    => "roles",
			array => 1
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{Complex} = {
	alias      => "Mapping",
	parents    => ['Mapping'],
	class      => 'child',
	attributes => [
		{
			name       => 'uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 0
		},
		{
			name       => 'modDate',
			printOrder => -1,
			perm       => 'rw',
			type       => 'Str',
			req        => 0
		},
		{
			name       => 'name',
			printOrder => 1,
			perm       => 'rw',
			type       => 'ModelSEED::varchar',
			req        => 0,
			default    => ""
		},
		{
			name       => 'reaction_uuids',
			printOrder => -1,
			perm       => 'rw',
			type       => 'ArrayRef',
			req        => 0,
			default    => "sub{return [];}"
		},
	],
	subobjects => [
		{
			name  => "complexroles",
			class => "ComplexRole",
			type  => "encompassed"
		}
	],
	primarykeys        => [qw(uuid)],
	links              => [
		{
			name      => "reactions",
			attribute => "reaction_uuids",
			parent    => "Biochemistry",
			method    => "reactions",
			array => 1
		}
	],
	reference_id_types => [qw(uuid)],
};

$objectDefinitions->{ComplexRole} = {
	parents    => ['Complex'],
	class      => 'encompassed',
	attributes => [
		{
			name       => 'role_uuid',
			printOrder => 0,
			perm       => 'rw',
			type       => 'ModelSEED::uuid',
			req        => 1
		},
		{
			name       => 'optional',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Int',
			req        => 0,
			default    => "0"
		},
		{
			name       => 'type',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Str',
			len        => 1,
			req        => 0,
			default    => "G"
		},
		{
			name       => 'triggering',
			printOrder => 0,
			perm       => 'rw',
			type       => 'Int',
			len        => 1,
			req        => 0,
			default    => "1"
		}
	],
	subobjects  => [],
	primarykeys => [qw(complex_uuid role_uuid)],
	links       => [
		{
			name      => "role",
			attribute => "role_uuid",
			parent    => "Mapping",
			method    => "roles"
		}
	]
};

#ORPHANED OBJECTS THAT STILL NEED TO BE BUILT INTO AN OBJECT TREE
#$objectDefinitions->{Strain} = {
#	parents => ['Genome'],
#	class => 'child',
#	attributes => [
#		{name => 'uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'modDate',printOrder => -1,perm => 'rw',type => 'Str',req => 0},
#		{name => 'name',printOrder => 0,perm => 'rw',type => 'ModelSEED::varchar',req => 0,default => ""},
#		{name => 'source',printOrder => 0,perm => 'rw',type => 'ModelSEED::varchar',req => 1},
#		{name => 'class',printOrder => 0,perm => 'rw',type => 'ModelSEED::varchar',req => 0,default => ""},
#	],
#	subobjects => [
#		{name => "deletions",class => "Deletion",type => "child"},
#		{name => "insertions",class => "Insertion",type => "child"},
#	],
#	primarykeys => [ qw(uuid) ],
#	links => [],
#    reference_id_types => [ qw(uuid) ],
#};
#
#$objectDefinitions->{Deletion} = {
#	parents => ['Genome'],
#	class => 'child',
#	attributes => [
#		{name => 'uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'start',printOrder => 0,perm => 'rw',type => 'Int',req => 0},
#		{name => 'stop',printOrder => 0,perm => 'rw',type => 'Int',req => 0,default => ""},
#	],
#	subobjects => [],
#	primarykeys => [ qw(uuid) ],
#	links => [],
#    reference_id_types => [ qw(uuid) ],
#};
#
#$objectDefinitions->{Insertion} = {
#	parents => ['Genome'],
#	class => 'child',
#	attributes => [
#		{name => 'uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'insertionTarget',printOrder => 0,perm => 'rw',type => 'Int',req => 0},
#		{name => 'sequence',printOrder => 0,perm => 'rw',type => 'Str',req => 0,default => ""},
#	],
#	subobjects => [],
#	primarykeys => [ qw(uuid) ],
#	links => [],
#    reference_id_types => [ qw(uuid) ],
#};
#
#$objectDefinitions->{Experiment} = {
#	parents => ["ModelSEED::Store"],
#	class => 'indexed',
#	attributes => [
#		{name => 'uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'genome_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},#I think this should be Strain.Right now, we�re linking an experiment to a single GenomeUUID here, but I think it makes more sense to link to a single StrainUUID, which is what we do in the Price DB.
#		{name => 'name',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#		{name => 'description',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#		{name => 'institution',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#		{name => 'source',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#	],
#	subobjects => [],
#	primarykeys => [ qw(uuid) ],
#	links => [
#		{name => "genome",attribute => "genome_uuid",parent => "ModelSEED::Store",method=>"genomes"},
#	],
#    reference_id_types => [ qw(uuid alias) ],
#    version => 1.0,
#};
#
#$objectDefinitions->{ExperimentDataPoint} = {
#	parents => ["Experiment"],
#	class => 'child',
#	attributes => [
#		{name => 'uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'strain_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},#Not needed if it�s in the experiment table? I think we need to be consistent in defining where in these tables to put e.g. genetic perturbations done in an experiment.
#		{name => 'media_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'pH',printOrder => 0,perm => 'rw',type => 'Num',req => 0},
#		{name => 'temperature',printOrder => 0,perm => 'rw',type => 'Num',req => 0},
#		{name => 'buffers',printOrder => 0,perm => 'rw',type => 'Str',req => 0},#There could be multiple buffers in a single media. Would this be listed in the Media table? Multiple buffers in single media isn�t something we�ve run across yet and seems like a rarity at best, since their purpose is maintaining pH.  We discussed just listing the buffer here, without amount, because the target pH should dictate the amount of buffer.
#		{name => 'phenotype',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#		{name => 'notes',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#		{name => 'growthMeasurement',printOrder => 0,perm => 'rw',type => 'Num',req => 0},#Would these be better in their own table? IT�s just another type of measurement just like the flux, metabolite, etc... One reason to keep the growth measurements here is unit consistency; moving them to the other table with the other flux measurements would require a clear division between growth rates and secretion/uptake rates to distinguish between 1/h and mmol/gDW/h. Rather than do that, I think keeping them in separate tables makes for an easy, logical division.
#		{name => 'growthMeasurementType',printOrder => 0,perm => 'rw',type => 'Str',req => 0},#Would these be better in their own table?
#	],
#	subobjects => [
#		{name => "fluxMeasurements",class => "FluxMeasurement",type => "child"},
#		{name => "uptakeMeasurements",class => "UptakeMeasurement",type => "child"},
#		{name => "metaboliteMeasurements",class => "MetaboliteMeasurement",type => "child"},
#		{name => "geneMeasurements",class => "GeneMeasurement",type => "child"},
#	],
#	primarykeys => [ qw(uuid) ],
#	links => [
#		{name => "strain",attribute => "strain_uuid",parent => "Genome",method=>"strains"},
#		{name => "media",attribute => "media_uuid",parent => "Biochemistry",method=>"media"},
#	],
#    reference_id_types => [ qw(uuid) ],
#};
#
#$objectDefinitions->{FluxMeasurement} = {
#	parents => ["ExperimentDataPoint"],
#	class => 'encompassed',
#	attributes => [
#		{name => 'value',printOrder => 0,perm => 'rw',type => 'Str',req => 0},#This could get confusing. Make sure the rate is defined relative to the way that the reaction itself is defined (i.e. even if the directionality of the reaction is <= we should define the rate relative to the forward direction, and if it is consistent with the directionality constraint it would be negative)
#		{name => 'reacton_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'compartment_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'type',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#	],
#	subobjects => [],
#	primarykeys => [ qw(uuid) ],
#	links => [
#		{name => "reaction",attribute => "reacton_uuid",parent => "Biochemistry",method=>"reactions"},
#		{name => "compartment",attribute => "compartment_uuid",parent => "Biochemistry",method=>"compartments"},
#	],
#};
#
#$objectDefinitions->{UptakeMeasurement} = {
#	parents => ["ExperimentDataPoint"],
#	class => 'encompassed',
#	attributes => [
#		{name => 'value',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#		{name => 'compound_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'type',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#	],
#	subobjects => [],
#	primarykeys => [ qw(uuid) ],
#	links => [
#		{name => "compound",attribute => "compound_uuid",parent => "Biochemistry",method=>"compounds"},
#	],
#};
#
#$objectDefinitions->{MetaboliteMeasurement} = {
#	parents => ["ExperimentDataPoint"],
#	class => 'encompassed',
#	attributes => [
#		{name => 'value',printOrder => 0,perm => 'rw',type => 'Str',req => 0},#In metabolomic experiments it is often hard to measure precisely whether a metabolite is present or not. and (even more so) it�s concentration. However, I imagine it is possible to guess a �probability� of particular compounds being present or not. I wanted to talk to one of the guys at Argonne (The guy who was trying to schedule the workshop for KBase) about metabolomics but we ran out of time. We should consult with a metabolomics expert on what a realistic thing to put into this table would be.
#		{name => 'compound_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'compartment_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},#I changed this from �extracellular [0/1]� since we could techincally measure them in any given compartment, not just cytosol vs. extracellular
#		{name => 'method',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#	],
#	subobjects => [],
#	primarykeys => [ qw(uuid) ],
#	links => [
#		{name => "compound",attribute => "compound_uuid",parent => "Biochemistry",method=>"compounds"},
#		{name => "compartment",attribute => "compartment_uuid",parent => "Biochemistry",method=>"compartments"},
#	],
#};
#
#$objectDefinitions->{GeneMeasurement} = {
#	parents => ["ExperimentDataPoint"],
#	class => 'encompassed',
#	attributes => [
#		{name => 'value',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#		{name => 'feature_uuid',printOrder => 0,perm => 'rw',type => 'ModelSEED::uuid',req => 0},
#		{name => 'method',printOrder => 0,perm => 'rw',type => 'Str',req => 0},
#	],
#	subobjects => [],
#	primarykeys => [ qw(uuid) ],
#	links => [
#		{name => "feature",attribute => "feature_uuid",parent => "Genome",method=>"features"},
#	],
#};

sub objectDefinitions {
	return $objectDefinitions;
}

1;
