#!/bin/sh

#retro="winter"
#retro="summer"
retro="spring"

if [[ $retro == "summer" ]]; then
  YYYY=2023
  MM=07
  D1=30
  D2=31
  #D2=$D1
elif [[ $retro == "winter" ]]; then
  YYYY=2022
  MM=02
  D1=27
  D2=28
  #D2=$D1
elif [[ $retro == "spring" ]]; then
  YYYY=2023
  MM=06
  D1=30
  D2=30
  #D2=$D1
  #YYYY=2024
  #MM=05
  #D1=05
  #D2=07
fi

spdy=${YYYY}${MM}${D1}
epdy=${YYYY}${MM}${D2}

set -x
bash ./run0.sh -p $retro -s $spdy -e $epdy
bash ./run1.sh -p $retro -s $spdy -e $epdy
bash ./run2.sh -p $retro -s $spdy -e $epdy
