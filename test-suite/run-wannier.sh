#!/bin/bash
#
# Copyright (C) 2001-2016 Quantum ESPRESSO group
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License. See the file `License' in the root directory
# of the present distribution.
#
# Maintainer: Samuel Ponce

#include ${ESPRESSO_ROOT}/test-suite/ENVIRONMENT
#bash ../ENVIRONMENT

if [[ $QE_USE_MPI == 1 ]]; then
  export PARA_PREFIX="mpirun -np ${TESTCODE_NPROCS}"
  export PARA_SUFFIX="-npool ${TESTCODE_NPROCS}"
else
  unset PARA_PREFIX
  unset PARA_SUFFIX
fi

echo $0" "$@
if [[ "$1" == "1" ]]
then
  echo "Running Wannier90 ..."
  export TMP=$2
  export OUTPUT="${TMP%??}out"
  echo "${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x $2 $3 2> $4"
  ${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x $2 $3 2> $4
  cp $OUTPUT $3
  if [[ -e CRASH ]]
  then
    cat $3
  fi  
elif [[ "$1" == "2" ]]
then
  echo "Running PW ..."
  echo "${PARA_PREFIX} ${ESPRESSO_ROOT}/bin/pw.x < $2 > $3 2> $4"
  ${PARA_PREFIX} ${ESPRESSO_ROOT}/bin/pw.x < $2 > $3 2> $4
  if [[ -e CRASH ]]
  then
    cat $3
  fi
elif [[ "$1" == "3" ]]
then
  echo "Running pw2wannier90 ..."
  echo "${PARA_PREFIX} ${ESPRESSO_ROOT}/bin/pw2wannier90.x < $2 > $3 2> $4"  
  ${PARA_PREFIX} ${ESPRESSO_ROOT}/bin/pw2wannier90.x < $2 > $3 2> $4
  if [[ -e CRASH ]]
  then
    cat $3
  fi
elif [[ "$1" == "4" ]]
then
  echo "Running PP wannier ..."
  export TMP=$2
  export OUTPUT="${TMP%??}out"
  echo "${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x -pp $2 $3 2> $4"
  ${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x -pp $2 $3 2> $4
  cp $OUTPUT $3
  if [[ -e CRASH ]]
  then
    cat $3
  fi  
elif [[ "$1" == "5" ]]
then
  echo "Running PP wannier and checking for nnkp ..."
  export TMP=$2
  export OUTPUT="${TMP%???}nnkp"
  echo "${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x -pp $2 $3 2> $4"
  ${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x -pp $2 $3 2> $4
  cp $OUTPUT $3
  if [[ -e CRASH ]]
  then
    cat $3
  fi  
elif [[ "$1" == "6" ]]
then
  echo "Running PP wannier and checking for crash ..."
  export TMP=$2
  export OUTPUT="${TMP%???}werr"
  echo "${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x -pp $2 $3 2> $4"
  ${PARA_PREFIX} ${WANNIER_ROOT}/wannier90.x $2 $3 2> $4
  cp $OUTPUT $3
  if [[ -e CRASH ]]
  then
    cat $3
  fi  
fi

#rm -f input_tmp.in
