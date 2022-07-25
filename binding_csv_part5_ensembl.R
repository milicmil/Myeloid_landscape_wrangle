library(data.table)
library(tidyverse)
library(readxl)


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\")

#here we fix one data frame GSE95587+GSE125583.csv so source_id is GSE125583 and then read in again (file name in exp_list already corrected)
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\complete_files\\")

#bad_csv <- read.csv("GSE125583_complete.csv", header =TRUE, na.strings = c("", "NA"))
#
##fix the source_id column
#bad_csv$sourceID <- "GSE125583"
#
#fwrite(bad_csv,"GSE125583_complete.csv", col.names = TRUE)


#now we make 2 large data frames and then bind together

#source dir, dest dir, gene row, source row
human_2020b <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\complete_files\\",
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\",
                    13,3,
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2020_2_files.csv")

human_2018 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\complete_files\\",
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\",
                   12,2,
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2018_files.csv")


#make a big data frame

#gene_id_original#human_entrez_id#human_ensembl_id#geneID#adjP#Log2FC#sourceID#compID

big_2020 <- data.frame(gene_id_original=character(),
                      human_entrez_id=character(),
                      human_ensembl_id=character(),
                      geneID=character(),
                      adjP=integer(),
                      Log2FC=integer(),
                      sourceID=character(),
                      compID=character(),
                      stringsAsFactors=FALSE)

big_2018 <- data.frame(gene_id_original=character(),
                       human_entrez_id=character(),
                       human_ensembl_id=character(),
                       geneID=character(),
                       adjP=integer(),
                       Log2FC=integer(),
                       sourceID=character(),
                       compID=character(),
                       stringsAsFactors=FALSE)





##############first read in the 2020 unicorn GSE97930_complete.csv which isnt in the 2020 and 2018 support df

setwd(human_2020b[[1]])

csv_2020 <- read.csv("GSE97930_complete.csv", header =TRUE, na.strings = c("", "NA"))
big_2020 <- rbind(big_2020,csv_2020)

#############now fix the 3 files with max cook issues GSE75246_complete.csv and GSE99074_complete.csv  

#setwd(human_2020b[[1]])
#
#csv_2020 <- read.csv("GSE99074_complete.csv", header =TRUE, na.strings = c("", "NA"))
#
##drop the damn max cook column
#drops <- c("Max.Cook.s.P")
#csv_2020 <- csv_2020[ , !(names(csv_2020) %in% drops)]
#
##save the file
#fwrite(csv_2020,"GSE99074_complete.csv", col.names = TRUE)



#list of file names to read in for each experiment in 2020 and bind to big_2020

file_list <-  read.csv(human_2020b[[5]], header =TRUE)

exp_list <- file_list$File_complete


name_2020 <- "big_2020_df2_ensembl.csv"
setwd(human_2020b[[1]])

for (row in 1:length(exp_list)){
  
  file_name <- exp_list[[row]]
  print(file_name)
  print(row)
  
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =TRUE)
  #we will keep adding csv
  big_2020 <- rbind(big_2020,container_csv)
  
}

#fwrite(container_csv,file_name, col.names = TRUE)
setwd(human_2020b[[2]])
fwrite(big_2020,name_2020, col.names = TRUE)



############## switch to 2018
#####################fix GSE 52564_complete.csv doenst have Log2FC
#setwd(human_2018[[1]])
#bad_csv <- read.csv("GSE52564_complete.csv", header =TRUE, na.strings = c("", "NA"))
#
##rename the last column as comp_id
##see column names
#colnames(bad_csv)
##rename the last one
#names(bad_csv)[names(bad_csv) == 'cell.type..microglia...astrocyte.endothelial.cells.neuron.oligodendrocyte.precursor.cells.newly.formed.oligodendrocytes.myelinating.oligodendrocytes'] <- 'compID'
#
#
##add a blank column for 
#bad_csv$Log2FC <- NA #blank column 
#
#col_order <- c("gene_id_original","human_entrez_id","human_ensembl_id","geneID","adjP","Log2FC","sourceID","compID" )
#
#bad_csv <- bad_csv[, col_order]
#
##now get the log2fc values
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\adj_1_p_files")
#
#log_2s <- read.csv("GSE52564_1_adjp.csv", header =FALSE, na.strings = c("", "NA"))

#log value storage
#log2_vals <- log_2s[13:nrow(log_2s),ncol(log_2s)]
#
##paste the log values into the empty column
#bad_csv$Log2FC <- as.numeric(log2_vals)
#
#setwd(human_2018[[1]])
#fwrite(bad_csv,"GSE52564_complete.csv", col.names = TRUE)

#######################




#do the same thing but for 2018 genes
setwd(human_2018[[1]])

file_list <-  read.csv(human_2018[[5]], header =TRUE)

exp_list <- file_list$File_complete


name_2018 <- "big_2018_df2.csv"


for (row in 1:length(exp_list)){
  
  file_name <- exp_list[[row]]
  print(file_name)
  print(row)
  
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =TRUE)
  #we will keep adding csv
  big_2018 <- rbind(big_2018,container_csv)
  
}

setwd(human_2018[[2]])
fwrite(big_2018,name_2018, col.names = TRUE)


################# binding the 2 files



biggie_file <- rbind(big_2018,big_2020)


fwrite(biggie_file,"biggie_file_ensembl.csv", col.names = TRUE)


#true to form, There is an issue with the data, genes are not fully capitalised

setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")
capital_gene <- read.csv('biggie_file3.csv', na.strings = c("", "NA"),header =TRUE)

head(capital_gene)

#capitalises all entries in gene name
capital_gene[,1] <- toupper(capital_gene[,1])
fwrite(capital_gene,'biggie_file2.csv', col.names = TRUE)
