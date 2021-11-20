#!/bin/bash 

#PBS -l nodes=2:ppn=48

#PBS -l walltime=01:00:00 

#PBS -q dssc_gpu

cd $PBS_O_WORKDIR 

module load openmpi-4.1.1+gnu-9.3.0  

 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreOb1VadGPU.csv 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreOb1tcpGPU.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreUcxGPU.csv

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketOb1tcpGPU.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketUcxGGPU.csv 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketOb1VaderGPU.csv 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by node ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeOb1tcpGPU.csv 

mpirun -mca pml ucx  --report-bindings -np 2 --map-by node ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeUcxGPU.csv 


git rm benchmarkGPU.sh.*  

git add * 

git commit -m "new benchmarks" 

git push 
  

exit 

