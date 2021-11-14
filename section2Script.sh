#!/bin/bash 

#PBS -l nodes=2:ppn=24 

#PBS -l walltime=01:00:00 

#PBS -q dssc 

  

cd $PBS_O_WORKDIR 

module load openmpi-4.1.1+gnu-9.3.0  

 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreOb1Vad.csv 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreOb1tcp.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreUcx.csv

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketOb1tcp.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketUcx.csv 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketOb1Vader.csv 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeOb1tcp.csv 

mpirun -mca pml ucx  --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeUcx.csv 


git rm section2Script.sh.*  

git add * 

git commit -m "new benchmarks" 

git push 
  

exit 
