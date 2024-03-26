#!/bin/ksh

set -ax

YYYY=2023
MM=06
mem_start=15; mem_end=19
mem_start=20; mem_end=23
mem_start=24; mem_end=27
mem_start=28; mem_end=30

for DD in $(seq -w 09 18) ; do

  date=${YYYY}${MM}${DD}

  # Set filename0
  #filename0=getFV3GDASensembles
  #filename0=getFV3GDASensembles_fh6
  #filename0=refl.ksh
  #filename0=retrieve_dsg_GEFS.sh  # can usually do about 4-5 members in 6h
  filename0=gfs.ksh

  # Generic copy and sed commands
  filename1=${filename0}_$date
  cp templates/${filename0} ./scripts/${filename1}
  sed -i "s/@YYYY@/${YYYY}/g" ./scripts/${filename1}
  sed -i "s/@MM@/${MM}/g"     ./scripts/${filename1}
  sed -i "s/@DD@/${DD}/g"     ./scripts/${filename1}
  sed -i "s/@mem_start@/${mem_start}/g" ./scripts/${filename1}
  sed -i "s/@mem_end@/${mem_end}/g"     ./scripts/${filename1}

done
