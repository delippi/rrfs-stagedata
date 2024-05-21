#!/bin/sh

#retro="winter"
retro="summer"

if [[ $retro == "summer" ]]; then
  YYYY=2023
  MM=07
  D1=19
  D2=20
elif [[ $retro == "winter" ]]; then
  YYYY=2022
  MM=02
  D1=10
  D2=10
fi

spdy=${YYYY}${MM}${D1}
epdy=${YYYY}${MM}${D2}

set -x
bash ./run0.sh -p $retro -s $spdy -e $epdy
bash ./run1.sh -p $retro -s $spdy -e $epdy
bash ./run2.sh -p $retro -s $spdy -e $epdy
