#!/bin/ksh --login
#####################################################
# machine set up (users should change this part)
#####################################################

#SBATCH --account=zrtrr
#SBATCH --qos=batch
#SBATCH --ntasks=1
#SBATCH --partition=service
#SBATCH --time=08:00:00
#SBATCH --job-name=get_rapObs
#SBATCH -o log.rapObs


#-----------------#
# rap observation #
#-----------------# 

mkdir -p obs_rap

cd obs_rap

yy=2023
mm=06

for day in $(seq -w 10 10); do
  for cyc in 00 06 12 18
  do
    hsi get /BMC/fdr/Permanent/${yy}/${mm}/${day}/data/grids/rap/obs/${yy}${mm}${day}${cyc}00.zip
    unzip ${yy}${mm}${day}${cyc}00.zip
    rm ${yy}${mm}${day}${cyc}00.zip
  done
done


exit


# 2019 rap data
# 2019 data in six zip file for each type, need langley nexrad prepbufr satwnd for RRFS retro 
#/BMC/fdr/Permanent/2019/02/01/data/grids/rap/langley/   nexrad/    prepbufr/  radiance/  radwnd/    satwnd/  
#unzip ${yy}${mm}${day}${cyc}00.zip

