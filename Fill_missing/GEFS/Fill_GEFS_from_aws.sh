#!/bin/ksh
#####################################################
# machine set up (users should change this part)
#####################################################

# For Hera, Jet, Orio
#SBATCH --time=23:30:00
#SBATCH --qos=batch
#SBATCH --partition=service
#SBATCH --ntasks=1
#SBATCH --account=zrtrr
#SBATCH --job-name=Fill_GEFS_from_aws
#SBATCH --output=./Fill_GEFS_from_aws.log

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N Fill_GEFS_from_aws
#PBS -j oe -o log.Fill_GEFS_from_aws.20230705

# https://noaa-gefs-pds.s3.amazonaws.com/gefs.20220429/00/atmos/pgrb2ap5/gep01.t00z.pgrb2a.0p50.f114
# https://noaa-gefs-pds.s3.amazonaws.com/gefs.20220429/00/atmos/pgrb2bp5/gep01.t00z.pgrb2b.0p50.f114

set -x

# Jet:
#datadir=/lfs4/BMC/wrfruc/RRFS_RETRO_DATA/GEFS
# Hera:
#datadir=/scratch2/BMC/zrtrr/RRFS_RETRO_DATA/GEFS
# WCOSS2:
datadir=/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata/GEFS/dsg

waittime=30
maxtries=10

#for dates in 20220131 2022020{0..8} 202306{09..18}
for dates in 20230705
do
  #for hh in 00 06 12 18
  for hh in 18
  do
    #for mems in {01..30}
    #for mems in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
    for mems in 01 03 04 07 08 10 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
    do
    mem=gep$( printf "%02d" $mems )
    #for fcsthr in {00..75..03}
    for fcsthr in {00..99..03}
      do
      fhr=$( printf "%03d" $fcsthr )

#for memdate in gep27.2022020100
#for memdate in $( seq -f "gep%02g.20220201" 27 30 ) 
#for memdate in $( cat ${datadir}/../script/missing_hpss_gefs.list )
#do
#  mem=${memdate:0:5}
#  yyyymmdd=${memdate:6:8}
#  hh=${memdate:14:2} 

      yyyymmdd=$dates
      yy="${yyyymmdd:2:2}"
      yyyy="${yyyymmdd:0:4}"
      mm="${yyyymmdd:4:2}"
      dd="${yyyymmdd:6:2}"
      doy=`date  --date=$yyyymmdd +%j `

      echo "processing member $mem for $yyyymmdd $hh"
      if [ ! -d $datadir/$mem ]; then
        mkdir -p $datadir/$mem
      fi
      cd $datadir/$mem

      localfile=${yy}${doy}${hh}000${fhr}

      if [[ ! -s $localfile ]] || [[ -n  "$( find $localfile  -size -90M )" ]];  then

         awsfile_a="https://noaa-gefs-pds.s3.amazonaws.com/gefs.${yyyymmdd}/${hh}/atmos/pgrb2ap5/${mem}.t${hh}z.pgrb2a.0p50.f${fhr}"
         localfile_a="${mem}.t${hh}z.pgrb2a.0p50.f${fhr}"
         if [ ! -s  ${localfile_a} ]; then
           tries=0
           while [[ ! -s ${localfile_a} && $tries -lt $maxtries ]]
           do
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
           while [[ ! -s ${localfile_b} && $tries -lt $maxtries ]]
           do
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

      done   # fcsthr
    done  # mems
  done  # hh
done  # dates

