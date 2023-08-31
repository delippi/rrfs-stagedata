# rrfs-stagedata
This repository contains scripts to stage RRFS data for retrospective experiments.
We will need to stage these data for RRFS retro run: 

Observation: GVF, SST, snow,  conventional observation, vaisala lightning, MRMS radar reflectivity

Data Assimilation: GDAS or RRFS ensemble for GSI hybrid, mesonet use list, amdar reject list

Model: GFS forecast as ICs/LBCs, RAP/HRRR soil for soil surgery

These scripts mainly provide the HPSS path for each data, please make a copy and update for your use.
  
  
  



***** Observation Scripts *****

GVF: gvf.ksh, zip file contains j01 and npp data, npp is used in RRFS.

SST: sst.ksh

Snow: snow.ksh

RRFS reads GVF, SST and snow from the previous day for the current cycle, so if retro run start from July 20, you need to save July 19 data also.

Vaisala lightning: lightning.ksh

RAP conventional observation: obsrap.ksh, zip file contain several types of data, *.rap.* and *rap_e* data are used in RRFS, you can delete other types if it’s needed.

Radar reflectivity: use refl.ksh to get MRMS reflectivity data and unzip files. It’s almost 23K files/day, the files are saved under upperair/mrms/conus/MergedReflectivityQC automatically, so usually I put data in tmp directory, if all data looks good, then  move data day by day to the desired location, for example, 
                mv tmp/upperair/mrms/conus/MergedReflectivityQC/*20230610*   reflectivity/



***** Data Assimilation scripts *****
                 
mesonet use list and amdar reject list are saved on Jet at
AIRCRAFT_REJECT="/home/role.amb-verif/acars_RR/amdar_reject_lists"
SFCOBS_USELIST="/lfs4/BMC/amb-verif/rap_ops_mesonet_uselists"

If retro run is on Hera, please copy the required file to Hera. 
GSI reads the previous day file for the current cycle, so if retro run start from July 20, you need to save July 19 data also.


GDAS ensemble members: getFV3GDASensembles, GSI reads previous six hour GDAS members for current cycle, so if retro run starts on July 20 03Z, you need to stage July 19 18Z members also.
 
RRFS ensemble:

For the script to pull GEFS GRIB-2 data for initializing the RRFS ensemble, please use 
/mnt/lfs1/BMC/wrfruc/chunhua/retro_data/retrieve_dsg_GEFS.sh

To pull GEFS data from AWS and fill the DSG GEFS data gaps, use   
/mnt/lfs1/BMC/wrfruc/chunhua/retro_data/Fill_GEFS_from_aws.sh

To interpolate the 3-hourly GEFS data to hourly data, please refer to the scripts at  https://github.com/NOAA-GSL/GEFS_time_interpolation



Model scripts:

GFS forecast: gfs.ksh, 96 hour forecast should be enough for current RRFS.  
RAP/HRRR soil: If you use GFS for ICs, you need to do soil surgery. Use get_raphrrrsoil.ksh to get rap/hrrr soil, for example, rap.t04z.wrf_inout_smoke and hrrr.t04z.wrf_inout are used to replace GFS soil.

If you use RAP for ICs, there is no need to do soil surgery.


Check retro data:
After stage data, usually I check the file number for each data using retro_check.ksh. If all data looks good, then update the data path in ufs-srweather-app/regional_workflow/ush/set_rrfs_config.sh if it's needed before generating the workflow.

For example, update these variables to your location on Hera:

if [[ $DO_RETRO == "TRUE" ]] ; then
…
if [[ $MACHINE == "hera" ]] ; then
…     

    EXTRN_MDL_SOURCE_BASEDIR_ICS=/scratch2/BMC/zrtrr/rli/data/gfs/0p25deg/grib2
    EXTRN_MDL_SOURCE_BASEDIR_LBCS=/scratch2/BMC/zrtrr/rli/data/gfs/0p25deg/grib2
    OBSPATH=/scratch2/BMC/zrtrr/rli/data/obs_rap
    OBSPATH_NSSLMOSIAC=/scratch2/BMC/zrtrr/rli/data/reflectivity
    LIGHTNING_ROOT=/scratch2/BMC/zrtrr/rli/data/lightning
    ENKF_FCST=/scratch2/BMC/zrtrr/rli/data/enkf/atm
    AIRCRAFT_REJECT="/scratch2/BMC/zrtrr/rli/data/amdar_reject_lists"
    SFCOBS_USELIST="/scratch2/BMC/zrtrr/rli/data/mesonet_uselists"
    SST_ROOT="/scratch2/BMC/zrtrr/rli/data/highres_sst"
    GVF_ROOT="/scratch2/BMC/zrtrr/rli/data/gvf/grib2"
    IMSSNOW_ROOT="/scratch2/BMC/zrtrr/rli/data/snow/ims96/grib2"
    RAPHRR_SOIL_ROOT="/scratch2/BMC/zrtrr/rli/data/rap_hrrr_soil"


