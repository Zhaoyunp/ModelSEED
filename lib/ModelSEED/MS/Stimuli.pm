########################################################################
# ModelSEED::MS::Stimuli - This is the moose object corresponding to the Stimuli object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2013-03-26T04:50:36
########################################################################
use strict;
use ModelSEED::MS::DB::Stimuli;
package ModelSEED::MS::Stimuli;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::DB::Stimuli';
#***********************************************************************************************************
# ADDITIONAL ATTRIBUTES:
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


__PACKAGE__->meta->make_immutable;
1;
