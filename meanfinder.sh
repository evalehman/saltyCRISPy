awk -F',' 'FNR>1 
{
    sum[FILENAME]+=$4; count[FILENAME]++
} 
END {
    > means.txt
    for (f in sum) {
        print f, sum[f]/count[f] >> "means.txt"
    } 
}' *.csv
