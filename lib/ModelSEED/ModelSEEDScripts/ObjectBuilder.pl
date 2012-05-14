use strict;
use ModelSEED::MS::MetaData::Definitions;
use ModelSEED::utilities;
use DateTime;

my $objects = ModelSEED::MS::DB::Definitions::objectDefinitions();
my $subtypes = [];
my $subtypesUse = [];
my $subtypesOpening = <<HEREDOC;
########################################################################
# ModelSEED::MS::Type - This contains automatically generated subtypes #
# that define coercion properties. Do not edit this file               #
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger             #
# Contact email: chenry\@mcs.anl.gov                                   #
# Development locations:                                               #
#   Mathematics and Computer Science Division, Argonne National Lab    #
#   Computation Institute, University of Chicago                       #
########################################################################
package ModelSEED::MS::Types;
use Moose::Util::TypeConstraints;

HEREDOC

foreach my $name (keys(%{$objects})) {
	my $object = $objects->{$name};
	#Creating header
	my $output = [
		"########################################################################",
		"# ModelSEED::MS::DB::".$name." - This is the moose object corresponding to the ".$name." object",
		"# Authors: Christopher Henry, Scott Devoid, Paul Frybarger",
		"# Contact email: chenry\@mcs.anl.gov",
		"# Development location: Mathematics and Computer Science Division, Argonne National Lab",
		"########################################################################",
	];
	#Creating perl use statements
	my $baseObject = "BaseObject";
	if ($object->{class} eq "indexed") {
		$baseObject = "IndexedObject";	
	}
	
	#if (defined($object->{parents}->[0])) {
	#	push(@{$output},"use ModelSEED::MS::".$object->{parents}->[0].";");
	#}
    my $packages = [];
    #push(@{$output},("use ModelSEED::MS::".$baseObject.";"));
	#foreach my $subobject (@{$object->{links}}) {
	#	push(@{$output},"use ModelSEED::MS::".$subobject->{class}.";");
	#}
	#Creating package statement
	push(@{$output},"package ModelSEED::MS::DB::".$name.";");
	foreach my $subobject (@{$object->{subobjects}}) {
		if ($subobject->{type} !~ /hasharray/) {
            push(@$packages,"ModelSEED::MS::LazyHolder::" . $subobject->{class});
		}
	}
    push(
        @{$output},
        "use Moose;",
        "use Moose::Util::TypeConstraints;",
    );
    push(@{$output}, map { "use $_;" } @$packages);
    push(
        @{$output},
        (   "extends 'ModelSEED::MS::" . $baseObject . "';",
            "use namespace::autoclean;",
            "", ""
        )
    );
	#Determining and setting base class
	#Printing parent
	my $type = ", type => 'parent', metaclass => 'Typed'";
	if (defined($object->{parents}->[0])) {
        my $parent = $object->{parents}->[0];
		push(@{$output},("# PARENT:"));
        if($parent =~ /ModelSEED::/) {
            push(@{$output},"has parent => (is => 'rw', isa => '$parent'$type);");
        } else {
            push(@{$output},"has parent => (is => 'rw',isa => 'ModelSEED::MS::".$object->{parents}->[0]."'".$type.",weak_ref => 1);");
        }
		push(@{$output},("",""));
	}
	#Printing attributes
	push(@{$output},("# ATTRIBUTES:"));
	$type = ", type => 'attribute', metaclass => 'Typed'";
	my $uuid = 0;
	my $modDate = 0;
	foreach my $attribute (@{$object->{attributes}}) {
		my $suffix = "";
		if (defined($attribute->{req}) && $attribute->{req} == 1) {
			$suffix .= ", required => 1";
		}
		if (defined($attribute->{default})) {
			$suffix .= ", default => '".$attribute->{default}."'";
		}
		if ($attribute->{name} eq "uuid") {
			$suffix .= ", lazy => 1, builder => '_builduuid'";
			$uuid = 1;
		}
		if ($attribute->{name} eq "modDate") {
			$suffix .= ", lazy => 1, builder => '_buildmodDate'";
			$modDate = 1;
		}
		push(@{$output},"has ".$attribute->{name}." => ( is => '".$attribute->{perm}."', isa => '".$attribute->{type}."'".$type.$suffix." );");
	}
	push(@{$output},("",""));
	#Printing ancestor
	if ($uuid == 1) {
		push(@{$output},("# ANCESTOR:"));
		my $type = ", type => 'acestor', metaclass => 'Typed'";
		push(@{$output},"has ancestor_uuid => (is => 'rw',isa => 'uuid'".$type.");");
	}
	push(@{$output},("",""));
	#Printing subobjects
	my $typeToFunction;
	if (defined($object->{subobjects}) && defined($object->{subobjects}->[0])) {
		push(@{$output},("# SUBOBJECTS:"));
		foreach my $subobject (@{$object->{subobjects}}) {
			$typeToFunction->{$subobject->{class}} = $subobject->{name};
			$type = ", type => '".$subobject->{type}."(".$subobject->{class}.")', metaclass => 'Typed'";
			if ($subobject->{type} =~ m/hasharray\((.+)\)/) {
				$type = ", type => 'hasharray(".$subobject->{class}.",".$1.")', metaclass => 'Typed'";
				push(@{$output},"has ".$subobject->{name}." => (is => 'rw',default => sub{return {};},isa => 'HashRef[ArrayRef]'".$type.");");
			} elsif ($subobject->{type} =~ m/link/) {				
				$type = ", type => 'solink(".$subobject->{parent}.",".$subobject->{class}.",".$subobject->{query}.",".$subobject->{attribute}.")', metaclass => 'Typed'";
				push(@{$output},"has ".$subobject->{name}." => (is => 'rw',default => sub{return [];},isa => 'ArrayRef|ArrayRef[ModelSEED::MS::".$subobject->{class}."]'".$type.",weak_ref => 1);");
			} else {
				push(@{$output},"has ".$subobject->{name}." => (is => 'bare', coerce => 1, handles => { ".
                    $subobject->{name}." => 'value' }, default => sub{return []}, isa => 'ModelSEED::MS::".$subobject->{class}."::Lazy'$type);");
			}
		}
		push(@{$output},("",""));
	}
	#Printing object links
	if (defined($object->{links}) || defined($object->{alias})) {
		push(@{$output},("# LINKS:"));
		if (defined($object->{links}) && defined($object->{links}->[0])) {
			foreach my $subobject (@{$object->{links}}) {
				$type = ", type => 'link(".$subobject->{parent}.",".$subobject->{class}.",".$subobject->{query}.",".$subobject->{attribute}.")', metaclass => 'Typed'";
				push(@{$output},"has ".$subobject->{name}." => (is => 'rw',lazy => 1,builder => '_build".$subobject->{name}."',isa => 'ModelSEED::MS::".$subobject->{class}."'".$type.",weak_ref => 1);");
			}
		}
		if (defined($object->{alias})) {
			push(@{$output},"has id => (is => 'rw',lazy => 1,builder => '_buildid',isa => 'Str', type => 'id', metaclass => 'Typed');");
		}
		push(@{$output},("",""));
	}
	#Printing builders
	push(@{$output},("# BUILDERS:"));
	if ($uuid == 1) {
		push(@{$output},"sub _builduuid { return Data::UUID->new()->create_str(); }");
	}
	if ($modDate == 1) {
		push(@{$output},"sub _buildmodDate { return DateTime->now()->datetime(); }");
	}
	foreach my $subobject (@{$object->{links}}) {
		push(@{$output},(
			"sub _build".$subobject->{name}." {",
				"\tmy (\$self) = \@_;",
				"\treturn \$self->getLinkedObject('".$subobject->{parent}."','".$subobject->{class}."','".$subobject->{query}."',\$self->".$subobject->{attribute}."());",
			"}"
		));
	}
	push(@{$output},("",""));
	#Printing constants
	push(@{$output},("# CONSTANTS:"));
	push(@{$output},"sub _type { return '".$name."'; }");
	if (defined($typeToFunction)) {
		push(@{$output},"sub _typeToFunction {");
		push(@{$output},"\treturn {");
		foreach my $key (keys(%{$typeToFunction})) {
			push(@{$output},"\t\t".$key." => '".$typeToFunction->{$key}."',");
		}
		push(@{$output},"\t};");
		push(@{$output},"}");
		if (defined($object->{alias})) {
			push(@{$output},"sub _aliasowner { return '".$object->{alias}."'; }");
		}
	}
	push(@{$output},("",""));
	#Finalizing
	push(@{$output},("__PACKAGE__->meta->make_immutable;","1;"));
	ModelSEED::utilities::PRINTFILE("../MS/DB/".$name.".pm",$output);
	if (!-e "../MS/".$name.".pm") {
		$output = [
			"########################################################################",
			"# ModelSEED::MS::".$name." - This is the moose object corresponding to the ".$name." object",
			"# Authors: Christopher Henry, Scott Devoid, Paul Frybarger",
			"# Contact email: chenry\@mcs.anl.gov",
			"# Development location: Mathematics and Computer Science Division, Argonne National Lab",
			"# Date of module creation: ".DateTime->now()->datetime(),
			"########################################################################",
			"use strict;",
			"use ModelSEED::MS::DB::".$name.";",
			"package ModelSEED::MS::".$name.";",
			"use Moose;",
			"use namespace::autoclean;",
			"extends 'ModelSEED::MS::DB::".$name."';",
			"# CONSTANTS:",
			"#TODO",
			"# FUNCTIONS:",
			"#TODO",
			"",
			"",
			"__PACKAGE__->meta->make_immutable;",
			"1;"
		];
		ModelSEED::utilities::PRINTFILE("../MS/".$name.".pm",$output);
	}
    # create subtype entries
    my $msPackage = "ModelSEED::MS::$name";
    my $dbPackage = "ModelSEED::MS::DB::$name";
    my $lazySubtype = "ModelSEED::MS::$name\:\:Lazy";
    my $coercedSubtype = "ModelSEED::MS::$name\:\:Coerced";
    my $lazyHolder = "ModelSEED::MS::LazyHolder::$name";
    my $collectionSubtype = "ModelSEED::MS::ArrayRefOf$name";
    my $subtypeEntry = <<HEREDOC;
#
# Subtypes for $msPackage
#
package ModelSEED::MS::Types::$name;
use Moose::Util::TypeConstraints;
use Class::Autouse qw ( $dbPackage );

coerce '$msPackage',
    from 'HashRef',
    via { $dbPackage->new(\$_) };
subtype '$collectionSubtype',
    as 'ArrayRef[$dbPackage]';
coerce '$collectionSubtype',
    from 'ArrayRef',
    via { [ map { $dbPackage->new( \$_ ) } \@{\$_} ] };

1;
HEREDOC
    push(@$subtypesUse, "use $msPackage;\n");
    push(@$subtypes, $subtypeEntry);
    my $lazyHolderEntry = <<HEREDOC;
# Holder for $msPackage
package $lazyHolder;
use Moose;
use Moose::Util::TypeConstraints;
use $msPackage;
use ModelSEED::MS::Types::$name;
use namespace::autoclean;

BEGIN {
    subtype '$lazySubtype',
        as '$lazyHolder';
    coerce '$lazySubtype',
        from 'Any',
        via { $lazyHolder->new( uncoerced => \$_ ) };
}

has uncoerced => (is => 'rw');
has value => (
    is      => 'rw',
    isa     => '$collectionSubtype',
    lazy    => 1,
    coerce  => 1,
    builder => '_build'
);

sub _build {
    my (\$self) = \@_; 
    my \$val = \$self->uncoerced;
    \$self->uncoerced(undef);
    return \$val;
}
__PACKAGE__->meta->make_immutable;
1;

HEREDOC
    open(my $typeFH, ">", "../MS/Types/$name.pm") || die ("Could not open file $name!");
    print $typeFH $subtypeEntry;
    close($typeFH);
    open(my $lazyFH, ">", "../MS/LazyHolder/$name.pm") || die("Could not open file!");
    print $lazyFH $lazyHolderEntry;
    close($lazyFH);
}
#push(@$subtypesUse, "BEGIN {\n");
#unshift(@$subtypes, ($subtypesOpening, join("", @$subtypesUse)));
#push(@$subtypes, "}\n__PACKAGE__->meta->make_immutable;\n1;\n");
#open(my $subtypeFH, ">", "../MS/Types.pm") || die("Could not open file!");
#print $subtypeFH join("", @$subtypes);
#close($subtypeFH);
