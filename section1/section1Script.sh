#!/bin/bash
#PBS -l nodes=2:ppn=24
#PBS -l walltime=01:00:00
#PBS -q dssc

cd $PBS_O_WORKDIR
module load openmpi-4.1.1+gnu-9.3.0

time_first=[]

for x in {2..48}
do
   mpirun -np $x --mca btl ^openib ./ringNonBlocking.x > ring_time_non_blocking_${x}_procc  
  
   str=$(cat output_ring_non_blocking_${x}_procc | tail -1 | cut -f2 -d '#######Execution time ')
 
   time_first[x]=$(echo ${str} | cut -d ' ' -f1)
   printf '%d\t%s\t\t%s\n' ${x} ${time_first[x]} >> results.csv   
done


exit

