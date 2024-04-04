#!/bin/sh

mkdir -p ./scripts1

#set -ax

YYYY=2023
MM=07

# For dsg GEFS
mem_start=01; mem_end=04
mem_start=05; mem_end=08
mem_start=09; mem_end=12
mem_start=13; mem_end=16
mem_start=17; mem_end=20
mem_start=21; mem_end=24
#mem_start=25; mem_end=28
#mem_start=29; mem_end=30

echo "cd scripts1"
for DD in $(seq -w 01 07) ; do

  date=${YYYY}${MM}${DD}

  # Set filename0

  #Need to Run

  # Running
  #filename0=retrieve_dsg_GEFS.sh  # can usually do about 4-5 members in 6h
  #filename0=getFV3GDASensembles
  filename0=refl.ksh

  # Done
  #filename0=getFV3GDASensembles_fh6
  #filename0=gfs.ksh

  # Generic copy and sed commands
  filename1=${filename0}_${date}
  if [[ $filename0 == "retrieve_dsg_GEFS.sh" ]]; then
    filename1=${filename0}_${date}_mem${mem_start}-mem${mem_end}
  fi
  cp templates1/${filename0} ./scripts1/${filename1}
  sed -i "s/@YYYY@/${YYYY}/g" ./scripts1/${filename1}
  sed -i "s/@MM@/${MM}/g"     ./scripts1/${filename1}
  sed -i "s/@DD@/${DD}/g"     ./scripts1/${filename1}
  sed -i "s/@mem_start@/${mem_start}/g" ./scripts1/${filename1}
  sed -i "s/@mem_end@/${mem_end}/g"     ./scripts1/${filename1}
  echo "qsub ${filename1}"
done
