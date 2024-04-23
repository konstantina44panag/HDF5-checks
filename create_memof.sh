#!/bin/bash
for year in $(seq 1993 1 2006); do
    y=$(printf '%02d' $(expr $year \% 100))  
    ssh panagopkonst@memos1.troias.offices.aueb.gr "cd ../../; ls /taq93-23/taq${year}taq${y}*" > memo_files${year}
done

for year in $(seq 2007 1 2023); do
    for m in $(seq 1 1 12); do
    month=$(printf '%02d' $m)
    ssh panagopkonst@memos1.troias.offices.aueb.gr "cd ../../; ls /taq93-23/taq_msec${year}/m${year}${month}" > memo_files${year}${month}
done
