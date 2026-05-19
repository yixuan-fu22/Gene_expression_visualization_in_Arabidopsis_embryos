#!/bin/bash
#SBATCH --job-name=kallisto_quant
#SBATCH --output=../logs/SLURM_out/%A_%a.out
#SBATCH --output=../logs/SLURM_err/%A_%a.err
#SBATCH --array=56-89
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=14400
#SBATCH --time=4:00:00

kallisto quant -t 4 \
-i ../reference_data/kallisto_index/AThalina_RefSeqRNA_withERCC92spike-in.idx \
-o ../results/kallisto/SRR80543${SLURM_ARRAY_TASK_ID} \
-b 100 ../results/fastp/SRR80543${SLURM_ARRAY_TASK_ID}_1.fastq \
../results/fastp/SRR80543${SLURM_ARRAY_TASK_ID}_2.fastq

# a version with --genomebam (make bam files). Note that bams are very space consuming
# kallisto quant -t 4 \
# -i ../reference_data/kallisto_index/AThalina_RefSeqRNA_withERCC92spike-in.idx \
# -o ../results/kallisto/SRR8054356 \
# -b 100 \
# --genomebam --gtf ../reference_data/kallisto_index/genomic.gtf \
# --chromosomes ../reference_data/kallisto_index/chromosomes.txt \
# ../results/fastp/SRR8054356_1.fastq ../results/fastp/SRR8054356_2.fastq^C
