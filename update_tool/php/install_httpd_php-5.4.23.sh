#!/bin/bash
rm -rf php-5.4.23
if [ ! -f php-5.4.23.tar.gz ];then
  wget http://oss.aliyuncs.com/aliyunecs/onekey/php/php-5.4.23.tar.gz
fi
tar zxvf php-5.4.23.tar.gz
cd php-5.4.23
./configure --prefix=/alidata/server/php \
--with-config-file-path=/alidata/server/php/etc \
--with-apxs2=/alidata/server/httpd/bin/apxs \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-static \
--enable-maintainer-zts \
--enable-zend-multibyte \
--enable-inline-optimization \
--enable-sockets \
--enable-wddx \
--enable-zip \
--enable-calendar \
--enable-bcmath \
--enable-soap \
--with-zlib \
--with-iconv \
--with-gd \
--with-xmlrpc \
--enable-mbstring \
--without-sqlite \
--with-curl \
--enable-ftp \
--with-mcrypt  \
--with-freetype-dir=/usr/local/freetype.2.1.10 \
--with-jpeg-dir=/usr/local/jpeg.6 \
--with-png-dir=/usr/local/libpng.1.2.50 \
--disable-ipv6 \
--disable-debug \
--with-openssl \
--disable-maintainer-zts \
--disable-safe-mode \
--disable-fileinfo

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
cp ./php-5.4.23/php.ini-production /alidata/server/php/etc/php.ini
#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/alidata/server/php/lib/php/extensions/no-debug-non-zts-20100525/"#'  /alidata/server/php/etc/php.ini
sed -i 's#extension_dir = \"\.\/\"#extension_dir = "/alidata/server/php/lib/php/extensions/no-debug-non-zts-20100525/"#'  /alidata/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /alidata/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /alidata/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /alidata/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /alidata/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /alidata/server/php/etc/php.ini
/etc/ini
if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi

mkdir -p /alidata/server/php/lib/php/extensions/no-debug-non-zts-20100525/
if [ $machine == "x86_64" ];then
	  if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz ];then 
		wget http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
	  fi
	  tar zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
	  mv ./ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/ZendGuardLoader.so /alidata/server/php/lib/php/extensions/no-debug-non-zts-20100525/
else
      if [ ! -f ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz ];then 
		wget http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
	  fi
	  tar zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
	  mv ./ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386/php-5.4.x/ZendGuardLoader.so /alidata/server/php/lib/php/extensions/no-debug-non-zts-20100525/
fi
echo "zend_extension=/alidata/server/php/lib/php/extensions/no-debug-non-zts-20100525/ZendGuardLoader.so" >> /alidata/server/php/etc/php.ini
echo "zend_loader.enable=1" >> /alidata/server/php/etc/php.ini
echo "zend_loader.disable_licensing=0" >> /alidata/server/php/etc/php.ini
echo "zend_loader.obfuscation_level_support=3" >> /alidata/server/php/etc/php.ini
echo "zend_loader.license_path=" >> /alidata/server/php/etc/php.ini