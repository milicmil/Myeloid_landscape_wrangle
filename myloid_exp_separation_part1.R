library(data.table)
library(tidyverse)
library(readxl)



#This dataframe reads in the excel sheets and separates them according to the experiment.


#start from here
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020")
setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018")


#dude2 <- read_excel("mmc3_2020.xlsx",col_names = FALSE)
#dude2 <- read_excel("mmc4_2020.xlsx",col_names = FALSE)
dude2 <- read_excel("mmc3_2018.xlsx",col_names = FALSE)


#reding in the data frrame gene names. ENSEML, ENTREZ Gene Name
setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\")
gene_names_2020 <- read.csv("gene_names_2020.csv", na.strings = c("", "NA"),header =FALSE)
#need to add 5 empty rows above
x <- rep(NA, ncol(gene_names_2020))
for (i in c(1:5)){
  gene_names_2020 <- rbind(x, gene_names_2020)
}

#for mmmc4 in 2020
gene_names_2020_2 <- read.csv("gene_names_2020.csv", na.strings = c("", "NA"),header =FALSE)

#for human in 2018
gene_names_2018 <- read.csv("gene_names_2018.csv", na.strings = c("", "NA"),header =FALSE)


#no need, this is for mouse genes
#dude2 <- read_excel("mmc4_2018.xlsx",col_names = FALSE)
#steps to clean up mmmc3 into individual studies

#part1
#read in excel sheet large(DONE)
#find column index of sourceID and save as list source_id_index (DONE)
#Delete the Fluidigm columns (DONE)
#Find the ID of source ID and save as list source_id_name (DONE)
#Now chop the table by the index of source ID subset function(DONE)
#Save the first column and cbind t the data frames (not needed)
#capitalise each gene in source ID column
#name each csv as source_id_name(DONE)
#
#PART 1 DONE

#Part2 (go through each csv and delete the log2 and p value columns you dont need) and the extra crap.


#part3 (migrating the columns)
#transform each individual study (dont do a loop as some studies have multiple P values)

#part4, joining the CSV into large data frame
#read in each csv and Rbind
#read in landscape labels and then attach it





#remove the fusiform gyrus from 2020 mmc3
#EK=141 GI=191 remove 
#cols = c(141:191)
#dude2 <- subset(dude2, select = -c(cols) )

#row.names(dude2) <- NULL

#source ID search 2nd row in 2018 paper, 3rd row in 2020
sourcer <- dude2[2,]
#turns to vector but still has DF elements

#sourcer <- as.vector(sourcer)

#ll <- list(1:4, 5:6, 7:12, 1:12)

#class(sourcer)
#dim(sourcer)

#a data frame but poor solution
#https://stackoverflow.com/questions/9981224/search-for-index-of-a-list-entry-in-r
#which(sapply(ll, FUN=function(X) "sourceID" %in% X))

#convert 1 d data frame to vector
#https://stackoverflow.com/questions/19340401/convert-a-row-of-a-data-frame-to-a-simple-vector-in-r

#saves only first row
#ll<-sourcer[1,]

#removed the names
#names(ll)<-NULL
#makes it into a list

ll <-unlist(c(sourcer))

##typeof(ll)
#ll

#finding the column index of source ID
source_id_start_index <- which(ll %in% "sourceID")
source_id_end_index <- source_id_start_index-1

#removing the first end index (8 or 24 )
source_id_end_index<-source_id_end_index[-1]
#adding the last index, 2020 is 619 or 177   #### mmc3_2018 is 338 
source_id_end_index<- append(source_id_end_index, 338)



##################seeing if I get the correct divisions of the (TEST BAtch)
#cols2 <- c(361:517)
cols2 <- c(source_id_start_index[1]:source_id_end_index[1])
test_data <- subset(dude2, select = c(cols2) )
#kkeps the file neme of the experiment
test_file_name <- test_data[[1,2]]


#figure out what is wrong wit loop
source_id_start_index

source_id_start_index[5]
source_id_end_index[5]
cols2 <- c(source_id_start_index[5]:source_id_end_index[5])
study_data <- subset(dude2, select = c(cols2) )
fwrite(study_data,file_name)

study_data
###################### end of test area


#now loop and chop

#counter of length of source_id_start_index
x <- c(1:length(source_id_start_index))
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_automatic2")

#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018\\experiment_list_automatic3_human")


###############For the 2nd attempt with the better gene identifiers
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\alzheimers paper2020\\experiments_2020")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\alzheimers paper2020\\experiments_2020_2")

setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\Diverse Brain2018\\experiments3_human")





#goes through the crappy excel and separates out the individual experiments,
#it works, make sure to delete the weird experiment from the excel before 
for (val in x) {
  print(val)
  #defines thew range of columns 
  cols2 <- c(source_id_start_index[val]:source_id_end_index[val])
  #subsets he read in excel data frame
  study_data <- subset(dude2, select = c(cols2) )
  
  
  #file_name <- study_data[[2,x+1]]
  #for the 2020 experiment name
  #file_name <- paste(study_data[[3,2]],".csv", collapse = "", sep="")
  #for the 2018 experiment
  file_name <- paste(study_data[[2,2]], ".csv",collapse = "", sep="")
  #adding the gene names and the study data together
  study_data <- cbind(gene_names_2018,study_data)
  
  fwrite(study_data,file_name, col.names = FALSE)
}


#This is the first attempt without the extra names

#for (val in x) {
#  print(val)
#  #defines thew range of columns 
#  cols2 <- c(source_id_start_index[val]:source_id_end_index[val])
#  #subsets he read in excel data frame
#  study_data <- subset(dude2, select = c(cols2) )
#  #file_name <- study_data[[2,x+1]]
#  #for the 2020 experiment name
#  file_name <- paste(study_data[[3,2]],".csv", collapse = "", sep="")
#  #for the 2018 experiment
#  #file_name <- paste(study_data[[2,2]],"mouse.csv", collapse = "", sep="")
#  fwrite(study_data,file_name, col.names = FALSE)
#}

