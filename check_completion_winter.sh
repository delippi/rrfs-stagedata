#!/bin/bash

# Function to display the script's usage/help information
display_help() {
  echo "Usage: ./${0}.sh [OPTIONS]"
  echo "Options:"
  echo "  -n    no pause between output"
  echo "  -u    upload to rzdm"
#  echo "  -s    start date"
#  echo "  -e    end date"
  echo "  -h    Display this help message"
}

pause="YES"
upload="NO"
while getopts ":nuseh" opt; do
  case $opt in
    n)
      echo "Option -n is set: no pause."
      pause="NO"
      ;;
    u)
      echo "Option -u is set: upload."
      upload="YES"
      ;;
#    s)
#      echo "Option -s is set: start date $OPTARG."
#      spdy=$OPTARG
#      ;;
#    e)
#      echo "Option -e is set: end date $OPTARG."
#      epdy=$OPTARG
#      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      # Handle invalid options
      ;;
  esac
done

stat="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata-scripts/status"

spdy=20220211; epdy=20220214; retro="winter"  # winter 2022 retro period 

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
#check_RAVE="NO"              # check RAVE;
#check_satFED="NO"            # check sat (fed-lightning);

if [[ $retro == "summer" ]]; then
  dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "winter" ]]; then
  #dataloc="/lfs/h2/emc/da/noscrub/donald.e.lippi/rrfs-stagedata"
  dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "spring" ]]; then
  dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
fi

mkdir -p $stat
cd $dataloc
pdy=$spdy
while [[ $pdy -le $epdy ]]; do
echo """`date` from `hostname`
script:
  `pwd`/$0
data:
  $dataloc
""" > ${stat}/status.$pdy

  echo `doy $pdy` | tee -a ${stat}/status.$pdy
  doy=`doy $pdy | cut -f 4 -d " "`
  doy=$(printf "%03d" $doy)
  yy=`echo $pdy | cut -c 3-4`
  yyyy=`echo $pdy | cut -c 1-4`

  # check enkf/atm
  if [[ $check_enkf == "YES" ]]; then
    dir="enkf/atm/enkfgdas.${pdy}"
    mkdir -p $dir
    num=`find $dir -name *nc | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 560 ))  # 80 ensemble members x 4 synoptic times = 320/day
    echo "enkf/atm/      $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
                                  #atm +30 ensemble members x 4 synoptic times = 440/day
                                  #sfc +30 ensemble members x 4 synoptic times = 560/day
  fi

  # check gvf
  if [[ $check_gvf == "YES" ]]; then
    dir="gvf/grib2/"
    mkdir -p $dir
    num=`find $dir -name "*e$pdy*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 2 ))  # 2 files for each day
    echo "gvf/grib2/     $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check highres_sst
  if [[ $check_highres_sst == "YES" ]]; then
    dir="highres_sst/"
    mkdir -p $dir
    num=`find $dir -name "${yy}${doy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 1 )) # 1 file for each day
    echo "highres_sst/   $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check obs_rap
  if [[ $check_obs_rap == "YES" ]]; then
    dir="obs_rap/"
    mkdir -p $dir
    num=`find $dir -name "${pdy}*rap*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 1050 )) # ~1050 files for each day (give or take a few)
    echo "obs_rap/       $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check rap_hrrr_soil
  if [[ $check_rap_hrrr_soil == "YES" ]]; then
    dir="rap_hrrr_soil/$pdy/"
    mkdir -p $dir
    num=`find $dir -name "*wrf*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 2 ))  # 2 files for each day
    echo "rap_hrrr_soil/ $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check MRMS reflectivity
  if [[ $check_MRMS_reflectivity == "YES" ]]; then
    #num=`find reflectivity/MergedReflectivityQC_${pdy}* | wc`
    dir="reflectivity/upperair/mrms/conus/MergedReflectivityQC/"
    mkdir -p $dir
    num=`find $dir -name "*${pdy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 23760 ))  # 23760 files for each day
    echo "reflectivity/  $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check IMS snow
  if [[ $check_IMS_snow == "YES" ]]; then
    dir="snow/ims96/grib2/"
    mkdir -p $dir
    num=`find $dir -name "${yy}${doy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 1 ))  # 1 files for each day
    echo "snow/          $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check RAVE dust
  if [[ $check_RAVE == "YES" ]]; then
    dir="RAVE_RAW/"
    mkdir -p $dir
    #num=`find $dir -name "RAVE*s${pdy}*" | wc`
    num=`find $dir -name "RAVE*${pdy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 24 ))  # 1 files for each day
    echo "RAVE/          $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check sat FED lightning 
  if [[ $check_satFED == "YES" ]]; then
    dir="sat/nesdis/goes-east/glm/full-disk/"
    mkdir -p $dir
    num=`find $dir -name "*GLM*s${yyyy}${doy}*nc" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 240 ))  # 240 files for each day
    echo "satFED/        $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check gfs
  if [[ $check_gfs == "YES" ]]; then
    dir="gfs/0p25deg/grib2/"
    mkdir -p $dir
    num=`find $dir -name "${yy}${doy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 320 ))  # 320 files for each day
    echo "gfs/           $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
  fi

  # check GEFS
  if [[ $check_GEFS == "YES" ]]; then
    for mem in $(seq -w 1 30);  do
      dir="GEFS/dsg/gep$mem/"
      mkdir -p $dir
      num=`find $dir/. -name "${yy}${doy}*" | wc`
      num=`echo $num | cut -f 1 -d " "`
      (( percent = 100 * $num / 136 ))  # 1 files for each day
      #if [[ $num -ne 136 ]]; then
      echo "GEFS/dsg/gep$mem/    $pdy is completed: ${percent}% ($num)" | tee -a ${stat}/status.$pdy
      #fi
    done
  fi


  (( pdy = pdy + 1 ))
  echo ""
  if [[ $pause == "YES" ]]; then
    read -p "Continue to next day? (n)ext" ans
    if [[ $ans != "n" ]]; then # n=next
       exit
    fi
  fi
done

#read -p "upload to rzdm? (y/n)" ans
if [[ $upload == 'YES' ]]; then
   cd $stat
   ssh-keygen -R emcrzdm.ncep.noaa.gov -f /u/donald.e.lippi/.ssh/known_hosts
   rsync -a status* donald.lippi@emcrzdm.ncep.noaa.gov:/home/www/emc/htdocs/mmb/dlippi/rrfs_sciEval_stagedataStatus
fi

