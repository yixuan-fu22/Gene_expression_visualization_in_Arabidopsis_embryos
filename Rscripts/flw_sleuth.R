# Thisscript use sleuth to read in the kallisto output files for sdl samples 
# and write into a tsv file

# Load packages
source("./load_libraries.R")
#renv::snapshot()

# find kallisto output files
sample_id <- dir(file.path("..", "results", "flw_kallisto"))
kal_dirs <- file.path("..", "results", "flw_kallisto", sample_id)
id_and_dirs <- data.frame(sample_id, kal_dirs)

# load sample info
sample_info <- read.table(file.path("..", "meta" ,"flower_SraRunTable.txt"), 
                          sep = "," , header = TRUE)  %>%
                          rename("Run"="sample_id")

sample_info <- merge(sample_info, id_and_dirs)

# use sleuth to read output files
s2c <- sample_info %>% dplyr::select(sample = sample_id, condition = tissue, path = kal_dirs)
so <- sleuth_prep(s2c)
sleuth_matrix_raw <- sleuth_to_matrix(so, which_df = "obs_raw", which_units = "tpm") %>% as.data.frame()

# check if sum is 1,000,000
colSums(sleuth_matrix_raw)

# add geneid and chromosome conversion
refseq_to_geneid <- read.table(file.path("..","reference_data","kallisto_index","refseq_to_geneid.tsv"), sep = "\t") %>% rename(V1="chromosome", V2="TAIR", V3="refseq")
counting_matrix <- merge(sleuth_matrix_raw, refseq_to_geneid, by.x = "row.names", by.y = "refseq", all.x = TRUE)
#check if there are NAs
sum(is.na(counting_matrix$TAIR))
# chromosome names
refseq_to_chr <- read.table(file.path("..","reference_data","kallisto_index","refseq_to_chr.tsv"), sep = "\t", header = TRUE)
counting_matrix <- merge(counting_matrix, refseq_to_chr, by.x = "chromosome", by.y = "refseq", all.x = TRUE) %>% rename(chromosome = "chromosome.refseq", chromosome.y = "chr", Row.names = "refseq.id") %>% mutate(TAIR = ifelse(is.na(TAIR),refseq.id,TAIR))
sum(is.na(counting_matrix$TAIR))

view(counting_matrix)

# check if there any chrC or chrM genes
counting_matrix %>% dplyr::filter( chr %in% c("ChrC","ChrM")) %>% dim()

gene_tpm_matrix <- counting_matrix %>%
  dplyr::select(-c(chromosome.refseq, refseq.id, chr)) %>%
  aggregate(. ~ TAIR, ., FUN = sum)
# check if col sum is still 1 Million
colSums(gene_tpm_matrix %>% dplyr::select(-c(TAIR)))

view(gene_tpm_matrix)

# write all the genes into the expression matrix
expression <- gene_tpm_matrix %>% t()
colnames(expression) <- expression[1, ]
expression <- expression[-1, ]
expression <- merge(expression, sample_info %>% dplyr::select(sample_id, tissue), by.x = 0, by.y = "sample_id", all.x = TRUE) %>% rename("Row.names" = "sample")
tissue <- sample_info$tissue %>% unique()
tissue_short <- c("FLW")
expression <- left_join(expression, cbind(tissue, tissue_short) %>% as.data.frame(), by = join_by(tissue))
#
view(expression)
expression$tissue_short

# Write the expression matrix to a file
write.table(expression, file = file.path("../results/tpm","flw.tpm.csv"),
            sep = ",", col.names = TRUE, row.names = FALSE)

