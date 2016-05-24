#
# Usage: 
#   input:  Strings with color, parameter must be in double quotes, and no * included
#   Output: Strings with colors
#
# F       B
# 30      40      黑色Black
# 31      41      红色Red
# 32      42      绿色Green
# 33      43      黄色Yellow
# 34      44      蓝色Blue
# 35      45      紫红色Purple
# 36      46      青蓝色Cyan
# 37      47      白色White
# <d> --> Default \033[0m 

#					b 			r 			g 			y 			u 			p 			c 			w
#  f(front)         黑色字体     红色字体      绿色字体 	黄色字体     蓝色字体     紫红色字体	青蓝色字体	白色字体
#  b(background)	黑色背景		红色背景		 绿色背景		黄色背景		蓝色背景		紫红色背景	青蓝色背景	白色背景
#

#
cecho() {

	tmp_str=$1

	# f for front, b for background
	tmp_str=`echo $tmp_str | sed  -e 's/<fb><bb>/\\\033\[40;30m/g' \
								  -e 's/<fb><br>/\\\033\[41;30m/g' \
								  -e 's/<fb><bg>/\\\033\[42;30m/g' \
								  -e 's/<fb><by>/\\\033\[43;30m/g' \
								  -e 's/<fb><bu>/\\\033\[44;30m/g' \
								  -e 's/<fb><bp>/\\\033\[45;30m/g' \
								  -e 's/<fb><bc>/\\\033\[46;30m/g' \
								  -e 's/<fb><bw>/\\\033\[47;30m/g' \
								  \
								  -e 's/<fr><bb>/\\\033\[40;31m/g' \
								  -e 's/<fr><br>/\\\033\[41;31m/g' \
								  -e 's/<fr><bg>/\\\033\[42;31m/g' \
								  -e 's/<fr><by>/\\\033\[43;31m/g' \
								  -e 's/<fr><bu>/\\\033\[44;31m/g' \
								  -e 's/<fr><bp>/\\\033\[45;31m/g' \
								  -e 's/<fr><bc>/\\\033\[46;31m/g' \
								  -e 's/<fr><bw>/\\\033\[47;31m/g' \
								  \
								  -e 's/<fg><bb>/\\\033\[40;32m/g' \
								  -e 's/<fg><br>/\\\033\[41;32m/g' \
								  -e 's/<fg><bg>/\\\033\[42;32m/g' \
								  -e 's/<fg><by>/\\\033\[43;32m/g' \
								  -e 's/<fg><bu>/\\\033\[44;32m/g' \
								  -e 's/<fg><bp>/\\\033\[45;32m/g' \
								  -e 's/<fg><bc>/\\\033\[46;32m/g' \
								  -e 's/<fg><bw>/\\\033\[47;32m/g' \
								  \
								  -e 's/<fy><bb>/\\\033\[40;33m/g' \
								  -e 's/<fy><br>/\\\033\[41;33m/g' \
								  -e 's/<fy><bg>/\\\033\[42;33m/g' \
								  -e 's/<fy><by>/\\\033\[43;33m/g' \
								  -e 's/<fy><bu>/\\\033\[44;33m/g' \
								  -e 's/<fy><bp>/\\\033\[45;33m/g' \
								  -e 's/<fy><bc>/\\\033\[46;33m/g' \
								  -e 's/<fy><bw>/\\\033\[47;33m/g' \
								  \
								  -e 's/<fu><bb>/\\\033\[40;34m/g' \
								  -e 's/<fu><br>/\\\033\[41;34m/g' \
								  -e 's/<fu><bg>/\\\033\[42;34m/g' \
								  -e 's/<fu><by>/\\\033\[43;34m/g' \
								  -e 's/<fu><bu>/\\\033\[44;34m/g' \
								  -e 's/<fu><bp>/\\\033\[45;34m/g' \
								  -e 's/<fu><bc>/\\\033\[46;34m/g' \
								  -e 's/<fu><bw>/\\\033\[47;34m/g' \
								  \
								  -e 's/<fp><bb>/\\\033\[40;35m/g' \
								  -e 's/<fp><br>/\\\033\[41;35m/g' \
								  -e 's/<fp><bg>/\\\033\[42;35m/g' \
								  -e 's/<fp><by>/\\\033\[43;35m/g' \
								  -e 's/<fp><bu>/\\\033\[44;35m/g' \
								  -e 's/<fp><bp>/\\\033\[45;35m/g' \
								  -e 's/<fp><bc>/\\\033\[46;35m/g' \
								  -e 's/<fp><bw>/\\\033\[47;35m/g' \
								  \
								  -e 's/<fc><bb>/\\\033\[40;36m/g' \
								  -e 's/<fc><br>/\\\033\[41;36m/g' \
								  -e 's/<fc><bg>/\\\033\[42;36m/g' \
								  -e 's/<fc><by>/\\\033\[43;36m/g' \
								  -e 's/<fc><bu>/\\\033\[44;36m/g' \
								  -e 's/<fc><bp>/\\\033\[45;36m/g' \
								  -e 's/<fc><bc>/\\\033\[46;36m/g' \
								  -e 's/<fc><bw>/\\\033\[47;36m/g' \
								  \
								  -e 's/<fw><bb>/\\\033\[40;37m/g' \
								  -e 's/<fw><br>/\\\033\[41;37m/g' \
								  -e 's/<fw><bg>/\\\033\[42;37m/g' \
								  -e 's/<fw><by>/\\\033\[43;37m/g' \
								  -e 's/<fw><bu>/\\\033\[44;37m/g' \
								  -e 's/<fw><bp>/\\\033\[45;37m/g' \
								  -e 's/<fw><bc>/\\\033\[46;37m/g' \
								  -e 's/<fw><bw>/\\\033\[47;37m/g' \
								  \
	  							  -e 's/<d>/\\\033\[0m/g' \
	  							  -e 's/$/\\\033\[0m/g'`

	if [ $(basename $SHELL) == 'ksh' ]; then
		echo $tmp_str
	else
		echo -e $tmp_str
	fi
}

# sample
cecho "<fb><bb>abc"
cecho "<fr><bu>red + blue<fb><bc>black + Cyan"
echo "xxxxxx"


