#!/bin/bash
#PBS -l nodes=1:ppn=2
#PBS -q dssc

cd mpi_examples/mpi-benchmarks/src_c 

module load openmpi-4.1.1+gnu-9.3.0

echo -e $"\n \n \n########################################## \n"
echo -e $"######## 1 NODE 1 SOCKET 2  CORES ######## \n" 
echo -e $"########################################## \n \n \n \n"
mpirun -np 2 --map-by core --report-bindings ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >oneNodeOneSocket.csv 


echo -e $"\n \n \n########################################## \n"
echo -e $"######## 1 NODE 2 SOCKET 2  CORES ######## \n"
echo -e $"########################################## \n \n \n \n"
mpirun -np 2 --map-by socket --report-bindings ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >oneNodeTwoSocket.csv 

echo -e $"\n \n \n########################################## \n"
echo -e $"######## 2 NODE 2 SOCKET 2  CORES ######## \n"
echo -e $"########################################## \n \n \n \n"
mpirun -np 2 --map-by node --report-bindings ./IMB-MPI1 PingPong 2> /dev/null | grep -v ^# | grep -v -e '^$' |  tr -s ' '| sed 's/^[ \t]+*//g' | sed 's/[ \t]+*/,/g' >twoNodeTwoSocket.csv 

# mpirun -np 2 --map-by node --report-bindings ./IMB-MPI1 PingPong     

# mpirun -np 2 --map-by node --report-bindings ./IMB-MPI1 PingPong

# mpirun -np 2 --map-by node --report-bindings ./IMB-MPI1 PingPong     

exit
