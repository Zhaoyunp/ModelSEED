########################################################################
# ModelSEED::MS::Biochemistry - This is the moose object corresponding to the Biochemistry object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-03-26T23:22:35
########################################################################
use strict;
use ModelSEED::MS::DB::Biochemistry;
package ModelSEED::MS::Biochemistry;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::DB::Biochemistry';
#***********************************************************************************************************
# ADDITIONAL ATTRIBUTES:
#***********************************************************************************************************
has definition => ( is => 'rw', isa => 'Str',printOrder => '-1', type => 'msdata', metaclass => 'Typed', lazy => 1, builder => '_builddefinition' );
has dataDirectory => ( is => 'rw', isa => 'Str',printOrder => '-1', type => 'msdata', metaclass => 'Typed', lazy => 1, builder => '_builddataDirectory' );


#***********************************************************************************************************
# BUILDERS:
#***********************************************************************************************************
sub _builddefinition {
	my ($self) = @_;
	return $self->createEquation({format=>"name",hashed=>0});
}
sub _builddataDirectory {
	my ($self) = @_;
	my $config = ModelSEED::Configuration->new();
	if (defined($config->user_options()->{MFATK_CACHE})) {
		return $config->user_options()->{MFATK_CACHE}."/";
	}
	return ModelSEED::utilities::MODELSEEDCORE()."/data/";
}


#***********************************************************************************************************
# CONSTANTS:
#***********************************************************************************************************

#***********************************************************************************************************
# FUNCTIONS:
#***********************************************************************************************************
=head3 printDBFiles
Definition:
	void ModelSEED::MS::Biochemistry->printDBFiles({
		forceprint => 0
	});
Description:
	Creates files with biochemistry data for use by the MFAToolkit
=cut
sub printDBFiles {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,[],{
		forceprint => 0
	});
	my $path = $self->dataDirectory()."/fbafiles/";
	if (!-d $path) {
		File::Path::mkpath ($path);
	}
	if (-e $path.$self->uuid()."-compounds.tbl" && $args->{forceprint} eq "0") {
		return;	
	}
	my $output = ["abbrev	charge	deltaG	deltaGErr	formula	id	mass	name"];
	my $columns = ["abbreviation","defaultCharge","deltaG","deltaGErr","formula","id","mass","name"];
	my $cpds = $self->compounds();
	for (my $i=0; $i < @{$cpds}; $i++) {
		my $cpd = $cpds->[$i];
		my $line = "";
		foreach my $column (@{$columns}) {
			if (length($line) > 0) {
				$line .= "\t";
			}
			if (defined($cpd->$column())) {
				$line .= $cpd->$column();
			}
		}
		push(@{$output},$line);
	}
	ModelSEED::utilities::PRINTFILE($path.$self->uuid()."-compounds.tbl",$output);
	$output = ["abbrev	deltaG	deltaGErr	equation	id	name	reversibility	status	thermoReversibility"];
	$columns = ["abbreviation","deltaG","deltaGErr","equation","id","name","direction","status","thermoReversibility"];
	my $rxns = $self->reactions();
	for (my $i=0; $i < @{$rxns}; $i++) {
		my $rxn = $rxns->[$i];
		my $line = "";
		foreach my $column (@{$columns}) {
			if (length($line) > 0) {
				$line .= "\t";
			}
			if (defined($rxn->$column())) {
				$line .= $rxn->$column();
			}
		}
		push(@{$output},$line);
	}
	ModelSEED::utilities::PRINTFILE($path.$self->uuid()."-reactions.tbl",$output);
}
=head3 makeDBModel
Definition:
	ModelSEED::MS::ModelReaction = ModelSEED::MS::Biochemistry->makeDBModel({
		balancedOnly => 1,
		forbiddenCompartments => [],
		guaranteedReactions => [],
		forbiddenReactions => [],
		annotation_uuid => "00000000-0000-0000-0000-000000000000",
		mapping_uuid => "00000000-0000-0000-0000-000000000000",
	});
Description:
	Creates a model that has every reaction instance in the database that pass through the specified filters
=cut
sub makeDBModel {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,[],{
		balancedOnly => 1,
		allowableCompartments => [],
		guaranteedReactions => [],
		forbiddenReactions => [],
		annotation_uuid => "00000000-0000-0000-0000-000000000000",
		mapping_uuid => "00000000-0000-0000-0000-000000000000",
	});
	my $mdl = ModelSEED::MS::Model->new({
		id => $self->name().".model",
		version => 0,
		type => "dbmodel",
		name => $self->name().".model",
		growth => 0,
		status => "Built from database",
		current => 1,
		mapping_uuid => $args->{mapping_uuid},
		biochemistry_uuid => $self->uuid(),
		biochemistry => $self,
		annotation_uuid => $args->{annotation_uuid}
	});
	my $hashes;
	for (my $i=0; $i < @{$args->{guaranteedReactions}}; $i++) {
		if ($args->{guaranteedReactions}->[$i] =~ /[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}/) {
			$hashes->{guaranteed}->{$args->{guaranteedReactions}->[$i]} = 1;
		} elsif ($args->{guaranteedReactions}->[$i] =~ /^Reaction\//) {
			my $array = [split(/\//,$args->{guaranteedReactions}->[$i])];
			if (defined($array->[2])) {
				my $rxn;
				if ($array->[1] eq "name") {
					$rxn = $self->queryObject("reactions",{$array->[1] => $array->[2]});
				} else {
					$rxn = $self->getObjectByAlias("reactions",$array->[2],$array->[1]);
				}
				if (defined($rxn)) {
					$hashes->{guaranteed}->{$rxn->uuid()} = 1;
				} else {
					print "Could not find guaranteed reaction ".$args->{guaranteedReactions}->[$i]."\n";	
				}
			}
		}
	}
	for (my $i=0; $i < @{$args->{forbiddenReactions}}; $i++) {
		if ($args->{forbiddenReactions}->[$i] =~ /[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}/) {
			$hashes->{forbidden}->{$args->{forbiddenReactions}->[$i]} = 1;
		} elsif ($args->{forbiddenReactions}->[$i] =~ /^Reaction\//) {
			my $array = [split(/\//,$args->{forbiddenReactions}->[$i])];
			if (defined($array->[2])) {
				my $rxn;
				if ($array->[1] eq "name") {
					$rxn = $self->queryObject("reactions",{$array->[1] => $array->[2]});
				} else {
					$rxn = $self->getObjectByAlias("reactions",$array->[2],$array->[1]);
				}
				if (defined($rxn)) {
					$hashes->{forbidden}->{$rxn->uuid()} = 1;
				} else {
					print "Could not find forbidden reaction ".$args->{forbiddenReactions}->[$i]."\n";	
				}
			}
		}
	}
	for (my $i=0; $i < @{$args->{allowableCompartments}}; $i++) {
		if ($args->{allowableCompartments}->[$i] =~ /[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}/) {
			$hashes->{allowcomp}->{$args->{allowableCompartments}->[$i]} = 1;
		} elsif ($args->{allowableCompartments}->[$i] =~ /^Compartment\//) {
			my $array = [split(/\//,$args->{allowableCompartments}->[$i])];
			if (defined($array->[2])) {
				my $cmp;
				if ($array->[1] eq "id" || $array->[1] eq "name") {
					$cmp = $self->queryObject("compartments",{$array->[1] => $array->[2]});
				} else {
					$cmp = $self->getObjectByAlias("compartments",$array->[2],$array->[1]);
				}
				if (defined($cmp)) {
					$hashes->{allowcomp}->{$cmp->uuid()} = 1;
				} else {
					print "Could not find allowable compartment ".$args->{allowableCompartments}->[$i]."\n";	
				}
			}
		}
	}
	my $reactions = $self->reactions();
	for (my $i=0; $i < @{$reactions}; $i++) {
		my $rxn = $reactions->[$i];
		if (!defined($hashes->{forbidden}->{$rxn->uuid()})) {
			my $add = 1;
			if (!defined($hashes->{guaranteed}->{$rxn->uuid()})) {
				if (!defined($hashes->{allowcomp}->{$rxn->compartment_uuid()})) {
					$add = 0;
				}
				if ($add == 1) {
					my $transports = $rxn->transports();
					for (my $j=0; $j < @{$transports};$j++) {
						if (!defined($hashes->{allowcomp}->{$transports->[$j]->compartment_uuid()})) {
							$add = 0;
							last;
						}
					}
				}
				if ($add == 1 && $args->{balancedOnly} == 1 && $rxn->balanced() == 0) {
					$add = 0;
				}
			}
			if ($add == 1) {
				$mdl->addReactionToModel({
					reaction => $rxn,
				});
			}
		}
	}
	return $mdl;
}
=head3 findCreateEquivalentCompartment
Definition:
	void ModelSEED::MS::Biochemistry->findCreateEquivalentCompartment({
		compartment => ModelSEED::MS::Compartment(REQ),
		create => 0/1(1)
	});
Description:
	Search for an equivalent comparment for the input biochemistry compartment
=cut
sub findCreateEquivalentCompartment {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,["compartment"],{create => 1});
	my $incomp = $args->{compartment};
	my $outcomp = $self->queryObject("compartments",{
		name => $incomp->name()
	});
	if (!defined($outcomp) && $args->{create} == 1) {
		$outcomp = $self->biochemistry()->add("compartments",{
			id => $incomp->id(),
			name => $incomp->name(),
			hierarchy => $incomp->hierarchy()
		});
	}
	$incomp->mapped_uuid($outcomp->uuid());
	$outcomp->mapped_uuid($incomp->uuid());
	return $outcomp;
}
=head3 findCreateEquivalentCompound
Definition:
	void ModelSEED::MS::Biochemistry->findCreateEquivalentCompound({
		compound => ModelSEED::MS::Compound(REQ),
		create => 0/1(1)
	});
Description:
	Search for an equivalent compound for the input biochemistry compound
=cut
sub findCreateEquivalentCompound {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,["compound"],{create => 1});
	my $incpd = $args->{compound};
	my $outcpd = $self->queryObject("compounds",{
		name => $incpd->name()
	});
	if (!defined($outcpd) && $args->{create} == 1) {
		$outcpd = $self->biochemistry()->add("compounds",{
			name => $incpd->name(),
			abbreviation => $incpd->abbreviation(),
			unchargedFormula => $incpd->unchargedFormula(),
			formula => $incpd->formula(),
			mass => $incpd->mass(),
			defaultCharge => $incpd->defaultCharge(),
			deltaG => $incpd->deltaG(),
			deltaGErr => $incpd->deltaGErr(),
		});
		for (my $i=0; $i < @{$incpd->structures()}; $i++) {
			my $cpdstruct = $incpd->structures()->[$i];
			$outcpd->add("structures",$cpdstruct->serializeToDB());
		}
		for (my $i=0; $i < @{$incpd->pks()}; $i++) {
			my $cpdpk = $incpd->pks()->[$i];
			$outcpd->add("pks",$cpdpk->serializeToDB());
		}
	}
	$incpd->mapped_uuid($outcpd->uuid());
	$outcpd->mapped_uuid($incpd->uuid());
	return $outcpd;
}
=head3 findCreateEquivalentReaction
Definition:
	void ModelSEED::MS::Biochemistry->findCreateEquivalentReaction({
		reaction => ModelSEED::MS::Reaction(REQ),
		create => 0/1(1)
	});
Description:
	Search for an equivalent reaction for the input biochemistry reaction
=cut
sub findCreateEquivalentReaction {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,["reaction"],{create => 1});
	my $inrxn = $args->{reaction};
	my $outrxn = $self->queryObject("reactions",{
		definition => $inrxn->definition()
	});
	if (!defined($outrxn) && $args->{create} == 1) { 
		$outrxn = $self->biochemistry()->add("reactions",{
			name => $inrxn->name(),
			abbreviation => $inrxn->abbreviation(),
			direction => $inrxn->direction(),
			thermoReversibility => $inrxn->thermoReversibility(),
			defaultProtons => $inrxn->defaultProtons(),
			status => $inrxn->status(),
			deltaG => $inrxn->deltaG(),
			deltaGErr => $inrxn->deltaGErr(),
		});
		for (my $i=0; $i < @{$inrxn->reagents()}; $i++) {
			my $rgt = $inrxn->reagents()->[$i];
			my $cpd = $self->biochemistry()->findCreateEquivalentCompound({
				compound => $rgt->compound(),
				create => 1
			});
			if ($rgt->isTransport()) {
				my $transcmp = $self->findCreateEquivalentCompartment({
					compartment => $rgt->destinationCompartment(),
					create => 1
				});
				$outrxn->add("reagents",{
					compound_uuid => $cpd->uuid(),
					destinationCompartment_uuid => $transcmp->uuid(),
					coefficient => $rgt->coefficient(),
					isCofactor => $rgt->isCofactor(),
					isTransport => $rgt->isTransport(),
				});
			} else {
				$outrxn->add("reagents",{
					compound_uuid => $cpd->uuid(),
					coefficient => $rgt->coefficient(),
					isCofactor => $rgt->isCofactor(),
					isTransport => $rgt->isTransport(),
				});
			}
		}
	}	
	$inrxn->mapped_uuid($outrxn->uuid());
	$outrxn->mapped_uuid($inrxn->uuid());
	return $outrxn;
}

=head3 validate
Definition:
	void ModelSEED::MS::Biochemistry->validate();
Description:
	This command runs a series of tests on the biochemistry data to ensure that it is valid
=cut
sub validate {
	my ($self) = @_;
	my $errors = [];
	#Check uniqueness of compound names and abbreviations
	my $cpds = $self->compounds();
	my $nameHash;
	my $abbrevHash;
	foreach my $cpd (@{$cpds}) {
		if (defined($nameHash->{$cpd->name()})) {
			push(@{$errors},"Compound names match: ".$cpd->name().": ".$cpd->uuid()."(".$cpd->id().")\t".$nameHash->{$cpd->name()}->uuid()."(".$cpd->id().")");
		} else {
			$nameHash->{$cpd->name()} = $cpd;
		}
		if (defined($abbrevHash->{$cpd->abbreviation()})) {
			push(@{$errors},"Compound abbreviations match: ".$cpd->abbreviation().": ".$cpd->uuid()."(".$cpd->id().")\t".$abbrevHash->{$cpd->abbreviation()}->uuid()."(".$cpd->id().")");
		} else {
			$abbrevHash->{$cpd->abbreviation()} = $cpd;
		}
	}
	return $errors;
}
=head3 addCompoundFromHash
Definition:
	ModelSEED::MS::Compound = ModelSEED::MS::Biochemistry->addCompoundFromHash({[]});
Description:
	This command adds a single compound from an input hash
=cut
sub addCompoundFromHash {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,["names","id"],{
		aliasType => $self->defaultNameSpace(),
		abbreviation => [$args->{names}->[0]],
		formula => [""],
		mass => [0],
		charge => [0],
		deltag => [10000],
		deltagerr => [0]
	});
	#Checking for id uniqueness
	my $cpd = $self->getObjectByAlias("compounds",$args->{id}->[0],$args->{aliasType});
	if (defined($cpd)) {
		print STDERR "Compound added with matching id ".$args->{id}->[0]."!\n";
		return $cpd;
	}
	#Checking for name uniqueness
	foreach my $name (@{$args->{names}}) {
		my $searchname = ModelSEED::MS::Compound::nameToSearchname($name);
		$cpd = $self->queryObject("compounds",{searchnames => $name});
		if (defined($cpd)) {
			print STDERR "Compound added with matching name ".$name."!\n";
			$self->addAlias({
				attribute => "compounds",
				aliasName => $args->{aliasType},
				alias => $args->{id}->[0],
				uuid => $cpd->uuid()
			});
			return $cpd;
		}
	}
	#Actually creating compound
	$cpd = $self->add("compounds",{
		name => $args->{names}->[0],
		abbreviation => $args->{abbreviation}->[0],
		formula => $args->{formula}->[0],
		mass => $args->{mass}->[0],
		defaultCharge => $args->{charge}->[0],
		deltaG => $args->{deltag}->[0],
		deltaGErr => $args->{deltagerr}->[0]
	});
	#Adding id as alias
	$self->addAlias({
		attribute => "compounds",
		aliasName => $args->{aliasType},
		alias => $args->{id}->[0],
		uuid => $cpd->uuid()
	});
	#Adding alternative names as aliases
	foreach my $name (@{$args->{names}}) {
		$self->addAlias({
			attribute => "compounds",
			aliasName => "name",
			alias => $name,
			uuid => $cpd->uuid()
		});
	}
	return $cpd;
}
=head3 addReactionFromHash
Definition:
	ModelSEED::MS::Compound = ModelSEED::MS::Biochemistry->addReactionFromHash({[]});
Description:
	This command adds a single reaction from an input hash
=cut
sub addReactionFromHash {
	my ($self,$args) = @_;
	$args = ModelSEED::utilities::ARGS($args,["equation","id"],{
		aliasType => $self->defaultNameSpace(),
		names => [$args->{id}->[0]],
		abbreviation => [$args->{id}->[0]],
		direction => ["="],
		deltag => [10000],
		deltagerr => [0],
		enzymes => []
	});
	#Checking for id uniqueness
	my $rxn = $self->getObjectByAlias("reactions",$args->{id}->[0],$args->{aliasType});
	if (defined($rxn)) {
		print STDERR "Reaction added with matching id ".$args->{id}->[0]."!\n";
		return $rxn;
	}
	#Creating reaction from equation
	$rxn = ModelSEED::MS::Reaction->new({
		name => $args->{names}->[0],
		abbreviation => $args->{abbreviation}->[0],
		direction => $args->{direction}->[0],
		deltaG => $args->{deltag}->[0],
		deltaGErr => $args->{deltagerr}->[0],
		status => "OK",
		thermoReversibility => "="
	});
	$rxn->parent($self);
	$rxn->loadFromEquation({
		equation => $args->{equation}->[0],
		aliasType => $args->{aliasType},
	});
	my $code = $rxn->equationCode();
	my $searchRxn = $self->queryObject("reactions",{equationCode => $code});
	if (defined($searchRxn)) {
		print STDERR "Reaction added with matching equation ".$args->{id}->[0]."!\n";
		return $searchRxn;
	}
	$self->add("reactions", $rxn);
	$self->addAlias({
		attribute => "reactions",
		aliasName => $args->{aliasType},
		alias => $args->{id}->[0],
		uuid => $rxn->uuid()
	});
	for (my $i=0;$i < @{$args->{names}}; $i++) {
		$self->addAlias({
			attribute => "reactions",
			aliasName => "name",
			alias => $args->{names}->[$i],
			uuid => $rxn->uuid()
		});
	}
	for (my $i=0;$i < @{$args->{enzymes}}; $i++) {
		$self->addAlias({
			attribute => "reactions",
			aliasName => "Enzyme Class",
			alias => $args->{enzymes}->[$i],
			uuid => $rxn->uuid()
		});
	}
	return $rxn;
}

__PACKAGE__->meta->make_immutable;
1;
