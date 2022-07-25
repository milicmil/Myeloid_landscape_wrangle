library(data.table)
library(tidyverse)
library(readxl)


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")

relevant_studies <- read.csv("source_comp_id.csv", header =TRUE)

#combines the individual csv into one large gene table

#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic2")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_automatic3_human")

#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_automatic4_mouse")



#list has all of the files in the folder
exp_list <-list.files(pattern=".csv")



#will start loop from here from the file read in

#reads in the CSV, but
test_csv_mouse <- read.csv("GSE66926mouse.csv", na.strings = c("", "NA"),header =FALSE)
#remove the last column
test_csv_mouse[,ncol(test_csv_mouse)] <- NULL




#location of gene column title [18th row in the 2020, 13 for 2020_2, or 12 row in 2018 paper(mouse and human)]
test_csv_mouse[12,1] <- "gene"

#takes out the second last column (compID left right method), maybe not needed
#test_csv_mouse_indexing <- test_csv_mouse
#test_csv_mouse_indexing[,ncol(test_csv_mouse_indexing)] <- NULL


#removing NA rows
#looping only through rows from the 12th onward or 18th or 13th onward for 2020 paper from those rows and onward is gene data
indexer <- c(12:nrow(test_csv_mouse))

#for now we save the first 11 rows, we will not delete them
non_empty_indexer <- c(1:11)
for (val in indexer){
  #counts the number of NA cells in row from col 2 to last col -1 if it is above 0 then it is TRUE
  #we only want FALSE results
  if (rowSums(is.na(test_csv_mouse[val,2:(ncol(test_csv_mouse)-1)])>0) == FALSE){
    non_empty_indexer <- append(non_empty_indexer, val)
  }
  

}

#from the st mike analysis
(rowSums(is.na(analysis_frame_clean[18,1:(ncol(analysis_frame_clean))]))>1 ) == TRUE 

rowSums(is.na(analysis_frame_clean[18,1:(ncol(analysis_frame_clean))])>0) == TRUE

#code chunk that deletes the empty rows
#Now we save a new data frame without the empty rows

#it now has no empty rows
test_csv_mouse_indexing <- test_csv_mouse[non_empty_indexer,]




#lets delete in between columns
#row 12 holds the column titles for 2018
sourcer <- test_csv_mouse_indexing[12,]
sourcer <-unlist(c(sourcer))

#finds all of the adjP indexes
delete_end_index_col <- which(sourcer %in% "adjP")

#the index to where to delete
delete_end_index_col_prim <- delete_end_index_col[[1]]-1

delete_end_index_col[[1]]-1
delete_start_index_col+1

#THIS IS FOR THE NEXT SECTION  here we need to find row number of comp_id
#in 2018 it is 8 in 2020 it is 14
comp_id_index_row <- 8
comp_id_index_col <- delete_end_index_col


delete_start_index_col <- 3 #delete from column 3 onward until delete_end_index-1 (we dont want adjP gone)

dude<-test_csv_mouse_indexing[,-c(3:11)]

#this works
test_csv_mouse_indexing<- test_csv_mouse_indexing[,-c(delete_start_index_col:delete_end_index_col_prim)]



#note the number of adjP columns and coordinates and save the file as a csv for each batch
#now we make the source ID move


#then we delete the in-between crap, keep the 2nd row for now

#save the files as something new in the same folder

#then get list of the experiments and comp_id in the summary listed from landscalpe_labels


#then we note the double studies, note the source 2018 or 2020
#then delete the extra P values


#source ID coordinates(turn into a column) [2,1][2,2] in the 2018 paper
#move Source ID to [17,-1] No, -1 means that the 1st column is ignored
sourceid <- test_csv[[2,1]]
test_csv[17,ncol(test_csv)] <- sourceid

sourceid_value <- test_csv[[2,2]]
test_csv[-1:-17,ncol(test_csv)] <- sourceid_value



#####################Now make a loop

#source dir, dest dir, gene col, source col

human_2020 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic",
                "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined",
                18,3)

human_2020b <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic2",
               "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined2",
               13,3)

human_2018 <- list("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_automatic3_human",
                "C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_auto_combined_human",
                12,2)


#test loop on 2018 human

setwd(human_2020b[[1]])

exp_list <-list.files(pattern=".csv")

#gene name column
#delete empty rows


for (row in 1:length(exp_list)){
  setwd(human_2020b[[1]])
  
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =FALSE)
  
  #holds the file name
  file_name <- paste(container_csv[[human_2020b[[4]],2]],"_no_na.csv", collapse = "", sep="")
  print(file_name)
  print(row)
  #remove the last column
  container_csv[,ncol(container_csv)] <- NULL
  
  #location of gene column title [18th row in the 2020, 13 for 2020_2, or 12 row in 2018 paper(mouse and human)]
  container_csv[human_2020b[[3]],1] <- "gene"
  
  #for now we save the first 11 rows, we will not delete them
  non_empty_indexer <- c(1:(human_2020b[[3]]-1))
  

  #removing NA rows
  #looping only through rows from the 12th onward or 18th or 13th onward for 2020 paper from those rows and onward is gene data
  indexer <- c(human_2020b[[3]]:nrow(container_csv))


  for (val in indexer){
    #counts the number of NA cells in row from col 2 to last col -1 if it is above 0 then it is TRUE
    #we only want FALSE results
    if (rowSums(is.na(container_csv[val,2:(ncol(container_csv)-1)])>0) == FALSE){
      non_empty_indexer <- append(non_empty_indexer, val)
    }
    
    
  }
  #deleted the empty rows
  container_csv_na <- container_csv[non_empty_indexer,]
  
  #narrowing down row that has adjp
  sourcer <- container_csv_na[human_2020b[[3]],]
  sourcer <-unlist(c(sourcer))
  
  #finds all of the adjP indexes
  delete_end_index_col <- which(sourcer %in% "adjP")
  
  #the index to where to delete
  delete_end_index_col_prim <- delete_end_index_col[[1]]-1
  
  delete_start_index_col <- 3 #delete from column 3 onward until delete_end_index-1 (we dont want adjP gone)
  
  #this works
  container_csv_na<- container_csv_na[,-c(delete_start_index_col:delete_end_index_col_prim)]
  
  setwd(human_2020b[[2]])
  
  fwrite(container_csv_na,file_name, col.names = FALSE)
  
}

#saving the data




