##### To plot the expression dynamics of genes of interests, please start with 

(1) Rscripts/main.plot_normalized_expression.R 
Which plot the expression data by TPM (Transcripts Per Million)
or 

(2) Rscripts/main.plot_normalized_expression.R
Which plot the expression data by TPM that are normalized by DEseq2, which ususllly provides better results when comparing between tissues


##### There are two ways to input a list of genes:

(1) Input a list of gene identifiers or gene names, for example:
'''
input <- c("AT5G45830", "AT4G27160", "AT1G69690")
'''

(2) Input from a text file, where each gene name or identifier occupies one row. For example:
'''
input <- read.table(file.path("input","gene_list.txt"))$V1
'''

##### The program automatically does the conversion between gene names and identifiers.

The main function to plot is plot_expression()
'''
plot_expression(input = input, expression = log_normalized_expression, 
                plottype = "heatmap",
                savefolder = saveFolder,
                ylab = "log2(DEseq2-normalized TPM + 1)")
'''

Plot types (box plots or heat maps) can be specified through plottype = "heatmap" or plottype = "boxplot"



