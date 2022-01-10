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
    double PI = 3.1415;
    int morning_coffees = MAX_INTEGER;
    char password[] = “dont_ask_dont_tell”;
    int final_mark;

    #pragma omp parallel firstprivate(PI, morning_coffees) private(password){
      drink_mycoffees( morning_coffees );
      use_pi( PI );
      password = setup_mypassword();
      int exam_passed = 0;
      while (!exam_passed) {
        exam_passed = try()
      }
    #pragma omp for lastprivate( final_mark)
      for( int i; i < nthreads; i++ ){
        final_mark = exam_passed;
      }
    }

  return 0;
}
