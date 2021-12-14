#!/bin/bash
#PBS -l nodes=1:ppn=24
#PBS -l walltime=02:00:00
#PBS -q dssc


cd $PBS_O_WORKDIR 
module load openmpi-4.1.1+gnu-9.3.0 


mpirun -np 24 -mca btl ^openib ./matrix 2400 100 100 > matrix_time_2400
mpirun -np 24 -mca btl ^openib ./matrix 1200 200 100 > matrix_time_1200
mpirun -np 24 -mca btl ^openib ./matrix 800 300 100 > matrix_time_800


exit

