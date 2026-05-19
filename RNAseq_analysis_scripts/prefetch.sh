#!/bin/bash
#SBATCH --job-name=prefetch
#SBATCH --output=../logs/SLURM_out/fastq_download_%A_%a.out
#SBATCH --output=../logs/SLURM_err/error=fastq_download_%A_%a.err
#SBATCH --array=1-32
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=14400
#SBATCH --time=4:00:00

accession=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ../meta/SRR_Acc_List.txt)

prefetch $accession --output-directory ../raw_data/sra