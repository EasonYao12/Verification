#!/bin/bash
#Link the verification data and calculate the average result versus lead time
#================================================

#Basic setting
#interactive code
echo 'case #1: 201206_FRONT'
echo 'case #2: 201407_MATMO'
echo 'case #3: 200908_MORAKOT'
echo 'case #4: 201009_FANAPI'
echo 'case #5: 201508_SOUDELOR'
echo 'case #6: 200807_FUNG-WONG'
echo 'case #7: 201307_SOULIK'
echo 'case #8: 201607_NEPARTAK'
echo 'case #9: 201609_MEGI'
echo 'case #10: 201707_NESAT'
echo 'case #11: 201509_DUJUAN'
echo 'case #12: 201707_HAITANG'
echo 'case #13: 201807_MARIA'
echo 'case #14: 201808_LOWPRESSURE'
echo 'case #15: 201008_NAMTHEUN'
echo 'case #16: 201409_FUNG-WONG'
echo 'case #17: 201609_MERANTI'
read -p 'Enter the start case number:' str_num
read -p 'Enter the end   case number:' end_num


#================================================
fr=60

#cd $dir_case
#rm continuous_*.nc
rm maple_144/alldata/T1/*
rm maple_144/typhoon/T1/*
rm maple_144/QPESUMS/T1/*
rm maple_144/alldata/T2/*
rm maple_144/typhoon/T2/*
rm maple_144/QPESUMS/T2/*
rm maple_144/alldata/T3/*
rm maple_144/typhoon/T3/*
rm maple_144/QPESUMS/T3/*
rm maple_144/alldata/All/*
rm maple_144/typhoon/All/*
rm maple_144/QPESUMS/All/*
now_num=${str_num}
while [ $now_num -le $end_num ];
do
case ${now_num} in
  "1")
    case_name='201206_FRONT'
    str_time=20120611080000
    end_time=20120612180000
    ;;

  "2")
    case_name='201407_MATMO'
    str_time=20140722040000
    end_time=20140723150000
          T1=20140722160000
	  T2=20140722200000
    ;;
  "3")
    case_name='200908_MORAKOT'
    str_time=20090806130000
    end_time=20090809180000
    	  T1=20090807160000
	  T2=20090808060000
    ;;
  "4")
    case_name='201009_FANAPI'
    str_time=20100918060000
    end_time=20100920070000
          T1=20100919010000
	  T2=20100919100000
    ;;
  "5")
    case_name='201508_SOUDELOR'
    str_time=20150807130000
    end_time=20150809010000
          T1=20150807210000
	  T2=20150808030000
    ;;
  "6")
    case_name='200807_FUNG-WONG'
    str_time=20080727060000
    end_time=20080729030000
          T1=20080727230000
	  T2=20080728070000
    ;;
  "7")
    case_name='201307_SOULIK'
    str_time=20130712070000
    end_time=20130713150000
          T1=20130712190000
	  T2=20130713000000
    ;;
  "8")
    case_name='201607_NEPARTAK'
    str_time=20160707020000
    end_time=20160709060000
          T1=20160707220000
	  T2=20160708070000
    ;;

  "9")
    case_name='201609_MEGI'
    str_time=20160926120000
    end_time=20160928090000
          T1=20160927060000
	  T2=20160927130000
    ;;

  "10")
    case_name='201707_NESAT'
    str_time=20170728200000
    end_time=20170730060000
          T1=20170729110000
	  T2=20170729150000
    ;;
  "11")
    case_name='201509_DUJUAN'
    str_time=20150927160000
    end_time=20150928230000
          T1=20150928100000
	  T2=20150928170000
    ;;
  "12")
    case_name='201707_HAITANG'
    str_time=20170729160000
    end_time=20170731040000
          T1=20170730010000
	  T2=20170730170000
    ;;
  "13")
    case_name='201807_MARIA'
    str_time=20180710080000
    end_time=20180711040000
          T1=-999
    ;;
  "14")
    case_name='201808_LOWPRESSURE'
    str_time=20180822180000
    end_time=20180824130000
          T1=-999
    ;;
   "15")
    case_name='201008_NAMTHEUN'  
    str_time=20100830150000
    end_time=20100831090000
          T1=-999
    ;;
   "16")
    case_name='201409_FUNG-WONG'
    str_time=20140920080000
    end_time=20140921210000
          T1=-999
    ;;
   "17")
    case_name='201609_MERANTI'
    str_time=20160913070000
    end_time=20160915030000
          T1=-999
    ;;
esac

if [ $T1 -ne -999 ];then
now=$str_time
#end_time=$T2

#echo 'Case name: '$case_name

while [ $now -le $T1 ];
do
  
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_alldata_DI.nc maple_144/alldata/T1/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_QPESUMs_DI.nc maple_144/QPESUMS/T1/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_typhoon_DI.nc maple_144/typhoon/T1/.

  timestamp=${now:0:4}-${now:4:2}-${now:6:2}' '${now:8:2}:${now:10:2}:${now:12:2}
  
  now=`date -d "+ $fr minutes $timestamp" +%Y%m%d%H%M%S`

done
  

now=$T1
while [ $now -le $T2 ];
do
  
  
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_alldata_DI.nc maple_144/alldata/T2/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_QPESUMs_DI.nc maple_144/QPESUMS/T2/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_typhoon_DI.nc maple_144/typhoon/T2/.

  timestamp=${now:0:4}-${now:4:2}-${now:6:2}' '${now:8:2}:${now:10:2}:${now:12:2}
  
  now=`date -d "+ $fr minutes $timestamp" +%Y%m%d%H%M%S`

done

now=$T2
while [ $now -le $end_time ];
do
  
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_alldata_DI.nc maple_144/alldata/T3/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_QPESUMs_DI.nc maple_144/QPESUMS/T3/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_typhoon_DI.nc maple_144/typhoon/T3/.

  timestamp=${now:0:4}-${now:4:2}-${now:6:2}' '${now:8:2}:${now:10:2}:${now:12:2}
  
  now=`date -d "+ $fr minutes $timestamp" +%Y%m%d%H%M%S`

done
fi
now=$str_time
while [ $now -le $end_time ];
do
  
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_alldata_144.nc maple_144/alldata/All/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_QPESUMs_144.nc maple_144/QPESUMS/All/.
  ln -sf /home/miayao/maple_adjust_vector/rainfall_verification/${case_name}/$now/categorical_${now}_typhoon_144.nc maple_144/typhoon/All/.

  timestamp=${now:0:4}-${now:4:2}-${now:6:2}' '${now:8:2}:${now:10:2}:${now:12:2}
  
  now=`date -d "+ $fr minutes $timestamp" +%Y%m%d%H%M%S`

done

 now_num=$(($now_num+1))
done

#================================================

#================================================

#================================================

echo '=============Info============='
echo 'Case name: '$case_name
echo 'Start time: '$str_time
echo 'End   time: '$end_time
echo 'Verification type: '$type_name
echo '=============================='




