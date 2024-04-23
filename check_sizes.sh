#!/bin/bash
set -eu

temp_file=$(mktemp)

while read -r line; do
    # Extracting the year and month directly from the given path
    year_month=$(echo "$line" | awk -F'/' '{print $NF}' | sed 's/[^0-9]*//g')

    # Ensure year_month has the correct length (6 characters: 4 for the year, 2 for the month)
    if [ ${#year_month} -ne 6 ]; then
        echo "Year and month extraction failed for line: $line" >&2
        continue
    fi

    additional_file_path="/work/pa24/kpanag/output/${year_month}.h5"

    if [ -f "$additional_file_path" ]; then
        # If the file exists, get its size in bytes for accuracy
        additional_file_size_bytes=$(du -b "${additional_file_path}" | awk '{print $1}')
        # Convert to gigabytes for consistency with the line format
        additional_file_size=$(echo "$additional_file_size_bytes" | awk '{printf "%.2fG", $1/1024/1024/1024}')
    else
        # Handle the case where the file doesn't exist
        additional_file_size="N/A"
        additional_file_size_bytes=0
    fi

    original_size_bytes=$(echo "$line" | awk '{print $1}' | sed 's/G//' | awk '{printf "%.0f", $1*1024*1024*1024}')
    if [[ "$additional_file_size_bytes" -gt 0 && "$original_size_bytes" -gt 0 ]]; then
        # Calculate ratio as a floating point number, preserving two decimal places
        ratio=$(awk -v orig="$original_size_bytes" -v add="$additional_file_size_bytes" 'BEGIN{printf "%.2f", add/orig}')
    else
        ratio="N/A"
    fi

    new_line="${line}    ${additional_file_size}    ${additional_file_path}    ${ratio}"

    echo "$new_line" >> "$temp_file"
done < rmemo_weights

mv "$temp_file" memo_hdf_weights

# Recalculate average ratio excluding lines where ratio is "N/A"
avg_ratio=$(awk '$5 != "N/A" { total += $5; count++ } END { if (count > 0) avg = total / count; printf "%.2f", avg }' memo_hdf_weights)

awk -v avg_ratio="$avg_ratio" '$5 != "N/A" && $5 < (avg_ratio * 0.8) { print $0 }' memo_hdf_weights > low_hdf_size

awk '$5 != "N/A" && $5 < 1 { print $0 }' memo_hdf_weights > extra_low_weights
