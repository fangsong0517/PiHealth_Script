#!/bin/bash
#时间
Time=`date +"%Y-%m-%d__%H:%M:%S"`
#平均负载
LoadAvg=`cut -d " " -f 1-3 /proc/loadavg`
#Cpu温度
CpuTemp=`cat /sys/class/thermal/thermal_zone0/temp`
CpuTemp=`echo "scale=2;$CpuTemp/1000" | bc`

eval $(head -n 1 /proc/stat | awk -v Sum1=0 '{for(i = 2;i<=11;i++){Sum1=Sum1+$i}
printf("Sum1=%d;Idle1=%d", Sum1, $5)}')

sleep 0.5

eval $(head -n 1 /proc/stat | awk -v sum2=0 '{for(i = 2;i<=11;i++){sum2=sum2+$i}
printf("Sum2=%d;Idle2=%d", sum2, $5)}')

#CPU占用率
CpuUsedPerc=`echo "scale=4;(1-(${Idle2} - ${Idle1})/(${Sum2} - ${Sum1}))*100"|bc`
CpuUsedPerc=`printf "%.2f" "${CpuUsedPerc}"`

WarnLevel="normal"

if [[ `echo "${CpuTemp} >= 70" | bc -l` == 1 ]];then
    WarnLevel="warning"
elif [[ `echo "${CpuTemp} >= 50" | bc -l` == 1 ]];then
    WarnLevel="note"
fi

echo "$Time $LoadAvg $CpuUsedPerc% ${CpuTemp}℃  ${WarnLevel}"









#nowtime_load=`date +"%Y-%m-%d__%H:%M:%S "``uptime | tr -s " " "\n" | tr -s "," " "|awk NF | tail -3 | tr -s "\n" " "`
#开机后总时间
#cpu_local1=`cat /proc/stat | grep -w 'cpu'|awk '{printf("%d", $2+$3+$4+$5+$6+$7+$8);}'`
#开机后累计休闲
#cpu_idle1=`cat /proc/stat | grep -w 'cpu' | awk '{printf("%d", $5);}'`

#sleep 0.5s

#开机后总时间
#cpu_local2=`cat /proc/stat | grep -w 'cpu'|awk '{printf("%d", $2+$3+$4+$5+$6+$7+$8);}'`
#开机后累计休闲
#cpu_idle2=`cat /proc/stat | grep -w 'cpu' | awk '{printf("%d", $5);}'`

#(( cpu_local=$cpu_local2-$cpu_local1 ))
#(( cpu_idle=$cpu_idle2-$cpu_idle1 ))
#cpu占用率
#cpu_usage=`echo "$cpu_local $cpu_idle" | awk '{printf("%.2f%%",(1 - $2 / $1)*100);}'`
#cpu温度
#cpu_temp=`cat /sys/class/thermal/thermal_zone0/temp | awk '{
#if($1 >= 1000 && $1 < 50000) {
#    printf("%.2f note", $1 / 1000);
#} else if($1 >= 50000 && $1 <= 70000) {
#    printf("%.2f note", $1 /1000);
#} else {
#    printf("%.2f warning", $1 / 1000);
#}
#}'`
#echo "$nowtime_load $cpu_usage $cpu_temp"

