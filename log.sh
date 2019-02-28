#/bin/bash
sys_log="/var/log/test.log-`date "+%Y-%m-%d"`"
# func of log
#定义了三个级别的日志
function log_info()
{
  local date=`date`
  local para=$1
  #echo "LOG[INFO]:$date $1" >> $sys_log
  echo -e "\033[32m $date LOG[INFO]:$1 \033[0m" >> $sys_log
}
function log_warn()
{
  local date=`date`
  local para=$1
  #echo "log info:$date $1" >> $sys_log
  echo -e "\033[33m $date LOG[WARN]:$1 \033[0m" >> $sys_log
}
function log_err()
{
  local date=`date`
  local para=$1
  #echo "log err:$date $1" >> $sys_log
  echo -e "\033[31m $date LOG[ERROR]:$1 \033[0m" >> $sys_log
}
log_warn "xxx warning"
log_info "xxx running"
log_err  "xxx error !"
