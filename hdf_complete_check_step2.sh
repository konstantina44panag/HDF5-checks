#!/bin/bash
set -eu

# Take year and month as arguments
year=$1
m=$2

# Format the month to always be two digits
month=$(printf '%02d' $m)
result_file="/work/pa24/kpanag/hdf_check_byname/results/result_${year}${month}"

if [ -f "$result_file" ]; then
    avg_count=$(awk '{ total += $NF; count++ } END { if (count > 0) printf "%f", total / count; else print "0" }' "$result_file")
    awk -v avg="$avg_count" '$NF < (avg * 0.7) { print $0 }' "$result_file" >> "/work/pa24/kpanag/hdf_check_byname/small_data/little_datasets_${year}${month}"
    awk '/^No matches found for|does not exist/ { print $0 }' "$result_file" >> "/work/pa24/kpanag/hdf_check_byname/absent_data/absent_files${year}${month}"
else
    echo "The result file $result_file does not exist."
fi
