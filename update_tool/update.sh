#!/bin/bash
function=change-php
install_log=/var/log/change-info.log
####---- function selection ----begin####
tmp=1
read -p "Please select the function of change-php/change-mysql, input 1 or 2 : " tmp
if [ "$tmp" == "1" ];then
  function=change-php
  tmp=1
  read -p "Please select the php version of 5.2.17/5.3.29/5.4.23/5.5.7, input 1 or 2 or 3 or 4 : " tmp
  if [ "$tmp" == "1" ];then
    php_version=5.2.17
  elif [ "$tmp" == "2" ];then
    php_version=5.3.29
  elif [ "$tmp" == "3" ];then
    php_version=5.4.23
  elif [ "$tmp" == "4" ];then
    php_version=5.5.7
  fi
elif [ "$tmp" == "2" ];then
  function=change-mysql
  tmp=1
  read -p "Please select the mysql version of 5.1.73/5.5.40/5.6.21, input 1 or 2 or 3 : " tmp
  if [ "$tmp" == "1" ];then
     mysql_version=5.1.73
  elif [ "$tmp" == "2" ];then
     mysql_version=5.5.40
  elif [ "$tmp" == "3" ];then
     mysql_version=5.6.21
  fi  
fi
echo ""
echo "You select the function :"
echo "function    : $function"
if echo $function |grep "php" > /dev/null;then
  echo "change the version of php $php_version"
else
  echo "change the version of mysql $mysql_version"
fi
read -p "Enter the y or Y to continue:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
   exit 1
fi
####---- function selection ----end####
####---- stop && backup && dir----start####
if echo $function|grep "php" > /dev/null;then
   ps -ef | grep nginx | grep -v grep
   if [ "$?" -eq "0" ];then
      /etc/init.d/php-fpm stop
	  mv /etc/init.d/php-fpm /etc/init.d/php-fpm.bak
   else
      /etc/init.d/httpd stop
   fi
   php_dir=php-${php_version}
   mkdir  /alidata/server/$php_dir
   rm -rf /alidata/server/php
   ln -s  /alidata/server/$php_dir  /alidata/server/php
else
   ps -ef | grep mysql | grep -v grep
   /etc/init.d/mysqld stop
   mv /etc/init.d/mysqld /etc/init.d/mysqld.bak
   mysql_dir=mysql-${mysql_version}
   mkdir /alidata/server/$mysql_dir
   rm -rf /alidata/server/mysql
   ln -s /alidata/server/$mysql_dir  /alidata/server/mysql
fi
####---- stop && backup && dir----end####
if echo $function|grep "php" > /dev/null;then
   ps -ef | grep nginx | grep -v grep
   if [ "$?" -eq "0" ];then
      ./php/install_nginx_php-${php_version}.sh
   else
      ./php/install_httpd_php-${php_version}.sh
   fi
else
   ./mysql/install_${mysql_dir}.sh
   TMP_PASS=$(date | md5sum |head -c 10)
   /alidata/server/mysql/bin/mysqladmin -u root password "$TMP_PASS"
   echo "mysql new password : $TMP_PASS"
fi
echo "$function is OK!"
