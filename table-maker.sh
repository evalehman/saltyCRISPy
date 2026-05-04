# Usage example: ./table-maker.sh DIR1 DIR2 (ect.)

# Create file and headers
echo "Accession Number,Salinity Prediction,Cas Presence,Dataset" > data_table.csv

for arg in "$@"; do
    DATASET=$arg

    # Iterate through subdirectories
    for acc in "${DATASET}"/*/; do
    
        # Get accession/subdirectory names
        ACCESSION=$(basename "$acc") 
        
        # Get normalized mean from normmean.txt under predictions directory
        MEANS=$(grep $ACCESSION predictions_$DATASET/means.txt | cut -d' ' -f2) 
        
        # Get crispr +/- from casresults.txt
        if grep "$ACCESSION" "$DATASET"/casresults.txt | grep "NONE"; then
            CAS="NO"
        else
            CAS="YES"
        fi
        
        # Write to the file
        echo "$ACCESSION,$MEANS,$CAS,$DATASET" >> data_table.csv
    done
done
