#!/bin/bash

export OMP_NUM_THREADS=12
#export MP_STACKSIZE=8G

pgf90 -mp -O3 -o FSS_omp.exe fss.f90
./FSS_omp.exe
