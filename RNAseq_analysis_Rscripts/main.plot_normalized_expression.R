# main program for making box or heat plots with expression values

### Load renv
library(renv)
renv::activate()

### load packages and functions
source("./load_libraries.R")
#renv::snapshot()
source("./make_boxplot.R")
source("./make_heatplot.R")
source("./plot_expression.R")

# load normalized expression matrix
normalized_expression <- read.table(file.path("..","results","tpm","embryos_sdl_flw.deseq2normalized.tpm.csv"),sep = ",",
                                    header = TRUE)

# input <- read.table(file.path("input","gene_list.txt"))$V1 # read from file
# plot_expression(input = input, expression = normalized_expression, 
#                plottype = "boxplot",
#  savefolder = "../results/Rplots/Normalized",
#  ylab = "TPM, DEseq2 Normalization")


# Plotting log transformation
# log_normalized_expression <- normalized_expression %>%
#   dplyr::select(-c(tissue,tissue_short,sample)) %>% +1 %>% log2() %>%
#   cbind(., normalized_expression %>% dplyr::select(c(tissue,tissue_short,sample))) %>%
#   select(tissue, tissue_short, sample, everything())
log_normalized_expression <- normalized_expression %>%
  dplyr::select(tissue, tissue_short, sample, everything()) %>%
  mutate(across(where(is.numeric), ~log2(. + 1)))

#input <- read.table(file.path("input","gene_list_Sara310125.txt"))$V1

#input <- c("AT1G21970", "AT5G47670", "AT3G50870", "AT3G15030", "AT4G27160", "AT3G24650")

input <- c("AT5G45830", "AT4G27160", "AT1G69690")

saveFolder <- "../results/Rplots/selectedGenes_forPosterAndPresentation"

#input <- c("AT2G26760", "AT5G67260", "AT3G12280", "AT1G63100")

saveFolder <- "../results/Rplots/cellCycleGenes_forPosterAndPresentation"

plot_expression(input = input, expression = log_normalized_expression, 
                plottype = "heatmap",
                savefolder = saveFolder,
                ylab = "log2(DEseq2-normalized TPM + 1)")

#plot_expression(input = input, expression = log_normalized_expression, 
#                plottype = "boxplot",
#                savefolder = saveFolder,
#                ylab = "log2(DEseq2-normalized TPM + 1)")

 

