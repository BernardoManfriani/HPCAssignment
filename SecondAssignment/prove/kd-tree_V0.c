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

#if defined(DEBUG)
#define VERBOSE
#endif

#if defined(VERBOSE)
#define PRINTF(...) printf(__VA_ARGS__)
#else
#define PRINTF(...)
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

typedef struct
{
  double data[DATA_SIZE];
} data_t;

typedef int (compare_t)(const void*, const void*);
typedef int (verify_t)(data_t *, int, int, int);

extern inline compare_t compare;
extern inline compare_t compare_ge;
verify_t  verify_partitioning;
verify_t  verify_sorting;
verify_t  show_array;

struct kpoint* initTree();   //Initialize the tree

void printTree(struct kpoint* tree);  // naive printing of a kd-trees

extern inline int partitioning( data_t *, int, int, compare_t );

void pqsort( data_t *, int, int, compare_t );

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

  pqsort( data, 0, N, compare_ge );
  //printf("Prima metà %f \nSeconda metà %f\n", sum1, sum2 );

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



//SORTING PARALLEL QUICK SORT

#define SWAP(A,B,SIZE) do {int sz = (SIZE); char *a = (A); char *b = (B); \
   do { char _temp = *a;*a++ = *b;*b++ = _temp;} while (--sz);} while (0)


void pqsort( data_t *data, int start, int end, compare_t cmp_ge )
{

   #if defined(DEBUG)
   #define CHECK {							\
      if ( verify_partitioning( data, start, end, mid ) ) {		\
        printf( "partitioning is wrong\n");				\
        printf("%4d, %4d (%4d, %g) -> %4d, %4d  +  %4d, %4d\n",		\
  	    start, end, mid, data[mid].data[HOT],start, mid, mid+1, end); \
        show_array( data, start, end, 0 ); }}
   #else
   #define CHECK
   #endif

   printf( "partitioning is wrong\n");				\
   printf("%4d, %4d (%4d, %g) -> %4d, %4d  +  %4d, %4d\n",		\
   start, end, mid, data[mid].data[HOT],start, mid, mid+1, end); \
   show_array( data, start, end, 0 ); }}
  int size = end-start;
  if ( size > 2 )
    {
      int mid = partitioning( data, start, end, cmp_ge );

      CHECK;

     #pragma omp task shared(data) firstprivate(start, mid)
      pqsort( data, start, mid, cmp_ge );
     #pragma omp task shared(data) firstprivate(mid, end)
      pqsort( data, mid+1, end , cmp_ge );
    }
  else
    {
      if ( (size == 2) && cmp_ge ( (void*)&data[start], (void*)&data[end-1] ) )
	SWAP( (void*)&data[start], (void*)&data[end-1], sizeof(data_t) );
    }
}


inline int partitioning( data_t *data, int start, int end, compare_t cmp_ge ){

  // pick up the meadian of [0], [mid] and [end] as pivot
  //
  /* to be done */

  // pick up the last element as pivot
  //
  --end;
  void *pivot = (void*)&data[end];

  int pointbreak = end-1;
  for ( int i = start; i <= pointbreak; i++ )
    if( cmp_ge( (void*)&data[i], pivot ) )
      {
	while( (pointbreak > i) && cmp_ge( (void*)&data[pointbreak], pivot ) ) pointbreak--;
	if (pointbreak > i )
	  SWAP( (void*)&data[i], (void*)&data[pointbreak--], sizeof(data_t) );
      }
  pointbreak += !cmp_ge( (void*)&data[pointbreak], pivot ) ;
  SWAP( (void*)&data[pointbreak], pivot, sizeof(data_t) );

  return pointbreak;
}

int verify_sorting( data_t *data, int start, int end, int not_used )
{
  int i = start;
  while( (++i < end) && (data[i].data[HOT] >= data[i-1].data[HOT]) );
  return ( i == end );
}

int verify_partitioning( data_t *data, int start, int end, int mid )
{
  int failure = 0;
  int fail = 0;

  for( int i = start; i < mid; i++ )
    if ( compare( (void*)&data[i], (void*)&data[mid] ) >= 0 )
      fail++;

  failure += fail;
  if ( fail )
    {
      printf("failure in first half\n");
      fail = 0;
    }

  for( int i = mid+1; i < end; i++ )
    if ( compare( (void*)&data[i], (void*)&data[mid] ) < 0 )
      fail++;

  failure += fail;
  if ( fail )
    printf("failure in second half\n");

  return failure;
}


int show_array( data_t *data, int start, int end, int not_used )
{
  for ( int i = start; i < end; i++ )
    printf( "%f ", data[i].data[HOT] );
  printf("\n");
  return 0;
}


inline int compare( const void *A, const void *B )
{
  data_t *a = (data_t*)A;
  data_t *b = (data_t*)B;

  double diff = a->data[HOT] - b->data[HOT];
  return ( (diff > 0) - (diff < 0) );
}

inline int compare_ge( const void *A, const void *B )
{
  data_t *a = (data_t*)A;
  data_t *b = (data_t*)B;

  return (a->data[HOT] >= b->data[HOT]);
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
