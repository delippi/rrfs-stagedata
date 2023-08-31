#!/bin/ksh --login
#####################################################
# machine set up (users should change this part)
#####################################################

#SBATCH --account=zrtrr
#SBATCH --qos=batch
#SBATCH --ntasks=1
#SBATCH --partition=service
#SBATCH --time=08:00:00
#SBATCH --job-name=get_snowObs
#SBATCH -o log.snowObs


#------#
# snow
#------# 

mkdir -p snow/ims96/grib2
cd snow/ims96/grib2

yy=2023
mm=06

for day in $(seq -w 09 10); do
  hsi get /BMC/fdr/Permanent/${yy}/${mm}/${day}/grib/ftp/7/4/25/0_37748736_20/${yy}${mm}${day}2200.zip
  unzip ${yy}${mm}${day}2200.zip
  rm ${yy}${mm}${day}2200.zip
done



