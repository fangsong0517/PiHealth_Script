#!/bin/bash
if [[ $# -lt 1 ]];then
    echo "Usage:$0 DyAver"
fi


Time=`date +"%Y-%m-%d__%H:%M:%S"`
DyAver=$1

if [[ ${DyAver}x == x ]];then
    exit 1
fi
#数组 0是总的 1是用的
MemValues=(`free -m | head -2| tail -1|awk '{printf("%s %s",$2,$3)}'`)

MemUsedPrec=`echo "scale=1; ${MemValues[1]}*100/${MemValues[0]}" | bc`
NowAver=`echo "scale=1; 0.7*${MemUsedPrec}+0.3*${DyAver}" | bc`

echo "${Time} ${MemValues[0]}M $[ ${MemValues[0]-${MemValues[1]}} ]M ${MemUsedPrec}% ${NowAver}%"






#nowtime=`date +"%Y-%m-%d__%H:%M:%S"`
#总量+剩余量
#mem_size=`free -m | grep "内存" | awk '{printf("%d %d", $2, $4);}'`
#剩余量
#mem_sy=`echo $mem_size | cut -d " " -f2`
#总量
#mem_total=`echo $mem_size | cut -d " " -f1`
#当前占用(%)
#bnum=`echo "scale=1;($mem_total - $mem_sy) * 100 / $mem_total"|bc`
#占用百分比动态平均值
#per_equal=`echo "scale=1;0.3*$1+0.7*$bnum" | bc`
#echo "$nowtime ${mem_total}M ${mem_sy}M $bnum% $per_equal%"

