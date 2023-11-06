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
#SBATCH --job-name=get_gvfObs
#SBATCH -o log.gvfObs

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N get_gvfObs
#PBS -j oe -o log.gvfObs

#------#
# gvf
#------# 

mkdir -p gvf/grib2
cd gvf/grib2

yy=2023
mm=06

for day in $(seq -w 09 10); do
  hsi get /BMC/fdr/Permanent/${yy}/${mm}/${day}/data/sat/ncep/viirs/gvf/grib2/${yy}${mm}${day}0000.zip
  unzip ${yy}${mm}${day}0000.zip
  rm ${yy}${mm}${day}0000.zip
done

exit


