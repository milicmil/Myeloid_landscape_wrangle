library(data.table)
library(tidyverse)
library(readxl)

#this script makes the detailed study summary csv

setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")

relevant_studies <- read.csv("source_comp_id.csv", header =TRUE)

#combines the individual csv into one large gene table

#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic2")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_automatic4_mouse")
setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_automatic3_human")


################looking to develop the first loop
#move the source ID and name gene column and delete the in between 

#Looking at 2020 experiments
#GSE3790mouse  
#test_csv <- read.csv("GSE125050.csv")
#test_csv <- read.csv("GSE3790mouse.csv")

#Delete the NA rows ACTION

#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_automatic4_mouse")
#exp_list <-list.files(pattern="mouse")
#exp_list <-list.files(pattern="human")
exp_list <-list.files(pattern=".csv")


#######################make a quick loop of number of adjp in each folder

adj_p_numbers <- data.frame(File=character(),
                            adj_p_num=integer(),
                            sourceID=character(),
                            stringsAsFactors=FALSE)


for (row in 1:length(exp_list)){
  
  container <- read.csv(exp_list[row], na.strings = c("", "NA"),header =FALSE)
  
  
  #source_id is 2,2 for 2018 or 3,2 for 2020
  
  
  #looks at adj p row 12 for 2018 or 18 for 2020, 13 for 2020_2
  sourcer <- container[12,]
  sourcer <-unlist(c(sourcer))
  #finds all of the adjP indexes
  delete_end_index_col <- which(sourcer %in% "adjP")
  #name of the experiment
  adj_p_numbers[row,1] <- exp_list[row]
  #number of adj_p
  adj_p_numbers[row,2] <- length(delete_end_index_col)
  #source_id
  #adj_p_numbers[row,3] <- container[[3,2]]
  adj_p_numbers[row,3] <- container[[2,2]]
}


#rm(container,dude,test_csv_mouse,test_csv_mouse_indexing,indexer,non_empty_indexer,row,sourcer,val)
#adj_p_numbers_2020_2 <- adj_p_numbers
#adj_p_numbers_2020 <- adj_p_numbers
adj_p_numbers_2018 <- adj_p_numbers

#adj_p_numbers_2020_2$year <- "2020_2"
#adj_p_numbers_2020$year <- "2020"
adj_p_numbers_2018$year <- "2018"

adj_numbers_total <- rbind(adj_p_numbers_2020_2,adj_p_numbers_2020,adj_p_numbers_2018)

#rel_exp_2018 <- merge(relevant_studies, adj_p_numbers_2018, by= "sourceID")
#rel_exp_2020 <- merge(relevant_studies, adj_p_numbers_2020, by= "sourceID")

rel_exp_total <- merge(relevant_studies, adj_numbers_total, by= "sourceID",all.x = TRUE)

fwrite(rel_exp_total,"detailed_study_sum.csv", col.names = TRUE)

#########################