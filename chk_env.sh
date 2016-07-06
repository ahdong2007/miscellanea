#!/bin/bash

#
# echo the status with same column size
#
echo_ok() {
  COL_SIZE=60
  STRING="$1"
  echo -e "${STRING} \\033[${COL_SIZE}G [\\033[1;32m ok \\033[0;39m]"
}

echo_failure() {
  COL_SIZE=60
  STRING="$1"
  echo -e "${STRING} \\033[${COL_SIZE}G [\\033[1;31mFAILED\\033[0;39m]"
}

check_pwd_strategy() {

	cat /etc/login.defs | grep '^PASS'
}

check_no_passwd() {

        flag=0

	for user in $(awk -F: '($2 == "") {print $1}' /etc/shadow)
	do
		echo_failure "user $user did't setup a password"
                flag=1
	done

        if [ $flag -eq 0 ]; then
                echo_ok "No user has empty passwd"
        fi
}

set_users() {


        chattr -i /etc/passwd
        chattr -i /etc/shadow
        chattr -i /etc/group
        chattr -i /etc/gshadow

	# games, ftp
	for user in $(echo -e "adm\nlp\nsync\nshutdown\nhalt\nnews\nuucp\noperator\ngopher")
	do
		# userdel $user
                id $user >/dev/null 2>&1
                if [ $? -eq 0 ]; then
		      chsh -s /sbin/nologin $user >/dev/null 2>&1
                      echo_ok "Changed shell to /sbin/nologin for $user"
                fi
	done

	chattr +i /etc/passwd
	chattr +i /etc/shadow
	chattr +i /etc/group
	chattr +i /etc/gshadow
}


set_home() {

	for attr in $(awk -F: 'BEGIN{OFS=","} ($3 >= 500) {print $1,$6}' /etc/passwd)
	do
                dir=$(echo $attr | cut -d, -f2)
                user=$(echo $attr | cut -d, -f1)

		chmod g-rwx $dir
		chmod o-rwx $dir
                echo_ok "Changed for user $user: chmod g-rwx $dir"
                echo_ok "Changed for user $user: chmod o-rwx $dir"
	done
}


find_vio_files() {
	echo "empty"
#[root@localhost ~]#  echo $PATH | egrep '(^|:)(\.|:|$)'	# 检查是否包含父目录
#[root@localhost ~]#  find `echo $PATH | tr ':' ' '` -type d \( -perm -002 -o -perm -020 \) -ls	
}


set_selinux() {

	selinux_cfg='/etc/sysconfig/selinux'

	# make a copy first
	\cp $selinux_cfg ${selinux_cfg}.bak

	sed -i 's/^SELINUX=.\+/SELINUX=permissive/g' $selinux_cfg

        echo_ok "setup SELinux"

}

check_root_user() {

        flag=0

	for user in $(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
	do
		if [ "$user" != "root" ]; then
			echo_failure "user $user can't has UID=0"
                        flag=1
		fi
	done

        if [  $flag -eq 0 ]; then
                echo_ok "Only root has uid=0"
        fi
}


# main function
##屏蔽CTRL + C, CTRL + Z 等中断SHELL的操作           
trap "" 2 3 15 18                                    
                                                     
while [ 1 ]
do
        clear
        num=1
        echo -e "\r\r\r\r\r"
        echo -e "\t\t\t ===================="
        echo -e "\t\t\t Linux系统安全管理菜单"
        echo -e "\t\t\t ==================="
        echo ""
        echo -e "\t\t\ta.  执行下面1-6步"
        echo ""
        echo -e "\t\t\t1).  检查密码安全策略"
        echo -e "\t\t\t2).  检查密码为空的用户"
        echo -e "\t\t\t3).  检查uid=0的用户"
        echo -e "\t\t\t4).  清除不必要的系统账户"
        echo -e "\t\t\t5).  检查用户主目录权限"
        echo -e "\t\t\t6).  设置SELinux"
        echo -e "\t\t\t7).  用户umask值检查"
        echo ""
        echo -e "\t\t\tQ.  Quit"
        echo ""
        echo -e "\t\t\tPlease select:\c"
        
        read CHOICE
        case $CHOICE in
                1)      clear
                        echo -e "\n\n\n\n\n\n\n"
                        check_pwd_strategy 1
                        echo "Press enter to continue..."
                        read qqq
                        continue
                        ;;
                2)      clear
                        echo -e "\n\n\n\n\n\n\n"
                        check_no_passwd 2
                        echo "Press enter to continue..."
                        read qqq
                        continue
                        ;;
                3)      clear
                        echo -e "\n\n\n\n\n\n\n"
                        check_root_user 3
                        echo "Press enter to continue..."
                        read qqq
                        continue
                        ;;
                4)      clear
                        echo -e "\n\n\n\n\n\n\n"
                        set_users 4
                        echo "Press enter to continue..."
                        read qqq
                        continue
                        ;;
                5)      clear
                        echo -e "\n\n\n\n\n\n\n"
                        set_home 5
                        echo "Press enter to continue..."
                        read qqq
                        continue
                        ;;
                6)      clear
                        echo -e "\n\n\n\n\n\n\n"
                        set_selinux 6
                        echo "Press enter to continue..."
                        read qqq
                        continue
                        ;;
                Q|q)    clear
                        exit
                        ;;
                a|A)    clear
                        echo -e "\n\n\n\n\n\n\n"
                        echo "Press enter to continue..."
                        read qqq
                        continue
                        ;;
                *)      clear
                        continue
                        ;;
        esac    
done
