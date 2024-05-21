#!/bin/sh

export ndate="/u/donald.e.lippi/bin/ndate"
mkdir -p ./scripts2

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

sdate=${YYYY}${MM}${D1}00
edate=${YYYY}${MM}${D2}00

tasks=""
tasks="$tasks get_raphrrrsoil.ksh"
tasks="$tasks gvf.ksh"
tasks="$tasks lightning.ksh"
tasks="$tasks obsrap.ksh"
tasks="$tasks snow.ksh"
tasks="$tasks sst.ksh"
tasks="$tasks fed_fulldisk.ksh"
tasks="$tasks rave.ksh"
#tasks=""
#tasks="$tasks fed_fulldisk.ksh"
#tasks="$tasks rave.ksh"

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

# create date list string like "01 02 03 04 05 06 07"
DLIST=""
date=$sdate
while [[ $date -le $edate ]]; do
  DD=`echo $date | cut -c 7-8`
  DLIST="$DLIST $DD"
  date=`ndate 24 $date`
done

YYYY=`echo $sdate | cut -c 1-4`
MM=`echo $sdate | cut -c 5-6`
SDAY=`echo $sdate | cut -c 7-8`
EDAY=`echo $edate | cut -c 7-8`

echo "cd scripts2"
for task in $tasks; do
  cp templates2/$task ./scripts2/$task
  sed -i "s/@YYYY@/${YYYY}/g"       ./scripts2/$task
  sed -i "s/@MM@/${MM}/g"           ./scripts2/$task
  sed -i "s/@DLIST@/${DLIST}/g"     ./scripts2/$task
  sed -i "s/@SDAY@/${SDAY}/g"       ./scripts2/$task
  sed -i "s/@EDAY@/${EDAY}/g"       ./scripts2/$task
  sed -i "s#@DATALOC@#${dataloc}#g" ./scripts2/$task

  echo "qsub $task"
done
