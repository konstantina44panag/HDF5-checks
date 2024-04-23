#FOR THE CHECK OF COMPLETE TRANSFER OF SAS FILES TO HDF5

#1.create_memof.sh

This creates monthly lists of all sas files in storage
#2.hdf_complete_check1.sh

This creates montlhy lists of all contents in hdf5 files inside a folder hdf_contents
For every filename in storage e.g. ctm_YYYYMMDD.sas7bdat.*, it counts the matches for all stocks found in the monthly HDF5 file e.g. STOCK_NAME/dayDD/ctm/table, or prints a negative message"No matches found for dayDD/ctm" ,"YYYYMM.h5 does not exist " 
And stores the matches or negative messsages to monthly "result" files

#3.hdf_complete_check_step2.s

For every month-year, this searches the "result" files, finds an average number of matches/stocks and prints the filenames e.g. dayDD/ctm/ with lower than average matches to little_datasets_${year}${month}
It also finds the negative messages the filenames e.g. dayDD/ctm/ to the absent_files${year}${month}

#4.The findings are:

1.Only the files: div_YYYYMMM have small nubmer of "stock" datasets in hdf5 files
2.The monthly absent files contain altogether:

 -absent_files201201
No matches found for /day02/mastm/
No matches found for /day16/mastm/
[kpanag@login02 absent_data]$  cat absent_files201202
No matches found for /day20/mastm/
The above mastm files are originally empty !

 -absent*
No matches found for /day07/wct/
No matches found for /day23/wct/
No matches found for /day30/wct/
But the above come from falsely named zipped folders that a cssv file from a different name and the correct names exist!



#5.check_sizes.sh

Creates weight ratios between the monthly folders of sas files and the monthly hdf5 files
Prints the months whose weight ratio of HDF5 size over the original folder size, is lower than 1 (since I expect HDF5 to be similar or larger) or lower than the average ratio.
The outputs are empy


#6.comparison.py

This executes and exact comparison of the data inside the original and the hdf5 datasets
I converted random days and types(ctm,nbbo) of sas files to csv files to have access to their data, then run for a random stock:
python3.11 comparison.py output/202201.h5 JJS/day03/ctm/table ctm_20220103/\"JJS\"_ctm_20220103.csv
python3.11 comparison.py output/199807.h5 MEM/day24/cq/table cq_19980724/\"MEM\"_cq_19980724.csv
..
All examined datasets turned out identical
