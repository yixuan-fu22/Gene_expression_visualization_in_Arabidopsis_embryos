#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --output=../logs/SLURM_out/%A_%a.out
#SBATCH --output=../logs/SLURM_err/%A_%a.err
#SBATCH --array=0-4
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=14400
#SBATCH --time=4:00:00

eval "$(conda shell.bash hook)"
conda activate fastqc

filenames=( $(find ../results/sdl2_fastp -type f -name \*.fastq) )

mkdir -p ../results/sdl2_fastqc2

fastqc ${filenames[$SLURM_ARRAY_TASK_ID]} -o ../results/sdl2_fastqc2
