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
#PBS -N get_raphrrrsoil.@YYYY@@MM@@DD@
#PBS -j oe -o log.rapsoil.@YYYY@@MM@@DD@

#------#
# rap_soil
#------#

# Record start time
start_time=$(date +%s)

# Set the path to where to stage the data.
if [[ -n $1 ]]; then  # use user defined path
  cd $1
elif [[ -n $SLURM_SUBMIT_DIR ]]; then  # use slurm submit dir
  cd $SLURM_SUBMIT_DIR
elif [[ -n $PBS_O_WORKDIR ]]; then  # use pbs submit dir
  cd $PBS_O_WORKDIR
fi

# EXPORT list here
 module purge
. $MODULESHOME/init/sh
module load hpss
module list
set -x

dataloc=@DATALOC@
cd $dataloc
mkdir -p rap_hrrr_soil
cd rap_hrrr_soil

yy=@YYYY@
yymm=@YYYY@@MM@

#for i in 11 12 13 14 15 16 17 18
for i in @DD@
do
  mkdir -p ${yymm}${i}
  cd ${yymm}${i}

  if [[ ${yymm}${i} -ge 20220701 ]]; then
    # After July 2022, rap and hrrr tar file name changed
    hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_rap_v5.1_rap.${yymm}${i}00-05.init.tar .
    hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_v4.1_hrrr.${yymm}${i}_conus00-05.init.tar .
    #hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_v4.1_hrrr.${yymm}${i}_alaska00-05.init.tar .
  elif [[ ${yymm}${i} -ge 20200101 ]]; then
    # Before July 2022: rap and hrrr tar file name
    hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_rap_prod_rap.${yymm}${i}00-05.init.tar .
    hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_prod_hrrr.${yymm}${i}_conus00-05.init.tar .
    #hsi get /NCEPPROD/1year/hpssprod/runhistory/rh${yy}/${yymm}/${yymm}${i}/com_hrrr_prod_hrrr.${yymm}${i}_alaska00-05.init.tar .
  fi

  #tar xvf ./com_rap_v5.1_rap.${yymm}${i}00-05.init.tar              ./rap.t04z.wrf_inout_smoke
  #tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_conus00-05.init.tar      ./hrrr.t04z.wrf_inout
  #tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_alaska00-05.init.tar     ./hrrrak.t03z.wrf_inout



  tar xvf ./com_rap_v5.1_rap.${yymm}${i}00-05.init.tar              ./rap.t04z.wrf_inout_smoke
  tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_conus00-05.init.tar      ./hrrr.t04z.wrf_inout
  #tar xvf ./com_hrrr_v4.1_hrrr.${yymm}${i}_alaska00-05.init.tar     ./hrrrak.t03z.wrf_inout

  rm *tar

  cd ..
done


# Record the end time
end_time=$(date +%s)

# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

# Print the elapsed time
echo "Script runtime: $elapsed_time seconds"
