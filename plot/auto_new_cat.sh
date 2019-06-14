#!/bin/bash
#Run MAPLE system automatically! Remember to change "Basic setting".
start=$(date +%s) #calculating how long would this .sh take
#================================================

#Basic setting
#interactive code
echo 'case #1: 201206_FRONT'
echo 'case #2: 201008_NAMTHEUN'
echo 'case #3: 201407_MATMO'
echo 'case #4: 200908_MORAKOT'
echo 'case #5: 201009_FANAPI'
echo 'case #6: 201508_SOUDELOR'
echo 'case #7: 200807_FUNG-WONG'
echo 'case #8: 201307_SOULIK'
echo 'case #9: 201607_NEPARTAK'
echo 'case #10: 201609_MEGI'
echo 'case #11: 201707_NESAT'
echo 'case #12: 201509_DUJUAN'
echo 'case #13: 201707_HAITANG'
echo 'case #14: 201609_MERANTI'
echo 'case #15: 201409_FUNG-WONG'
echo 'case #16: 201807_MARIA'
echo 'case #17: 201808_LOWPRESSURE'
read -p 'Enter the start case number:' str_num
read -p 'Enter the end   case number:' end_num
echo '#1 dBZ threshold =  0 dBZ'
echo '#2 dBZ threshold = 10 dBZ'
echo '#3 dBZ threshold = 15 dBZ'
echo '#4 dBZ threshold = 25 dBZ'
echo '#5 dBZ threshold = 35 dBZ'
echo '#6 dBZ threshold = 40 dBZ'
read -p 'Enter the NEW SCORE threshold number:' num_dbz
#================================================

n=0
f_int=60 #forecast frequency (minute)
now_num=${str_num}
rm pod/maple48/*
rm pod/maple144/*
rm pod/com/*
rm far/maple48/*
rm far/maple144/*
rm far/com/*
case ${num_dbz} in
"1")
 th=0  
;;
"2")
 th=10
;;
"3")
 th=15
;;
"4")
 th=25
;;
"5")
 th=35
;;
"6")
th=40
;;
esac
while [ $now_num -le $end_num ];
do
case_num=${now_num}

case ${case_num} in
  "1")
    case_name='201206_FRONT'
    str_time=20120611080000
    end_time=20120612180000
    ;;
  "2")
    case_name='201008_NAMTHEUN'  
    str_time=20100830150000
    end_time=20100831090000
    ;;
  "3")
    case_name='201407_MATMO'
    str_time=20140722040000
    end_time=20140723150000
    ;;
  "4")
    case_name='200908_MORAKOT'
    str_time=20090806130000
    end_time=20090809180000
    ;;
  "5")
    case_name='201009_FANAPI'
    str_time=20100918060000
    end_time=20100920070000
    ;;
  "6")
    case_name='201508_SOUDELOR'
    str_time=20150807130000
    end_time=20150809010000
    ;;
  "7")
    case_name='200807_FUNG-WONG'
    str_time=20080727060000
    end_time=20080729030000
    ;;
  "8")
    case_name='201307_SOULIK'
    str_time=20130712070000
    end_time=20130713150000
    ;;
  "9")
    case_name='201607_NEPARTAK'
    str_time=20160707020000
    end_time=20160709060000
    ;;
  "14")
    case_name='201609_MERANTI'
    str_time=20160913070000
    end_time=20160915030000
    ;;
  "10")
    case_name='201609_MEGI'
    str_time=20160926120000
    end_time=20160928090000
    ;;
  "15")
    case_name='201409_FUNG-WONG'
    str_time=20140920080000
    end_time=20140921210000
    ;;
  "11")
    case_name='201707_NESAT'
    str_time=20170728200000
    end_time=20170730060000
    ;;
  "12")
    case_name='201509_DUJUAN'
    str_time=20150927160000
    end_time=20150928230000
    ;;
  "13")
    case_name='201707_HAITANG'
    str_time=20170729160000
    end_time=20170731040000
    ;;
  "16")
    case_name='201807_MARIA'
    str_time=20180710080000
    end_time=20180711040000
    ;;
  "17")
    case_name='201808_LOWPRESSURE'
    str_time=20180822180000
    end_time=20180824130000
    ;;
esac
now=$str_time
while [ $now -le $end_time ];
do
  ln -sf /home/miayao/maple_ncu/categorical_verification/${case_name}/${now:0:14}/pod_${now:0:14}_${th}dBZ.txt pod/maple48/.
  ln -sf /home/miayao/maple_adjust_vector/categorical_verification/${case_name}/${now:0:14}/pod_${now:0:14}_${th}dBZ.txt pod/maple144/.
  ln -sf /home/miayao/com_weak_WRF/categorical_verification/${case_name}/${now:0:14}/pod_${now:0:14}_${th}dBZ_144d03_interp_400hPa_0.7_0.3.txt pod/com/.
  ln -sf /home/miayao/maple_ncu/categorical_verification/${case_name}/${now:0:14}/far_${now:0:14}_${th}dBZ.txt far/maple48/.
  ln -sf /home/miayao/maple_adjust_vector/categorical_verification/${case_name}/${now:0:14}/far_${now:0:14}_${th}dBZ.txt far/maple144/.
  ln -sf /home/miayao/com_weak_WRF/categorical_verification/${case_name}/${now:0:14}/far_${now:0:14}_${th}dBZ_144d03_interp_400hPa_0.7_0.3.txt far/com/.
  timestamp=${now:0:4}-${now:4:2}-${now:6:2}' '${now:8:2}:${now:10:2}:${now:12:2}
  now=`date -d "+ $f_int minutes $timestamp" +%Y%m%d%H%M%S`
done
  now_num=$(($now_num+1))
done
  a=${str_time:0:4}-${str_time:4:2}-${str_time:6:2}'_'${str_time:8:2}:${str_time:10:2}:${str_time:12:2}
  b=${end_time:0:4}-${end_time:4:2}-${end_time:6:2}'_'${end_time:8:2}:${end_time:10:2}:${end_time:12:2}

#================================================

echo $n
end=$(date +%s)
diff=$(($end - $start))
diff=$((${diff}/60))
echo 'It takes' $diff 'minutes!'

