library(data.table)
library(tidyverse)
library(readxl)


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\")

#now capitalise the name
#biggie_file[,1] <- toupper(biggie_file[,1])

#from first try
#relevant_studies <- read.csv("source_comp_id.csv", header =TRUE)

#from 2 nd try
relevant_studies_1_2018 <- read.csv("multiple_adj_p_exp_2018.csv", header =TRUE)
relevant_studies_2_2018 <- read.csv("single_adj_p_exp_2018.csv", header =TRUE)



setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\initial_files\\")



#list has all of the files in the folder
exp_list <-list.files(pattern=".csv")


#######################testing with sample file
#will start loop from here from the file read in

#reads in the CSV, but
test_csv_mouse <- read.csv("GSE97930.csv", na.strings = c("", "NA"),header =FALSE)
#remove the last column
test_csv_mouse[,ncol(test_csv_mouse)] <- NULL




#location of gene column title [18th row in the 2020, 13 for 2020_2, or 12 row in 2018 paper(mouse and human)]
#4th column
test_csv_mouse[18,4] <- "gene"

#takes out the second last column (compID left right method), maybe not needed
#test_csv_mouse_indexing <- test_csv_mouse
#test_csv_mouse_indexing[,ncol(test_csv_mouse_indexing)] <- NULL


#removing NA rows
#looping only through rows from the 12th onward or 19th or 13th onward for 2020 paper from those rows and onward is gene data
indexer <- c(19:nrow(test_csv_mouse))

#for now we save the first 11 rows, we will not delete them
non_empty_indexer <- c(1:18)
for (val in indexer){
  #counts the number of NA cells in row from col 5 to last col -1 if it is above 0 then it is TRUE
  #we only want FALSE results where all of the cells are full
  if ((rowSums(is.na(test_csv_mouse[val,5:(ncol(test_csv_mouse)-1)]))>0 ) == FALSE){
    non_empty_indexer <- append(non_empty_indexer, val)
  }
  
}

###############from the st mike analysis
(rowSums(is.na(analysis_frame_clean[18,1:(ncol(analysis_frame_clean))]))>1 ) == TRUE 
rowSums(is.na(analysis_frame_clean[18,1:(ncol(analysis_frame_clean))])>0) == TRUE

(rowSums(is.na(test_csv_mouse[13,5:(ncol(test_csv_mouse))])) > 1 ) == TRUE


rowSums(is.na(analysis_frame_clean[18,1:(ncol(analysis_frame_clean))])>0) == TRUE

#counts the number of NA cells in row from col 1 to last col if it is above 0 then it is TRUE
#we only want FALSE results
if ((rowSums(is.na(analysis_frame_clean[val,1:(ncol(analysis_frame_clean))]))>1 ) == FALSE)
####################




#code chunk that deletes the empty rows
#Now we save a new data frame without the empty rows

#it now has no empty rows
test_csv_mouse_indexing <- test_csv_mouse[non_empty_indexer,]




#lets delete in between columns
#row 12 holds the column titles for 2018, row 18 for 2020 and row 13 for 2020_2
sourcer <- test_csv_mouse_indexing[18,]
sourcer <-unlist(c(sourcer))

#finds all of the adjP indexes
delete_end_index_col <- which(sourcer %in% "adjP")

#the index to where to delete
delete_end_index_col_prim <- delete_end_index_col[[1]]-1


#delete_end_index_col[[1]]-1
#delete_start_index_col+1

#THIS IS FOR THE NEXT SECTION  here we need to find row number of comp_id
#in 2018 it is 8 in 2020 it is 14
#comp_id_index_row <- 8
#comp_id_index_col <- delete_end_index_col
#
#
#
#delete_start_index_col <- 6 #delete from column 5 onward until delete_end_index-1 (we dont want adjP gone)
#
#dude<-test_csv_mouse_indexing[,-c(6:delete_end_index_col-1)]

#this works
test_csv_mouse_indexing<- test_csv_mouse_indexing[,-c(delete_start_index_col:delete_end_index_col_prim)]

#capitalise the gene names in the 4th column
test_csv_mouse_indexing[18:nrow(test_csv_mouse_indexing),4] <- toupper(test_csv_mouse_indexing[18:nrow(test_csv_mouse_indexing),4])

#now we save it
setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\no_na_files")

fwrite(test_csv_mouse_indexing,"GSE97930_no_na.csv", col.names = FALSE)


######################################### end of testing phase

#note the number of adjP columns and coordinates and save the file as a csv for each batch
#now we make the source ID move


#then we delete the in-between crap, keep the 2nd row for now

#save the files as something new in the same folder

#then get list of the experiments and comp_id in the summary listed from landscalpe_labels


#then we note the double studies, note the source 2018 or 2020
#then delete the extra P values


#source ID coordinates(turn into a column) [2,1][2,2] in the 2018 paper
#move Source ID to [17,-1] No, -1 means that the 1st column is ignored
sourceid <- test_csv[[2,4]]
test_csv[17,ncol(test_csv)] <- sourceid

sourceid_value <- test_csv[[2,2]]
test_csv[-1:-17,ncol(test_csv)] <- sourceid_value



#####################Now make a loop

#source dir, dest dir, gene row, source_id row, file list

#not using this, only one file to sift through GSE97930
#human_2020 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic",
#                "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined",
#                18,3,)

human_2020b <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\initial_files\\",
                     "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\no_na_files\\",
               13,3,
               "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2020_2_files.csv")

human_2018 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\initial_files\\",
                   "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\no_na_files\\",
                12,2,
                "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\2018_files.csv")


#test loop on 2018 human


setwd(human_2018[[1]])

file_list <-  read.csv(human_2018[[5]], header =TRUE)


exp_list <-file_list$Initial_file

na_list <- file_list$File_na
#gene name column
#delete empty rows


for (row in 1:length(exp_list)){
  setwd(human_2018[[1]])
  
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
  
  #holds the file name
  #file_name <- paste(na_list[row],"_no_na.csv", collapse = "", sep="")
  file_name <- na_list[row]
  print(file_name)
  print(row)
  #remove the last column
  container_csv[,ncol(container_csv)] <- NULL
  
  #location of gene column title [18th row in the 2020, 13 for 2020_2, or 12 row in 2018 paper(mouse and human)]
  container_csv[human_2018[[3]],4] <- "gene"
  
  #for now we save the first 11 rows, we will not delete them
  non_empty_indexer <- c(1:(human_2018[[3]]-1))
  

  #removing NA rows
  #looping only through rows from the 12th onward or 18th or 13th onward for 2020 paper from those rows and onward is gene data
  indexer <- c(human_2018[[3]]:nrow(container_csv))


  for (val in indexer){
    #counts the number of NA cells in row from col 2 to last col -1 if it is above 0 then it is TRUE
    #we only want FALSE results
    if ((rowSums(is.na(container_csv[val,5:(ncol(container_csv)-1)]))>0 ) == FALSE){
      non_empty_indexer <- append(non_empty_indexer, val)
    }
    
  }
  #deleted the empty rows
  container_csv_na <- container_csv[non_empty_indexer,]
  
  #narrowing down row that has adjp
  sourcer <- container_csv_na[human_2018[[3]],]
  sourcer <-unlist(c(sourcer))
  
  #finds all of the adjP indexes
  delete_end_index_col <- which(sourcer %in% "adjP")
  
  #the index to where to delete
  delete_end_index_col_prim <- delete_end_index_col[[1]]-1
  
  delete_start_index_col <- 6 #delete from column 3 onward until delete_end_index-1 (we dont want adjP gone)
  
  #this works
  container_csv_na<- container_csv_na[,-c(delete_start_index_col:delete_end_index_col_prim)]
  
  #capitalise gene names
  container_csv_na[human_2018[[3]]:nrow(container_csv_na),4] <- toupper(container_csv_na[human_2018[[3]]:nrow(container_csv_na),4])
  
  setwd(human_2018[[2]])
  
  
  fwrite(container_csv_na,file_name, col.names = FALSE)
  
}

#saving the data




