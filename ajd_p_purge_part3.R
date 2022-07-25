library(data.table)
library(tidyverse)
library(readxl)


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")

detailed_study_sum <- read.csv("detailed_study_sum.csv", header =TRUE, na.strings = c("", "NA"))
adjp_mul_2018 <- read.csv("adjp_mul_2018.csv", header =TRUE, na.strings = c("", "NA"))
adjp_mul_2018_1 <- read.csv("adjp_mul_2018_1.csv", header =TRUE, na.strings = c("", "NA"))

adjp_mul_2020b <- read.csv("adjp_mul_2020b.csv", header =TRUE, na.strings = c("", "NA"))
adjp_mul_2020b_1 <- read.csv("adjp_mul_2020b_1.csv", header =TRUE, na.strings = c("", "NA"))



#source dir, dest dir, gene col, source col

human_2020 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined\\",
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined2\\part3\\part3b",
                   18,3)

human_2020b <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined2\\",
                    "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined2\\part3\\part3b",
                    13,3)

human_2018 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_auto_combined_human\\part3",
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_auto_combined_human\\part3\\part3b",
                   12,2)


#test loop on 2018 human

#went manually through part3 folder and made copies of csv where 2 adjp columns were used in the gene_summary ex GSE62420_no_na2.csv GSE62420_no_na.csv

#part3

#we will go through the csvs only with more than 1 adj p so everyone is on the csv structure with a single adjp and log2

#column indexes to have 1,2,adj_p,log2FC, method(last) columns

#for 2018 multiple ADJP

setwd(human_2018[[1]])

exp_list <-adjp_mul_2018$File


for (row in 1:length(exp_list)){
  setwd(human_2018[[1]])
  
  #holds the compID that is looked at
  #match_comp_id <- adjp_mul_2018$compID[[row]]
  
  match_comp_id <- adjp_mul_2018$compID[[1]]
  
  #junk
  #compid_df <- data.frame(index=integer(),
  #                        comp_id_row=integer(),
  #                        sourceID=character(),
  #                        stringsAsFactors=FALSE)
  
  #for 1 test file
  container_csv <- read.csv("GSE18597_no_na.csv", na.strings = c("", "NA"),header =FALSE)
  #container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
  
  #holds the file name
  file_name <- paste(container_csv[[human_2018[[4]],2]],"_1_adjp.csv", collapse = "", sep="")
  print(file_name)
  print(row)
  
  #narrowing down row that has adjp
  sourcer <- container_csv[human_2018[[3]],]
  sourcer <-unlist(c(sourcer))
  
  #comp ID is 4 rows up from adjp and has the contants of the comp id row
  comp_id_row <- container_csv[(human_2018[[3]]-4),]
  comp_id_row <-unlist(c(comp_id_row))
  
  
  
  adj_p_cols <- which(comp_id_row %in% "adjP")
  
  #Too tired
  #compid_df$index <- adj_p_cols
  #compid_df$comp_id_row <- container_csv[(human_2018[[3]]-4),]
  #compid_df$sourceID <- human_2018[compid_df$index,compid_df$comp_id_row]
  
  #loop through comp_id row and find match  ARRRGHHHHH 
  comp_index <- NULL
  for (x in comp_id_row){
    
    #matching the valuesof the com_id we want and the index on the row
    #https://stackoverflow.com/questions/27350636/r-argument-is-of-length-zero-in-if-statement
    if (!is.null  (container_csv[[(human_2018[[3]]-4), x]]) &  (container_csv[[(human_2018[[3]]-4), x]] == match_comp_id) ){
      comp_index <- x
      break
    }
  }
  
  save_file <- container_csv  %>% select(1,2,comp_index,(comp_index+1), ncol(container_csv))
  
  container_csv[[(human_2018[[3]]-4), 16]] == match_comp_id
  
  !is.na(container_csv[[(human_2018[[3]]-4), 1]])
  
  #(human_2018[[3]]-4)
  #
  #comp_id_row
}  





#just do it manually 2018

  container_csv <- read.csv("GSE79812_no_na.csv", na.strings = c("", "NA"),header =FALSE)
  
  file_name <- paste(adjp_mul_2018$sourceID[[11]],"_1_adjp2.csv", collapse = "", sep="")
  file_name
  #what col is comp_id
  comp_index<- 5
  
  save_file <- container_csv  %>% select(1,2,comp_index,(comp_index+1), ncol(container_csv))
  
  fwrite(save_file,file_name, col.names = FALSE)
  
  
  
  
 ############################### for 2018 single adjP
  
  setwd(human_2018[[1]])
  
  exp_list <-adjp_mul_2018_1$File
  name_list <-adjp_mul_2018_1$File_1_adjp
  
  
  for (row in 1:length(exp_list)){
    
    #sets the directory where part3 files _no_na are located
    setwd(human_2018[[1]])
    
    #holds the compID that is looked at
    #match_comp_id <- adjp_mul_2018$compID[[row]]
    
    match_comp_id <- adjp_mul_2018$compID[[1]]
    
    #junk
    #compid_df <- data.frame(index=integer(),
    #                        comp_id_row=integer(),
    #                        sourceID=character(),
    #                        stringsAsFactors=FALSE)
    
    #for 1 test file
    #container_csv <- read.csv("GSE18597_no_na.csv", na.strings = c("", "NA"),header =FALSE)
    container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
    
    #holds the file name
    #file_name <- paste(container_csv[[human_2018[[4]],2]],"_1_adjp.csv", collapse = "", sep="")
    file_name <- name_list[[row]]
    print(file_name)
    print(row)
    
    #narrowing down row that has adjp
    sourcer <- container_csv[human_2018[[3]],]
    sourcer <-unlist(c(sourcer))
    
    #comp ID is 4 rows up from adjp and has the contants of the comp id row
    adjp_row <- container_csv[(human_2018[[3]]-4),]
    adjp_row <- unlist(c(adjp_row))
    
    
    
    adj_p_cols <- which(adjp_row %in% "adjP")
    
    #Too tired
    #compid_df$index <- adj_p_cols
    #compid_df$comp_id_row <- container_csv[(human_2018[[3]]-4),]
    #compid_df$sourceID <- human_2018[compid_df$index,compid_df$comp_id_row]
    
    #loop through comp_id row and find match  ARRRGHHHHH 
    #comp_index <- NULL
    #for (x in comp_id_row){
    #  
    #  #matching the valuesof the com_id we want and the index on the row
    #  #https://stackoverflow.com/questions/27350636/r-argument-is-of-length-zero-in-if-statement
    #  if (!is.null  (container_csv[[(human_2018[[3]]-4), x]]) &  (container_csv[[(human_2018[[3]]-4), x]] == match_comp_id) ){
    #    comp_index <- x
    #    break
    #  }
    #}
    
    save_file <- container_csv  %>% select(1,2,adj_p_cols,(adj_p_cols+1), ncol(container_csv))
    
    setwd(human_2018[[2]])
    
    fwrite(container_csv,file_name, col.names = FALSE)
  }  
  
  
  
  
  ###############################2020 2020_2
  
  #2020 had only one study and it only have one adjp value
  
  setwd(human_2020[[1]])
  
  container_csv <- read.csv("GSE97930_no_na.csv", na.strings = c("", "NA"),header =FALSE)
  
  container_csv<- container_csv %>% slice(-(9:13))
  
  setwd(human_2020[[2]])
  
  fwrite(container_csv,"GSE97930_1_adjp.csv", col.names = FALSE)
  
  ######################2020_2
  
  #filter the 1_adj files first
  
  setwd(human_2020b[[1]])
  
  exp_list <-adjp_mul_2020b_1$File
  name_list <-adjp_mul_2020b_1$File_1_adjp
  
  
  for (row in 1:length(exp_list)){
    
    #sets the directory where part3 files _no_na are located
    setwd(human_2020b[[1]])
    
    #holds the compID that is looked at
    #match_comp_id <- adjp_mul_2018$compID[[row]]
    
    match_comp_id <- adjp_mul_2020_1$compID[[1]]
    
    #for 1 test file
    #container_csv <- read.csv("GSE18597_no_na.csv", na.strings = c("", "NA"),header =FALSE)
    container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
    
    #holds the file name
    #file_name <- paste(container_csv[[human_2020b[[4]],2]],"_1_adjp.csv", collapse = "", sep="")
    file_name <- name_list[[row]]
    print(file_name)
    print(row)
    
    #narrowing down row that has adjp
    sourcer <- container_csv[human_2020b[[3]],]
    sourcer <-unlist(c(sourcer))
    
    #comp ID is 4 rows up from adjp and has the contants of the comp id row
    adjp_row <- container_csv[(human_2020b[[3]]-4),]
    adjp_row <-unlist(c(adjp_row))
    
    adj_p_cols <- which(adjp_row %in% "adjP")
    
    save_file <- container_csv  %>% select(1,2,adj_p_cols,(adj_p_cols+1), ncol(container_csv))
    
    setwd(human_2020b[[2]])
    
    fwrite(save_file,file_name, col.names = FALSE)
  }  
  
  ######################2020_2 more than 1 adj_p do it manually
  setwd(human_2020b[[1]])
  
  container_csv <- read.csv(adjp_mul_2020b$File[[4]], na.strings = c("", "NA"),header =FALSE)
  
  file_name <- adjp_mul_2020b$File_1_adjp[[4]]
  file_name
  #what col is comp_id
  comp_index<- 3
  
  setwd(human_2020b[[2]])
  
  save_file <- container_csv  %>% select(1,2,comp_index,(comp_index+1), ncol(container_csv))
  
  fwrite(save_file,file_name, col.names = FALSE)
  
  
  ############FIX  ROSMAP DLPFC end column missing (FIXED)
  
  #made new column
  container_csv['new_col'] <- NA
  #purged the names
  #names(container_csv) <- NULL
  
  #9,10,11,12
  #compID
  #left
  #right
  #method
  
  container_csv[9,7]<- "compID"
  container_csv[10,7]<- "left"
  container_csv[11,7]<- "right"
  container_csv[12,7]<- "method"
  
  file_name <- adjp_mul_2020b$File[[4]]
  fwrite(container_csv,file_name, col.names = FALSE)
  
  
  