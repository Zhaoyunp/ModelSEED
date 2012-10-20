########################################################################
# ModelSEED::MS::GapgenFormulation - This is the moose object corresponding to the GapgenFormulation object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-08-07T07:31:48
########################################################################
use strict;
use ModelSEED::MS::DB::GapgenFormulation;
package ModelSEED::MS::GapgenFormulation;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::DB::GapgenFormulation';
#***********************************************************************************************************
# ADDITIONAL ATTRIBUTES:
#***********************************************************************************************************
has mediaID => ( is => 'rw',printOrder => 19, isa => 'Str', type => 'msdata', metaclass => 'Typed', lazy => 1, builder => '_buildmediaID' );
has reactionKOString => ( is => 'rw',printOrder => 19, isa => 'Str', type => 'msdata', metaclass => 'Typed', lazy => 1, builder => '_buildreactionKOString' );
has geneKOString => ( is => 'rw',printOrder => 19, isa => 'Str', type => 'msdata', metaclass => 'Typed', lazy => 1, builder => '_buildgeneKOString' );

#***********************************************************************************************************
# BUILDERS:
#***********************************************************************************************************
sub _buildmediaID {
	my ($self) = @_;
	return $self->fbaFormulation()->media()->id();
}
sub _buildreactionKOString {
	my ($self) = @_;
	my $string = "";
	my $rxnkos = $self->fbaFormulation()->reactionKOs();
	for (my $i=0; $i < @{$rxnkos}; $i++) {
		if ($i > 0) {
			$string .= ", ";
		}
		$string .= $rxnkos->[$i]->id();
	}
	return $string;
}
sub _buildgeneKOString {
	my ($self) = @_;
	my $string = "";
	my $genekos = $self->fbaFormulation()->geneKOs();
	for (my $i=0; $i < @{$genekos}; $i++) {
		if ($i > 0) {
			$string .= ", ";
		}
		$string .= $genekos->[$i]->id();
	}
	return $string;
}

#***********************************************************************************************************
# CONSTANTS:
#***********************************************************************************************************

#***********************************************************************************************************
# FUNCTIONS:
#***********************************************************************************************************

=head3 biochemistry

Definition:
	ModelSEED::MS::Biochemistry = biochemistry();
Description:
	Returns biochemistry behind gapfilling object

=cut

sub biochemistry {
	my ($self) = @_;
	$self->model()->biochemistry();	
}

=head3 annotation

Definition:
	ModelSEED::MS::Annotation = annotation();
Description:
	Returns annotation behind gapfilling object

=cut

sub annotation {
	my ($self) = @_;
	$self->model()->annotation();	
}

=head3 mapping

Definition:
	ModelSEED::MS::Mapping = mapping();
Description:
	Returns mapping behind gapfilling object

=cut

sub mapping {
	my ($self) = @_;
	$self->model()->mapping();	
}

=head3 prepareFBAFormulation

Definition:
	void prepareFBAFormulation();
Description:
	Ensures that an FBA formulation exists for the gapgen, and that it is properly configured for gapgen

=cut

sub prepareFBAFormulation {
	my ($self,$args) = @_;
	my $form;
	if (!defined($self->fbaFormulation_uuid())) {
		my $exFact = ModelSEED::MS::Factories::ExchangeFormatFactory->new();
		$form = $exFact->buildFBAFormulation({model => $self->model(),overrides => {
			media => "Media/name/Complete",
			notes => "Default gapgen FBA formulation",
			allReversible => 1,
			reactionKO => "none",
			numberOfSolutions => 1,
			maximizeObjective => 1,
			fbaObjectiveTerms => [{
				variableType => "biomassflux",
				id => "Biomass/id/bio00001",
				coefficient => 1
			}]
		}});
		$self->fbaFormulation($form);
		$self->fbaFormulation_uuid($form->uuid());
	} else {
		$form = $self->fbaFormulation();
	}
	if ($form->media()->name() eq "Complete") {
		if ($form->defaultMaxDrainFlux() < 100) {
			$form->defaultMaxDrainFlux(100);
		}	
	}
	$form->objectiveConstraintFraction(1);
	$form->defaultMaxFlux(100);
	$form->defaultMinDrainFlux(-100);
	$form->fluxUseVariables(1);
	$form->decomposeReversibleFlux(1);
	#Setting other important parameters
	$form->parameters()->{"Perform gap generation"} = 1;
	$form->parameters()->{"Gap generation media"} = $self->referenceMedia()->name();
	if ($self->referenceMedia()->name() ne $form->media()->name()) {
		push(@{$form->secondaryMedia_uuids()},$self->referenceMedia()->uuid());
		push(@{$form->secondaryMedia()},$self->referenceMedia());
	}
	if ($self->biomassHypothesis() == 1) {
		$form->parameters()->{"Biomass modification hypothesis"} = "1";
	} else {
		$form->parameters()->{"Biomass modification hypothesis"} = "0";
	}
	if ($self->reactionRemovalHypothesis() == 1) {
		$form->parameters()->{"Reaction removal hypothesis"} = "1";
	} else {
		$form->parameters()->{"Reaction removal hypothesis"} = "0";
	}
	if ($self->mediaHypothesis() == 1) {
		$form->decomposeReversibleDrainFlux(1);
		$form->drainfluxUseVariables(1);
		$form->parameters()->{"Media hypothesis"} = "1";
	} else {
		$form->decomposeReversibleDrainFlux(0);
		$form->drainfluxUseVariables(0);
		$form->parameters()->{"Media hypothesis"} = "0";
	}
	$form->parameters()->{"Minimum flux for use variable positive constraint"} = 10;
	$form->parameters()->{"Objective coefficient file"} = "NONE";
	$form->parameters()->{"just print LP file"} = "0";
	$form->parameters()->{"use database fields"} = "1";
	$form->parameters()->{"REVERSE_USE;FORWARD_USE;REACTION_USE"} = "1";
	$form->parameters()->{"CPLEX solver time limit"} = "82800";
	push(@{$form->outputfiles}, "GapGenerationReport.txt");
	return $form;	
}

=head3 runGapGeneration

Definition:
	ModelSEED::MS::GapgenSolution = ModelSEED::MS::GapgenFormulation->runGapGeneration({
		model => ModelSEED::MS::Model(REQ)
	});
Description:
	Identifies the solution that disables growth in the specified conditions

=cut

sub runGapGeneration {
	my ($self,$args) = @_;
	# Preparing fba formulation describing gapfilling problem
	my $form = $self->prepareFBAFormulation();
	my $directory = $form->jobDirectory()."/";
	# Running the gapfilling
	my $fbaResults = $form->runFBA();
	#Parsing solutions
	$self->parseGapgenResults($fbaResults);
	return $fbaResults->gapgenSolutions();
}

=head3 parseGapgenResults

Definition:
	void parseGapgenResults();
Description:
	Parses Gapgen results

=cut

sub parseGapgenResults {
	my ($self, $fbaResults) = @_;
	my $outputHash = $fbaResults->outputfiles();
	if (defined($outputHash->{"GapGenerationReport.txt"})) {
		my $filedata = $outputHash->{"GapGenerationReport.txt"};
		for (my $i=1; $i < @{$filedata}; $i++) {
			my $array = [split(/\t/,$filedata->[$i])];
			if (defined($array->[1])) {
				my $subarray = [split(/,/,$array->[1])];
				my $ggsolution = $self->add("gapgenSolutions",{});
				$ggsolution->loadFromData({
					objective => $array->[0],
					reactions => $subarray,
					model => $self->model()
				});
			}
		}
	}
}

=head3 printStudy

Definition:
	string printStudy();
Description:
	Prints study and solutions in human readable format

=cut

sub printStudy {
	my ($self,$index) = @_;
	my $solutions = $self->gapgenSolutions();
	my $numSolutions = @{$solutions};
	my $output = "*********************************************\n";
	$output .= "Gapgen formulation: GG".$index."\n";
	$output .= "Media: ".$self->mediaID()."\n";
	if ($self->geneKOString() ne "") {
		$output .= "GeneKO: ".$self->geneKOString()."\n";
	}
	if ($self->reactionKOString() ne "") {
		$output .= "ReactionKO: ".$self->reactionKOString()."\n";
	}
	$output .= "---------------------------------------------\n";
	if ($numSolutions == 0) {
		$output .= "No gapgen solutions found!\n";
		$output .= "---------------------------------------------\n";
	} else {
		$output .= $numSolutions." gapgen solution(s) found.\n";
		$output .= "---------------------------------------------\n";
	}
	for (my $i=0; $i < @{$solutions}; $i++) {
		$output .= "New gapgen solution: GG".$index.".".$i."\n";
		$output .= $solutions->[$i]->printSolution();
		$output .= "---------------------------------------------\n";
	}
	return $output;
}

__PACKAGE__->meta->make_immutable;
1;
