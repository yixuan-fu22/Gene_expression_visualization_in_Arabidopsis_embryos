#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --output=../logs/SLURM_out/%A_%a.out
#SBATCH --output=../logs/SLURM_err/%A_%a.err
#SBATCH --array=0-65
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=14400
#SBATCH --time=4:00:00

conda activate fastqc

filenames=( $(find ../results/fastp -type f -name \*.fastq) )

fastqc ${filenames[$SLURM_ARRAY_TASK_ID]} -o ../results/fastqc_trimming
