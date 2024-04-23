#!/bin/bash
for year in $(seq 1993 1 2006); do
    y=$(printf '%02d' $(expr $year \% 100))  
    ssh panagopkonst@memos1.troias.offices.aueb.gr "cd ../../; ls /taq93-23/taq${year}taq${y}*" > memo_files${year}
done

