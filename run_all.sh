#!/bin/sh

retro="winter"
retro="summer"

if [[ $retro == "summer" ]]; then
  YYYY=2023
  MM=07
  D1=26
  D2=27
elif [[ $retro == "winter" ]]; then
  YYYY=2022
  MM=02
  D1=16
  #D2=13
  D2=$D1
fi

spdy=${YYYY}${MM}${D1}
epdy=${YYYY}${MM}${D2}

set -x
bash ./run0.sh -p $retro -s $spdy -e $epdy
bash ./run1.sh -p $retro -s $spdy -e $epdy
bash ./run2.sh -p $retro -s $spdy -e $epdy
