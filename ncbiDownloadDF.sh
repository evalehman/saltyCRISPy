# Script used to download multiple protein files through NCBI datasets before running Defense Finder on them
# Input: path to tsv file, column containing accession numbers, directory
# Before running: mkdir [DIR_NAME]
# Before running: conda activate saltycrispy
# Usage example: ./ncbiDownloadDF.sh imgInput/img_freshwater_test.tsv 3 DIR_NAME

#!/usr/bin/env bash

INPUT_PATH=$1
COL=$2

DATA=$(cut -f $COL $INPUT_PATH | tail -n +2)
cd $3
for acc in $DATA; do
	# Set-up
	mkdir $acc
	cd $acc

	# Download
	echo Downloading $acc.faa
	datasets download genome accession $acc --include protein

	unzip ncbi_dataset.zip
	mv ncbi_dataset/data/${acc}/protein.faa .
 
	echo Downloaded $acc protein.faa successfully

	# Defense Finder
	echo Running defense finder on $acc protein.faa
	defense-finder run protein.faa --out-dir dfOutput
	echo Ran defense finder on protein.faa successfully

	# Clean up
	cd ..
done

conda deactivate