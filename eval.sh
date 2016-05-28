

# get the last parameter by using eval 
eval echo \$$#

# create a pointer
x=100
ptrx=x
eval echo \$$ptrx
eval $ptrx=50
echo $x

# we can use ${!n} instead of eval \${$n}

for ((n=1; n<=3; n++))
do
	eval echo \$$n
	echo ${!n}
done 