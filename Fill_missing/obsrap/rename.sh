#!/bin/bash

directory="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata-scripts/Fill_missing/obsrap/test"

cd $directory

rm -f $directory/*listing

#for dates in 20230606
#for dates in 20230706
#for dates in 20240510
#for dates in 20240518
#for dates in 20240528
for dates in 20240531
do
  #for hh in {0..11}
  #for hh in {0..5}
  for hh in {6..11}
  #for hh in {12..17}
  #for hh in {18..23}
  #for hh in {12..23}
  do
    hh=$( printf "%02d" $hh )

    for file in rap*t${hh}*
    do
      prefix="${dates}${hh}."
      if [[ -f "$file" ]]; then
        new_name="${prefix}${file}"
        echo $new_name
        mv "$file" "$new_name"
      fi
    done
  done
done
