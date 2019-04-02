#!/bin/bash
#######################################################
# File Name: update_git2.2.1.sh                       #
# Author: drinkboy                                    #
# Mail: drinkboy@qq.com                               #
# Description: update git                             #
# Created Time:  2019 / 04 / 01                       #
#######################################################

git_check()
{
    command -v git  >/dev/null 2>&1
    if [ ! $? -ne  0 ] ;then
        git_version=`git version`
        echo "$git_version"
    else
        echo -e "\033[33m git is not installed! \033[0m"
        echo -e "\033[32m And you can install by yum -y install git \033[0m"
        exit
    fi
}

git_update()
{
    mkdir /usr/src/software -p
    cd  /usr/src/software
    ## install libiconv ##
    rm -rf libiconv-1.14
    if [ ! -f libiconv-1.14.tar.gz ];then
        wget  http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
    fi
    tar zxvf libiconv-1.14.tar.gz
    cd libiconv-1.14
    ./configure --prefix=/usr/local/libiconv
    sed -i '1010d' srclib/stdio.h
    make && make install
    echo "libiconv is ok"
    cd  ..
    ## install rpms ##
    yum -y  install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc gcc perl-ExtUtils-MakeMaker tcl xmlto
    ## install asciidoc ##
    rm -rf asciidoc-8.6.9
    if [ ! -f asciidoc-8.6.9.zip ];then
        wget --no-check-certificate https://jaist.dl.sourceforge.net/project/asciidoc/asciidoc/8.6.9/asciidoc-8.6.9.zip
    fi
    unzip asciidoc-8.6.9.zip
    cd asciidoc-8.6.9
    ./configure
    make && make install
    echo "asciidoc is ok"
    cd ..
    ## install git ##
    rm -rf git-2.2.1
    if [ ! -f v2.2.1.tar.gz ];then
        wget https://github.com/git/git/archive/v2.2.1.tar.gz
    fi
    tar zxvf v2.2.1.tar.gz
    cd git-2.2.1
    make configure
    ./configure --prefix=/usr/local/git --with-iconv=/usr/local/libiconv
    make all doc
    make install install-doc install-html
    echo "export PATH=$PATH:/usr/local/git/bin:/usr/local/git/libexec/git-core" >> /etc/bashrc
    cd ..
    mv /usr/bin/git /usr/bin/git.old
    ln -s /usr/local/git/bin/git /usr/bin/git
    echo "git update success"
    git_new_version=`git version`
    echo "$git_new_version"
}
git_check
git_update
