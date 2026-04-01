#!/bin/bash
#SBATCH --job-name=haloclass         # Job name
#SBATCH --output=haloclass_%j.out    # STDOUT log
#SBATCH --error=haloclass_%j.err     # STDERR log
#SBATCH --time=40:00:00              # Max runtime
#SBATCH --cpus-per-task=1            # 1 CPU
#SBATCH --mem=16G                    # 16 Gb
#SBATCH --partition=debug            # Default partition

# Run the script
python3 haloclass-source/haloclass/publish/gurney_evaluate.py --fasta_dir ncbi_proteins