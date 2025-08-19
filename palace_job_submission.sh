#!/bin/bash

# Firas Abouzahr - August 19, 2025

## everything you need to run palace is packaged under /cvmfs/fermilab.opensciencegrid.org/cosmiq/palace-env, including: ##
# * palace
# * OpenBlas
# * OpenMPI

##############################################################################################
##############################################################################################
#################### setting paths & environment variables to run palace #####################
##############################################################################################
##############################################################################################

# do not change these
export HOME_DIR="/cvmfs/fermilab.opensciencegrid.org/cosmiq"
export PALACE_ENV="$HOME_DIR/palace-env"
export LD_LIBRARY_PATH="$PALACE_ENV/palace/palace_install/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$PALACE_ENV/openmpi/install/lib:$LD_LIBRARY_PATH"
export OPAL_PREFIX="$PALACE_ENV/openmpi/install"
export PATH="$PALACE_ENV/openmpi/install/bin:$PATH"
export PALACE="$PALACE_ENV/palace/palace_install/bin/palace-x86_64.bin"

##############################################################################################
##############################################################################################
############################ setup grid and PNFS transfer tools ##############################
##############################################################################################
##############################################################################################

# do not change these
export PNFS_BASE_DIR="/pnfs/cosmiq"
export PNFS_OUT_DIR="$PNFS_BASE_DIR/scratch/"
export EXPERIMENT="cosmiq"
export USER=`whoami`
export IFDH_CP_MAXRETRIES=2
source /cvmfs/fermilab.opensciencegrid.org/products/common/etc/setup
setup ifdhc

##############################################################################################
##############################################################################################
######################### simulation specific environment variables ##########################
######################### change as needed for your own simulations ##########################
##############################################################################################
##############################################################################################

# directory where your palace script and (ideally) corresponding mesh file are located
export SIM_DIR="$HOME_DIR/palace-cylinder-example/"

# palace script filename
export SIM_FILE="cavity_pec.json"

# define full path to palace script (do
export JSON_PATH="$SIM_DIR/$SIM_FILE"

# this MUST match Output name in json file ($SIM_FILE)
export OUTPUTNAME="palace_cylinder_example_output"

# number of MPI processes
export mpi_processes=16

##############################################################################################
##############################################################################################
######################### Run simulation and transfer data to pnfs ###########################
##############################################################################################
##############################################################################################

# Run palace simulation
mpirun -n $mpi_processes $PALACE $JSON_PATH

# Tar the output file
tar -czvf $OUTPUTNAME.tar.gz ./$OUTPUTNAME

# remove file if it already exists
rm -f $PNFS_OUT_DIR/$OUTPUTNAME.tar.gz

# move tarred output file to pnfs
ifdh cp $OUTPUTNAME.tar.gz $PNFS_OUT_DIR/$OUTPUTNAME.tar.gz
