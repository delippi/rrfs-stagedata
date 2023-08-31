#!/bin/ksh --login 
#SBATCH --time=23:30:00
#SBATCH --qos=batch
#SBATCH --partition=service
#SBATCH --ntasks=1
#SBATCH --account=zrtrr
#SBATCH --job-name=Fill_GEFS_from_aws
#SBATCH --output=./Fill_GEFS_from_aws.log

# https://noaa-gefs-pds.s3.amazonaws.com/gefs.20220429/00/atmos/pgrb2ap5/gep01.t00z.pgrb2a.0p50.f114
# https://noaa-gefs-pds.s3.amazonaws.com/gefs.20220429/00/atmos/pgrb2bp5/gep01.t00z.pgrb2b.0p50.f114

set -x

#datadir=/mnt/lfs1/BMC/wrfruc/chunhua/retro_data/GEFS
#targetdatadir=/mnt/lfs1/BMC/wrfruc/chunhua/retro_data/GEFS/merged
datadir=/scratch1/BMC/wrfruc/chunhua/data/GEFS
waittime=30
maxtries=10

#for memdate in gep23.2022072012 gep01.2022072112 gep02.2022072212 gep03.2022072206 gep23.2022072318 gep27.2022072406
#for memdate in gep01.2022072112 gep02.2022072212 gep03.2022072206 gep23.2022072318 gep27.2022072406
#for memdate in gep18.2022020418 
for memdate in $( seq -f "gep%02g.20220210" 21 30 ) 
do
mem=${memdate:0:5}
yyyymmdd=${memdate:6:8}
#hh=${memdate:14:2} 

for hh in 00 06 12 18
do
echo "processing member $mem for $yyyymmdd $hh"

#for mems in {01..30}; do
#  mem=$( printf "%02d" $mems ) 
  if [ ! -d $datadir/$mem ]; then 
    mkdir -p $datadir/$mem
  fi
  cd $datadir/$mem
#  for dates in  20220428 20220429 20220430 20220501 20220502 20220503 20220504 20220505 20220506 20220507 20220508 20220509 20220510 20220511 20220512 ; do
#    yyyymmdd=$dates
    yy="${yyyymmdd:2:2}"
    yyyy="${yyyymmdd:0:4}"
    mm="${yyyymmdd:4:2}"
    dd="${yyyymmdd:6:2}"
    doy=`date  --date=$yyyymmdd +%j `
#    for hrs in {00..18..06}; do
#      hh=$( printf "%02d" $hrs )
      for fcsthr in {06..75..03}; do
        fhr=$( printf "%03d" $fcsthr )
        localfile=${yy}${doy}${hh}000${fhr}

        if [ ! -s $localfile ]; then

        awsfile_a="https://noaa-gefs-pds.s3.amazonaws.com/gefs.${yyyymmdd}/${hh}/atmos/pgrb2ap5/${mem}.t${hh}z.pgrb2a.0p50.f${fhr}"
        localfile_a="${mem}.t${hh}z.pgrb2a.0p50.f${fhr}"
        if [ ! -s  ${localfile_a} ]; then
          tries=0
          while [[ ! -s ${localfile_a} && $tries -lt $maxtries ]]; do
            timeout  --foreground  $waittime wget ${awsfile_a}
            if [ $? -ne 0 ] ; then
              echo "Failed to download ${awsfile_a} ... trying again ..."
              rm -f ${localfile_a}
              let tries=$((tries+1))
            fi
          done
        fi

        awsfile_b="https://noaa-gefs-pds.s3.amazonaws.com/gefs.${yyyymmdd}/${hh}/atmos/pgrb2bp5/${mem}.t${hh}z.pgrb2b.0p50.f${fhr}"
        localfile_b="${mem}.t${hh}z.pgrb2b.0p50.f${fhr}"
        if [ ! -s  ${localfile_b} ]; then
          tries=0
          while [[ ! -s ${localfile_b} && $tries -lt $maxtries ]]; do
            timeout  --foreground  $waittime wget ${awsfile_b}
            if [ $? -ne 0 ] ; then
              echo "Failed to download ${awsfile_b} ... trying again ..."
              rm -f ${localfile_b}
              let tries=$((tries+1))
            fi
          done
        fi

        if [ -s ${localfile_a} ] && [ -s ${localfile_b} ]; then
           cat ${localfile_a} ${localfile_b} > ${localfile}
           res=$?
           if [ $res == 0 ]; then
             rm -f  ${localfile_a} ${localfile_b}
           fi
        fi

        fi

#      done
    done
  done
done

