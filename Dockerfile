FROM debian:stable

MAINTAINER Richard Lincoln, r.w.lincoln@gmail.com

# Select the latest stable release of PETSc.
#
# http://www.mcs.anl.gov/petsc/download/
ENV PETSC_VERSION 3.5.2

RUN apt-get update

# Install compiler tools.
RUN apt-get install -y make gcc gfortran wget python pkg-config

# PETSc requires BLAS, LAPACK and MPI.
RUN apt-get install -y libblas-dev liblapack-dev libopenmpi-dev openmpi-bin openssh-client

# Download and extract PETSc.
WORKDIR /opt
RUN wget --no-verbose http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-$PETSC_VERSION.tar.gz
RUN gunzip -c petsc-lite-$PETSC_VERSION.tar.gz | tar -xof -

ENV PETSC_DIR /opt/petsc-$PETSC_VERSION
ENV PETSC_ARCH arch-linux2-c-debug

WORKDIR $PETSC_DIR

# https://github.com/dotcloud/docker/issues/2637
#WORKDIR /opt/petsc-3.4.4

# Configure and build PETSc.
RUN ./configure
#  --with-mpi=0 \
#  --with-debugging=0 \
#  --with-threadcomm --with-pthreadclasses \
#  --download-superlu \
#  --with-64-bit-indices
RUN make all
RUN make test

# Add the newly compiled libraries to the environment.
ENV LD_LIBRARY_PATH $PETSC_DIR/$PETSC_ARCH/lib
ENV PKG_CONFIG_PATH $PETSC_DIR/$PETSC_ARCH/lib/pkgconfig

