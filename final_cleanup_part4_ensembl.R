library(data.table)
library(tidyverse)
library(readxl)


#source dir, dest dir, gene row, source row


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\")


human_2020b <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\adj_1_p_files\\",
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\complete_files\\",
                    13,3,
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2020_2_files.csv")

human_2018 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\adj_1_p_files\\",
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\complete_files\\",
                   12,2,
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2018_files.csv")

#2018 redo
#what needs to be done


#move "sourceID" [2,1] to  row: human_2018[[3]], lastcolumn (DONE)
#fill from human_2018[[3]]+1 until bottom row (DONE)

#comp_ID (DONE)

#remove first 11 rows for 2018 (DONE)
#remove column 2 (DONE)

###############test on one csv the sole 2020, woo hoo it works
setwd(human_2020b[[1]])
container_csv <- read.csv("GSE97930_1_adjp.csv", na.strings = c("", "NA"),header =FALSE)


#move source ID column name to correct column row
container_csv[18,ncol(container_csv)] <- container_csv[[human_2020b[[4]],4]]
#move source ID column value to correct column row
container_csv[(18+1):nrow(container_csv),ncol(container_csv)] <- container_csv[[human_2020b[[4]],5]]

#make a new column for comp_id
container_csv['new_col'] <- NA
#purged the names
names(container_csv) <- NULL

#now do it for the comp_id (we added a new column)
container_csv[18,ncol(container_csv)] <- container_csv[(18-4),(ncol(container_csv)-1)] 
#move source ID column value to correct column rows from the first row of data down to the bottom
container_csv[(18+1):nrow(container_csv),ncol(container_csv)] <- container_csv[(18-4),(ncol(container_csv)-2)]

#rename the first 3 columns

container_csv[[18,1]] <- "gene_id_original"
container_csv[[18,2]] <- "human_entrez_id"
container_csv[[18,3]] <- "human_ensembl_id"
container_csv[[18,4]] <- "geneID"


#remove the 1st 11 rows for 2018 or 17
container_csv <- container_csv[18:nrow(container_csv),]


#drop 5th column
container_csv <- container_csv[,-c(5)]

#now chandge directory
setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\complete_files\\")

fwrite(container_csv,"GSE97930_complete.csv", col.names = TRUE)

#############actual loop

setwd(human_2018[[1]])

file_list <-  read.csv(human_2018[[5]], header =TRUE)

exp_list <-file_list$File_1_adjp
name_list <-file_list$File_complete


for (row in 1:length(exp_list)){
  
  #sets the directory where part3 files _no_na are located
  
  setwd(human_2018[[1]])
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
  #name of file
  file_name <- name_list[[row]]
  print(file_name)
  print(row)
  
  #move source ID column name to correct column row
  container_csv[human_2018[[3]],ncol(container_csv)] <- container_csv[[human_2018[[4]],4]]
  #move source ID column value to correct column row
  container_csv[(human_2018[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[[human_2018[[4]],5]]
  
  #make a new column for comp_id
  container_csv['new_col'] <- NA
  #purged the names
  names(container_csv) <- NULL
  
  #now do it for the comp_id (we added a new column)
  container_csv[human_2018[[3]],ncol(container_csv)] <- container_csv[(human_2018[[3]]-4),(ncol(container_csv)-1)] 
  #move source ID column value to correct column row
  container_csv[(human_2018[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[(human_2018[[3]]-4),(ncol(container_csv)-2)]
  
  
  
  #rename the gene id_cells
  
  container_csv[[human_2018[[3]],1]] <- "gene_id_original"
  container_csv[[human_2018[[3]],2]] <- "human_entrez_id"
  container_csv[[human_2018[[3]],3]] <- "human_ensembl_id"
  container_csv[[human_2018[[3]],4]] <- "geneID"
  
  #remove the 1st 11 rows or whatever
  container_csv <- container_csv[human_2018[[3]]:nrow(container_csv),]
  
  
  
  #drop 5th column
  container_csv <- container_csv[,-c(5)]
  
  #change directory
  setwd(human_2018[[2]])
  
  fwrite(container_csv,file_name, col.names = TRUE)
  
}

#now do the same thing with the 2020

setwd(human_2020b[[1]])

file_list <-  read.csv(human_2020b[[5]], header =TRUE)

exp_list <-file_list$File_1_adjp
name_list <-file_list$File_complete

for (row in 1:length(exp_list)){
  
  #sets the directory where part3 files _no_na are located
  
  setwd(human_2020b[[1]])
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
  #name of file
  file_name <- name_list[[row]]
  print(file_name)
  print(row)
  
  #move source ID column name to correct column row
  container_csv[human_2020b[[3]],ncol(container_csv)] <- container_csv[[human_2020b[[4]],4]]
  #move source ID column value to correct column row
  container_csv[(human_2020b[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[[human_2020b[[4]],5]]
  
  #make a new column for comp_id
  container_csv['new_col'] <- NA
  #purged the names
  names(container_csv) <- NULL
  
  #now do it for the comp_id (we added a new column)
  container_csv[human_2020b[[3]],ncol(container_csv)] <- container_csv[(human_2020b[[3]]-4),(ncol(container_csv)-1)] 
  #move source ID column value to correct column row
  container_csv[(human_2020b[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[(human_2020b[[3]]-4),(ncol(container_csv)-2)]
  
  
  container_csv[[human_2020b[[3]],1]] <- "gene_id_original"
  container_csv[[human_2020b[[3]],2]] <- "human_entrez_id"
  container_csv[[human_2020b[[3]],3]] <- "human_ensembl_id"
  container_csv[[human_2020b[[3]],4]] <- "geneID"
  
  #remove the 1st 12 rows
  container_csv <- container_csv[human_2020b[[3]]:nrow(container_csv),]
  #drop 5th column
  container_csv <- container_csv[,-c(5)]
  
  #change directory
  setwd(human_2020b[[2]])
  
  fwrite(container_csv,file_name, col.names = TRUE)
}
