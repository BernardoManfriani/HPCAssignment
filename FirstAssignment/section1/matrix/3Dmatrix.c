#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <time.h>

int main(int argc, char* argv[]) {
  int r1, r2, r3, size, myrank;
  int dim_recv;
  double timeS, timeE, timeT;
  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  MPI_Barrier(MPI_COMM_WORLD);
  timeS = MPI_Wtime();
  if(myrank == 0){
    r1 = atoi(argv[1]);
    r2 = atoi(argv[2]);
    r3 = atoi(argv[3]);
    dim_recv = (atoi(argv[1])*atoi(argv[2])*atoi(argv[3]))/size;
  } else {
    r1 = (atoi(argv[1])*atoi(argv[2])*atoi(argv[3]))/size;
    r2 = 0; //atoi(argv[2])/size;
    r3 = 0; //atoi(argv[3])/size;
    dim_recv = r1;
  }

  double mat1[r1][r2][r3],
         mat2[r1][r2][r3],
         matEnd[r1][r2][r3],
         recv_data1[dim_recv],
         recv_data2[dim_recv],
         send_data[dim_recv];

  if(myrank == 0){
    int dimFin = r1*r2*r3/size;
    printf("I am the processor %d of %d processor I have two matrices of dimension %d \\n\n", myrank, size, dimFin);
    //CREATE and INITIALIZE MATRIXES
    srand(time(NULL));
    for (int i = 0; i < r1; i++) {
      for (int j = 0; j < r2; j++) {
        for (int k = 0; k < r3; k++) {
          mat1[i][j][k] = (double)(rand()/1000000000.0);
          mat2[i][j][k] = (double)(rand()/1000000000.0);
        }
      }
    }
    //PRINT MATRIXES
    /*
    for (int i = 0; i < r1; i++) {
      for (int j = 0; j < r2; j++) {
        for (int k = 0; k < r3; k++) {
          printf("mat1[%d][%d][%d]: %f \n", i, j, k, mat1[i][j][k]);
          printf("mat2[%d][%d][%d]: %f \n", i, j, k, mat2[i][j][k]);
        }
      }
      printf("\n");
    }
    printf("\n");
    */
  }else{
    printf("I am the processor %d of %d processor I have two matrices of dimension %d \n\n", myrank, size, r1);
  }

  MPI_Scatter(&mat1, dim_recv, MPI_DOUBLE, &recv_data1, dim_recv, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Scatter(&mat2, dim_recv, MPI_DOUBLE, &recv_data2, dim_recv, MPI_DOUBLE, 0, MPI_COMM_WORLD);

  for (int i = 0; i < dim_recv; i++) {
    send_data[i] = recv_data1[i] + recv_data2[i] ;
  }

  MPI_Gather(&send_data, dim_recv, MPI_DOUBLE, &matEnd, dim_recv, MPI_DOUBLE, 0, MPI_COMM_WORLD);

  MPI_Barrier(MPI_COMM_WORLD);
  timeE = MPI_Wtime();
  timeT = timeE - timeS;

  /*
  if(myrank == 0){
    for (int i = 0; i < r1; i++) {
      for (int j = 0; j < r2; j++) {
        for (int k = 0; k < r3; k++) {
          printf("matEnd[%d][%d][%d]: %f \n", i, j, k, matEnd[i][j][k]);
        }
      }
      printf("\n");
    }
    printf("\n");
  }
  */

  MPI_Finalize();

  if (myrank == 0) {
    printf("The time is: %10.8f\n", timeT);
  }

  return 0;
}
