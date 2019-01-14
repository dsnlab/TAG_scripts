#!/bin/bash
#
#
#
#

module load ants
module load fsl
module load afni
module load c3d
module load python3
module load R
module load singularity

export AFNI_PATH=/packages/afni/18.2.04/
export XCPEDIR=/projects/dsnlab/shared/tag/TAG_scripts/rsfMRI/xcpEngine_REST
export C3D_PATH=/projects/tau/packages/c3d/1.0.0/bin/c3d

#now run xcpReset to make sure these were loaded properly
