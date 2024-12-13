#!/bin/sh

# ==============================================================================
usage() {
  set +x
  echo
  echo "Usage: $0 -p <period> | -s <spdy> | -e <epdy> -h"
  echo
  echo "  -p  retro period <period>      DEFAULT: <none>"
  echo "  -s  retro start date <spdy>    DEFAULT: <none>"
  echo "  -e  retro end date <epdy>      DEFAULT: <none>"
  echo "  -d  location for staged data   DEFAULT: <none>"
  echo "  -h  display this message and quit"
  exit 1
}

# ==============================================================================

retro=""
while getopts "p:s:e:d:h" opt; do
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
    d)
      dataloc=$OPTARG
      ;;
  esac
done

mkdir -p ./scripts2_${retro}

YYYY=`echo $spdy | cut -c 1-4`
MM=`echo $spdy | cut -c 5-6`
D1=`echo $spdy | cut -c 7-8`
D2=`echo $epdy | cut -c 7-8`

#if [[ $retro == "summer" ]]; then
#  #dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
#  #dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
#  dataloc="/lfs/h3/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
#elif [[ $retro == "winter" ]]; then
#  #dataloc="/lfs/h2/emc/da/noscrub/donald.e.lippi/rrfs-stagedata" #old location
#  #dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
#  dataloc="/lfs/h3/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
#elif [[ $retro == "spring" ]]; then
#  #dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
#  dataloc="/lfs/h3/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
#fi


filenames0=""
filenames0="$filenames0 get_raphrrrsoil.ksh"
filenames0="$filenames0 gvf.ksh"
filenames0="$filenames0 lightning.ksh"
filenames0="$filenames0 obsrap.ksh"
filenames0="$filenames0 snow.ksh"
filenames0="$filenames0 sst.ksh"
filenames0="$filenames0 fed_fulldisk.ksh"
filenames0="$filenames0 rave.ksh"

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


echo "cd scripts2_${retro}"
#for DD in $(seq -w 04 11) ; do
for DD in $(seq -w $D1 $D2) ; do

  date=${YYYY}${MM}${DD}

  for filename0 in $filenames0; do
    # Generic copy and sed commands
    filename1=${filename0}_${date}
    cp templates2/$filename0 ./scripts2_${retro}/$filename1
    sed -i "s/@YYYY@/${YYYY}/g"       ./scripts2_${retro}/$filename1
    sed -i "s/@MM@/${MM}/g"           ./scripts2_${retro}/$filename1
    sed -i "s/@DD@/${DD}/g"       ./scripts2_${retro}/$filename1
    sed -i "s#@DATALOC@#${dataloc}#g" ./scripts2_${retro}/$filename1
    echo "qsub ${filename1}"
  done
done
echo "cd .."
