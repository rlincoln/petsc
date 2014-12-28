PETSc Docker Image
==================

[Docker][docker] image for [PETSc][petsc], [TAO][tao] and [SLEPc][slepc].

Build
-----

To build the Docker image run:

    make

Usage
-----

Derive your image from `rlincoln/petsc` and use the environment variables:

    FROM rlincoln/petsc

    ADD petsc1.c /root/petsc1.c
    WORKDIR /root
    RUN gcc -g -v \
      -I/usr/lib/openmpi/include -I/usr/lib/openmpi/include/openmpi \
      -I$PETSC_DIR/include -I$PETSC_DIR/$PETSC_ARCH/include \
      -L/usr/lib -L$PETSC_DIR/$PETSC_ARCH/lib \
      petsc1.c -lpetsc -lmpi

    RUN mpirun -np 2 ./a.out

[docker]: https://www.docker.com/
[petsc]: http://www.mcs.anl.gov/petsc/
[tao]: http://www.mcs.anl.gov/research/projects/tao/
[slepc]: http://www.grycap.upv.es/slepc/

