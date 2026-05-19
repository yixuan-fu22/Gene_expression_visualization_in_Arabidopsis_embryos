#!/bin/bash
#SBATCH --job-name=kallisto_sdl
#SBATCH --output=../logs/SLURM_out/%A_%a.out
#SBATCH --output=../logs/SLURM_err/%A_%a.err
#SBATCH --array=199-200
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=14400
#SBATCH --time=4:00:00

kallisto quant -t 4 \
-i ../reference_data/kallisto_index/AThalina_RefSeqRNA_withERCC92spike-in.idx \
-o ../results/sdl_kallisto/ERR10163${SLURM_ARRAY_TASK_ID} \
-b 100 ../results/sdl_fastp/ERR10163${SLURM_ARRAY_TASK_ID}_1.fastq \
../results/sdl_fastp/ERR10163${SLURM_ARRAY_TASK_ID}_2.fastq
