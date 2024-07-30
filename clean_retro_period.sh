#!/bin/bash
export doy="/u/donald.e.lippi/bin/doy"
export ndate="/u/donald.e.lippi/bin/ndate"

##################
#retro="winter"
#retro="summer"
retro="spring"

if [[ $retro == "summer" ]]; then
  spdy=20230730
  epdy=20230730
  #epdy=$spdy
  dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "winter" ]]; then
  spdy=20220221
  epdy=20220222
  #epdy=$spdy
  dataloc="/lfs/h2/emc/da/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "spring" ]]; then
  spdy=20230628
  epdy=20230628
  dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
fi

#cmd="rm -rf"
#cmd="du -msch"
##################

echo "You are about to clean up retro data for the period"
echo "  period: $retro"
echo "  starting: $spdy"
echo "  ending: $epdy"
echo "  in stage dir: $dataloc"
echo "  command: $cmd"
echo "---------------------------------------------------"
echo ""
read -p "Continue? (y/n) " ans
if [[ $ans != "y" ]]; then
  exit
fi
read -p "Delete or inventory? (d/i) " ans
if [[ $ans == "i" ]]; then
  cmd="du -msch"
elif [[ $ans == "d" ]]; then
  cmd="rm -rf"
else
  echo "invalid command. exiting..."
  exit
fi




# get the day of year
#sdoy=`doy $spdy | awk '{print $4}'`
#edoy=`doy $epdy | awk '{print $4}'`

pdy=$spdy

while [[ $pdy -le $epdy ]]; do
  dayOfYear=`doy $pdy | awk '{print $4}'`
  echo "current date: $pdy @ $dayOfYear"
  yy=`echo $pdy | cut -c 3-4`

  cd $dataloc
  #enkf
  echo " - purging enkf data"
  ${cmd} enkf/atm/${yy}${dayOfYear}*atm*nc
  ${cmd} enkf/atm/${yy}${dayOfYear}*sfc*nc
  ${cmd} enkf/atm/${dir}/enkfgdas.${pdy}
  #GEFS
  echo " - purging GEFS data"
  ${cmd} GEFS/dsg/gep*/${yy}${dayOfYear}*00*
  #gfs
  echo " - purging gfs data"
  ${cmd} gfs/0p25deg/grib2/${yy}${dayOfYear}*
  #obs rap
  echo " - purging RAP obs"
  ${cmd} obs_rap/${pdy}*rap*
  ${cmd} obs_rap/${pdy}*rtma*
  #gvf
  echo " - purging gvf"
  ${cmd} gvf/grib2/*_e${pdy}*.grib2
  #highres_sst
  echo " - purging sst"
  ${cmd} highres_sst/${yy}${dayOfYear}*00*
  #rap_hrrr_soil
  echo " - purging soil"
  ${cmd} rap_hrrr_soil/${pdy}
  #reflectivity
  echo " - purging dbz"
  ${cmd} reflectivity/upperair/mrms/conus/MergedReflectivityQC/*${pdy}*grib2
  #snow
  echo " - purging snow"
  ${cmd} snow/ims96/grib2/${yy}${dayOfYear}*00*

  # update pdy
  date=`ndate 24 ${pdy}00`
  pdy=`echo $date | cut -c 1-8`
done






