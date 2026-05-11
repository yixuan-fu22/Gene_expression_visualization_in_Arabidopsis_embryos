# Plot expression for PRC1 related genes and possible H2AUb-binding PRC2 recrutiers
# Modified from main.plot_normalized_expression.R

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

input <- read.table(file.path("input","gene_list_PRC1_related_and_possible_recruiters.txt"))$V1

savefolder = "../results/Rplots/PRC1_related_and_possible_recruiters"

plot_expression(input = input, expression = log_normalized_expression, 
                plottype = "heatmap",
                savefolder = savefolder,
                ylab = "log2(DEseq2-normalized TPM + 1)")


# make an aggregated heatmap
selected_expression_matrix <- log_normalized_expression[c("tissue_short", input)] %>% as.data.frame()

summerised_matrix <- selected_expression_matrix %>% group_by(tissue_short) %>% 
  summarise(across(where(is.numeric), mean))

summerised_matrix_longer <- summerised_matrix %>% 
  pivot_longer(cols = where(is.numeric), names_to = "GENE_ID", values_to = "EXPRESSION")

level=c("pre-G","G","EH","LH","ET","LT","BC","MG", "SDL","SDL2","FLW")

heatplot <-
  summerised_matrix_longer %>%
  mutate(tissue_short=factor(tissue_short, levels=level)) %>%
  ggplot(aes(x=tissue_short, y=GENE_ID,fill=EXPRESSION)) +
  geom_tile()+
  xlab("")+
  ylab("")+
  theme_ipsum_es()+
  labs(fill="TPM")+
  theme(plot.background = element_rect(fill = 'white'))+
  #      gradient_color(c("blue", "white", "red"))+
  scale_fill_gradient(
    low = "blue",
    high = "red"
  )

ggsave(file.path(savefolder, "aggregated_heatmap.png"), heatplot, 
       width = 10, height = length(selected_expression_matrix), units = "in")





