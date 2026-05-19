eval "$(conda shell.bash hook)"
conda activate fastp

mkdir -p ../results/sdl2_fastp
mkdir -p ../logs/sdl2_fastp_log

fastp -w 16 -l 30 --trim_poly_x --poly_x_min_len 32 \
-i ../raw_data/fastq/seedlingsRNA-seq_2/SRR1931614_1.fastq \
-I ../raw_data/fastq/seedlingsRNA-seq_2/SRR1931614_2.fastq \
-o ../results/sdl2_fastp/SRR1931614_1.fastq \
-O ../results/sdl2_fastp/SRR1931614_2.fastq \
-h ../logs/sdl2_fastp_log/SRR1931614.html \
-j ../logs/sdl2_fastp_log/SRR1931614.json

fastp -w 16 -l 30 --trim_poly_x --poly_x_min_len 32 \
-i ../raw_data/fastq/seedlingsRNA-seq_2/SRR2500947_1.fastq \
-I ../raw_data/fastq/seedlingsRNA-seq_2/SRR2500947_2.fastq \
-o ../results/sdl2_fastp/SRR2500947_1.fastq \
-O ../results/sdl2_fastp/SRR2500947_2.fastq \
-h ../logs/sdl2_fastp_log/SRR2500947.html \
-j ../logs/sdl2_fastp_log/SRR2500947.json