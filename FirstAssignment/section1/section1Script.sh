#!/bin/bash
#PBS -l nodes=2:ppn=24
#PBS -l walltime=01:00:00
#PBS -q dssc

cd $PBS_O_WORKDIR 
module load openmpi-4.1.1+gnu-9.3.0 

time_first=[]
rm results.csv
rm ring_time_non_blocking*

for x in {2..48}
do
   mpirun --map-by core -np $x --mca btl ^openib ./ringNonBlock.x > ring_time_non_blocking_${x}_procc

   str=$(cat ring_time_non_blocking_${x}_procc | tail -1 )

   time_first[x]=$(echo ${str} )
   printf '%d\t%s\n' ${x} ${time_first[x]} >> results.csv
done



exit

