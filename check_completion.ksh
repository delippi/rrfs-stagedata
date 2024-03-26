#!/bin/ksh

spdy=20230610; epdy=20230618  # spring 2023 retro period

check_enkf="YES"              # check enkf/atm; getFV3GDASensembles
check_gvf="YES"               # check gvf; gvf.ksh
check_highres_sst="YES"       # check highres_sst; sst.ksh
check_obs_rap="YES"           # check obs_rap; obsrap.ksh
check_rap_hrrr_soil="YES"     # check rap_hrrr_soil; get_raphrrrsoil.ksh
check_MRMS_reflectivity="YES" # check MRMS reflectivity; refl.ksh
check_IMS_snow="YES"          # check IMS snow; snow.ksh
check_GEFS="YES"              # check GEFS; retrieve_dsg_GEFS.sh

#check_enkf="NO"              # check enkf/atm; getFV3GDASensembles
#check_gvf="NO"               # check gvf; gvf.ksh
#check_highres_sst="NO"       # check highres_sst; sst.ksh
#check_obs_rap="NO"           # check obs_rap; obsrap.ksh
#check_rap_hrrr_soil="NO"     # check rap_hrrr_soil; get_raphrrrsoil.ksh
#check_MRMS_reflectivity="NO" # check MRMS reflectivity; refl.ksh
#check_IMS_snow="NO"          # check IMS snow; snow.ksh
#check_GEFS="NO"              # check GEFS; retrieve_dsg_GEFS.sh

pdy=$spdy
while [[ $pdy -le $epdy ]]; do
  echo `doy $pdy`
  doy=`doy $pdy | cut -f 4 -d " "`
  yy=`echo $pdy | cut -c 3-4`

  # check enkf/atm
  if [[ $check_enkf == "YES" ]]; then
    #num=`find enkf/atm/${yy}${doy}* | wc`
    num=`find enkf/atm/enkfgdas.${pdy} -name *nc | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 560 ))  # 80 ensemble members x 4 synoptic times = 320/day
    echo "enkf/atm/      $pdy is completed: ${percent}% ($num)"
                                  #atm +30 ensemble members x 4 synoptic times = 440/day
                                  #sfc +30 ensemble members x 4 synoptic times = 560/day
  fi

  # check gvf
  if [[ $check_gvf == "YES" ]]; then
    num=`find gvf/grib2/ -name "*e$pdy*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 2 ))  # 2 files for each day
    echo "gvf/grib2/     $pdy is completed: ${percent}% ($num)"
  fi

  # check highres_sst
  if [[ $check_highres_sst == "YES" ]]; then
    num=`find highres_sst/ -name "${yy}${doy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 1 )) # 1 file for each day
    echo "highres_sst/   $pdy is completed: ${percent}% ($num)"
  fi

  # check obs_rap
  if [[ $check_obs_rap == "YES" ]]; then
    num=`find obs_rap/ -name "${pdy}*rap*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 1050 )) # ~1050 files for each day (give or take a few)
    echo "obs_rap/       $pdy is completed: ${percent}% ($num)"
  fi

  # check rap_hrrr_soil
  if [[ $check_rap_hrrr_soil == "YES" ]]; then
    num=`find rap_hrrr_soil/$pdy/ -name "*wrf*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 2 ))  # 2 files for each day
    echo "rap_hrrr_soil/ $pdy is completed: ${percent}% ($num)"
  fi

  # check MRMS reflectivity
  if [[ $check_MRMS_reflectivity == "YES" ]]; then
    #num=`find reflectivity/MergedReflectivityQC_${pdy}* | wc`
    num=`find reflectivity/upperair/mrms/conus/MergedReflectivityQC/ -name "*${pdy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 23760 ))  # 23760 files for each day
    echo "reflectivity/  $pdy is completed: ${percent}% ($num)"
  fi

  # check IMS snow
  if [[ $check_IMS_snow == "YES" ]]; then
    num=`find snow/ims96/grib2/ -name "${yy}${doy}*" | wc`
    num=`echo $num | cut -f 1 -d " "`
    (( percent = 100 * $num / 1 ))  # 1 files for each day
    echo "snow/          $pdy is completed: ${percent}% ($num)"
  fi

  # check GEFS
  if [[ $check_GEFS == "YES" ]]; then
    for mem in $(seq -w 1 30);  do
      num=`find GEFS/dsg/gep$mem/. -name "${yy}${doy}*" | wc`
      num=`echo $num | cut -f 1 -d " "`
      (( percent = 100 * $num / 136 ))  # 1 files for each day
      if [[ $num -ne 136 ]]; then
      echo "GEFS/mem$mem/    $pdy is completed: ${percent}% ($num)"
      fi
    done
  fi


  (( pdy = pdy + 1 ))
  echo ""
done
