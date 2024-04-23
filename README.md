# FOR THE CHECK OF COMPLETE TRANSFER OF SAS FILES TO HDF5

## 1. create_memof.sh

This script creates monthly lists of all SAS files in storage.

## 2. hdf_complete_check1.sh

This script creates monthly lists of all contents in HDF5 files inside a folder `hdf_contents`. For every filename in storage (e.g., `ctm_YYYYMMDD.sas7bdat.*`), it counts the matches for all stocks found in the monthly HDF5 file (e.g., `STOCK_NAME/dayDD/ctm/table`) or prints a negative message if no matches are found. It then stores the matches or negative messages in monthly "result" files.

## 3. hdf_complete_check_step2.sh

This script, for every month-year, searches the "result" files, finds the average number of matches/stocks, and prints the filenames (e.g., `dayDD/ctm/`) with fewer than the average matches to `little_datasets_${year}${month}`. It also identifies the negative messages in the filenames (e.g., `dayDD/ctm/`) and stores them in `absent_files${year}${month}`.

## 4. Findings

1. Only the files `div_YYYYMMM` have a small number of "stock" datasets in HDF5 files.
2. The monthly absent files contain the following:

   - `absent_files201201`
     ```
     No matches found for /day02/mastm/
     No matches found for /day16/mastm/
     ```
     The above `mastm` files are originally empty!

   - `absent_files201202`
     ```
     No matches found for /day20/mastm/
     ```
     The above `mastm` files are originally empty!

   - `absent*`
     ```
     No matches found for /day07/wct/:      taq.WCT_19940507
     No matches found for /day23/wct/:      taq.WCT_19980823
     No matches found for /day30/wct/       taq.WCT_20021130
     ```
     But the above wct filenames come from falsely named zipped folders that contain CSV files with different names. The correct names exist!

## 5. check_sizes.sh

This script creates weight ratios between the monthly folders of SAS files and the monthly HDF5 files. It prints the months whose weight ratio of HDF5 size over the original folder size is lower than 1 (since HDF5 is expected to be similar or larger) or lower than the average ratio. The outputs are empty.

## 6. comparison.py

This script executes an exact comparison of the data inside the original and the HDF5 datasets. It converts random days and types (ctm, nbbo) of SAS files to CSV files to have access to their data, then runs for a random stock:

```bash
python3.11 comparison.py output/202201.h5 JJS/day03/ctm/table ctm_20220103/"JJS"_ctm_20220103.csv
python3.11 comparison.py output/199807.h5 MEM/day24/cq/table cq_19980724/"MEM"_cq_19980724.csv
