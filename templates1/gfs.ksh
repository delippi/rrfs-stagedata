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
#SBATCH --job-name=get_gfsFcst
#SBATCH -o log.gfsFcst

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N get_gfsFcst.@YYYY@@MM@@DD@
#PBS -j oe -o log.gfsFcst.@YYYY@@MM@@DD@

#-----------------#
# gfs forecast #
#-----------------# 

#module load hpss
set -x
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
mkdir -p gfs/0p25deg/grib2
cd gfs/0p25deg/grib2

yy=@YYYY@
mm=@MM@

for day in $(seq -w @DD@ @DD@); 
do
  for cyc in 00 06 12 18
  do
    hsi get /BMC/fdr/Permanent/${yy}/${mm}/${day}/grib/ftp/7/0/96/0_1038240_0/${yy}${mm}${day}${cyc}00.zip
    unzip ${yy}${mm}${day}${cyc}00.zip
    rm ${yy}${mm}${day}${cyc}00.zip

  done
done

# keep 0-49 hour forecast and delete others
#rm ??????????05?
#rm ??????????06?
#rm ??????????07?
rm ??????????08?
rm ??????????09?
rm ??????????1*
rm ??????????2*
rm ??????????3*


# Record the end time
end_time=$(date +%s)

# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

# Print the elapsed time
echo "Script runtime: $elapsed_time seconds"
