# Project info

The aim of this project is to compile the public RNA-datasets for different embryo stages of Arabidopsis, together with some different tissues, into expression levels and make plots for their expression levels.
.sh root dir: scripts/
R root dir: R project

# Get data
```
sbatch prefetch.sh # adapt to embryo datasets
sbatch fasterq-dump.sh # adapt to embryo datasets
```

# QC and Trimming
```
sbatch fastqc.sh
sbatch fastp.sh
sbatch fastqc_fastp.sh
```

# Pseudo-aliganment
```
sbatch kallisto_quant.sh
```

# R: read the kallisto results and write tpm matrix
```
cd ../Rproject
rscript sleuth.Rmd
```

# Add seedling datasets
```
# get data
# code missing # wget data from url in meta/seedling_RNAseq_E-MTAB-10965.txt
# qc and trimming
sbatch fastqc.sh # adapt to seedling datasets
sbatch sdl_fastp.sh
sbatch fastqc_fastp.sh # adapt to seedling datasets
# pseudo-alignment
sbatch sdl_kallisto.sh
# R: read the kallisto results and write tpm matrix
cd ../Rproject
rscript sdl_sleuth.R
```

# Add flower datasets
```
# get data
sbatch prefetch.sh # adapt to flower datasets
sbatch fasterq-dump.sh # adapt to flower datasets
# qc and trimming
sbatch fastqc.sh # adapt to flw datasets
sbatch flw_fastp.sh
sbatch fastqc_fastp.sh # adapt to seedling datasets
# pseudo-alignment
sbatch flw_kallisto.sh
# R: read the kallisto results and write tpm matrix
cd ../Rproject
rscript flw_sleuth.R
```

# Make plots
```
Rscript main.plot_normalized_expression.R
```

# Normalize data and log2+1 transformation
```
Rscript sleuth_all_and_norm.R
main.plot_normalized_expression.R
```

# add another seedling dataset
```
# use seedling RNA seq from GSE67322 (14D)
# get data
sbatch sdl2_prefectch.sh
mkdir ../raw_data/fastq/sdlingsRNA-seq_2
sbatch sdl2_fasterq-dump.sh
# QC and trimming
sbatch sdl2_fastqc.sh
bash sdl2_fastp.sh
sbatch sdl2_fastqc2.sh
```

# Plots for PRC1 related genes and possible recruiters
The embryo H2AUb datasets revealed that there are genes, perticularly related to seed development, are marked by H2AUb in embryos as well as in seedlings. However in seedlings they are able to recuit PRC2 for H3K27me3 and therefore repression, while in embryos it is not the case. Sara is interesred to see what makes the difference in embryos and seedlings, and suggested the difference may lay in the different expression of PRC1 subunits or potential PRC2 recruiter. Therefore I will plot for the expression of PRC1 subunits and possible reruiters in embryos and seedlings.
'''
Rscript heatPlots_PRC1related_andPossibleRecruiters.R
'''