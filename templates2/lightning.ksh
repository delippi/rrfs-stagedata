#!/bin/ksh
#####################################################
# machine set up (users should change this part)
#####################################################

# For Hera, Jet, Orion
#SBATCH --account=zrtrr
#SBATCH --qos=batch
#SBATCH --ntasks=1
#SBATCH --partition=service
#SBATCH --time=08:00:00
#SBATCH --job-name=get_lightningObs
#SBATCH -o log.lightningObs

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N get_lightningObs.@YYYY@@MM@@DD@
#PBS -j oe -o log.lightningObs.@YYYY@@MM@@DD@

#-----------------------#
# lightning observation #
#-----------------------# 

dataloc=@DATALOC@
cd $dataloc
mkdir -p lightning/vaisala/netcdf
cd lightning/vaisala/netcdf

yy=@YYYY@
mm=@MM@

for day in  $(seq -w @DD@ @DD@); do 
  for cyc in 00
  do
    hsi get /BMC/fdr/Permanent/${yy}/${mm}/${day}/data/lightning/vaisala/netcdf/${yy}${mm}${day}${cyc}00.zip
    unzip ${yy}${mm}${day}${cyc}00.zip
    rm ${yy}${mm}${day}${cyc}00.zip
  done
done
