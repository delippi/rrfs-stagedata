#!/bin/ksh --login
#####################################################
# machine set up (users should change this part)
#####################################################

#SBATCH --account=zrtrr
#SBATCH --qos=batch
#SBATCH --ntasks=1
#SBATCH --partition=service
#SBATCH --time=08:00:00
#SBATCH --job-name=get_gfsFcst
#SBATCH -o log.gfsFcst

#-----------------#
# gfs forecast #
#-----------------# 

cd gfs/0p25deg/grib2

yy=2023
mm=06

for day in $(seq -w 09 09); 
do
  for cyc in 00 06 12 18
  do
    hsi get /BMC/fdr/Permanent/${yy}/${mm}/${day}/grib/ftp/7/0/96/0_1038240_0/${yy}${mm}${day}${cyc}00.zip
    unzip ${yy}${mm}${day}${cyc}00.zip
    rm ${yy}${mm}${day}${cyc}00.zip

  done
done

# keep 0-99 hour forecast and delete others
rm ??????????1*
rm ??????????2*
rm ??????????3*



