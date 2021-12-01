#!/bin/bash 

#PBS -l nodes=2:ppn=48

#PBS -l walltime=01:00:00 

#PBS -q dssc_gpu


cd $PBS_O_WORKDIR 

module load openmpi-4.1.1+gnu-9.3.0  
module load intel 


#OPENMPI

#MAP BY CORE 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreOb1VadGPU.csv 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreOb1tcpGPU.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreUcxGPU.csv

#MAP BY SOCKET

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketOb1tcpGPU.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketUcxGPU.csv 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketOb1VaderGPU.csv 

#MAP BY NODE

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by node ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeOb1tcpGPU.csv 

mpirun -mca pml ucx  --report-bindings -np 2 --map-by node ./IMB-MPI1 PingPong  -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeUcxGPU.csv 


#INTEL

#MAP BY CORE

mpiexec -n 2 -genv I_MPI_PIN_PROCESSOR_LIST=0,2  ./IMB-MPI1_intel PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreIntelGPU.csv

mpiexec -n 2 -genv I_MPI_PIN_PROCESSOR_LIST=0,2 -genv I_MPI_OFI_PROVIDER tcp ./IMB-MPI1_intel PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreIntelTcpGPU.csv

mpiexec -n 2 -genv I_MPI_PIN_PROCESSOR_LIST=0,2 -genv I_MPI_OFI_PROVIDER shm ./IMB-MPI1_intel PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycoreIntelShmGPU.csv

#MAP BY SOCKET

mpiexec -n 2 -genv I_MPI_PIN_PROCESSOR_LIST=0,1  ./IMB-MPI1_intel PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketIntelGPU.csv

mpiexec -n 2 -genv I_MPI_PIN_PROCESSOR_LIST=0,1 -genv I_MPI_OFI_PROVIDER tcp ./IMB-MPI1_intel PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketIntelTcpGPU.csv

mpiexec -n 2 -genv I_MPI_PIN_PROCESSOR_LIST=0,1 -genv I_MPI_OFI_PROVIDER shm ./IMB-MPI1_intel PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocketShmGPU.csv
  
#MAP BY NODE

mpiexec -n 2 -ppn 1 ./IMB-MPI1_intel  PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeIntelIfinibandGPU.csv

mpiexec -n 2 -ppn 1 -genv I_MPI_OFI_PROVIDER tcp ./IMB-MPI1_intel PingPong -msglog 28 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynodeIntelTcpGPU.csv



git rm benchmarkGPU.sh.*  

git add * 

git commit -m "new benchmarks" 

git push 
  

exit 

