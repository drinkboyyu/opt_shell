#!/bin/bash
#######################################################
# File Name: update_git2.2.1.sh                       #
# Author: drinkboy                                    #
# Mail: drinkboy@qq.com                               #
# Description: install aview                          #
# Created Time:  2019 / 04 / 04                       #
#######################################################

os_check()
{
    cat /etc/redhat-release  | grep -i centos  >/dev/null 2>&1
    if [ ! $? -ne  0 ] ;then
        os_version=`cat /etc/redhat-release`
        echo "$os_version"
    else
        echo -e "\033[33m Only support Centos \033[0m"
        exit
    fi
}
ins_aalib()
{
    mkdir /usr/src/software -p
    yum install libtool -y
    cd  /usr/src/software
    rm -rf aalib-1.4.0
    if [ ! -f aalib-1.4rc5.tar.gz ];then
        wget  https://jaist.dl.sourceforge.net/project/aa-project/aa-lib/1.4rc5/aalib-1.4rc5.tar.gz
    fi
    tar zxvf aalib-1.4rc5.tar.gz
    cd aalib-1.4.0
    ./configure
    make && make install
    echo "aalib-1.4.0 is ok"
    cd  ..
}
ins_aview()
{
    cd  /usr/src/software
    rm -rf aview-1.3.0
    if [ ! -f aview-1.3.0rc1.tar.gz ];then
        wget http://prdownloads.sourceforge.net/aa-project/aview-1.3.0rc1.tar.gz
    fi
    tar zxvf aview-1.3.0rc1.tar.gz
    cd aview-1.3.0
    ./configure
    make && make install
    yum -y install ImageMagick
    echo "aview-1.3.0 is ok"
    cd  ..
}
os_check
ins_aalib
ins_aview
