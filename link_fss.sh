#!/bin/bash

case_name="201808_LOWPRESSURE"
obs_date='20180824130000'
#Enter the threshold of rainfall events, 999 for stop(dBZ)

#================================================


test -z ${obs_date} && echo 'You MUST input a time.'


    site_code='C39' #4
    product_number=3380 #5

    out_int=10 #6
    out_numbers=36 #7
    #th=40 #8 --> rainfall threshold(unit:dBZ) --> change from interactive code 

    dir_fstdata='/home/miayao/maple_ncu/output/'${obs_date:0:6}/${obs_date:0:8}
    dir_obsdata='/home/miayao/maple_ncu/datar'

    timestamp=${obs_date:0:4}-${obs_date:4:2}-${obs_date:6:2}' '${obs_date:8:2}:${obs_date:10:2}:${obs_date:12:2} #A format of date for calculation below!

#================================================

#   echo '-----START TO LINK FORECAST DATA(BIL FILE) TO "fstdatafile"-----'
    cd fstdatafile
    rm *.bil
    ln -sf $dir_fstdata/${site_code}_${product_number}_${obs_date:0:8}_T${obs_date:8:6}Z*.bil .


    ls ${site_code}_${product_number}_*.bil > fstdata.list
    cd ..

#   echo '-----END OF LINKING FORECAST DATA(BIL FILE)-----'

#================================================

#   echo '-----START TO LINK OBSERVATION DATA(DAT FILE) TO "obsdatafile"-----'
    cd obsdatafile
    rm *.dat

    let j=$out_numbers #let:A Bash command for Arithmetic
    while [ $j -ge 0 ]
    do
      let timeint_2=$j*$out_int
      now_2=`date -d "+$timeint_2 minutes $timestamp" +%Y%m%d%H%M%S`
      ln -sf $dir_obsdata/${now_2:0:6}/${now_2:0:8}/COMPREF.${now_2:0:8}.${now_2:8:4}.dat .
      let j=$j-1
    done
    ls COMPREF.*.dat > obsdata.list
    cd ..

#   echo '-----END OF LINKING OBSERVATION DATA(DAT FILE)-----'

#===============================================

#   echo '-----START TO DO THE CATEGORICAL VERIFICATION-----'

#Make sure the number of line is right in categorical_ver.f90!(180),2016-11
    sed -i "26c \  filename1='${obs_date}_FSS.dat'" fss.f90  
    sed -i "27c \  filename2='${obs_date}_FSS_REF.dat'" fss.f90   
    ./fss.sh
#This kind of txt file name is easily to store and plot in IDL
   
#    if [ ! -e ${case_name} ]; then mkdir -p ${case_name}; fi
    if [ ! -e ${case_name}/${obs_date} ]; then mkdir -p ${case_name}/${obs_date}; fi
    mv ${obs_date}*.dat ${case_name}/${obs_date}

#   echo '-----END OF CALCULATION-----'


