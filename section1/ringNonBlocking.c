#include <stdio.h>
#include <mpi.h>

#define FALSE 0
#define TRUE 1

int main (int argc, char * argv[])
{
  const int qperiod = TRUE;
  int rank, value, size, np = 0;
  int rightP, leftP;
  int msgleft, msgright;
  int msgFromLeft, msgFromRight;  //msgrcv[0] viene da destra msgrcv[1] viene da sinistra
  int itag1, itag2;
  double timeS;  //Start Time
  double timeE;  //End Time
  double timeT;
  double timeRcv;

  MPI_Request reqs[4];   // required variable for non-blocking calls
  MPI_Comm ringCommunicator;
  MPI_Status status[4];

  MPI_Init( &argc, &argv );
  MPI_Barrier(MPI_COMM_WORLD);

  for (size_t i = 0; i < 100; i++) {
    timeS = MPI_Wtime();
    MPI_Comm_size( MPI_COMM_WORLD,&size );
    MPI_Cart_create( MPI_COMM_WORLD, 1, &size, &qperiod, 1, &ringCommunicator );    //left and right processors
    MPI_Cart_shift( ringCommunicator, 0, 1, &leftP, &rightP );
    MPI_Comm_rank( ringCommunicator, &rank );
    MPI_Comm_size( ringCommunicator, &size );

    msgleft = rank;
    msgright = -rank;
    itag1 = rank*10;
    itag2 = rank*10;

    status[2].MPI_TAG = 1;  //Initialise status tag for have safe check in the while loop
    status[3].MPI_TAG = 1;  //Initialise status tag for have safe check in the while loop

    for (size_t i = 0; i < 100000; i++) {
      while(status[3].MPI_TAG != rank*10 && status[2].MPI_TAG != rank*10){
        MPI_Isend(&msgleft, 1, MPI_INT, leftP, itag1, ringCommunicator, &reqs[0]);          //Send msglefto left
        MPI_Isend(&msgright, 1, MPI_INT, rightP, itag2, ringCommunicator, &reqs[1]);        //Send msright to right
        MPI_Irecv(&msgFromRight, 1, MPI_INT, rightP, MPI_ANY_TAG, ringCommunicator, &reqs[2]); //Receive msgrcv[1] from right
        MPI_Irecv(&msgFromLeft, 1, MPI_INT, leftP, MPI_ANY_TAG, ringCommunicator, &reqs[3]);  //Receive msgrcv[0] from left

        np = np + 2;  //Updating number of time that rank processor has recived a message
        MPI_Waitall(4, reqs, status);   //Wait for every call MPI_Irecv and MPI_Irecv to mantain safety

        msgleft = msgFromRight - rank ;    //received from right forward to left substracted
        msgright = msgFromLeft + rank;    //received from left forward to right added
        itag2 = status[3].MPI_TAG;      //taken received tags for forwarding and complete the ring
        itag1 = status[2].MPI_TAG;      //taken received tags for forwarding and complete the ring
      }
    }

    printf("I am process %d and I have received %d messages. My final messages have tag %d and value %d, %d\n", rank, np, status[2].MPI_TAG ,msgFromLeft, msgFromRight);

    MPI_Barrier(ringCommunicator);

    timeE = MPI_Wtime();
    timeT = timeT + (timeE - timeS);
  }
  timeT = timeT / 100;
  MPI_Reduce(&timeT, &timeRcv, 1, MPI_DOUBLE, MPI_MIN,0, ringCommunicator);

  MPI_Finalize();

  if(rank == 0){
      printf("%10.8f\n", timeRcv);
  }


}
