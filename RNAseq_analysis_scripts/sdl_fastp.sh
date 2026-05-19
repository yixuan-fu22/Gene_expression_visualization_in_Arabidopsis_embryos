#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --output=../logs/SLURM_out/%A_%a.out
#SBATCH --output=../logs/SLURM_err/%A_%a.err
#SBATCH --array=0-1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=14400
#SBATCH --time=4:00:0

fastp -w 16 -l 30 --trim_poly_x --poly_x_min_len 32 \
-i ../raw_data/fastq/embryosRNA-seq/SRR8054356_1.fastq \
-I ../raw_data/fastq/embryosRNA-seq/SRR8054356_2.fastq \
-o ../results/fastp/SRR8054356_1.fastq \
-O ../results/fastp/SRR8054356_2.fastq \
-h ../logs/fastp_log/SRR8054356.html \
-j ../logs/fastp_log/SRR8054356.json
