cd /home/yifu/scratch/embryoSeedlingFlower_RNAseq/results/flw_fastq
for i in *.fastq; do kallisto quant \
-i ../../reference_data/kallisto_index/AThalina_RefSeqRNA_withERCC92spike-in.idx \
--single -l 200 -s 100 -t 16 -b 100 -o ../flw_kallisto/${i/.fastq/} $i; done
