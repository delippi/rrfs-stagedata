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
#SBATCH --job-name=get_raphrrrsoil
#SBATCH -o log.raphrrrsoil

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N get_raphrrrsoil
#PBS -j oe -o log.rapsoil


# EXPORT list here
 module purge
. $MODULESHOME/init/sh
module load hpss
module list
set -x

mkdir -p rap_hrrr_soil
cd rap_hrrr_soil


yy=2023
yymm=202306

for i in 10 
do
  mkdir -p ${yymm}${i}
  cd ${yymm}${i}

  # Before July 2022: rap and hrrr tar file name
  #hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_rap_prod_rap.${yymm}${i}00-05.init.tar .
  #hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_prod_hrrr.${yymm}${i}_conus00-05.init.tar .
  #hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_prod_hrrr.${yymm}${i}_alaska00-05.init.tar .

  #tar xvf ./com_rap_v5.1_rap.${yymm}${i}00-05.init.tar              ./rap.t04z.wrf_inout_smoke
  #tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_conus00-05.init.tar      ./hrrr.t04z.wrf_inout
  #tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_alaska00-05.init.tar     ./hrrrak.t03z.wrf_inout


  # After July 2022, rap and hrrr tar file name changed
  hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_rap_v5.1_rap.${yymm}${i}00-05.init.tar .
  hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_v4.1_hrrr.${yymm}${i}_conus00-05.init.tar .
  #hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_v4.1_hrrr.${yymm}${i}_alaska00-05.init.tar .

  tar xvf ./com_rap_v5.1_rap.${yymm}${i}00-05.init.tar              ./rap.t04z.wrf_inout_smoke
  tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_conus00-05.init.tar      ./hrrr.t04z.wrf_inout
  #tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_alaska00-05.init.tar     ./hrrrak.t03z.wrf_inout

  rm *tar

  cd ..
done


exit





