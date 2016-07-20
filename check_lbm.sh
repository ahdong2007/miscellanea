#!/bin/bash

cd /home/kbssuser/kcbp/bin64
cat LBMCALL_*.LST | \
 egrep -w 'END' | \
 awk -F':' '{a[$2]++} END{for (i in a) print i,a[i]}' | \
 sort -nr -k 2 | \
 head -20 | \
 sed -e 's/\ /,/g' | \
 tee /tmp/bin64.lbmcall.out

echo "调用次数    lbm名称    对应module名称"
for lbm_count in $(cat /tmp/bin64.lbmcall.out)
do
	lbm=$(echo $lbm_count | cut -d',' -f1)
	count=$(echo $lbm_count | cut -d',' -f2)
	echo -n "$count    $lbm    "
	grep -w $lbm KCBPSPD.xml | sed -e 's/\(.\+\) \(module=.\+\) \(type=.\+\)/\2/g'
done


cd /home/kbssuser/kcbp/binimg
cat LBMCALL_*.LST | \
 egrep -w 'END' | \
 awk -F':' '{a[$2]++} END{for (i in a) print i,a[i]}' | \
 sort -nr -k 2 | \
 head -20 | \
 sed -e 's/\ /,/g' | \
 tee /tmp/binimg.lbmcall.out

echo "调用次数    lbm名称    对应module名称"
for lbm_count in $(cat /tmp/binimg.lbmcall.out)
do
	lbm=$(echo $lbm_count | cut -d',' -f1)
	count=$(echo $lbm_count | cut -d',' -f2)
	echo -n "$count    $lbm    "
	grep -w $lbm KCBPSPD.xml | sed -e 's/\(.\+\) \(module=.\+\) \(type=.\+\)/\2/g'
done

exit 0