# Section 1

To compile files of __section1__ it is necessary to load the __openmpi__. With the following code compiles `ring/ring.c`  and  `matrix/3Datrix.c`.

```bash
  module load openmpi-4.1.1+gnu-9.3.0
  make
```
---

### Ring `section1/ring/`

The `ring.c` use a non blocking solution. The `ringScript.sh` run the code taking taking the outputs and puts them in `ring_x_procc` and times in `results.csv`. This is done for all configurations from 2 to 48 cores.

```bash
for x in {2..48}
do
  mpirun --map-by core -np $x --mca btl ^openib ./ring.x > ring${x}_procc
done
```
---
### Matrix addition `section1/matrix/`

The `sum3Dmstrix` is compiled in make file. The `matrixScript.sh` run the code taking the outputs and puts them in `matrix_time_x` where x is 2400, 1200 or 800.

```bash
mpirun -np 24 -mca btl ^openib ./matrix 2400 100 100 > matrix_time_2400
mpirun -np 24 -mca btl ^openib ./matrix 1200 200 100 > matrix_time_1200
mpirun -np 24 -mca btl ^openib ./matrix 800 300 100 > matrix_time_800
```
