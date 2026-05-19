# Using tpm without normalization, the expression levels in some tissues (like sdl) tends to be underestimated 
# and in some tissues (flowers) they tends to be overestimated


# load libraries
library(renv)
renv::activate()

source("./load_libraries.R")

# find kallisto output files
kallisto_dirs <- c("kallisto","sdl_kallisto", "sdl2_kallisto","flw_kallisto")
dir_list <- c()
id_list <- c()
for (i in kallisto_dirs) {
  sample_id <- dir(file.path("..", "results", i))
  kal_dirs <- file.path("..", "results", i, sample_id)
  dir_list <- dir_list %>% append(kal_dirs)
  id_list <- id_list %>% append(sample_id)
}
id_and_dirs <- data.frame(sample_id = id_list, kal_dirs = dir_list)

# read sample infos
info_embryos <- read.table(file.path("..", "meta" ,"embryo_SraRunTable.txt"), 
                           sep = "," , header = TRUE) %>%
  rename("Run" = "sample_id")

info_sdl <- read.table(file.path("..", "meta" ,"seedling_RNAseq_E_MTAB-10965_list.txt"), 
           sep = "," , header = TRUE) %>%
  rename("sample"="sample_id")

# add sdl2
info_sdl2 <- read.table(file.path("..", "meta" ,"sdl2_SraRunTable.txt"), 
                        sep = "," , header = TRUE) %>%
  rename("Run"="sample_id")

# add flw
info_flw <- read.table(file.path("..", "meta" ,"flower_SraRunTable.txt"), 
                          sep = "," , header = TRUE)  %>%
  rename("Run"="sample_id")

info_all <- rbind(info_flw %>% dplyr::select(sample_id, condition = tissue),
      info_embryos %>% dplyr::select(sample_id, condition = tissue),
      info_sdl %>% dplyr::select(sample_id, condition = tissue),
      info_sdl2 %>% dplyr::select(sample_id, condition = tissue))

sample_table <- merge(info_all, id_and_dirs)

# read by sleuth
s2c <- sample_table %>% dplyr::select(sample = sample_id, condition, path = kal_dirs)
so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE)
# get both the raw and normalized matrix # Default normalization method of sleuth: DEseq2 normalization
sleuth_matrix_raw <- sleuth_to_matrix(so, which_df = "obs_raw", which_units = "tpm") %>% as.data.frame()
sleuth_matrix_norm <- sleuth_to_matrix(so, which_df = "obs_norm", which_units = "tpm") %>% as.data.frame()


# check the sum
colSums(sleuth_matrix_raw)
colSums(sleuth_matrix_norm) # sum raw = 1M while sum norm not, which makes sense

# use norm matrix to continue
refseq_to_geneid <- read.table(file.path("..","reference_data","kallisto_index","refseq_to_geneid.tsv"), sep = "\t") %>% rename(V1="chromosome", V2="TAIR", V3="refseq")
counting_matrix <- merge(sleuth_matrix_norm, refseq_to_geneid, by.x = "row.names", by.y = "refseq", all.x = TRUE)
#check if there are NAs
sum(is.na(counting_matrix$TAIR))
# chromosome names
refseq_to_chr <- read.table(file.path("..","reference_data","kallisto_index","refseq_to_chr.tsv"), sep = "\t", header = TRUE)
counting_matrix <- merge(counting_matrix, refseq_to_chr, by.x = "chromosome", by.y = "refseq", all.x = TRUE) %>% rename(chromosome = "chromosome.refseq", chromosome.y = "chr", Row.names = "refseq.id") %>% mutate(TAIR = ifelse(is.na(TAIR),refseq.id,TAIR))
sum(is.na(counting_matrix$TAIR))

# remove mitochondria and chloroplast genes
counting_matrix <- counting_matrix %>% dplyr::filter(! chr %in% c("ChrC","ChrM"))
# ChrC and ChrM not found. Maybe they were excluded in the fasta file
#
# calculate gene tpm from transcript tpm
gene_tpm_matrix <- counting_matrix %>%
  dplyr::select(-c(chromosome.refseq, refseq.id, chr)) %>%
  aggregate(. ~ TAIR, ., FUN = sum)
# check if col sum is still 1 Million
colSums(gene_tpm_matrix %>% dplyr::select(-c(TAIR)))

# write all the genes into the expression matrix (normalized)
expression <- gene_tpm_matrix %>% t()
colnames(expression) <- expression[1, ]
expression <- expression[-1, ]
expression <- merge(expression, info_all %>% dplyr::select(sample_id, tissue = condition), by.x = 0, by.y = "sample_id", all.x = TRUE) %>% rename("Row.names" = "sample")
tissue <- expression$tissue %>% unique()
tissue_short <- c("SDL","SDL2","FLW","pre-G","G","EH","LH","ET","LT","BC","MG")
expression <- left_join(expression, cbind(tissue, tissue_short) %>% as.data.frame(), by = join_by(tissue))

# Write the normalized expression matrix to a file
write.table(expression, 
            file = file.path("../results/tpm","embryos_sdl_flw.deseq2normalized.tpm.csv"),sep = ",", col.names = TRUE, row.names = FALSE)


