# Downloads multiple genomes with EDirect
# Input: path to tsv file, column containing accession numbers, directory
# Usage example: ./genomegrabber.sh input_files/inputfile.tsv 3 freshwater_genomes
# Before running: mkdir DIR_NAME 
# Make sure you have EDirect installed

INPUT_PATH=$1
COL=$2

DATA=$(cut -f $COL $INPUT_PATH | tail -n +2)
cd $3
for acc in $DATA; do
	# Set-up
	mkdir $acc
	cd $acc

	# Download
	echo Downloading $acc.fasta
	esearch -db assembly -query $acc | elink -target nuccore | efetch -format fasta > $acc.fasta
	echo Downloaded $acc.fasta successfully

	cd ..
done
