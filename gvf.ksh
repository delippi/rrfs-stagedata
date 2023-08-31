#!/bin/ksh --login
#####################################################
# machine set up (users should change this part)
#####################################################

#SBATCH --account=zrtrr
#SBATCH --qos=batch
#SBATCH --ntasks=1
#SBATCH --partition=service
#SBATCH --time=08:00:00
#SBATCH --job-name=get_gvfObs
#SBATCH -o log.gvfObs


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


