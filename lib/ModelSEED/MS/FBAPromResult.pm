########################################################################
# ModelSEED::MS::FBAPromResult - This is the moose object corresponding to the FBAPromResult object
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
# Date of module creation: 2012-11-27T23:16:35
########################################################################
use strict;
use ModelSEED::MS::DB::FBAPromResult;
package ModelSEED::MS::FBAPromResult;
use Moose;
use namespace::autoclean;
extends 'ModelSEED::MS::DB::FBAPromResult';
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
