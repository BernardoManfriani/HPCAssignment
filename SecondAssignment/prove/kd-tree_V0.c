#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <omp.h>


struct kdnode * build_kdtree( kpoint *points, int N, int ndim, int axis ){
  /*
  * points is a pointer to the relevant section of the data set;
  * N is the number of points to be considered, from points to points+N
  * ndim is the number of dimensions of the data points
  * axis is the dimension used previsously as the splitting one
  */

  if( N == 1 ) {
    return a leaf with the point *points;
  }
  struct kdnode *node;
  //
  // ... here you should either allocate the memory for a new node
  // like in the classical linked-list, or implement something different
  // and more efficient in terms of tree-traversal
  //
  int myaxis = choose_splitting_dimension( points, ndim, axis); //
  implement the choice for
  // the
  splitting dimension
  kpoint *mypoint = choose_splitting_point( points, myaxis); // pick-up
  the splitting point
  struct kpoint *left_points, *right_points;
  //
  // ... here you individuate the left- and right- points
  //
  node -> axis = myaxis;
  node -> split = *splitting_point; // here we save a data point, but it's up to you
  // to opt to save a pointer, instead
  node -> left = build_kdtree( left_points, N_left, ndim, myaxis );
  node -> right = build_kdtree( right_points, N_right, ndim, myaxis );
  return node;
}
