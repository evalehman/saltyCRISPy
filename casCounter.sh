# Script used to count the number of times "Cas" shows up in a directory
# Usage example: ./casCounter.sh freshGenomes
# Where freshGenomes is a directory
cd $1
DIRS=$(ls)
COUNTER=0
for dir in $DIRS; do
    numCas=$(grep "Cas" $dir/dfOutput/protein_defense_finder_systems.tsv | wc -l) 
    # if numCas not 0 add 1
    if [ "$numCas" -ne "0" ]; then
        echo "CrisprCas found in $dir"
        COUNTER=$((COUNTER+1))
    else
        echo "NONE in $dir"
    fi
    
done

TOTAL=$(echo $DIRS | wc -w)
echo "Total genomes with cas found: $COUNTER out of $TOTAL"