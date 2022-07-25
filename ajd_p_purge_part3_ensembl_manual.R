library(data.table)
library(tidyverse)
library(readxl)


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\")


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\initial_files\\")

human_2020b <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\no_na_files\\",
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\adj_1_p_files\\",
                    13,3,
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2020_2_files.csv")

human_2018 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\no_na_files\\",
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\adj_1_p_files\\",
                   12,2,
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2018_files.csv")


#test loop on 2018 human


setwd(human_2018[[1]])

file_list <-  read.csv(human_2018[[5]], header =TRUE)

#list of na_files with more than 1 adj p
na_list <- file_list %>% filter(file_list$adj_p_num >1)

#container_csv[grep("MARCH", container_csv[,4]), ]


##################################################################START HERE
#going through 2020_2 4 files (DONE)

setwd(human_2018[[1]])

################################################################################CHANGE HERE
container_csv <- read.csv(na_list$File_na[[12]], header =FALSE)

################################################################################CHANGE HERE
#holds the name of the comp_id
comps<- na_list$compID[[12]]
#in 2020_2 it is 9, this holds the 
comp_id_row <- container_csv[(human_2018[[3]]-4),]

#finds the column index of the comp ID

comps_column <- which(comp_id_row %in% comps)



#for ROSMAP-DLPFC ONLY
#container_csv['new_col'] <- NA
#purged the names
#names(container_csv) <??? NULL

#9,10,11,12
#compID
#left
#right
#method

#container_csv[9,ncol(container_csv)]<- "compID"
#container_csv[10,ncol(container_csv)]<- "left"
#container_csv[11,ncol(container_csv)]<- "right"
#container_csv[12,ncol(container_csv)]<- "method"


save_file <- container_csv  %>% select(1:5,comps_column[1],comps_column[2], ncol(container_csv))

#add last column to ROSMAP-DLPFC

setwd(human_2018[[2]])

#######################################################################CHANGE HERE
fwrite(save_file,na_list$File_1_adjp[[12]], col.names = FALSE)


