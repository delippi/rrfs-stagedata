#!/bin/sh

mkdir -p ./scripts1

#set -ax

#YYYY=2023; MM=07; D1=04; D2=11 # summer
YYYY=2022; MM=02; D1=01; D2=01 # winter
dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"


filenames0=""
filenames0="$filenames0 getFV3GDASensembles"
filenames0="$filenames0 getFV3GDASensembles_fh6"
filenames0="$filenames0 gfs.ksh"
#filenames0="$filenames0 refl.ksh"

echo "cd scripts1"
#for DD in $(seq -w 04 11) ; do
for DD in $(seq -w $D1 $D2) ; do

  date=${YYYY}${MM}${DD}

  for filename0 in $filenames0; do
    # Generic copy and sed commands
    filename1=${filename0}_${date}
    if [[ $filename0 == "retrieve_dsg_GEFS.sh" ]]; then
      filename1=${filename0}_${date}_mem${mem_start}-mem${mem_end}
    fi
    cp templates1/${filename0}            ./scripts1/${filename1}
    sed -i "s/@YYYY@/${YYYY}/g"           ./scripts1/${filename1}
    sed -i "s/@MM@/${MM}/g"               ./scripts1/${filename1}
    sed -i "s/@DD@/${DD}/g"               ./scripts1/${filename1}
    sed -i "s/@mem_start@/${mem_start}/g" ./scripts1/${filename1}
    sed -i "s/@mem_end@/${mem_end}/g"     ./scripts1/${filename1}
    sed -i "s#@DATALOC@#${dataloc}#g"     ./scripts1/${filename1}
    echo "qsub ${filename1}"
  done
done
echo "cd .."
