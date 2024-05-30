#!/bin/sh

mkdir -p ./scripts1

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
elif [[ $retro == "spring" ]]; then
  dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
fi


filenames0=""
filenames0="$filenames0 getFV3GDASensembles"
filenames0="$filenames0 getFV3GDASensembles_fh6"
filenames0="$filenames0 gfs.ksh"
filenames0="$filenames0 refl.ksh"


echo "You are about to stage data for the period"
echo "  period: $retro"
echo "  starting: ${YYYY}${MM}${D1}"
echo "  ending: ${YYYY}${MM}${D2}"
echo "  in stage dir: $dataloc"
echo "---------------------------------------------------"
echo ""
read -p "Continue? (y/n) " ans
if [[ $ans != "y" ]]; then
  exit
fi


echo "cd scripts1"
#for DD in $(seq -w 04 11) ; do
for DD in $(seq -w $D1 $D2) ; do

  date=${YYYY}${MM}${DD}

  for filename0 in $filenames0; do
    # Generic copy and sed commands
    filename1=${filename0}_${date}
    cp templates1/${filename0}            ./scripts1/${filename1}
    sed -i "s/@YYYY@/${YYYY}/g"           ./scripts1/${filename1}
    sed -i "s/@MM@/${MM}/g"               ./scripts1/${filename1}
    sed -i "s/@DD@/${DD}/g"               ./scripts1/${filename1}
    sed -i "s#@DATALOC@#${dataloc}#g"     ./scripts1/${filename1}
    echo "qsub ${filename1}"
  done
done
echo "cd .."
