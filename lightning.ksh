#!/bin/ksh --login
#####################################################
# machine set up (users should change this part)
#####################################################

#SBATCH --account=zrtrr
#SBATCH --qos=batch
#SBATCH --ntasks=1
#SBATCH --partition=service
#SBATCH --time=08:00:00
#SBATCH --job-name=get_lightningObs
#SBATCH -o log.lightningObs


#-----------------------#
# lightning observation #
#-----------------------# 

mkdir -p lightning/vaisala/netcdf
cd lightning/vaisala/netcdf

yy=2023
mm=06

for day in  $(seq -w 10 10); do 
  for cyc in 00
  do
    hsi get /BMC/fdr/Permanent/${yy}/${mm}/${day}/data/lightning/vaisala/netcdf/${yy}${mm}${day}${cyc}00.zip
    unzip ${yy}${mm}${day}${cyc}00.zip
    rm ${yy}${mm}${day}${cyc}00.zip
  done
done
