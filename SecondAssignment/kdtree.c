#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <omp.h>
#include <assert.h>

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
#define TASK_SIZE 100


struct kpoint {
   float_t axis[2];
};

struct kdnode {
  int axis;                     // the splitting dimension
  struct kpoint split;                 // the splitting element
  struct kdnode *left, *right;  // the left and right sub-trees
};


struct kpoint* initTree(int size);   //Initialize the tree
struct kpoint* copyTree(struct kpoint* treeX, int size);

void printTree(struct kpoint* tree, int size);  // naive printing of a kd-trees

int partition(struct kpoint* tree, int p, int r, int axis1, int axis2);

void quicksort(struct kpoint* tree, int p, int r, int axis1, int axis2);

int main(int argc, char const *argv[]) {
  srand(123456);
  int treeSize  = (argc > 1) ? atoi(argv[1]) : 10;
  int print = (argc > 2) ? atoi(argv[2]) : 0;
  int numThreads = (argc > 3) ? atoi(argv[3]) : 2;

  omp_set_dynamic(0);              /** Explicitly disable dynamic teams **/
  omp_set_num_threads(numThreads); /** Use N threads for all parallel regions **/

  struct kpoint * treeX, * treeY;
  treeX = initTree(treeSize);
  treeY = copyTree(treeX, treeSize);
  printTree(treeX, treeSize);
  printTree(treeY, treeSize);

  double begin = omp_get_wtime();
  #pragma omp parallel
  {
      #pragma omp critical
       quicksort(treeX, 0, treeSize - 1, 0, 1);
       quicksort(treeY, 0, treeSize - 1, 1, 0);
  }

  double end = omp_get_wtime();
  printf("Time: %f (s) \n",end-begin);

  printTree(treeX, treeSize);
  printTree(treeY, treeSize);

  free(treeX);
  free(treeY);

  return 0;
}


struct kpoint* initTree(int size){   //Initialize the tree
  struct kpoint point;
  struct kpoint *tree = malloc (sizeof (struct kpoint) * size);   //Creation of the array of kpoints.

  for(int i = 0; i < size; i++){                  //Iterate on the array [0:TREESIZE] to initialize it
      tree[i].axis[0]= (float_t)rand()/200000000.0;                  //Random generation of points normalized between 0:10
      tree[i].axis[1] = (float_t)rand()/200000000.0;
  }

  return tree;
}

struct kpoint* copyTree(struct kpoint* treeX, int size){
  struct kpoint point;
  struct kpoint *tree = malloc (sizeof (struct kpoint) * size);

  for(int i = 0; i < size; i++){                  //Iterate on the array [0:TREESIZE] to initialize it
    tree[i].axis[0] = treeX[i].axis[0];
    tree[i].axis[1] = treeX[i].axis[1];
  }

  return tree;
}

void printTree(struct kpoint* tree, int size){  //Print 2D-Tree
  for(int i = 0; i < size; i++){
    printf("(%f, ",tree[i].axis[0]);
    printf("%f)   ",tree[i].axis[1]);
    printf("\n");
  }
  printf("\n");
}


int partition(struct kpoint* tree, int p, int r, int axis1, int axis2)
{
    float_t ltX[r-p];
    float_t ltY[r-p];
    float_t gtX[r-p];
    float_t gtY[r-p];
    float_t keyX = tree[r].axis[axis1];
    float_t keyY = tree[r].axis[axis2];
    int i,j;
    int lt_nX = 0;
    int gt_nX = 0;
    int lt_nY= 0;
    int gt_nY = 0;

    for(i = p; i < r; i++){
        if(tree[i].axis[axis1] < tree[r].axis[axis1]){
            ltX[lt_nX++] = tree[i].axis[axis1];
            ltY[lt_nY++] = tree[i].axis[axis2];
        }else{
            gtX[gt_nX++] = tree[i].axis[axis1];
            gtY[gt_nY++] = tree[i].axis[axis2];
        }
    }

    for(i = 0; i < lt_nX; i++){
        tree[p + i].axis[axis1] = ltX[i];
        tree[p + i].axis[axis2] = ltY[i];
    }

    tree[p + lt_nX].axis[axis1] = keyX;
    tree[p + lt_nY].axis[axis2] = keyY;

    for(j = 0; j < gt_nX; j++){
        tree[p + lt_nX + j + 1].axis[axis1] = gtX[j];
        tree[p + lt_nY + j + 1].axis[axis2] = gtY[j];
    }

    return p + lt_nX;
}

void quicksort(struct kpoint* tree, int p, int r, int axis1, int axis2)  //axis: 0 or 1 0 for x 1 for y
{

    int div;
    if(p < r){
        div = partition(tree, p, r, axis1, axis2);
        #pragma omp task shared(tree) if(r - p > TASK_SIZE)
        quicksort(tree, p, div - 1, axis1, axis2);
        #pragma omp task shared(tree) if(r - p > TASK_SIZE)
        quicksort(tree, div + 1, r, axis1, axis2);
    }
}
