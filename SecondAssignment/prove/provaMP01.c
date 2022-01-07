#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <omp.h>

int main(int argc, char const *argv[]) {
  int nthreads = 1;
  #pragma omp parallel
  {
     int myid = omp_get_thread_num();
    #pragma omp master
     int nthreads = omp_get_num_threads();
    #pragma omp barrier
    #pragma omp for ordered
     for ( int i = 0; i < nthreads; i++ ){
      #pragma omp ordered
       printf( "greetings from thread num %d\n", my_thread_id );
     }
  }
  return 0;
}
