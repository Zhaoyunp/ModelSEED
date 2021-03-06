########################################################################
# ModelSEED::MS::Factories - This is the factory for producing the moose objects from the SEED data
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-03-15T16:44:01
########################################################################
use strict;
use Data::Dumper;
package ModelSEED::MS::Factories::ExchangeFormatFactory;
use ModelSEED::utilities;
use Moose;
use namespace::autoclean;
use Class::Autouse qw(
	ModelSEED::MS::FBAFormulation
    ModelSEED::MS::GapfillingFormulation
    ModelSEED::MS::GapgenFormulation
    ModelSEED::MS::ModelTemplate
);
#***********************************************************************************************************
# ATTRIBUTES:
#***********************************************************************************************************

#***********************************************************************************************************
# BUILDERS:
#***********************************************************************************************************

#***********************************************************************************************************
# CONSTANTS:
#***********************************************************************************************************


#***********************************************************************************************************
# FUNCTIONS:
#***********************************************************************************************************

=head3 buildRegulatoryModel

Definition:
	ModelSEED::MS::RegulatoryModel = buildRegulatoryModel({
		filename => string,
		type => string,
		name => string
	});
Description:
	Parses the bayesian classifier file into a classifier object

=cut

sub buildRegulatoryModel {
    my $self = shift;
	my $args = ModelSEED::utilities::args(["genes","mapping","annotation"],{
		name => undef,
		type => "ManualModel"
	}, @_);
	if (!defined($args->{name})) {
		$args->{name} = $args->{annotation}->name();
	}
	my $mapping = $args->{mapping};
	my $anno = $args->{annotation};
	my $regmdl = ModelSEED::MS::RegulatoryModel->new({
		defaultNameSpace => "SEED",
		name => $args->{name},
		type => $args->{type},
		mapping_uuid => $args->{mapping}->uuid(),
		annotation_uuid => $args->{annotation}->uuid(),
	});
	my $regulons;
	my $missing = {};
	for (my $i=0; $i < @{$args->{genes}}; $i++) {
		my $gene = $args->{genes}->[$i];
		my $geneobj = $anno->searchForFeature($gene->[1]);
		if (!defined($geneobj)) {
			push(@{$missing->{genes}},$gene->[1]);
			next;
		}
		$regulons->{$gene->[0]}->{genes}->{$geneobj->uuid()} = 1;
		my $stimobj = $mapping->searchForStimuli($gene->[2]);
		if (!defined($stimobj)) {
			push(@{$missing->{stimuli}},$gene->[2]);
			next;
		}
		if (defined($regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()})) {
			if ($regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()} ne $gene->[3]) {
				ModelSEED::utilities::USEWARNING("Conflicting sign for stimuli ".$gene->[2]." in regulon ".$gene->[0]);
			}
		} else {
			if ($gene->[3] == -1) {
				$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{isInhibitor} = 1;
			} else {
				$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{isInhibitor} = 0;
			}
		}
		if (defined($gene->[5])) {
			$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{strength} = $gene->[5];
		} else {
			$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{strength} = 1;
		}
		if (defined($gene->[6])) {
			$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{MinConcentration} = $gene->[6];
		} else {
			$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{MinConcentration} = 0.0000001;
		}
		if (defined($gene->[7])) {
			$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{MaxConcentration} = $gene->[7];
		} else {
			$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{MaxConcentration} = 1;
		}
		$geneobj = $anno->searchForFeature($gene->[4]);
		if (!defined($geneobj)) {
			push(@{$missing->{regulators}},$gene->[1]);
			next;
		}
		$regulons->{$gene->[0]}->{stimuli}->{$stimobj->uuid()}->{regulators}->{$geneobj->uuid()} = 1;
	}
	foreach my $reg (keys(%{$regulons})) {
		my $regulator = $regulons->{$reg};
		my $regobj = $regmdl->add("regulatoryModelRegulons",{
			name => $reg,
			abbreviation => $reg,
			feature_uuids => [keys(%{$regulons->{$reg}->{genes}})],
		});
		foreach my $stim (keys(%{$regulons->{$reg}->{stimuli}})) {
			my $stimuli = $regulons->{$reg}->{stimuli}->{$stim};
			$regobj->add("regulonStimuli",{
				stimuli_uuid => $stim,
				isInhibitor => $stimuli->{isInhibitor},
				strength => $stimuli->{isInhibitor},
				minConcentration => $stimuli->{MinConcentration},
				maxConcentration => $stimuli->{MaxConcentration},
				regulator_uuids => [keys(%{$stimuli->{regulators}})]
			});
		}
	}
	return ($regmdl,$missing);
}

=head3 buildClassifier

Definition:
	ModelSEED::MS::Classifier = buildClassifier({
		filename => string,
		type => string,
		name => string
	});
Description:
	Parses the bayesian classifier file into a classifier object

=cut

sub buildClassifier {
    my $self = shift;
	my $args = ModelSEED::utilities::args(["filename","name","mapping"],{}, @_);
	my $mapping = $args->{mapping};
	my $data = ModelSEED::utilities::LOADFILE($args->{filename});
	my $headings = [split(/\t/,$data->[0])];
	my $popprob = [split(/\t/,$data->[1])];
	my $classifier = ModelSEED::MS::Classifier->new({
		name => $args->{name},
		type => $headings->[0],
		mapping_uuid => $mapping->uuid(),
		mapping => $mapping
	});
	my $cfHash = {};
	for (my $i=1; $i < @{$headings}; $i++) {
		$cfHash->{$headings->[$i]} = $classifier->add("classifierClassifications",{
			name => $headings->[$i],
			populationProbability => $popprob->[$i]
		});
	}
	my $cfRoleHash = {};
	for (my $i=2;$i < @{$data}; $i++) {
		my $row = [split(/\t/,$data->[$i])];
		my $objData = {
			classifications => [],
			classification_uuids => [],
			classificationProbabilities => {},
			role_uuid => undef
		};
		for (my $j=1; $j < @{$headings}; $j++) {
			my $cf = $cfHash->{$headings->[$j]};
			push(@{$objData->{classification_uuids}},$cf->uuid());
			push(@{$objData->{classifications}},$cf);
			$objData->{classificationProbabilities}->{$cf->uuid()} = $row->[$j];
		}
		my $role = $args->{mapping}->queryObject("roles",{name => $row->[0]});
		if (!defined($role)) {
			$role = $args->{mapping}->add("roles",{
				name => $row->[0]
			});
		}
		$objData->{role_uuid} = $role->uuid();
		$cfRoleHash->{$row->[0]} = $classifier->add("classifierRoles",$objData);
	}
	return ($classifier);   #,$mapping); THIS VARIABLE IS UNDEFINED
}

=head3 buildFBAFormulation

Definition:
	ModelSEED::MS::FBAFormulation = buildFBAFormulation({
		array => [string],
		filename => string,
		text => string,
		model => ModelSEED::MS::Model
	});
Description:
	Parses the FBA formulation exchange object

=cut

sub buildFBAFormulation {
    my $self = shift;
	my $args = ModelSEED::utilities::args(["model"],{
		text => undef,
		filename => undef,
		overrides => {}
	}, @_);
	my $model = $args->{model};
        my $pmodel = $args->{promModel};
	my $data = $self->parseExchangeFileArray($args);
	#Setting default values for exchange format attributes
	$data = ModelSEED::utilities::args([],{
		media => "Media/name/Complete",
		type => "singlegrowth",
		simpleThermoConstraints => 0,
		thermodynamicConstraints => 0,
		noErrorThermodynamicConstraints => 0,
		minimizeErrorThermodynamicConstraints => 0,
		fva => 0,
		notes => "",
		comboDeletions => 0,
		fluxMinimization => 0,
		findMinimalMedia => 0,
		objectiveConstraintFraction => 0.1,
		allReversible => 0,
		dilutionConstraints => 0,
		uptakeLimits => "none",
		geneKO => "none",
		reactionKO => "none",
		parameters => "none",
		numberOfSolutions => 1,
		defaultMaxFlux => 100,
		defaultMaxDrainFlux => 0,
		defaultMinDrainFlux => -100,
		maximizeObjective => 1,
		decomposeReversibleFlux => 0,
		decomposeReversibleDrainFlux => 0,
		fluxUseVariables => 0,
		drainfluxUseVariables => 0,
		fbaConstraints => [],
		fbaObjectiveTerms => [{
			variableType => "biomassflux",
			id => "Biomass/id/bio1",
			coefficient => 1
		}],
		fbaPhenotypeSimulations => [],
		promModel => ""
	}, $data);
	# Finding (or creating) the media
	(my $media) = $model->interpretReference($data->{media},"Media");
	if (!defined($media)) {
		ModelSEED::utilities::ERROR("Media referenced in formulation not found in database: ".$data->{media});
	}
	# Creating objects and populating with provenance objects
	my $form = ModelSEED::MS::FBAFormulation->new({
		promModel_uuid => (defined $pmodel) ?  $pmodel->uuid() : "",
		PROMModel => $pmodel,
		parent => $model->parent(),
		model_uuid => $model->uuid(),
		model => $model,
		media_uuid => $media->uuid(),
		type => $data->{type},
		notes => $data->{notes},
		growthConstraint => $data->{growthConstraint},
		simpleThermoConstraints => $data->{simpleThermoConstraints},
		thermodynamicConstraints => $data->{thermodynamicConstraints},
		noErrorThermodynamicConstraints => $data->{noErrorThermodynamicConstraints},
		minimizeErrorThermodynamicConstraints => $data->{minimizeErrorThermodynamicConstraints},
		fva => $data->{fva},
		comboDeletions => $data->{comboDeletions},
		fluxMinimization => $data->{fluxMinimization},
		findMinimalMedia => $data->{findMinimalMedia},
		objectiveConstraintFraction => $data->{objectiveConstraintFraction},
		allReversible => $data->{allReversible},
		uptakeLimits => $self->stringToHash($data->{uptakeLimits}),
		defaultMaxFlux => $data->{defaultMaxFlux},
		defaultMaxDrainFlux => $data->{defaultMaxDrainFlux},
		defaultMinDrainFlux => $data->{defaultMinDrainFlux},
		maximizeObjective => $data->{maximizeObjective},
		decomposeReversibleFlux => $data->{decomposeReversibleFlux},
		decomposeReversibleDrainFlux => $data->{decomposeReversibleDrainFlux},
		fluxUseVariables => $data->{fluxUseVariables},
		drainfluxUseVariables => $data->{drainfluxUseVariables},
		parameters => $self->stringToHash($data->{parameters}),
		numberOfSolutions => $data->{numberOfSolutions},
	});
	$form->parsePhenotypeSimulations({fbaPhenotypeSimulations => $data->{fbaPhenotypeSimulations}});
	$form->parseObjectiveTerms({objTerms => $data->{fbaObjectiveTerms}});
	$form->parseGeneKOList({string => $data->{geneKO}});
	$form->parseReactionKOList({string => $data->{reactionKO}});
	$form->parseConstraints({constraints => $data->{fbaConstraints}});
	return $form;
}

=head3 buildTemplateModel
Definition:
	ModelSEED::MS::ModelTemplate = buildTemplateModel({
		templateReactions => [[]],
		templateBiomass => [[]],
		name => string,
		modelType => string,
		mapping => ModelSEED::MS::Mapping,
		domain => string
	});
Description:
	Build template model from template model data

=cut

sub buildTemplateModel {
	my $self = shift;
	my $args = ModelSEED::utilities::args(["templateReactions","templateBiomass","mapping","name"],{
		modelType => "GenomeScale",
		domain => "Bacteria"
	}, @_);
	my $mdlTmp = ModelSEED::MS::ModelTemplate->new({
		name => $args->{name},
		modelType => $args->{modelType},
		domain => $args->{domain},
		mapping_uuid => $args->{mapping}->uuid()
	});
	my $map = $args->{mapping};
	my $bio = $map->biochemistry();
	for (my $i=0; $i < @{$args->{templateReactions}}; $i++) {
		my $row = $args->{templateReactions}->[$i];
		my $rxn = $bio->searchForReaction($row->[0]);
		if (!defined($rxn)) {
			ModelSEED::utilities::error("Reaction ".$row->[0]." not found!");
		}
		my $cmp = $bio->searchForCompartment($row->[1]);
		if (!defined($cmp)) {
			ModelSEED::utilities::error("Compartment ".$row->[1]." not found!");
		}
		my $cpxs = [];
		for (my $j=0; $j < @{$row->[4]}; $j++) {
			my $cpx = $map->searchForComplex($row->[4]->[$j]);
			if (!defined($cpx)) {
				ModelSEED::utilities::error("Complex ".$row->[4]->[$j]." not found!");
			}
			push(@{$cpxs},$cpx->uuid());
		}
		if (!defined($row->[2]) || length($row->[2]) == 0) {
			$row->[2] = $rxn->direction();
		}
		if (!defined($row->[3]) || length($row->[3]) == 0) {
			$row->[3] = "conditional";
		}
		$mdlTmp->add("templateReactions",{
			reaction_uuid => $rxn->uuid(),
			compartment_uuid => $cmp->uuid(),
			direction => $row->[2],
			type => $row->[3],
			complex_uuids => $cpxs
		});
	}
	for (my $i=0; $i < @{$args->{templateBiomass}}; $i++) {
		my $row = $args->{templateBiomass}->[$i];
		my $comps = [];
		my $tmpBio = $mdlTmp->add("templateBiomasses",{
			name => $row->[0],
			type => $row->[1],
			dna => $row->[2],
			rna => $row->[3],
			protein => $row->[4],
			lipid => $row->[5],
			cellwall => $row->[6],
			cofactor => $row->[7],
			energy => $row->[8],
			other => $row->[9]
		});
		for (my $j=0; $j < @{$row->[10]}; $j++) {
			my $comprow = $row->[10]->[$j];
			my $cmp = $bio->searchForCompartment($comprow->[1]);
			if (!defined($cmp)) {
				ModelSEED::utilities::error("Compartment ".$comprow->[1]." not found!");
			}
			my $cpd = $bio->searchForCompound($comprow->[0]);
			if (!defined($cpd)) {
				ModelSEED::utilities::error("Compound ".$comprow->[0]." not found!");
			}
			my $comp = ModelSEED::MS::TemplateBiomassComponent->new({
				class => $comprow->[2],
				compound_uuid => $cpd->uuid(),
				compartment_uuid => $cmp->uuid(),
				coefficientType => $comprow->[3],
				coefficient => $comprow->[4],
			});
			if ($comprow->[5] eq "universal") {
				$comp->universal(1);
			} elsif ($comprow->[5] =~ m/(.+):(.+)/) {
				my $classifier = $1;
				my $classification = $2;
				my $cf = $map->queryObject("mappingClassifiers",{name => $classifier});
				if (!defined($cf)) {
					ModelSEED::utilities::error("Classifier ".$classifier." not found!");
				}
				my $cfclass = $cf->classifier()->queryObject("classifierClassifications",{name => $classification});
				if (!defined($cfclass)) {
					ModelSEED::utilities::error("Classifier class ".$classification." not found!");
				}
				$comp->classifierClassification_uuid($cfclass->uuid());
				$comp->classifier_uuid($cf->classifier()->uuid());
			}
			if (@{$comprow->[6]} > 0) {
				my $linkuuids = [];
				my $linkcoefs = [];
				for (my $k=0; $k < @{$comprow->[6]}; $k++) {
					$cpd = $bio->searchForCompound($comprow->[6]->[$k]->[0]);
					if (!defined($cpd)) {
						ModelSEED::utilities::error("Compound ".$comprow->[6]->[$k]->[0]." not found!");
					}
					push(@{$linkuuids},$cpd->uuid());
					push(@{$linkcoefs},$comprow->[6]->[$k]->[1]);
				}
				$comp->linkedCompound_uuids($linkuuids);
				$comp->linkCoefficients($linkcoefs);
			}
			$tmpBio->add("templateBiomassComponents",$comp);
		}
	}
	return $mdlTmp;
}

=head3 buildGapfillingFormulation
Definition:
	ModelSEED::MS::FBAFormulation = buildGapfillingFormulation({
		array => [string],
		filename => string,
		text => string,
		model => ModelSEED::MS::Model
	});
Description:
	Parses the FBA formulation exchange object

=cut

sub buildGapfillingFormulation {
    my $self = shift;
	my $args = ModelSEED::utilities::args(["model"],{
		text => undef,
		filename => undef,
		overrides => {}
	}, @_);
	my $model = $args->{model};
	$args->{overrides}->{fbaFormulation}->{model} = $model;
	my $fbaform = $self->buildFBAFormulation($args->{overrides}->{fbaFormulation});
	my $data = $self->parseExchangeFileArray($args);
	#Setting default values for exchange format attributes
	$data = ModelSEED::utilities::args([],{
		fbaFormulation => $fbaform,
		balancedReactionsOnly => 1,
		guaranteedReactions => join("|", map { "Reaction/ModelSEED/" . $_ } qw(
			rxn1 rxn2 rxn3 rxn4 rxn5 rxn6 rxn7 rxn8 rxn01659
			rxn07298 rxn24256 rxn04219 rxn17241 rxn19302 rxn25468 rxn11572
			rxn23165 rxn25469 rxn23171 rxn23067 rxn30830 rxn30910 rxn31440
		)),
		blacklistedReactions => join("|", map { "Reaction/ModelSEED/" . $_ } qw(
rxn12985 rxn00238 rxn07058 rxn05305 rxn00154 rxn09037 rxn10643
rxn11317 rxn05254 rxn05257 rxn05258 rxn05259 rxn05264 rxn05268
rxn05269 rxn05270 rxn05271 rxn05272 rxn05273 rxn05274 rxn05275
rxn05276 rxn05277 rxn05278 rxn05279 rxn05280 rxn05281 rxn05282
rxn05283 rxn05284 rxn05285 rxn05286 rxn05963 rxn05964 rxn05971
rxn05989 rxn05990 rxn06041 rxn06042 rxn06043 rxn06044 rxn06045
rxn06046 rxn06079 rxn06080 rxn06081 rxn06086 rxn06087 rxn06088
rxn06089 rxn06090 rxn06091 rxn06092 rxn06138 rxn06139 rxn06140
rxn06141 rxn06145 rxn06217 rxn06218 rxn06219 rxn06220 rxn06221
rxn06222 rxn06223 rxn06235 rxn06362 rxn06368 rxn06378 rxn06474
rxn06475 rxn06502 rxn06562 rxn06569 rxn06604 rxn06702 rxn06706
rxn06715 rxn06803 rxn06811 rxn06812 rxn06850 rxn06901 rxn06971
rxn06999 rxn07123 rxn07172 rxn07254 rxn07255 rxn07269 rxn07451
rxn09037 rxn10018 rxn10077 rxn10096 rxn10097 rxn10098 rxn10099
rxn10101 rxn10102 rxn10103 rxn10104 rxn10105 rxn10106 rxn10107
rxn10109 rxn10111 rxn10403 rxn10410 rxn10416 rxn11313 rxn11316
rxn11318 rxn11353 rxn05224 rxn05795 rxn05796 rxn05797 rxn05798
rxn05799 rxn05801 rxn05802 rxn05803 rxn05804 rxn05805 rxn05806
rxn05808 rxn05812 rxn05815 rxn05832 rxn05836 rxn05851 rxn05857
rxn05869 rxn05870 rxn05884 rxn05888 rxn05896 rxn05898 rxn05900
rxn05903 rxn05904 rxn05905 rxn05911 rxn05921 rxn05925 rxn05936
rxn05947 rxn05956 rxn05959 rxn05960 rxn05980 rxn05991 rxn05992
rxn05999 rxn06001 rxn06014 rxn06017 rxn06021 rxn06026 rxn06027
rxn06034 rxn06048 rxn06052 rxn06053 rxn06054 rxn06057 rxn06059
rxn06061 rxn06102 rxn06103 rxn06127 rxn06128 rxn06129 rxn06130
rxn06131 rxn06132 rxn06137 rxn06146 rxn06161 rxn06167 rxn06172
rxn06174 rxn06175 rxn06187 rxn06189 rxn06203 rxn06204 rxn06246
rxn06261 rxn06265 rxn06266 rxn06286 rxn06291 rxn06294 rxn06310
rxn06320 rxn06327 rxn06334 rxn06337 rxn06339 rxn06342 rxn06343
rxn06350 rxn06352 rxn06358 rxn06361 rxn06369 rxn06380 rxn06395
rxn06415 rxn06419 rxn06420 rxn06421 rxn06423 rxn06450 rxn06457
rxn06463 rxn06464 rxn06466 rxn06471 rxn06482 rxn06483 rxn06486
rxn06492 rxn06497 rxn06498 rxn06501 rxn06505 rxn06506 rxn06521
rxn06534 rxn06580 rxn06585 rxn06593 rxn06609 rxn06613 rxn06654
rxn06667 rxn06676 rxn06693 rxn06730 rxn06746 rxn06762 rxn06779
rxn06790 rxn06791 rxn06792 rxn06793 rxn06794 rxn06795 rxn06796
rxn06797 rxn06821 rxn06826 rxn06827 rxn06829 rxn06839 rxn06841
rxn06842 rxn06851 rxn06866 rxn06867 rxn06873 rxn06885 rxn06891
rxn06892 rxn06896 rxn06938 rxn06939 rxn06944 rxn06951 rxn06952
rxn06955 rxn06957 rxn06960 rxn06964 rxn06965 rxn07086 rxn07097
rxn07103 rxn07104 rxn07105 rxn07106 rxn07107 rxn07109 rxn07119
rxn07179 rxn07186 rxn07187 rxn07188 rxn07195 rxn07196 rxn07197
rxn07198 rxn07201 rxn07205 rxn07206 rxn07210 rxn07244 rxn07245
rxn07253 rxn07275 rxn07299 rxn07302 rxn07651 rxn07723 rxn07736
rxn07878 rxn11417 rxn11582 rxn11593 rxn11597 rxn11615 rxn11617
rxn11619 rxn11620 rxn11624 rxn11626 rxn11638 rxn11648 rxn11651
rxn11665 rxn11666 rxn11667 rxn11698 rxn11983 rxn11986 rxn11994
rxn12006 rxn12007 rxn12014 rxn12017 rxn12022 rxn12160 rxn12161
rxn01267 )),
		allowableCompartments => "Compartment/id/c|Compartment/id/e|Compartment/id/p",
		mediaHypothesis => 1,
		biomassHypothesis => 1,
		gprHypothesis => 1,
		reactionAdditionHypothesis => 1,
		reactionActivationBonus => 0,
		drainFluxMultiplier => 1,
		directionalityMultiplier => 1,
		deltaGMultiplier => 1,
		noStructureMultiplier => 1,
		noDeltaGMultiplier => 1,
		biomassTransporterMultiplier => 1,
		singleTransporterMultiplier => 1,
		transporterMultiplier => 1,
		gapfillingGeneCandidates => [],
		reactionSetMultipliers => [],
                cplexTimeLimit => 3600,
                milpRecursionTimeLimit => 3600,
	}, $data);
	#Creating gapfilling formulation object
	my $gapform = ModelSEED::MS::GapfillingFormulation->new({
		parent => $model->parent(),
		model_uuid => $model->uuid(),
		model => $model,
		fbaFormulation_uuid => $fbaform->uuid(),
		fbaFormulation => $fbaform,
		balancedReactionsOnly => $data->{balancedReactionsOnly},
		reactionActivationBonus => $data->{reactionActivationBonus},
		drainFluxMultiplier => $data->{drainFluxMultiplier},
		directionalityMultiplier => $data->{directionalityMultiplier},
		deltaGMultiplier => $data->{deltaGMultiplier},
		noStructureMultiplier => $data->{noStructureMultiplier},
		noDeltaGMultiplier => $data->{noDeltaGMultiplier},
		biomassTransporterMultiplier => $data->{biomassTransporterMultiplier},
		singleTransporterMultiplier => $data->{singleTransporterMultiplier},
		transporterMultiplier => $data->{transporterMultiplier},
		mediaHypothesis => $data->{mediaHypothesis},
		biomassHypothesis => $data->{biomassHypothesis},
		gprHypothesis => $data->{gprHypothesis},
		reactionAdditionHypothesis => $data->{reactionAdditionHypothesis},
		timePerSolution => $data->{cplexTimeLimit},
		totalTimeLimit => $data->{milpRecursionTimeLimit},
	});
	$gapform->parseGeneCandidates({geneCandidates => $data->{gapfillingGeneCandidates}});
	$gapform->parseSetMultipliers({sets => $data->{reactionSetMultipliers}});
	$gapform->parseGuaranteedReactions({string => $data->{guaranteedReactions}});
	$gapform->parseBlacklistedReactions({string => $data->{blacklistedReactions}});
	$gapform->parseAllowableCompartments({string => $data->{allowableCompartments}});
	return $gapform;
}

=head3 buildGapgenFormulation
Definition:
	ModelSEED::MS::GapgenFormulation = buildGapgenFormulation({
		array => [string],
		filename => string,
		text => string,
		model => ModelSEED::MS::Model
	});
Description:
	Parses the FBA formulation exchange object

=cut

sub buildGapgenFormulation {
    my $self = shift;
    my $args = ModelSEED::utilities::args(["model"], {
		text => undef,
		filename => undef,
		overrides => {}
	}, @_);
	my $model = $args->{model};
	$args->{overrides}->{fbaFormulation}->{model} = $model;
	my $fbaform = $self->buildFBAFormulation($args->{overrides}->{fbaFormulation});
	my $data = $self->parseExchangeFileArray($args);
	#Setting default values for exchange format attributes			
	$data = ModelSEED::utilities::args([],{
		referenceMedia => "Media/name/".$fbaform->media()->name(),
		fbaFormulation => $fbaform,
		mediaHypothesis => 0,
		biomassHypothesis => 0,
		gprHypothesis => 0,
		reactionRemovalHypothesis => 1,
                cplexTimeLimit => 3600,
                milpRecursionTimeLimit => 3600,
	}, $data);
	#Finding (or creating) the media
	(my $media) = $model->interpretReference($data->{referenceMedia},"Media");
	if (!defined($media)) {
		ModelSEED::utilities::ERROR("Media referenced in formulation not found in database: ".$data->{referenceMedia});
	}
	#Creating gapfilling formulation object
	my $gapgenform = ModelSEED::MS::GapgenFormulation->new({
		parent => $model->parent(),
		model_uuid => $model->uuid(),
		model => $model,
		fbaFormulation_uuid => $fbaform->uuid(),
		fbaFormulation => $fbaform,
		referenceMedia_uuid => $media->uuid(),
		referenceMedia => $media,
		mediaHypothesis => $data->{mediaHypothesis},
		biomassHypothesis => $data->{biomassHypothesis},
		gprHypothesis => $data->{gprHypothesis},
		reactionRemovalHypothesis => $data->{reactionRemovalHypothesis},
		timePerSolution => $data->{cplexTimeLimit},
		totalTimeLimit => $data->{milpRecursionTimeLimit},
	});
	return $gapgenform;
}

=head3 stringToHash
Definition:
	{} = stringToHash(string);
Description:
	Parses the input string into a hash using the delimiters "|" and ":"

=cut

sub stringToHash {
	my ($self,$string) = @_;
	my $output = {};
	if ($string ne "none") {
		my $array = [split(/\|/,$string)];
		foreach my $item (@{$array}) {
			my $subarray = [split(/\:/,$item)];
			if (defined($subarray->[1])) {
				$output->{$subarray->[0]} = $subarray->[1];
			}
		}
	}
	return $output;
}

=head3 parseExchangeFileArray
Definition:
	{} = ModelSEED::MS::Biochemistry->parseExchangeFileArray({
		array => [string](undef),
		text => string(undef),
		filename => string(undef)
	});
Description:
	Parses the exchange file array into a attribute and subobject hash

=cut

sub parseExchangeFileArray {
    my $self = shift;
	my $args = ModelSEED::utilities::args([],{
		text => undef,
		filename => undef,
		array => [],
		overrides => {}
	}, @_);
	if (defined($args->{filename}) && -e $args->{filename}) {
		$args->{array} = ModelSEED::utilities::LOADFILE($args->{filename}); 
		delete $args->{text};
	}
	if (defined($args->{text})) {
		$args->{array} = [split(/\n/,$args->{text})];
	}
	my $array = $args->{array};
	my $data = {};
	my $section = "none";
	my $headings;
	for (my $i=0; $i < @{$array}; $i++) {
		if ($array->[$i] =~ m/^Attributes/) {
			$section = "attributes";
		} elsif ($array->[$i] eq "}") {
			$section = "none";
		} elsif ($section eq "attributes") {
			$array->[$i] =~ s/^[\s\t]+//g;
			my $arrayTwo = [split(/:/,$array->[$i])];
			$data->{$arrayTwo->[0]} = $arrayTwo->[1];
		} elsif ($array->[$i] =~ m/^([a-zA-Z])\s*\((.+)\)/ && $section eq "none") {
			$section = $1;
			$headings = [split(/\t/,$2)];
		} elsif ($section ne "none") {
			my $arrayTwo = [split(/:/,$array->[$i])];
			my $subobjectData;
			for (my $j=0; $j < @{$headings}; $j++) {
				$subobjectData->{$headings->[$j]} = $arrayTwo->[$j];
			}
			push(@{$data->{$section}},$subobjectData);
		}
	}
	#Setting overrides
	foreach my $key (%{$args->{overrides}}) {
#	    print $key,"\n" if !exists($args->{overrides}->{$key});
		$data->{$key} = $args->{overrides}->{$key};
	}
	return $data;
}

=head3 buildObjectFromExchangeFileArray
Definition:
	ModelSEED::MS::?? = ModelSEED::MS::Biochemistry->buildObjectFromExchangeFileArray({
		array => [string](REQ)
	});
Description:
	Parses the exchange file array into a attribute and subobject hash

=cut

sub buildObjectFromExchangeFileArray {
    my $self = shift;
	my $args = ModelSEED::utilities::args(["array"],{
		Biochemistry => undef,
		Mapping => undef,
		Model => undef,
		Annotation => undef
	}, @_);
    my $data = $self->parseExchangeFileArray($args);
	#The data object must have an ID, which is used to identify the type
	if (!defined($data->{id})) {
		ModelSEED::utilities::ERROR("Input exchange file must have ID!");
	}
	my $refdata = $self->reconcileReference($data->{id});
	delete $data->{id};
	#Checking for shortened names and array-type attributes
	my $dbclass = 'ModelSEED::MS::DB::'.$refdata->{class};
	my $class = 'ModelSEED::MS::'.$refdata->{class};
	for my $attr ( $dbclass->meta->get_all_attributes ) {
		if ($attr->isa('ModelSEED::Meta::Attribute::Typed')) {
			my $name = $attr->name();
			if ($attr->type() eq "attribute") {
				if ($attr->type_constraint() =~ m/ArrayRef/ && defined($data->{$name})) {
					$data->{$name} = [split(/\|/,$data->{$name})];
				}
				if ($name =~ m/(.+)_uuid$/ && !defined($data->{$name})) {
					my $shortname = $1;
					if (defined($data->{$shortname})) {
						$data->{$name} = $data->{$shortname};
						delete $data->{$shortname};
					}
				}
			}
		}
	}
	#Parsing through all attributes looking for and reconciling parent references
	my $parentObjects = {
		Biochemistry => 1,
		Annotation => 1,
		Model => 1,
		Mapping => 1
	};
	my $parents;
	foreach my $att (keys(%{$data})) {
		my $refData = $self->reconcileReference($data->{$att});
		if (defined($refData)) {
			if (defined($parentObjects->{$refData->{class}})) {
				if (defined($args->{$refData->{class}})) {
					$parents->{$refData->{class}} = $args->{$refData->{class}};
				} elsif (defined($args->{store})) {
					$parents->{$refData->{class}} = $self->store()->get_object($data->{$att});	
				}
				if (defined($parents->{$refData->{class}})) {
					$data->{$att} = $parents->{$refData->{class}}->uuid();
				}
			}
		}	
	}
	my $subobjectParents = {
			Reaction => "Biochemistry",
			Media => "Biochemistry",
			Compartment => "Biochemistry"
	};
	my $subobjectAttributes = {
			Reaction => "reactions",
			Media => "media",
			Compartment => "compartments"
	};
	#Parsing through all attributes looking for and reconciling all non-parent references
	foreach my $att (keys(%{$data})) {
		my $refData = $self->reconcileReference($data->{$att});
		if (defined($refData)) {
			if ($refData->{type} eq "uuid") {
				$data->{$att} = $refData->{id};
			} elsif (!defined($parentObjects->{$refData->{class}}) && defined($subobjectParents->{$refData->{class}})) {
				if (defined($parents->{$subobjectParents->{$refData->{class}}})) {
					my $obj;
					if ($refData->{type} eq "name" || $refData->{type} eq "abbreviation") {
						$obj = $parents->{$subobjectParents->{$refData->{class}}}->queryObject($subobjectAttributes->{$refData->{class}},{$refData->{type} => $refData->{id}});
					} else {
						$obj = $parents->{$subobjectParents->{$refData->{class}}}->getObjectByAlias($subobjectAttributes->{$refData->{class}},$refData->{id},$refData->{type});
					}
					if (defined($obj)) {
						$data->{$att} = $obj->uuid();	
					}
				}	
			}
		}	
	}
	return $class->new($data);
}

=head3 reconcileReference
Definition:
	{
		class => string,
		id => string,
		type => string
	} = ModelSEED::MS::Biochemistry->reconcileReference(string);
Description:
	Parses the input reference and translates to class, id, and type

=cut

sub reconcileReference {
	my ($self,$ref) = @_;
	my $output;
	if ($ref =~ m/^([a-zA-z]+)\/[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}/) {
		$output->{class} = $1;
		$output->{id} = $2;
		$output->{type} = "uuid";
	} elsif ($ref =~ m/^([a-zA-z]+)\/([^\/]+)\/([^\/]+)/) {
		$output->{class} = $1;
		$output->{type} = $2;
		$output->{id} = $3;
	}
	return $output;
}

=head3 createFromAPI
Definition:
	ModelSEED::MS::$class = createFromAPI(string);
Description:
	Parses the input reference and translates to class, id, and type

=cut

sub createFromAPI {
	my ($self,$class,$parent,$data) = @_;
	$data->{parent} = $parent;
	if ($class eq "Media") {
        # FIXME : not sure what to do with this case, only time used?
		$data = ModelSEED::utilities::ARGS($data,["name","compounds"],{},{
			isdefined => "isDefined",
			isminimal => "isMinimal",
			id => "name"
		});
		my $cpds = [split(/;/,$data->{compounds})];
		my $concentrations = [];
		if (defined($data->{concentrations})) {
			$concentrations = [split(/;/,$data->{concentrations})];
		}
		$data->{mediacompounds} = [];
		my $notfound = [];
		for (my $i=0; $i < @{$cpds};$i++) {
			my $cpd = $parent->searchForCompound($cpds->[$i]);
			if (defined($cpd)) {
				my $conc = "0.001";
				if (defined($concentrations->[$i])) {
					$conc = $concentrations->[$i];
				}
				push(@{$data->{mediacompounds}},{
					compound_uuid => $cpd->uuid(),
					concentration => $conc,
					maxFlux => 100,
					minFlux => -100
				});
			} else {
				push(@{$notfound},$cpds->[$i]);
			}
		}
		if (@$notfound > 0) {
			die "Cannot find media compound(s) ".join("|",@$notfound)."\n";	
		}
	}
	my $fullclass = "ModelSEED::MS::".$class;
	return $fullclass->new($data);
}

__PACKAGE__->meta->make_immutable;
