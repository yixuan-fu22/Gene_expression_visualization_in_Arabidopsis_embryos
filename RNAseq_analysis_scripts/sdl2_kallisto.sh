#!/bin/bash

mkdir -p ../results/sdl2_kallisto

kallisto quant -t 16 \
-i ../reference_data/kallisto_index/AThalina_RefSeqRNA_withERCC92spike-in.idx \
-o ../results/sdl2_kallisto/SRR1931614 \
-b 100 ../results/sdl2_fastp/SRR1931614_1.fastq \
../results/sdl2_fastp/SRR1931614_2.fastq

kallisto quant -t 16 \
-i ../reference_data/kallisto_index/AThalina_RefSeqRNA_withERCC92spike-in.idx \
-o ../results/sdl2_kallisto/SRR2500947 \
-b 100 ../results/sdl2_fastp/SRR2500947_1.fastq \
../results/sdl2_fastp/SRR2500947_2.fastq