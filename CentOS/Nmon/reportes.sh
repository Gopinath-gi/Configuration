#!/bin/bash
REPORTS_DIR="/reportes"
export PATH=$PATH:/usr/local/bin

run_daily_report()
{
  local DAILY_REPORT_FILE="$(hostname -s)_$(date +%d-%m-%Y).csv"
  #
  # Recolectar cada 5 min durante 1 dia entero
  nmon -F $REPORTS_DIR/$DAILY_REPORT_FILE -t -s 300 -c 288
}

run_monthly_report()
{
  local MONTHLY_REPORT_FILE="$(hostname -s)_monthly_$(date +%d-%m-%Y).csv"
  local days=$(cal | grep -v "^$" | tail -1 | tr ' ' '\n' | grep -v "^$" | sort -n | tail -1)
  local num=$((($days-1)*24))
  #
  # Recolectar cada hora durante 1 mes entero
  nmon -F $REPORTS_DIR/$MONTHLY_REPORT_FILE -t -s 3600 -c $num
}

check_daily_report()
{
  local DAILY_REPORT_FILE="$(hostname -s)_$(date +%d-%m-%Y).csv"
  local fecha=$(date +%d-%m-%Y)
  local nmonpid=$(ps -ef | grep "[[:blank:]]nmon.*$fecha" | grep -v "monthly" | grep -v grep | awk '{ print $2 }')
  if [ -z "$nmonpid" ]
  then
    local hour=$(date +%H)
    local pending=$((288-($hour*12)))
    #
    # Recolectar cada 5 min durante lo que resta del dia
    nmon -F $REPORTS_DIR/$DAILY_REPORT_FILE -t -s 300 -c $pending
  fi
}

check_monthly_report()
{
  local MONTHLY_REPORT_FILE="$(hostname -s)_monthly_$(date +%d-%m-%Y).csv"
  local fecha=$(date +%d-%m-%Y)
  local nmonpid=$(ps -ef | grep "[[:blank:]]nmon.*monthly.*" | grep -v grep | awk '{ print $2 }')
  local days=$(cal | grep -vE "^($|[[:blank:]]+$)" | tail -1 | tr ' ' '\n' | grep -v "^$" | sort -n | tail -1)
  local num=$((($days)*24))
  if [ -z "$nmonpid" ]
  then
    local hour=$(((($(date +%d | sed -r -e "s/^0+//g")-1)*24)+$(date +%H)))
    local pending=$(($num-$hour))
    #
    # Recolectar cada hora durante lo que resta del mes
    nmon -F $REPORTS_DIR/$MONTHLY_REPORT_FILE -t -s 3600 -c $pending
  fi
}

RUN=0
CHECK=0
DAILY=0
MONTHLY=0
while getopts "rcdm" OPTS
do
  case "$OPTS" in
    r)
      RUN=1
      ;;
    c)
      CHECK=1
      ;;
    d)
      DAILY=1
      ;;
    m)
      MONTHLY=1
      ;;
  esac
done
if [ $RUN -eq 1 ]
then
  if [ $DAILY -eq 1 ]
  then
    run_daily_report
  elif [ $MONTHLY -eq 1 ]
  then
    run_monthly_report
  fi
elif [ $CHECK -eq 1 ]
then
  if [ $DAILY -eq 1 ]
  then
    check_daily_report
  elif [ $MONTHLY -eq 1 ]
  then
    check_monthly_report
  fi
fi
