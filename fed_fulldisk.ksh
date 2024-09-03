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
#SBATCH --job-name=get_satLightningObs
#SBATCH -o log.satLightningObs

# For WCOSS2
#PBS -A RRFS-DEV
#PBS -q dev_transfer
#PBS -l select=1:ncpus=1:mem=2G
#PBS -l walltime=06:00:00
#PBS -N get_satLightningObs
#PBS -j oe -o log.satLightningObs

#-------------------------------------------#
# full-disk satellite lightning observation #
#-------------------------------------------# 

mkdir -p sat/nesdis/goes-east/glm/full-disk
cd sat/nesdis/goes-east/glm/full-disk

yy=2023
mm=06

for day in  $(seq -w 10 10); do 
    hsi get "/BMC/fdr/Permanent/${yy}/${mm}/${day}/data/sat/nesdis/goes-east/glm/full-disk/*.zip" 
    unzip "*.zip" "*55000_e*" "*56000_e*" "*57000_e*" "*58000_e*" "*59000_e*"
    rm *.zip
done
