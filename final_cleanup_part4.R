library(data.table)
library(tidyverse)
library(readxl)


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")

detailed_study_sum <- read.csv("detailed_study_sum.csv", header =TRUE, na.strings = c("", "NA"))
adjp_mul_2018 <- read.csv("adjp_mul_2018.csv", header =TRUE, na.strings = c("", "NA"))
adjp_mul_2018_1 <- read.csv("adjp_mul_2018_1.csv", header =TRUE, na.strings = c("", "NA"))

adjp_mul_2018_tot<- rbind(adjp_mul_2018, adjp_mul_2018_1)

adjp_mul_2020b <- read.csv("adjp_mul_2020b.csv", header =TRUE, na.strings = c("", "NA"))
adjp_mul_2020b_1 <- read.csv("adjp_mul_2020b_1.csv", header =TRUE, na.strings = c("", "NA"))

adjp_mul_2020b_tot <- rbind(adjp_mul_2020b,adjp_mul_2020b_1)

#source dir, dest dir, gene col, source col


human_2020b <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined2\\part3\\part3b",
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined2\\part3\\part4",
                    13,3)

human_2018 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_auto_combined_human\\part3\\part3b",
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_auto_combined_human\\part3\\part4",
                   12,2)

#2018 redo
#what needs to be done


#move "sourceID" [2,1] to  row: human_2018[[3]], lastcolumn (DONE)
#fill from human_2018[[3]]+1 until bottom row (DONE)

#comp_ID (DONE)

#remove first 11 rows for 2018 (DONE)
#remove column 2 (DONE)

###############test on one csv, woo hoo it works
setwd(human_2018[[1]])
container_csv <- read.csv("GSE13162_1_adjp.csv", na.strings = c("", "NA"),header =FALSE)

#move source ID column name to correct column row
container_csv[human_2018[[3]],ncol(container_csv)] <- container_csv[[human_2018[[4]],1]]
#move source ID column value to correct column row
container_csv[(human_2018[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[[human_2018[[4]],2]]

#make a new column for comp_id
container_csv['new_col'] <- NA
#purged the names
names(container_csv) <- NULL

#now do it for the comp_id (we added a new column)
container_csv[human_2018[[3]],ncol(container_csv)] <- container_csv[(human_2018[[3]]-4),(ncol(container_csv)-1)] 
#move source ID column value to correct column row
container_csv[(human_2018[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[(human_2018[[3]]-4),(ncol(container_csv)-2)]

#remove the 1st 11 rows
container_csv <- container_csv[12:nrow(container_csv),]
#drop 2nd column
container_csv <- container_csv[,-c(2)]

#############actual loop
exp_list <-adjp_mul_2018_tot$File_1_adjp
name_list <-adjp_mul_2018_tot$File_complete

for (row in 1:length(exp_list)){
  
  #sets the directory where part3 files _no_na are located
  
  setwd(human_2018[[1]])
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
  #name of file
  file_name <- name_list[[row]]
  print(file_name)
  print(row)
  
  #move source ID column name to correct column row
  container_csv[human_2018[[3]],ncol(container_csv)] <- container_csv[[human_2018[[4]],1]]
  #move source ID column value to correct column row
  container_csv[(human_2018[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[[human_2018[[4]],2]]
  
  #make a new column for comp_id
  container_csv['new_col'] <- NA
  #purged the names
  names(container_csv) <- NULL
  
  #now do it for the comp_id (we added a new column)
  container_csv[human_2018[[3]],ncol(container_csv)] <- container_csv[(human_2018[[3]]-4),(ncol(container_csv)-1)] 
  #move source ID column value to correct column row
  container_csv[(human_2018[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[(human_2018[[3]]-4),(ncol(container_csv)-2)]
  
  #remove the 1st 11 rows
  container_csv <- container_csv[human_2018[[3]]:nrow(container_csv),]
  #drop 2nd column
  container_csv <- container_csv[,-c(2)]
  
  #change directory
  setwd(human_2018[[2]])
  
  fwrite(container_csv,file_name, col.names = FALSE)
  
}

#now do the same thing with the 2020

exp_list <-adjp_mul_2020b_tot$File_1_adjp
name_list <-adjp_mul_2020b_tot$File_complete

for (row in 1:length(exp_list)){
  
  #sets the directory where part3 files _no_na are located
  
  setwd(human_2020b[[1]])
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
  #name of file
  file_name <- name_list[[row]]
  print(file_name)
  print(row)
  
  #move source ID column name to correct column row
  container_csv[human_2020b[[3]],ncol(container_csv)] <- container_csv[[human_2020b[[4]],1]]
  #move source ID column value to correct column row
  container_csv[(human_2020b[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[[human_2020b[[4]],2]]
  
  #make a new column for comp_id
  container_csv['new_col'] <- NA
  #purged the names
  names(container_csv) <- NULL
  
  #now do it for the comp_id (we added a new column)
  container_csv[human_2020b[[3]],ncol(container_csv)] <- container_csv[(human_2020b[[3]]-4),(ncol(container_csv)-1)] 
  #move source ID column value to correct column row
  container_csv[(human_2020b[[3]]+1):nrow(container_csv),ncol(container_csv)] <- container_csv[(human_2020b[[3]]-4),(ncol(container_csv)-2)]
  
  #remove the 1st 12 rows
  container_csv <- container_csv[human_2020b[[3]]:nrow(container_csv),]
  #drop 2nd column
  container_csv <- container_csv[,-c(2)]
  
  #change directory
  setwd(human_2020b[[2]])
  
  fwrite(container_csv,file_name, col.names = TRUE)
}
