#!/bin/bash
#Using this shell script to 'link FORECAST and OBSERVATION data' in order to DO THE CATEGORICAL VERIFICATION between these two kinds of data in 'categorical_ver.f90' and then compile and execute the 'categorical_ver.f90' to get 'csi_time.txt','ets_time.txt','far_time.txt','pod_time.txt'
#================================================
#2016-04 edition 1.Calculate the one time skill score data.
#2016-07 edition 2.Set up the selectable data time in this file.
#2016-08 edition 3.Change some files' name.
#2016-11 edition 4.Add a new score---Kuiper score(KS) and user-selctable 'th' value.Here,'th' needs to be the same with the 'th' in the 'categorical_ver.f90'.Change the 'dir_obsdata'.Add interactive code to read some information.
#2017-05 edition 6.Auto calculate the result by 'auto_categorical_ver.sh'. In this case we DO NOT use the #Interactive code here and add #For auto-run code.-->This part moves to 'link_and_execute_forauto.sh'
#================================================
#For auto-run code
#Enter the start time of forecast(YYYYMMDDhhmmss)
case_name="201808_LOWPRESSURE"
obs_date='20180824130000'
#Enter the threshold of rainfall events, 999 for stop(dBZ)
th=40

#================================================

#Interactive code,2016-11
#read -p 'Enter the start time of forecast(YYYYMMDDhhmmss):' obs_date
test -z ${obs_date} && echo 'You MUST input a time.'
#echo ${obs_date}

###th=0
###while [ ${th} -ne 999 ]
###do  #2016-11
##  read -p 'Enter the threshold of rainfall events, 999 for stop(dBZ):' th
##  test -z ${th} && echo 'You MUST input a threshold.'
##  echo ${th}

  if [ ${th} -ne 999 ]; then  #2016-11

#Carefully,#1~3 and #6~7 must be the same value with maple_ncu/run_maple.sh! #4~5 don't need to change! #8 changes with the 'th' value in the 'categorical_ver.f90' 
    #obs_date='20100831120000' #1 --> change from interactive code
    #obs_int=20 #2        !not use here
    #obs_numbers=3 #3     !not use here

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

#To remove useless F data(first two data in VET) in CAL_COR with O data
#let i=$obs_numbers-1  #let:A Bash command for Arithmetic
#while [ $i -ge 1 ]
#do
#  let timeint_1=$i*$obs_int
#  now_1=`date -d "-$timeint_1 minutes $timestamp" +%Y%m%d%H%M%S`
#  echo 'REMOVE '${now_1:0:8}' '${now_1:8:6}' data'
#  rm ${site_code}_${product_number}_${obs_date:0:8}_T${now_1:8:6}Z.bil
#  let i=$i-1
#done
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
#      echo 'OBS data time: '$now_2
      ln -sf $dir_obsdata/${now_2:0:6}/${now_2:0:8}/COMPREF.${now_2:0:8}.${now_2:8:4}.dat .
      let j=$j-1
    done
    ls COMPREF.*.dat > obsdata.list
    cd ..

#   echo '-----END OF LINKING OBSERVATION DATA(DAT FILE)-----'

#===============================================

#   echo '-----START TO DO THE CATEGORICAL VERIFICATION-----'

#Make sure the number of line is right in categorical_ver.f90!(180),2016-11
    sed -i '126c \      real,parameter :: th='${th}'.  !th:rainfall threshold(unit:dBZ)' categorical_ver.f90  
    pgf90 categorical_ver.f90
    ./a.out

#This kind of txt file name is easily to store and plot in IDL
    mv csi.txt csi_${obs_date}_${th}dBZ.txt
    mv ets.txt ets_${obs_date}_${th}dBZ.txt
    mv far.txt far_${obs_date}_${th}dBZ.txt
    mv pod.txt pod_${obs_date}_${th}dBZ.txt
    mv ks.txt ks_${obs_date}_${th}dBZ.txt
    mv scc.txt scc_${obs_date}.txt
    mv rmse.txt rmse_${obs_date}.txt
 
   
#    if [ ! -e ${case_name} ]; then mkdir -p ${case_name}; fi
    if [ ! -e ${case_name}/${obs_date} ]; then mkdir -p ${case_name}/${obs_date}; fi
    mv *.txt ${case_name}/${obs_date}

#   echo '-----END OF CALCULATION-----'

  fi  #2016-11
###done  #2016-11

