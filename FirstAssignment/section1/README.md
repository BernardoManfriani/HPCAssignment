# Section 1

To compile files of __section1__ it is necessary to load the __openmpi__. With the following code compiles `ring/ringNonBlocking.c`  and  `matrix/3Datrix.c`.

```bash
  module load openmpi-4.1.1+gnu-9.3.0
  make
```
---

### Ring

The `ringNonBlocking.c` use a non blocking solution. The `ringScript.sh` run the code taking taking the outputs and puts them in `ring_non_blocking_x_procc` and times in `results.csv`. This is done for all configurations from 2 to 48 cores.
```bash
for x in {2..48}
do
  mpirun --map-by core -np $x --mca btl ^openib ./ringNonBlock.x > ring_non_blocking_${x}_procc
done
```
---
### Matrix addition
