#!/bin/bash

#
# cmp_dir.sh dir1 dir2
# 比较目录dir1里的文件和dir2目录内的文件是否一致
#

if [ $# -ne 2 ]; then
	echo "Usage: $0 dir1 dir2"
	exit 1
fi

dir1=$1
dir2=$2

cd $dir1
printf "%-20s%-20s%-10s\n" "dir1" "dir2" "result"
for file in `\ls`
do 
	# echo -n "$file            "
	printf "%-20s" $file

	md5sum_1=$(md5sum $file | cut -d' ' -f1)

	if [ -f ${dir2}/${file} ]; then
		# echo -n "$file            "
		printf "%-20s" $file
		md5sum_2=$(md5sum ${dir2}/${file} | cut -d' ' -f1)
	else
		# echo -n "!!!!!!            "
		printf "%-20s" "!!!!!!"
	fi

	if [ "$md5sum_1" == "$md5sum_2" ]; then
		# echo "same"
		printf "%-10s\n" "same"	
	else
		# echo "diff"
		printf "%-10s\n" "diff"	
	fi

done