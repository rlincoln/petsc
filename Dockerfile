FROM debian:stable

MAINTAINER Richard Lincoln, r.w.lincoln@gmail.com

# Select the latest stable releases of PETSc, SLEPc and TAO.
#
# http://www.mcs.anl.gov/petsc/download/
# http://www.mcs.anl.gov/research/projects/tao/download/
# http://www.grycap.upv.es/slepc/download/
ENV PETSC_VERSION 3.4.5
ENV TAO_VERSION 2.2.2
ENV SLEPC_VERSION 3.4.4

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

# Configure and build PETSc.
RUN ./configure
#  --with-mpi=0 \
#  --with-debugging=0 \
#  --with-threadcomm --with-pthreadclasses \
#  --download-superlu \
#  --with-64-bit-indices
RUN make all
RUN make test


# Download and extract TAO.
WORKDIR /opt
RUN wget --no-verbose http://www.mcs.anl.gov/research/projects/tao/download/tao-$TAO_VERSION.tar.gz
RUN gunzip -c tao-$TAO_VERSION.tar.gz | tar -xof -

ENV TAO_DIR /opt/tao-$TAO_VERSION

# Build and test TAO.
WORKDIR $TAO_DIR
RUN make all
RUN make tao_testexamples


# Download and extract SLEPc.
WORKDIR /opt
RUN wget --no-verbose http://www.grycap.upv.es/slepc/download/distrib/slepc-$SLEPC_VERSION.tar.gz
RUN gunzip -c slepc-$SLEPC_VERSION.tar.gz | tar -xof -

ENV SLEPC_DIR /opt/slepc-$SLEPC_VERSION

WORKDIR $SLEPC_DIR

# Configure and build SLEPc.
RUN ./configure
RUN make all
RUN make test


# Add the newly compiled libraries to the environment.
ENV LD_LIBRARY_PATH $PETSC_DIR/$PETSC_ARCH/lib:$TAO_DIR/$PETSC_ARCH/lib:$SLEPC_DIR/$PETSC_ARCH/lib
ENV PKG_CONFIG_PATH $PETSC_DIR/$PETSC_ARCH/lib/pkgconfig:$SLEPC_DIR/$PETSC_ARCH/lib/pkgconfig

