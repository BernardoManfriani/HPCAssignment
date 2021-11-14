#!/bin/bash 

#PBS -l nodes=2:ppn=24 

#PBS -l walltime=00:01:00 

#PBS -q dssc 

  

cd $PBS_O_WORKDIR 

module load openmpi-4.1.1+gnu-9.3.0  

 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycore_vader.csv 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycore_tcp.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bycore_ucx.cvs 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocket_tcp.csv 

mpirun -mca pml ucx --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bysocket_ucx.csv 

mpirun -mca pml ob1 --mca btl self,vader --report-bindings -np 2 --map-by socket ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >by_socket_vader.csv 

mpirun -mca pml ob1 --mca btl self,tcp --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynode_tcp.csv 

mpirun -mca pml ucx  --report-bindings -np 2 --map-by core ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >bynode_ucx.csv 

  

git add * 

git commit -m "new benchmarks" 

git push 

  

exit 
