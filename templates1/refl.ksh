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
#SBATCH --job-name=get_reflObs
#SBATCH -o log.reflObs

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N get_reflObs
#PBS -j oe -o log.reflObs.@YYYY@@MM@@DD@

#--------------#
# reflectivity
#--------------#

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

cd ../../rrfs-stagedata-data/
mkdir -p tmp
cd tmp

yy=@YYYY@
mm=@MM@

for dd in $(seq -w @DD@ @DD@); do

 # 2020-Jun. 2022
 #htar -xvf /NCEPPROD/hpssprod/runhistory/rh${yy}/${yy}${mm}/${yy}${mm}${dd}/dcom_prod_ldmdata_obs.tar ./upperair/mrms/conus/MergedReflectivityQC/MergedReflectivityQC_*_${yy}${mm}${dd}-*.grib2.gz

 # start from Jul. 2022, tar file name changed
 htar -xvf /NCEPPROD/hpssprod/runhistory/rh${yy}/${yy}${mm}/${yy}${mm}${dd}/dcom_ldmdata_obs.tar ./upperair/mrms/conus/MergedReflectivityQC/MergedReflectivityQC_*_${yy}${mm}${dd}-*.grib2.gz

 cd upperair/mrms/conus/MergedReflectivityQC
 for file in `ls MergedReflectivityQC_*_${yy}${mm}${dd}-*.grib2.gz  `
 do
   gzip -d ${file}
 done

 # return to tmp directory
 cd ../../../../

done

# Record the end time
end_time=$(date +%s)

# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

# Print the elapsed time
echo "Script runtime: $elapsed_time seconds"
