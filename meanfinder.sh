# Takes the mean of all Haloclass salinity protein predictions per proteome 
# Make sure you're already in the proper predictions directory 
# Usage example: ./meanfinder.sh

> means.txt
awk -F',' 'FNR>1 
{
    sum[FILENAME]+=$4; count[FILENAME]++
} 
END {
    for (f in sum) {
        print f, sum[f]/count[f] >> "means.txt"
    } 
}' *.csv
