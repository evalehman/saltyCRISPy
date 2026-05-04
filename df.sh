# Run DefenseFinder on a directory full of genomes or proteomes 
# Input: directory
# Usage example: ./df.sh freshwaterGenomes
# Before running: conda activate defense-finder

INPUT_PATH=$1

cd $1

#Loop over all files and run Defense Finder
for acc_file in *.fa*; do
	echo "Running defense finder on $acc_file"
	defense-finder run $acc_file --out-dir dfOutput
	echo "Ran defense finder on $acc_fasta successfully"
done

