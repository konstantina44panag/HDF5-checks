#!/bin/bash
set -eu

year="$1"
month=$(printf '%02d' "$2")
HDF5_FILE="/work/pa24/kpanag/output/${year}${month}.h5"

if [ -f "$HDF5_FILE" ]; then
    h5ls -r "$HDF5_FILE" > /work/pa24/kpanag/hdf_check_byname/hdf_contents/hdf_files_${year}${month}
    while IFS= read -r file; do
        if [[ $file =~ ([^_]+)_${year}${month}([0-9]{2})\.sas7bdat\.(gz|bz2) ]]; then
            type=${BASH_REMATCH[1]}
            day=${BASH_REMATCH[2]}
            group="day$day"
            if [ "$type" = "nbbo" ]; then
                type="complete_nbbo"
            fi
        elif [[ $file =~ ([^_]+)_${year}${month}\.sas7bdat\.(gz|bz2) ]]; then
            type=${BASH_REMATCH[1]}
            group="monthly"
        elif [[ $file =~ taq\.WCT_${year}${month}([0-9]{2})\.zip ]]; then
            type="wct"
            day=${BASH_REMATCH[1]}
            group="day$day"
        else
            continue
        fi
        match_count=0
        match_count=$(grep -Eo "/$group/$type/table" /work/pa24/kpanag/hdf_check_byname/hdf_contents/hdf_files_${year}${month} | wc -l)
        if [ "$match_count" -gt 0 ]; then
            echo "Matches for /$group/$type/: $match_count" >> /work/pa24/kpanag/hdf_check_byname/results/result_${year}${month}
        else
            echo "No matches found for /$group/$type/" >> /work/pa24/kpanag/hdf_check_byname/results/result_${year}${month}
        fi
    done < /work/pa24/kpanag/hdf_check_byname/memo_files${year}
else
    echo "$HDF5_FILE does not exist " >> /work/pa24/kpanag/hdf_check_byname/results/result_${year}${month}
fi
