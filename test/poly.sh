#!/bin/bash

#SBATCH --account=mam
#SBATCH --time=168:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --cpus-per-task=1
###SBATCH --nthreads=12
#SBATCH --mem=768000MB
#SBATCH --partition=inv-camml
#SBATCH --job-name=test
#SBATCH --output=%x_%j.out
### mailing options
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE
#SBATCH --mail-user=pshen@uwyo.edu

module load arcc/1.0  gcc/12.2.0 openmpi/4.1.4 petsc/3.18.2-ompi python/3.10.6
module load libtirpc/1.2.6 libevent/2.1.12
module load cmake/3.24.2

#source /project/mam/apps/mooseinstall_01082023/.moose_profile
#cd $workdir

srun   /project/mam/apps/moose_pshen/moose/modules/combined/combined-opt -i  polycrystal4.i

