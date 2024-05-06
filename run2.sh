#!/bin/sh

export ndate="/u/donald.e.lippi/bin/ndate"
mkdir -p ./scripts2

#set -ax
#2023070100-2023073118
sdate=2023070400; edate=2023071100 # summer
sdate=2022020100; edate=2022020200 # summer

dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"

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
