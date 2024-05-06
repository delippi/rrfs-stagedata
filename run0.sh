#!/bin/sh

mkdir -p ./scripts0

#set -ax

#YYYY=2023; MM=07; D1=04; D2=11 # summer
YYYY=2022; MM=02; D1=01; D2=01 # winter
dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"

# For dsg GEFS
#mem_start=01; mem_end=04
#mem_start=05; mem_end=08
#mem_start=09; mem_end=12
#mem_start=13; mem_end=16
#mem_start=17; mem_end=20
#mem_start=21; mem_end=24
#mem_start=25; mem_end=27
#mem_start=28; mem_end=30

#DD="05"; mem_start=01 ; mem_end=30
#DD="06"; mem_start=01 ; mem_end=30

mem_start=01; mem_end=30; mem_concurrent=3 # usually no more than 4 at a time.

echo "cd scripts0"
#for DD in $(seq -w 04 11) ; do
#for DD in $(seq -w 08 11) ; do
#for DD in $(seq -w 05 06) ; do
for DD in $(seq -w $D1 $D2) ; do

  date=${YYYY}${MM}${DD}

  # Set filename0
  filename0=retrieve_dsg_GEFS.sh  # can usually do about 4-5 members in 6h

  memid1=$mem_start
  while [[ $memid1 -lt $mem_end ]]; do
    (( memid2 = $memid1 + $mem_concurrent - 1 ))
    if [[ $memid2 -ge 30 ]]; then
      memid2=30
    fi
    memid_str1=$(printf "%02d" $memid1)
    memid_str2=$(printf "%02d" $memid2)
    # Generic copy and sed commands
    filename1=${filename0}_${date}
    if [[ $filename0 == "retrieve_dsg_GEFS.sh" ]]; then
      filename1=${filename0}_${date}_mem${memid_str1}-mem${memid_str2}
    fi
    cp templates0/${filename0}            ./scripts0/${filename1}
    sed -i "s/@YYYY@/${YYYY}/g"           ./scripts0/${filename1}
    sed -i "s/@MM@/${MM}/g"               ./scripts0/${filename1}
    sed -i "s/@DD@/${DD}/g"               ./scripts0/${filename1}
    sed -i "s/@mem_a@/${memid_str1}/g"    ./scripts0/${filename1}
    sed -i "s/@mem_b@/${memid_str2}/g"    ./scripts0/${filename1}
    sed -i "s#@DATALOC@#${dataloc}#g"     ./scripts0/${filename1}
    echo "qsub ${filename1}"
    (( memid1 = $memid1 + $mem_concurrent ))
  done
done
echo "cd .."
