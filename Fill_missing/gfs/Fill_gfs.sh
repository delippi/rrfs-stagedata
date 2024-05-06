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

#set -x
export ndate=/u/donald.e.lippi/bin/ndate
dryrun="YES"
dryrun="NO"

# Jet:
#datadir=/lfs4/BMC/wrfruc/RRFS_RETRO_DATA/GEFS
# Hera:
#datadir=/scratch2/BMC/zrtrr/RRFS_RETRO_DATA/GEFS

# WCOSS2:
datadir=/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata/gfs/0p25deg/grib2/
datadir_a=$datadir

if [[ $dryrun == "YES" ]]; then
  datadir_a=/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata/gfs/0p25deg/test/
fi

err="\n\nUnable to find a good gfs file for:\n"
for dates in 2023070{5..6}
#for dates in 20230705
do
  for hh in 00 06 12 18
  #for hh in 00
  do
    for fcsthr in {0..79..01}
    #for fcsthr in {0..6..01}
    do
      fhr=$( printf "%03d" $fcsthr )
      yyyymmdd=$dates
      yy="${yyyymmdd:2:2}"
      yyyy="${yyyymmdd:0:4}"
      mm="${yyyymmdd:4:2}"
      dd="${yyyymmdd:6:2}"
      doy=`date  --date=$yyyymmdd +%j `
      cd $datadir

      localfile=${yy}${doy}${hh}000${fhr}
      #echo localfile_a=$localfile

      # Check if file exists (i.e., filesize > 0) and is not bad (filesize < 90M).
      if [[ ! -s $localfile ]] || [[ -n  "$( find $localfile  -size -90M )" ]];  then
        cd $datadir_a
        tried=""
        # Look for the next 4 closest cycles for something else to use.
        # Relative gfs runs to try -6 (previous), +6 (next), -12 (previous), 12 (next)
        for try in -6 6 -12 12
        do
          (( next_fhr = $fcsthr - $try ))
          (( next_hh = $hh + $try ))
          #next_hh=$( printf "%02d" $next_hh )
          next_fhr=$( printf "%03d" $next_fhr )
          next_yyyymmddhh=`$ndate $try ${dates}${hh}`

          next_yyyymmdd="${next_yyyymmddhh:0:8}"
          next_yy="${next_yyyymmdd:2:2}"
          next_yyyy="${next_yyyymmdd:0:4}"
          next_mm="${next_yyyymmdd:4:2}"
          next_dd="${next_yyyymmdd:6:2}"
          next_doy=`date  --date=$next_yyyymmdd +%j `

          if [[ $next_hh -gt 24 ]]; then
            (( next_hh = $next_hh - 24 ))
          fi
          if [[ $next_hh -lt 0 ]]; then
            (( next_hh = $next_hh + 24 ))
          fi
          next_hh=$( printf "%02d" $next_hh )
          localfile_b=${next_yy}${next_doy}${next_hh}000${next_fhr}
          tried="$tried $localfile_b"
          #echo "checking: $localfile_b"

          # Break this loop if we have found something we can use.
          # If a file exists and is not a link.
          if [[ -s $datadir/$localfile_b && ! -L $datadir/$localfile_b ]];  then
          #if [[ -s $datadir/$localfile_b ]];  then
            break
          fi
        done

        if [[ -s $datadir/$localfile_b && ! -L $datadir/$localfile_b ]];  then
        #if [[ -s $datadir/$localfile_b ]];  then
          ln -s $datadir/$localfile_b $datadir_a/$localfile
          #echo "$datadir/$localfile_b $localfile"
        else
          err="${err}${localfile} (${yyyymmdd}${hh} fh$fcsthr)\n"
          err="${err}   tried: ${tried}\n"
        fi
      fi
    done
  done
done
echo -e $err
