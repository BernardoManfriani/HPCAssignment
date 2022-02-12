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
#define TREESIZE 10

struct kpoint {
   float_t x;
   float_t y;
};

struct kdnode {
  int axis;                     // the splitting dimension
  struct kpoint split;                 // the splitting element
  struct kdnode *left, *right;  // the left and right sub-trees
};


struct kpoint* initTree();   //Initialize the tree

void printTree(struct kpoint* tree);  // naive printing of a kd-trees


int main(int argc, char const *argv[]) {
  struct kpoint *tree;
  tree = initTree();
  printTree(tree);

  float_t sum1 = 0.0;
  float_t sum2 = 0.0;
  for (int i = 0; i < TREESIZE; i++) {
    if(i < TREESIZE/2){
      sum1 += tree[i].x + tree[i].y;
    }
    if(i >= TREESIZE/2){
      sum2 += tree[i].x + tree[i].y;
    }
  }

  printf("Prima metà %f \nSeconda metà %f\n", sum1, sum2 );



  return 0;
}


struct kpoint* initTree(){   //Initialize the tree
  struct kpoint point;
  struct kpoint *tree = malloc (sizeof (struct kpoint) * TREESIZE);   //Creation of the array of kpoints.

  for(int i = 0; i < TREESIZE; i++){                  //Iterate on the array [0:TREESIZE] to initialize it
      tree[i].x= rand()/100000000.0;                  //Random generation of points normalized between 0:10
      tree[i].y = rand()/100000000.0;
  }

  return tree;
}

void printTree(struct kpoint* tree){  //Print 2D-Tree
  for(int i = 0; i < TREESIZE; i++){
    printf("(%f, ",tree[i].x);
    printf("%f)   ",tree[i].y);
  }
  printf("\n");
}

// struct kdnode * build_kdtree( <current data set>, int ndim, int axis )
// {
//   // axis is the splitting dimension from the previous call
//   // ( may be -1 for the first call)
//   int myaxis = (axis+1)%ndim;
//   struct kdnode *this_node = (struct kdnode*)malloc(sizeof(struct kdnode));
//   this_node.axis = myaxis;
//   ...;
//   this_node.left = build_kdtree( <left_points>, ndim, myaxis);
//   this_node.right = build_kdtree( <right_points>, ndim, myaxis);
//   return this_node;
// }
