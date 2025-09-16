## AWS Palace on the Quest HPC at Northwestern University

Our group has been approved to use the Quest HPC at Northwestern for AWS Palace simulations. 

I will add information here in the near future on: 
* How to use AWS Palace on Quest
* Any additional useful resources (HPC rules of thumb, Palace performance measurements, etc)
* How I installed Palace on Quest


# Appendix A: Installation Process 

Loaded in the following modules: 
* cmake/3.26.3-gcc-10.4.0
* gcc/11.2.0
* mpi/openmpi-4.1.7-gcc-10.4.0
* openblas/0.3.23-gcc-10.4.0
* python/3.9.16-gcc-10.4.0

Before starting the build process I also had to run: ```$export FC=mpif90``` because cmake wasn't finding the Fotran compiler on its own.

Cmake commands I ran:

```cmake ../palace_source -DCMAKE_INSTALL_PREFIX=../palace_install -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx -DPALACE_WITH_OPENMP=ON -DPALACE_WITH_CUDA=ON -DPALACE_WITH_GPU_AWARE_MPI=OFF -DBLA_VENDOR=OpenBLAS```

Notice I have enabled GPU usage (```PALACE_WITH_CUDA=ON```) and multi-threading (```PALACE_WITH_OPENMP=ON```). The hope is these will add a bit of a performance boost to lower computation time.

