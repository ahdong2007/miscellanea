#!/bin/bash

# be sure run with root
if [ $(id -u) -ne 0 ]; then
	echo "Pls run it with root"
	exit 1
fi

yum_cfg_path='/etc/yum.repos.d'

# get the OS VERSION first
# if [ -f '/etc/redhat-release' ]; then
	
# 	version=$(cat /etc/redhat-release | \
#		sed -e 's/\(.\+\)\([1-9]\)\.\([0-9]\+\)\(.\+\)/\2/')
# fi
version=$(uname -a | sed -e 's/^.\+\.el\([0-9]\).\+$/\1/g')

# suport Linux 5.x, 6.x, 7.x so far
if [ $version -ne 5 -a $version -ne 6 -a $version -ne 7 ]; then
	echo "This version $version is not supported yet"
	exit 1
fi

# disable RedHat subscription-manager
subscription_manager='/etc/yum/pluginconf.d/subscription-manager.conf'
if [ -f $subscription_manager ]; then
	sed -i 's/enabled=1/enabled=0/g' $subscription_manager
fi

cd $yum_cfg_path

# move the old repo(s) to bak
if [ ! -d bak.${version} ]; then
	mkdir -pv bak.${version}
fi

\mv *.repo bak.${version}

# get the new yum repo
url="http://x.x.x.x/repo/L${version}.repo"

wget $url

# run some tests
yum clean all
yum list | tail -10

cd -

exit 0
