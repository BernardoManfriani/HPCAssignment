#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <omp.h>

#if defined(__STDC__)
#  if (__STDC_VERSION__ >= 199901L)
#     define _XOPEN_SOURCE 700
#  endif
#endif

#if !defined(DOUBLE_PRECISION)
# define float_t float
#else
# define float_t double
#endif
#define NDIM 2

struct kpoint float_t[NDIM];

struct kdnode {
int axis; // the splitting dimension
kpoint split; // the splitting element
struct kdnode *left, *right; // the left and right sub-trees
}

int main(int argc, char const *argv[]) {
  int array_0[10];
  return 0;
}
