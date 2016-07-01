#!/bin/bash

#
# 信息技术中心 平台组 华远东
#
# 日期        变更人        变更          
# 2016/07/01  华远东        初始版本
#
#

DEBUG=TRUE

echo_ok() {
  COL_SIZE=80
  STRING="$1"
  echo -e "${STRING} \\033[${COL_SIZE}G [\\033[1;32m ok \\033[0;39m]"
}

echo_failure() {
  COL_SIZE=80
  STRING="$1"
  echo -e "${STRING} \\033[${COL_SIZE}G [\\033[1;31mFAILED\\033[0;39m]"
}

# run it with root
if [ $(id -u) -ne 0 ]; then
    echo_failure "run it with root only"
    exit 1
fi

# close std output and error
# exec 1>/dev/null
# exec 2>/dev/null

disable_usb() {
    cfgfile='/etc/modprobe.d/usb-storage.conf'

    if [ -f $cfgfile ]; then
        if [ $(grep -c '^install usb-storage /bin/true' $cfgfile) -ge 1 ]; then
            [ $DEBUG ] && echo_ok "disable usb"
        fi
    else
        echo "install usb-storage /bin/true" >> $cfgfile
    fi
}

# disable reboot server with control-alt-delete
disable_control_alt_delete() {
    cfgfile='/etc/init/control-alt-delete.conf'
    sed -i 's/^start on control-alt-delete/#start on control-alt-delete/g' $cfgfile
}

pwd_strategy() {
    cfgfile='/etc/pam.d/system-auth-ac'
    # make copy first
    \cp $cfgfile ${cfgfile}.bak
    sed -i "s/password    requisite     pam_cracklib.so.*/password    required      pam_cracklib.so try_first_pass retry=6 minlen=8 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 enforce_for_root/g" $cfgfile
}

pwd_life_time() {

    [ $DEBUG ] ||  { exec 1>/dev/null; exec 2>/dev/null; }

    chattr -i /etc/passwd
    chattr -i /etc/shadow
    chattr -i /etc/group
    chattr -i /etc/gshadow

    chage -d 0 -m 0 -M 90 -W 7 root

    chattr +i /etc/passwd
    chattr +i /etc/shadow
    chattr +i /etc/group
    chattr +i /etc/gshadow

    [ $DEBUG ] ||  { exec 1<&0; exec 2<&0; }
}

disable_users() {

    [ $DEBUG ] ||  { exec 1>/dev/null; exec 2>/dev/null; }

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

    [ $DEBUG ] ||  { exec 1<&0; exec 2<&0; }
}

# check users with uid=0
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
        [ $DEBUG ] && echo_ok "Only root has uid=0"
    fi
}

setup_login_defs() {

    cfgfile='/etc/login.defs'
    
    if [ $(grep -c '^LOG_UNKFAIL_ENAB        no' $cfgfile) -eq 0 ]; then
        echo "LOG_UNKFAIL_ENAB        no" >> $cfgfile
    fi

    if [ $(grep -c '^LASTLOG_ENAB           yes' $cfgfile) -eq 0 ]; then
        echo "LASTLOG_ENAB           yes" >> /etc/login.defs
    fi
}

setup_profile() {

    cfgfile1='/etc/bashrc'

    if [ $(grep -c '^export  HISTTIMEFORMAT' $cfgfile1) -eq 0 ]; then
        echo 'export  HISTTIMEFORMAT="%F %T "' >> $cfgfile1
    fi

    cfgfile2='/etc/profile'
    if [ $(grep -c '^export HISTFILESIZE' $cfgfile2) -eq 0 ]; then
        echo "export HISTFILESIZE=5000" >> $cfgfile2
    fi
}

disable_services() {

    [ $DEBUG ] ||  { exec 1>/dev/null; exec 2>/dev/null; }

    for service in $(echo -e "cups\npostfix\npcscd\nsmarted\nalsasound\niscsitarget\nsmb\nacpid\ntelnet")
    do
        service $service stop
        chkconfig $sevice off
    done

    [ $DEBUG ] ||  { exec 1<&0; exec 2<&0; }
}

set_selinux() {

    selinux_cfg='/etc/sysconfig/selinux'

    # make a copy first
    \cp $selinux_cfg ${selinux_cfg}.bak

    sed -i 's/^SELINUX=.\+/SELINUX=permissive/g' $selinux_cfg

    [ $DEBUG ] && echo_ok "setup SELinux"
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


# main function
# exec 1<&0
# exec 2<&0

disable_usb
echo_ok "task 1: disable usb-storage"

disable_control_alt_delete
echo_ok "task 2: disable Control+Alt+Delete reboot server"

pwd_strategy
echo_ok "task 3: setup password strategy"

pwd_life_time
echo_ok "task 4: setup password life time to 90 days"

disable_users
echo_ok "task 5: disable useless system usrss"

check_root_user
echo_ok "task 6: check uid=0 users"

setup_login_defs
echo_ok "task 7: setup login configurations"

setup_profile
echo_ok "task 8: setup global profile"

disable_services
echo_ok "task 9: stop unnecessary services"

set_selinux
echo_ok "task 10: setup SELinux"

echo "end of task"