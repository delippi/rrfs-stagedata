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
#PBS -N Fill_obsrap
#PBS -j oe -o log.Fill_rapobs.20240518

# https://noaa-gefs-pds.s3.amazonaws.com/gefs.20220429/00/atmos/pgrb2ap5/gep01.t00z.pgrb2a.0p50.f114
# https://noaa-gefs-pds.s3.amazonaws.com/gefs.20220429/00/atmos/pgrb2bp5/gep01.t00z.pgrb2b.0p50.f114

#set -x
export ndate=/u/donald.e.lippi/bin/ndate

#retro="winter"
#retro="summer"
retro="spring"

dryrun="YES"
#dryrun="NO"

# Jet:
#datadir=/lfs4/BMC/wrfruc/RRFS_RETRO_DATA/GEFS
# Hera:
#datadir=/scratch2/BMC/zrtrr/RRFS_RETRO_DATA/GEFS

# WCOSS2:
if [[ $retro == "summer" ]]; then
  dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "winter" ]]; then
  #dataloc="/lfs/h2/emc/da/noscrub/donald.e.lippi/rrfs-stagedata"
  dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "spring" ]]; then
  dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
fi
#datadir=/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata/obs_rap
datadir=$dataloc
datadir_a=$datadir

if [[ $dryrun == "YES" ]]; then
  datadir_a=/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata-scripts/Fill_missing/obsrap/test
  datadir=$datadir_a
fi
mkdir -p $datadir

#for dates in 2023070{5..6}
for dates in 20240518
do
  #for hh in 00 06 12 18
  for hh in 18
  do
    (( hhp = $hh + 5 )) #e.g., 0, 1, 2, 3, 4, 5
    hhp=$( printf "%02d" $hhp )
    yyyymmdd=$dates
    yy="${yyyymmdd:2:2}"
    yyyy="${yyyymmdd:0:4}"
    mm="${yyyymmdd:4:2}"
    dd="${yyyymmdd:6:2}"
    doy=`date  --date=$yyyymmdd +%j `
    cd $datadir
    hpss=/NCEPPROD/hpssprod/runhistory/rh${yyyy}/${yyyy}${mm}/${yyyymmdd}/
    htar -xvf $hpss/com_obsproc_v1.1_rap.${yyyymmdd}${hh}-${hhp}.obsproc_bufr.tar
    #echo "$hpss"
    #echo "com_obsproc_v1.1_rap.${yyyymmdd}${hh}-${hhp}.obsproc_bufr.tar"
  done
done
