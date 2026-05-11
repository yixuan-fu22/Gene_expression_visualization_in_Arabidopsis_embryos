# Thisscript use sleuth to read in the kallisto output files for sdl samples 
# and write into a tsv file

# Load packages
source("./load_libraries.R")
#renv::snapshot()

sample_id <- dir(file.path("..", "results", "sdl_kallisto"))
kal_dirs <- file.path("..", "results", "sdl_kallisto", sample_id)
id_and_dirs <- data.frame(sample_id, kal_dirs)
