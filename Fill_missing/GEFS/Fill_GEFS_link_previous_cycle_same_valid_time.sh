#!/bin/ksh
#####################################################
# machine set up (users should change this part)
#####################################################
set -x
export ndate=/u/donald.e.lippi/bin/ndate
dryrun="YES"
dryrun="NO"

# Jet:
#datadir=/lfs4/BMC/wrfruc/RRFS_RETRO_DATA/GEFS
# Hera:
#datadir=/scratch2/BMC/zrtrr/RRFS_RETRO_DATA/GEFS

# WCOSS2:
for memid in 02 18
do
datadir=/lfs/h3/emc/rrfstemp/donald.e.lippi/rrfs-stagedata/GEFS/dsg/gep${memid}/

datadir_a=$datadir

#if [[ $dryrun == "YES" ]]; then
#  datadir_a=$datadir_a/test/
#fi

err="\n\nUnable to find a good gefs file for:\n"
#for dates in 2023070{5..6}
for dates in 20240113
do
  #for hh in 00 06 12 18
  for hh in 12
  do
    for fcsthr in {0..99..03}
    do
      fhr=$( printf "%03d" $fcsthr )
      yyyymmdd=$dates
      yy="${yyyymmdd:2:2}"
      yyyy="${yyyymmdd:0:4}"
      mm="${yyyymmdd:4:2}"
      dd="${yyyymmdd:6:2}"
      doy=`date  --date=$yyyymmdd +%j `
      cd $datadir

      localfile=${yy}${doy}${hh}000${fhr}
      #echo localfile_a=$localfile

      # Check if file exists (i.e., filesize > 0) and is not bad (filesize < 90M).
      if [[ ! -s $localfile ]] || [[ -n  "$( find $localfile  -size -90M )" ]];  then
        cd $datadir_a
        tried=""
        # Look for the next 4 closest cycles for something else to use.
        # Relative gfs runs to try -6 (previous), +6 (next), -12 (previous), 12 (next)
        for try in -6 #6 -12 12
        do
          (( next_fhr = $fcsthr - $try ))
          (( next_hh = $hh + $try ))
          #next_hh=$( printf "%02d" $next_hh )
          next_fhr=$( printf "%03d" $next_fhr )
          next_yyyymmddhh=`$ndate $try ${dates}${hh}`

          next_yyyymmdd="${next_yyyymmddhh:0:8}"
          next_yy="${next_yyyymmdd:2:2}"
          next_yyyy="${next_yyyymmdd:0:4}"
          next_mm="${next_yyyymmdd:4:2}"
          next_dd="${next_yyyymmdd:6:2}"
          next_doy=`date  --date=$next_yyyymmdd +%j `

          if [[ $next_hh -gt 24 ]]; then
            (( next_hh = $next_hh - 24 ))
          fi
          if [[ $next_hh -lt 0 ]]; then
            (( next_hh = $next_hh + 24 ))
          fi
          next_hh=$( printf "%02d" $next_hh )
          localfile_b=${next_yy}${next_doy}${next_hh}000${next_fhr}
          tried="$tried $localfile_b"
          #echo "checking: $localfile_b"

          # Break this loop if we have found something we can use.
          # If a file exists and is not a link.
          if [[ -s $datadir/$localfile_b && ! -L $datadir/$localfile_b ]];  then
          #if [[ -s $datadir/$localfile_b ]];  then
            break
          fi
        done

        if [[ -s $datadir/$localfile_b && ! -L $datadir/$localfile_b ]];  then
        #if [[ -s $datadir/$localfile_b ]];  then
          ln -s $datadir/$localfile_b $datadir_a/$localfile
          #echo "$datadir/$localfile_b $localfile"
        else
          err="${err}${localfile} (${yyyymmdd}${hh} fh$fcsthr)\n"
          err="${err}   tried: ${tried}\n"
        fi
      fi
    done
  done
  done
done
echo -e $err
