#!/bin/bash

# take /root as the working directory
wdir='/tmp'
old_pwd=$(pwd)
ssl_tar='openssl-1.0.1t.tar.gz'
ssh_tar='openssh-6.7p1.tar.gz' 
target_ssl='1.0.1t'
target_ssh='6.7p1'

# download tar files
# cd $wdir
# wget https://www.openssl.org/source/openssl-1.0.1t.tar.gz
# wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz

update_open_ssh() {

	# make backup first
	\mv /etc/ssh /etc/ssh.bak

	cd $wdir
	if [ ! -f $ssh_tar ]; then
		echo "OpenSSH tar file is not exists"
		exit 1
	fi
	tar -zxvf $ssh_tar
	cd openssh-6.7p1
	./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-zlib --with-md5-passwords

	if [ $? -ne 0 ]; then
		./configure --prefix=/usr --sysconfdir=/etc/ssh --with-pam --with-zlib --with-md5-passwords --without-hardening
	fi

	make

	# remove old version OpenSSH
	rpm -e `rpm -qa | grep openssh` --allmatches --nodeps

	# check if all remove
	if [ $(rpm -qa | grep openssh | wc -l) -ne 0 ]; then
		echo "remove old version OpenSSH failed, pls check"
		exit 1
	fi

	make install

	\cp ${wdir}/openssh-6.7p1/contrib/redhat/sshd.init /etc/init.d/sshd
	chkconfig --add sshd
	service sshd start	
}

update_open_ssl() {

	# make a backup first
	\mv /usr/bin/openssl /usr/bin/openssl.bak
	\mv /usr/include/openssl/openssl /usr/include/openssl/openssl.bak

	cd $wdir
	if [ ! -f $ssl_tar ]; then
		echo "OpenSSL tar file is not exists"
		exit 1
	fi

	# remove old version OpenSSL first
	rpm -e `rpm -qa | grep openssl` --allmatches --nodeps

	tar -zxvf $ssl_tar
	cd openssl-1.0.1t
	./config --prefix=/usr --shared 
	make
	make install

	if [ ! -f /usr/bin/openssl ]; then
		ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl 
	fi

	if [ ! -f /usr/include/openssl ]; then
		ln -s /usr/local/ssl/include/openssl /usr/include/openssl 
	fi

	# fix errors:
	# ssh: error while loading shared libraries: libcrypto.so.10: cannot open shared object file: No such file or directory
	# libssl.so.10: cannot open shared object file: No such file or directory 
	cd /usr/lib64
	ln -s libssl.so.1.0.0 libssl.so.10
  	ln -s libcrypto.so.1.0.0 libcrypto.so.10

  	# fix bug in RH5.5
  	ln -s libssl.so.1.0.0 libssl.so.6
	ln -s libcrypto.so.1.0.0 libcrypto.so.6

	echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
	ldconfig –v
}

ssl_version=$(openssl version -a | grep OpenSSL | awk -F'[-| ]' '{print $2}')
ssh_version=$(ssh -V 2>&1 | awk -F'[,|_]' '{print $2}')

echo "target OpenSSL version: $target_ssl"
echo "current OpenSSL version: $ssl_version"
echo "target OpenSSH version: $target_ssh"
echo "current OpenSSH version: $ssh_version"

sleep 3

# install packages: zlib、gcc、make、perl、pam、pam-devel
# missing zlib-devel
# make sure yum is available
yum clean all >/dev/null
yum list >/dev/null
if [ $? -ne 0 ]; then
	echo ""
	echo ""
	echo "yum is not available, pls make sure it can be used first"
	exit 1
fi

yum install –y zlib*
yum install -y gcc*
yum install -y make* 
yum install -y perl*
yum install -y pam*
yum install -y pam-devel*

# check if update needed first
if [ "$target_ssl" != "$ssl_version" ]; then
	# update OpenSSH here
	echo "going to update OpenSSL"
	update_open_ssl
fi

if [ "$target_ssh" != "$ssh_version" ]; then
	# update OpenSSH here
	echo "going to update OpenSSH"
	update_open_ssh
fi

# check versions after update
#ssl_version=$(openssl version -a | grep OpenSSL | awk -F'[-| ]' '{print $2}')
ssh_ssl_version=$(ssh -V 2>&1)

echo ""
echo ""
echo "target OpenSSL version: $target_ssl"
echo "target OpenSSH version: $target_ssh"
echo "OpenSSL/OpenSSH version after update: $ssh_ssl_version"
echo ""

# make sure we can login with root after update, bug reported in RH6.3
echo "we need to be sure that we can login with root after update"
ssh_cfg_file='/etc/ssh/sshd_config'
if [ $(cat $ssh_cfg_file | grep -c '^\ *PermitRootLogin yes') -lt 1 ]; then
	echo "PermitRootLogin yes" >> $ssh_cfg_file
fi

if [ $(cat $ssh_cfg_file | grep -c '^\ *PasswordAuthentication yes') -lt 1 ]; then
	echo "PasswordAuthentication yes" >> $ssh_cfg_file
fi

echo "let's check the configure"
cat $ssh_cfg_file | grep '^\ *PermitRootLogin yes'
cat $ssh_cfg_file | grep '^\ *PasswordAuthentication yes'

# back to old path
cd $old_pwd

echo ""
echo ""
echo "Pls restart the ssh manaully: service sshd restart"
echo ""
echo ""

exit 0

