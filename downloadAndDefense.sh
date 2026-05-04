# Download multiple genomes and run defense-finder on said genomes
# Input: path to tsv file, column containing accession numbers, directory
# Usage example: ./downloadAndDefense.sh input/genomes.tsv 3 freshwaterGenomes
# Before running: conda activate defense-finder

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

	# Defense Finder
	echo Running defense finder on $acc.fasta
	defense-finder run $acc.fasta --out-dir dfOutput
	echo Ran defense finder on $acc.fasta successfully

	# Clean up
	cd ..
done

