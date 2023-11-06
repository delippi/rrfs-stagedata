#!/bin/bash

#set -euax


data=/scratch2/BMC/zrtrr/rli/data

yy=22

# check using juldate: gfs fcst, lightning and gdas ensemble link
for dd in $(seq 119 132); do
  #num=`ls ${data}/rap/full/wrfnat/grib2/21${dd}*       | wc`
  #echo "${dd} rap_bdy " $num 
  #num=`ls ${data}/hrrr/conus/wrfnat/grib2/21${dd}*00  | wc`
  #echo "${dd} hrrr " $num 

  num=`ls ${data}/gfs/0p25deg/grib2/${yy}${dd}*           | wc`
  echo "${dd} gfs_fcst " $num 

  num=`ls ${data}/lightning/vaisala/netcdf/${yy}${dd}*    | wc`
  echo "${dd} lighting" $num

  num=`ls ${data}/enkf/atm/${yy}${dd}*                    | wc`
  echo "${dd} gfs_ensemble_ln" $num

  echo ''
done


# check other data
yymm=202204
for dd in $(seq -w 29 30); do   

  yymmdd=${yymm}${dd}
    
  num=`ls  ${data}/enkf/atm/enkfgdas.${yymmdd}/*/atmos/mem*/gdas.t*z.atmf009.nc | wc`
  echo "${yymmdd} gfs_ensemble" $num

  num=`ls ${data}/obs_rap/${yymmdd}*rap_e.*               |wc`
  echo "${yymmdd} rap_e" $num

  num=`ls ${data}/obs_rap/${yymmdd}*rap.*          |wc`
  echo "${yymmdd} rap_obs" $num

  num=`ls ${data}/reflectivity/*${yymmdd}-*.grib2 |wc`
  echo "${yymmdd} reflectivity" $num

  echo ''

done

yymm=202205
for dd in  $(seq -w 01 12); do   

  yymmdd=${yymm}${dd}

  num=`ls  ${data}/enkf/atm/enkfgdas.${yymmdd}/*/atmos/mem*/gdas.t*z.atmf009.nc | wc`
  echo "${yymmdd} gfs_ensemble" $num

  num=`ls ${data}/obs_rap/${yymmdd}*rap_e.*               |wc`
  echo "${yymmdd} rap_e" $num

  num=`ls ${data}/obs_rap/${yymmdd}*rap.*          |wc`
  echo "${yymmdd} rap_obs" $num

  num=`ls ${data}/reflectivity/*${yymmdd}-*.grib2 |wc`
  echo "${yymmdd} reflectivity" $num

  echo ''

done

