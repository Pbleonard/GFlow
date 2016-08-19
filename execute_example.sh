#!/bin/bash -x

# This script will execute Gflow with 5 random pairwise computations using 4 cpus on Mac OSX and output only the current density summation. 
# The default inputs include 588 node pairs that solve > 34.25 million unknowns. 
# Gflow must be compiled locally before executing this script. Dependencies for Gflow include: openmpi, hypre, and petsc. If you would like to execute a random shuffle
# of all pairwise, please install 'coreutils'as well.

# Example flags are commented below to demonstrate example execution of GFlow

which mpiexec

# Set and add PETSc to PATH
export PETSC_DIR=/usr/local/Cellar/petsc/3.7.3/real
export LD_LIBRARY_PATH=${PETSC_DIR}/lib:$LD_LIBRARY_PATH

# Set Output Directory: Default is Current Directory
OUTPUT_DIR=.

# DEBUG: Set number of random pairs to calculate from all possible pairs (Currently n=5). Must be used with -node_pairs flag
# Remove or comment line for all pairwise. Requires 'coreutils'
gshuf all.tsv -n 5 > ${OUTPUT_DIR}/shuf.tsv 

# Set the Clock
SECONDS=0
date
# Set Number of processes (CPUs) and call Gflow. Currently n = 4
	# -Set Prefix for output files: Currently = 'local_'
	# -Set Output Directory: Set to default above
	# -Set Habitat Map or resistance surface (.asc)
	# -Set Focal Nodes or Source/Destination Points (.txt list of point pairs to calculate or .asc grid)
	# -Calculate only desired node pairs if input. Currently set to 5 random suffles above.
	# -Set convergence factor (accepts the following example formats, 4N, .0001, 1e-4 ). Currently not set.
	# -Shuffles pairs for random selection. Input is binary. Currently = 0; using 5 random shuffles above.
	# -Set output format -- .asc or amps. Default = .asc
	# -Select output options. 1 = Only summation; 0 = Pairwise calculations + Summation

mpiexec -n 4 ./gflow.x \
	-output_prefix local_ \
	-output_directory ${OUTPUT_DIR} \
	-habitat resistance.asc \
	-nodes nodes \
	-node_pairs ${OUTPUT_DIR}/shuf.tsv \
	-converge_at \
	-shuffle_node_pairs 0\
	-output_format asc \
	-output_final_current_only 1
 

: "walltime: $SECONDS seconds"
