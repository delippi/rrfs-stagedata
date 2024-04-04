#!/bin/bash
export doy="/u/donald.e.lippi/bin/doy"
export ndate="/u/donald.e.lippi/bin/ndate"

##################
spdy=20230826
epdy=20230831
dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/trash/rrfs-stagedata.trash"
##################

echo "You are about to clean up retro data for the period"
echo "  starting: $spdy"
echo "  ending: $epdy"
echo "---------------------------------------------------"
echo ""
read -p "Continue? (y/n) " ans
if [[ $ans != "y" ]]; then
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
  rm -rf enkf/atm/${yy}${dayOfYear}*atm*nc
  rm -rf enkf/atm/${dir}/enkfgdas.${pdy}
  #GEFS
  echo " - purging GEFS data"
  rm -rf GEFS/dsg/gep*/${yy}${dayOfYear}*00*
  #obs rap
  echo " - purging RAP obs"
  rm -rf obs_rap/${pdy}*rap*
  #gvf
  echo " - purging gvf"
  rm -rf gvf/grib2/*_e${pdy}*.grib2
  #highres_sst
  echo " - purging sst"
  rm -rf highres_sst/${yy}${dayOfYear}*00*
  #rap_hrrr_soil
  echo " - purging soil"
  rm -rf rap_hrrr_soil/${pdy}
  #reflectivity
  echo " - purging dbz"
  rm -rf reflectivity/upperair/mrms/conus/MergedReflectivityQC/*${pdy}*grib2
  #snow
  echo " - purging snow"
  rm -rf snow/ims96/grib2/${yy}${dayOfYear}*00*

  # update pdy
  date=`ndate 24 ${pdy}00`
  pdy=`echo $date | cut -c 1-8`
done






