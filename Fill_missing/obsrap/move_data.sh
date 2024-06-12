#!/bin/sh
#####################################################
# machine set up (users should change this part)
#####################################################

export ndate=/u/donald.e.lippi/bin/ndate

#retro="winter"
#retro="summer"
retro="spring"

date=20230606

# WCOSS2:
if [[ $retro == "summer" ]]; then
  dataloc="/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "winter" ]]; then
  dataloc="/lfs/h2/emc/da/noscrub/donald.e.lippi/rrfs-stagedata"
elif [[ $retro == "spring" ]]; then
  dataloc="/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata"
fi

datadir_a=/lfs/h2/emc/lam/noscrub/donald.e.lippi/rrfs-stagedata-scripts/Fill_missing/obsrap/test

cd $dataloc/obs_rap
mv $datadir_a/${date}* .
