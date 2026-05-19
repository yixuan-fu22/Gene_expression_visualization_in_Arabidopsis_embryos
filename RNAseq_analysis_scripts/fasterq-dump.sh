#!/bin/bash
#SBATCH --job-name=fasterq-dump
#SBATCH --output=../logs/SLURM_out/fasterq-dump%A_%a.out
#SBATCH --error=../logs/SLURM_err/fasterq-dump%A_%a.err
#SBATCH --array=1-32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time=4:00:00


# Read the accession from the file based on the SLURM array task ID
accession=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ../meta/SRR_Acc_List.txt)

# Use fasterq-dump to download the fastq files
fasterq-dump ../raw_data/sra/$accession --outdir ../raw_data/fastq