#!/bin/sh

retro="winter"
#retro="summer"
#retro="spring"

if [[ $retro == "summer" ]]; then
  dataloc="/lfs/h3/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
  YYYY=2023
  MM=07
  D1=23
  D2=23
elif [[ $retro == "winter" ]]; then
  dataloc="/lfs/h3/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
  YYYY=2024
  MM=02
  D1=06
  D2=08
elif [[ $retro == "spring" ]]; then
  dataloc="/lfs/h3/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
  dataloc="/lfs/h3/emc/lam/noscrub/emc.lam/rrfs-stagedata"
  YYYY=2024
  MM=05
  D1=10
  D2=10
fi

spdy=${YYYY}${MM}${D1}
epdy=${YYYY}${MM}${D2}

set -x
bash ./run0.sh -p $retro -s $spdy -e $epdy -d $dataloc
bash ./run1.sh -p $retro -s $spdy -e $epdy -d $dataloc
bash ./run2.sh -p $retro -s $spdy -e $epdy -d $dataloc
