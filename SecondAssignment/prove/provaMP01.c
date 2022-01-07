#if defined(__STDC__)
#  if (__STDC_VERSION__ >= 199901L)
#     define _XOPEN_SOURCE 700
#  endif
#endif

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <omp.h>

int main(int argc, char const *argv[]) {
  //int nthreads = 1;

  // #pragma omp parallel
  // {
  //    int myid = omp_get_thread_num();
  //   #pragma omp master
  //    int nthreads = omp_get_num_threads();
  //   #pragma omp barrier
  //
  //   #pragma omp for ordered
  //    for ( int i = 0; i < nthreads; i++ ){
  //     #pragma omp ordered
  //      printf( "greetings from thread num %d\n", myid );
  //    }
  // }

  int order = 0;
  #pragma omp parallel
  {
    int myid = omp_get_thread_num();
    int done = 0;
    
    while (!done) {
     #pragma omp critical
      if ( order == myid ) {
        printf( "greetings from thread num %d\n", myid );
        order++;
        done=1;
      }
    }
  }
  return 0;
}
