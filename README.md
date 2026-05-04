# saltyCRISPy

All scripts written for the saltyCRISPy project are below. Scripts are listed in the order they were ran with the exception of the four scripts at the top. These scripts accomplish similar tasks depending on specific needs. 

## genomegrabber.sh

Downloads multiple genomes with EDirect.

## downloadAndDefense.sh

Downloads multiple genomes with EDirect and runs defense-finder on said genomes.

## protein_downloadAndDefense.sh

Downloads multiple proteomes through NCBI datasets before running defense-finder on said proteomes. 

## df.sh

Runs defense-finder on a directory full of genomes or proteomes. Use if files are already downloaded. 

## casCounter.sh

Counts the number of times "cas" shows up in defense-finder output. This determines Cas gene presence or absence.

## gurney_evaluate.py

Edited Haloclass evaluate.py code. Changed to take an input directory instead of an input file. 

## meanfinder.sh

Takes the mean of all Haloclass salinity predictions per proteome once inside the proper predictions directory. 

## table-maker.sh

Builds a table with accession numbers, salinity predicition means, cas presence/absence detection, and dataset used. 
