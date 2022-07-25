library(data.table)
library(tidyverse)
library(readxl)

#this R script then takes in the biggie file and joins it to the relevant genes Dan wants to look at to create merged_df_mono_myeloid3.csv

setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes\\")

#large ddf with all of the genes, use ENSEMBL has all unique values
mono_big <- read.csv('all_monocyte_genes.csv', na.strings = c("", "NA"),header =TRUE)

colnames(mono_big) <- c("geneID","human_ensembl_id")

#use ensembl
df_uniq <- unique(mono_big$ENSG_ID)
length(df_uniq)


mono <- read.csv('mono_blood_for_myeloidlandscape.csv', na.strings = c("", "NA"),header =TRUE)

colnames(mono) <- c("phenotype","human_ensembl_id","geneID","t_statistic_mono","mono_blood_p_value")

#dropped 1 columns, the ensembl gene, no dont drop ensembl gene
#mono <- mono[,-c(2)]

#orders the data grame by gene a-z
mono <- mono[order(mono$geneID),]

#orders the data grame by gene a-z
mono <- mono[order(mono$geneID),]


colnames(mono) <- c("phenotype","geneID","t_statistic_mono","mono_blood_p_value")

#used to sort the p values and gene
mono_drop <- mono[,-c(1,3)]

#now let us find the duplicates and remove the higher P values, Only keep the lowest

#https://stackoverflow.com/questions/12805964/remove-duplicates-keeping-entry-with-largest-absolute-value
#https://statisticsglobe.com/delete-duplicate-rows-based-on-column-values-r
#data_ordered <- mono_drop[order(mono_drop$mono_blood_p_value, decreasing = FALSE), ] 

#kept the smallest on top
data_ordered <- mono_drop[order(mono_drop$geneID, abs(mono_drop$mono_blood_p_value)), ]

#done, removed the higher values for each gene
data_ordered2 <- data_ordered[ !duplicated(data_ordered$geneID), ]  

#now get the phenotype and t_stat back, it works !
data_ordered2 <- merge(data_ordered2, mono, by = c("geneID", "mono_blood_p_value"))
#2820 genes



#####################################################################
#rename col names for biggie file
# old "gene","sourceID","comp_id","adjp","log2"

# new "geneID","experimentID","test","pvalue","coefficient"
#read in the bi

#bad biggie file, non capitalised
biggie <- read.csv("biggie_file_ensembl.csv", na.strings = c("", "NA"),header =TRUE)
#biggie <- read.csv("biggie_file2.csv", na.strings = c("", "NA"),header =TRUE)

#in case something screws up, you have biggie file as backup
biggie_join<- biggie

#changing the col names that dan likes
colnames(biggie_join) <- c("geneID_original","human_entrez_id","human_ensembl_id","geneID","pvalue","coefficient","experimentID","test")


#now merge on mono_big
biggie_join_ensembl <- merge(biggie_join, mono_big, by = c("human_ensembl_id"))

biggie_join_gene <- merge(biggie_join, mono_big, by = c("geneID"))




#final join, only keeps the data for the 2080 genes #for MONO DF
biggie_join <- merge(biggie_join, data_ordered2, by = c("geneID"))

#bad df
#fwrite(biggie_join,"merged_df_mono_myeloid.csv", col.names = TRUE)
#has the correct capitalisation


#double check that the number of genes is normal
table(biggie_join_ensembl$test)

gene_names <- biggie_join_ensembl %>% select(geneID.x) %>%  distinct()

gene_names[grep("-MAR", gene_names$geneID.x), ]


#drop some columns
biggie_join_ensembl_save <- biggie_join_ensembl[,c(1,3,4,5,6,7,8)]

#renamethe gene column
colnames(biggie_join_ensembl_save)
names(biggie_join_ensembl_save)[names(biggie_join_ensembl_save) == 'geneID.x'] <- 'geneID'

##########

fwrite(biggie_join_ensembl_save,"merged_all_monocyte_genes_ensembl.csv", col.names = TRUE)


###################### redo except use biggie_file4.csv which has no duplicate rows and has ensembl
# and now this time use ensembl value as a 2nd factor in joining to make merged_df_mono_myeloid3.csv 

# read in regular mono and join using ensembl and note the row number. Theoretically there should be no difference

#testing the biggie_file_ensembl for geneID consistency between original gene_id and experiment gene_id
biggie_test <- biggie
biggie_test$result <- NA


biggie_test[[1,1]] == biggie_test[[1,4]]

for (row in 1:nrow(biggie_test)){
  
  if (biggie_test[[row,1]] == biggie_test[[row,4]]){
    biggie_test[[row,9]] <- 1
  }
}


#what was sent to Dan
#some genes use old Previous HGNC symbols ex: new:GATD1 old:PDDC1 same ENSEMBL_ID
biggie_test <- biggie_join_ensembl
biggie_test$result <- NA


biggie_test[[1,2]] == biggie_test[[1,4]]

for (row in 1:nrow(biggie_test)){
  
  if (biggie_test[[row,2]] == biggie_test[[row,4]]){
    biggie_test[[row,10]] <- 1
  }
}

biggie_test_na <- biggie_test[,c(2,4,10)]


#keeps only the distinct rows of the two geneIDs
biggie_test_na <- distinct(biggie_test_na)
#ensebl is a good starting pint for gene linkage
nas <- filter(biggie_test_na, is.na(result))



################################  
  file_name <- exp_list[[row]]
  print(file_name)
  print(row)
  
  container_csv <- read.csv(exp_list[[row]], na.strings = c("", "NA"),header =TRUE)
  #we will keep adding csv
  big_2020 <- rbind(big_2020,container_csv)
  
}

