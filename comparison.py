#!/usr/bin/env python3.11
import argparse
import pandas as pd
import h5py
import numpy as np

parser = argparse.ArgumentParser(description="Compare all columns of HDF5 and CSV datasets as numeric values.")
parser.add_argument("hdf5_file", help="Path to the HDF5 file.")
parser.add_argument("data_set_path", help="Path of the dataset within the HDF5 file.")
parser.add_argument("csv_file", help="Path to the CSV file.")

args = parser.parse_args()

parent_group_path = args.data_set_path.rsplit('/', 1)[0]

with h5py.File(args.hdf5_file, 'r') as f:
    hdf5_data = np.array(f[args.data_set_path])
    hdf5_columns = list(f[parent_group_path].attrs['column_names'])  # Using the parent group path
    df_hdf5 = pd.DataFrame(hdf5_data, columns=hdf5_columns).applymap(lambda x: x.decode('utf-8') if isinstance(x, bytes) else x)

# Drop the index column from df_hdf5 if it exists
if 'index' in df_hdf5.columns:
    df_hdf5.drop('index', axis=1, inplace=True)

df_csv = pd.read_csv(args.csv_file, dtype=str, header=None, names=hdf5_columns)

# Print the datasets being compared
print("Datasets being compared:")
print("HDF5 Dataset:", args.data_set_path)
print("CSV Dataset:", args.csv_file)

# Print the DataFrames
print("DataFrame from HDF5 dataset:")
print(df_hdf5)
print("DataFrame from CSV dataset:")
print(df_csv)

# Convert 'nan' to NaN in df_csv
df_csv.replace('nan', np.nan, inplace=True)

# Initialize a DataFrame to hold comparison results
comparison_results = pd.DataFrame()

for col in hdf5_columns:
    # Filter out NaN values for comparison
    mask = ~(df_hdf5[col].isna() | df_csv[col].isna())
    comparison_results[col] = df_hdf5[col][mask] == df_csv[col][mask]

are_all_values_exact = comparison_results.all(axis=None)

print("Are all values exactly the same for all non-NaN columns?", are_all_values_exact)
