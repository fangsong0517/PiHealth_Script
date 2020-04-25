#!/bin/bash 
#df -T -m -x tmpfs -x  devtmpfs | tail -n +2 |awk -v ntime=$(date +"%Y-%m-%d__%H:%M:%S") '
#BEGIN{
# num = 0;
# unum = 0;
# hnum = 0;
#}
#{
#    num+=$3;
#    unum+=$4;
#    hnum+=$5;
#    printf("%s 1 %s %s %s %s\n", ntime, $7, $3, $5, $6);
#}
#END{
#printf("%s 0 disk %d %d %.2f%%\n", ntime, num, hunm, unum/num*100);
#}'


Time=`date +"%Y-%m-%d__%H:%M:%S"`

eval `df -T -m -x tmpfd -x devtempfs | tail -n +2 |\
    awk -v DiskSum=0 -v DiskLeft=0 \
       '{printf("Pname["NR"]=%s;Psum["NR"]=%d;Pleft["NR"]=%d;Puseperc["NR"]=%s;",$7, $3, $4, $6);DiskSum+=$3; DiskLeft+=$5} \
       END{printf("Pnum=%d;DiskSum=%d;DiskLeft=%d;", NR, DiskSum, DiskLeft)}'`

for (( i=1; i <= ${Pnum}; i++ ));do
    echo "${Time} 1 ${Pname[$i]} ${Psum[$i]} ${P[$i]} ${Puseperc[$i]}"
done

DiskPerc=$[ (100-${DiskLeft} *100)/${DiskSum} ]
echo "${Time} 0 disk ${DiskSum} ${DiskLeft} ${DiskPerc}"
