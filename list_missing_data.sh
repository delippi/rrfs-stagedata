#!/bin/bash

# Function to display the script's usage/help information
display_help() {
  echo "Usage: ./${0}.sh [OPTIONS]"
  echo "Options:"
  echo "  -u    upload to rzdm"
  echo "  -h    Display this help message"
}

pause="YES"
upload="NO"
while getopts ":uh" opt; do
  case $opt in
    u)
      echo "Option -u is set: upload."
      upload="YES"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      # Handle invalid options
      ;;
  esac
done

# Define a good date without missing data to compare against any date.
goodDate=20230704
spdy=20230704; epdy=20230711; retro="summer"  # summer 2023 retro period
#spdy=20230705; epdy=20230705  # summer 2023 retro period

# Define data directory
if [[ $retro == "summer" ]]; then
  dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "winter" ]]; then
  dataloc="/lfs/h2/emc/da/noscrub/donald.e.lippi/rrfs-stagedata"
fi
scriptsloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata-scripts"

# Define missing data location
missing="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata-scripts/missing"
list="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata-scripts/missing/list"

check_gvf="YES"               # check gvf; gvf.ksh
check_highres_sst="YES"       # check highres_sst; sst.ksh
check_obs_rap="YES"           # check obs_rap; obsrap.ksh
check_rap_hrrr_soil="YES"     # check rap_hrrr_soil; get_raphrrrsoil.ksh
check_IMS_snow="YES"          # check IMS snow; snow.ksh
check_enkf="YES"              # check enkf/atm; getFV3GDASensembles
check_MRMS_reflectivity="YES" # check MRMS reflectivity; refl.ksh
check_gfs="YES"              # check gvf; gvf.ksh
check_GEFS="YES"              # check GEFS; retrieve_dsg_GEFS.sh
check_RAVE="YES"              # check RAVE;
check_satFED="YES"            # check sat (fed-lightning);

#check_gvf="NO"               # check gvf; gvf.ksh
#check_highres_sst="NO"       # check highres_sst; sst.ksh
#check_obs_rap="NO"           # check obs_rap; obsrap.ksh
#check_rap_hrrr_soil="NO"     # check rap_hrrr_soil; get_raphrrrsoil.ksh
#check_IMS_snow="NO"          # check IMS snow; snow.ksh
#check_enkf="NO"              # check enkf/atm; getFV3GDASensembles
#check_MRMS_reflectivity="NO" # check MRMS reflectivity; refl.ksh
#check_gfs="NO"               # check gvf; gvf.ksh
#check_GEFS="NO"              # check GEFS; retrieve_dsg_GEFS.sh
check_RAVE="NO"              # check RAVE;
#check_satFED="NO"            # check sat (fed-lightning);

mkdir -p $list
cd $dataloc
pdy=$spdy
good_pdy=$goodDate
while [[ $pdy -le $epdy ]]; do
  cd $dataloc
  echo $pdy
  doy=`doy $pdy | cut -f 4 -d " "`
  yy=`echo $pdy | cut -c 3-4`
  yyyy=`echo $pdy | cut -c 1-4`

  good_doy=`doy $good_pdy | cut -f 4 -d " "`
  good_yy=`echo $good_pdy | cut -c 3-4`
  good_yyyy=`echo $good_pdy | cut -c 1-4`


  if [[ $check_gvf == "YES" ]]; then
    dir="gvf/grib2/"
    mkdir -p $dir
    filename1=${list}/${dir//\//_}good.txt
    filename2=${list}/${dir//\//_}${pdy}.txt
    filename3=${missing}/${dir//\//_}${pdy}_missing.txt
    ls -1 $dir/*e${good_pdy}* > $filename1
    ls -1 $dir/*e${pdy}* > $filename2
    sed -i "s/${good_pdy}/\${pdy}/g" $filename1
    sed -i "s/${pdy}/\${pdy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  if [[ $check_highres_sst == "YES" ]]; then
    dir="highres_sst/"
    mkdir -p $dir
    filename1=${list}/${dir//\//_}good.txt
    filename2=${list}/${dir//\//_}${pdy}.txt
    filename3=${missing}/${dir//\//_}${pdy}_missing.txt
    ls -1 $dir/${good_yy}${good_doy}* > $filename1
    ls -1 $dir/${yy}${doy}* > $filename2
    sed -i "s/${good_yy}${good_doy}/\${yy}\${doy}/g" $filename1
    sed -i "s/${yy}${doy}/\${yy}\${doy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  if [[ $check_obs_rap == "YES" ]]; then
    dir="obs_rap/"
    mkdir -p $dir
    filename1=${list}/${dir//\//_}good.txt
    filename2=${list}/${dir//\//_}${pdy}.txt
    filename3=${missing}/${dir//\//_}${pdy}_missing.txt
    ls -1 $dir/${good_pdy}*rap* > $filename1
    ls -1 $dir/${pdy}*rap* > $filename2
    sed -i "s/${good_pdy}/\${pdy}/g" $filename1
    sed -i "s/${pdy}/\${pdy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  if [[ $check_rap_hrrr_soil == "YES" ]]; then
    dir1="rap_hrrr_soil/$good_pdy/"
    dir2="rap_hrrr_soil/$pdy/"
    mkdir -p $dir2
    filename1=${list}/${dir1//\//_}good.txt
    filename2=${list}/${dir2//\//_}.txt
    filename3=${missing}/${dir2//\//_}missing.txt
    ls -1 $dir1/*wrf* > $filename1
    ls -1 $dir2/*wrf* > $filename2
    sed -i "s/${good_pdy}/\${pdy}/g" $filename1
    sed -i "s/${pdy}/\${pdy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  if [[ $check_IMS_snow == "YES" ]]; then
    dir="snow/ims96/grib2/"
    mkdir -p $dir
    filename1=${list}/${dir//\//_}good.txt
    filename2=${list}/${dir//\//_}${pdy}.txt
    filename3=${missing}/${dir//\//_}${pdy}_missing.txt
    ls -1 $dir/${good_yy}${good_doy}* > $filename1
    ls -1 $dir/${yy}${doy}* > $filename2
    sed -i "s/${good_yy}${good_doy}/\${yy}\${doy}/g" $filename1
    sed -i "s/${yy}${doy}/\${yy}\${doy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  if [[ $check_enkf == "YES" ]]; then
    dir1="enkf/atm/enkfgdas.${good_pdy}"
    dir2="enkf/atm/enkfgdas.${pdy}"
    mkdir -p $dir2
    filename1=${list}/${dir1//\//_}good.txt
    filename2=${list}/${dir2//\//_}.txt
    filename3=${missing}/${dir2//\//_}missing.txt
    ls -1 $dir1/*/atmos/mem*/*nc > $filename1
    ls -1 $dir2/*/atmos/mem*/*nc > $filename2
    sed -i "s/${good_pdy}/\${pdy}/g" $filename1
    sed -i "s/${pdy}/\${pdy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi

  fi

  if [[ $check_MRMS_reflectivity == "YES" ]]; then
    dir="reflectivity/upperair/mrms/conus/MergedReflectivityQC/"
    mkdir -p $dir
    filename1=${list}/${dir//\//_}good.txt
    filename2=${list}/${dir//\//_}${pdy}_.txt
    filename3=${missing}/${dir//\//_}${pdy}_missing.txt
    ls -1 $dir/*${good_pdy}* > $filename1
    ls -1 $dir/*${pdy}* > $filename2
    sed -i "s/${good_pdy}/\${pdy}/g" $filename1
    sed -i "s/${pdy}/\${pdy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  if [[ $check_gfs == "YES" ]]; then
    dir="gfs/0p25deg/grib2/"
    mkdir -p $dir
    filename1=${list}/${dir//\//_}good.txt
    filename2=${list}/${dir//\//_}${pdy}.txt
    filename3=${missing}/${dir//\//_}${pdy}_missing.txt
    ls -1 $dir/${good_yy}${good_doy}* > $filename1
    ls -1 $dir/${yy}${doy}* > $filename2
    sed -i "s/${good_yy}${good_doy}/\${yy}\${doy}/g" $filename1
    sed -i "s/${yy}${doy}/\${yy}\${doy}/g" $filename2
    #echo "${yy}${doy}" > $filename3
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  if [[ $check_GEFS == "YES" ]]; then
    for mem in $(seq -w 01 30);  do
      dir="GEFS/dsg/gep$mem/"
      mkdir -p $dir
      filename1=${list}/${dir//\//_}good.txt
      filename2=${list}/${dir//\//_}${pdy}.txt
      filename3=${missing}/${dir//\//_}${pdy}_missing.txt
      ls -1 $dir/${good_yy}${good_doy}* > $filename1
      ls -1 $dir/${yy}${doy}* > $filename2
      sed -i "s/${good_yy}${good_doy}/\${yy}\${doy}/g" $filename1
      sed -i "s/${yy}${doy}/\${yy}\${doy}/g" $filename2
      #echo "${yy}${doy}" > $filename3
      comm -3 $filename1 $filename2 > $filename3
      # Delete an empty file (easier to find data that is missing)
      if [[ ! -s $filename3 ]]; then
        rm -f $filename3
      fi
    done
  fi

  if [[ $check_RAVE == "YES" ]]; then
    echo "skip RAVE... one file"
  fi

  if [[ $check_satFED == "YES" ]]; then
    dir="sat/nesdis/goes-east/glm/full-disk/"
    mkdir -p $dir
    filename1=${list}/${dir//\//_}good.txt
    filename2=${list}/${dir//\//_}${pdy}.txt
    filename3=${missing}/${dir//\//_}${pdy}_missing.txt
    ls -1 $dir/*GLM*s${good_yyyy}${good_doy}*nc > $filename1
    ls -1 $dir/*GLM*s${yyyy}${doy}*nc > $filename2
    sed -i "s/${good_yyyy}${good_doy}/\${yyyy}\${doy}/g" $filename1
    sed -i "s/${yyyy}${doy}/\${yyyy}\${doy}/g" $filename2
    comm -3 $filename1 $filename2 > $filename3
    # Delete an empty file (easier to find data that is missing)
    if [[ ! -s $filename3 ]]; then
      rm -f $filename3
    fi
  fi

  cd $missing
  mkdir -p $pdy
  mv *$pdy*missing*txt $pdy/.
  cp -p ../rzdm/* $pdy/.
  if [[ $upload == 'YES' ]]; then
     cd $missing
     ssh-keygen -R emcrzdm.ncep.noaa.gov -f /u/donald.e.lippi/.ssh/known_hosts
     rsync -a --delete $pdy donald.lippi@emcrzdm.ncep.noaa.gov:/home/www/emc/htdocs/mmb/dlippi/rrfs_sciEval_stagedataStatus/missing/.
fi
  (( pdy = pdy + 1 ))
done


