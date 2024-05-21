#!/bin/sh

mkdir -p ./scripts0

# ==============================================================================
usage() {
  set +x
  echo
  echo "Usage: $0 -p <period> | -s <spdy> | -e <epdy> -h"
  echo
  echo "  -p  retro period <period>      DEFAULT: <none>"
  echo "  -s  retro start date <spdy>    DEFAULT: <none>"
  echo "  -e  retro end date <epdy>      DEFAULT: <none>"
  echo "  -m  run manually               DEFAULT: NO"
  echo "  -h  display this message and quit"
  exit 1
}

# ==============================================================================

retro=""
while getopts "p:s:e:h" opt; do
  case $opt in
    p)
      retro=$OPTARG
      ;;
    s)
      spdy=$OPTARG
      ;;
    e)
      epdy=$OPTARG
      ;;
    e)
      run_manually="NO"
      ;;
  esac
done

# Run manually
if [[ $retro == "" ]]; then
  echo "Running manually"
  retro="summer"
  #retro="winter"
  if [[ $retro == "summer" ]]; then
    spdy=20230719
    epdy=20230719
  elif [[ $retro == "winter" ]]; then
    spdy=20220210
    epdy=20220210
  fi
fi

YYYY=`echo $spdy | cut -c 1-4`
MM=`echo $spdy | cut -c 5-6`
D1=`echo $spdy | cut -c 7-8`
D2=`echo $epdy | cut -c 7-8`

if [[ $retro == "summer" ]]; then
  dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "winter" ]]; then
  dataloc="/lfs/h2/emc/da/noscrub/donald.e.lippi/rrfs-stagedata"
fi

mem_start=01; mem_end=30; mem_concurrent=2 # usually no more than 4 at a time.
#mem_start=01; mem_end=01; mem_concurrent=1 # usually no more than 4 at a time.
#mem_start=01; mem_end=30; mem_concurrent=1 # usually no more than 4 at a time.
#mem_start=23; mem_end=23; mem_concurrent=1 # usually no more than 4 at a time.
#mem_start=9; mem_end=9; mem_concurrent=1 # usually no more than 4 at a time.

echo "You are about to stage data for the period"
echo "  period: $retro"
echo "  starting: ${YYYY}${MM}${D1}"
echo "  ending: ${YYYY}${MM}${D2}"
echo "  in stage dir: $dataloc"
echo "  command: $cmd"
echo "---------------------------------------------------"
echo ""
read -p "Continue? (y/n) " ans
if [[ $ans != "y" ]]; then
  exit
fi


echo "cd scripts0"
for DD in $(seq -w $D1 $D2) ; do

  date=${YYYY}${MM}${DD}

  # Set filename0
  filename0=retrieve_dsg_GEFS.sh  # can usually do about 4-5 members in 6h

  memid1=$mem_start
  while [[ $memid1 -le $mem_end ]]; do
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
