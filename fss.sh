#!/bin/bash

export OMP_NUM_THREADS=12 #the core you want to use ; max = 12

pgf90 -mp -O3 -o FSS_omp.exe fss.f90
./FSS_omp.exe
