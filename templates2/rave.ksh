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
#SBATCH --job-name=local_rave
#SBATCH -o log.RAVEObs

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N local_rave.@YYYY@@MM@@DD@
#PBS -j oe -o log.RAVEObs.@YYYY@@MM@@DD@

#-------------------------------------------#
# full-disk satellite lightning observation #
#-------------------------------------------#

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

dataloc=@DATALOC@
cd $dataloc
mkdir -p RAVE_RAW
cd RAVE_RAW

yy=@YYYY@
mm=@MM@

for day in  $(seq -w @DD@ @DD@); do
    #Cactus
    cp -r /lfs/h2/emc/physics/noscrub/partha.bhattacharjee/RAVE_rawdata/RAVE_v2_Retro/${yy}${mm}${day}/ .
done

# Record the end time
end_time=$(date +%s)

# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

# Print the elapsed time
echo "Script runtime: $elapsed_time seconds"
