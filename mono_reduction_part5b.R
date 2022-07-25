library(data.table)
library(tidyverse)
library(readxl)

#this R script then takes in the biggie file and joins it to the relevant genes Dan wants to look at to create merged_df_mono_myeloid3.csv

setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")

mono <- read.csv('mono_blood_for_myeloidlandscape.csv', na.strings = c("", "NA"),header =TRUE)

#dropped 1 columns, the ensembl gene, no dont drop ensembl gene
#mono <- mono[,-c(2)]

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


#rename col names for biggie file
# old "gene","sourceID","comp_id","adjp","log2"

# new "geneID","experimentID","test","pvalue","coefficient"
#read in the bi

#bad biggie file, non capitalised
biggie <- read.csv("biggie_file3.csv", na.strings = c("", "NA"),header =TRUE)
#biggie <- read.csv("biggie_file2.csv", na.strings = c("", "NA"),header =TRUE)

#in case something screws up, you have biggie file as backup
biggie_join<- biggie

#changing the col names that dan likes
colnames(biggie_join) <- c("geneID","pvalue","coefficient","experimentID","test")

#final join, only keeps the data for the 2080 genes
biggie_join <- merge(biggie_join, data_ordered2, by = c("geneID"))

#bad df
#fwrite(biggie_join,"merged_df_mono_myeloid.csv", col.names = TRUE)
#has the correct capitalisation
fwrite(biggie_join,"merged_df_mono_myeloid3.csv", col.names = TRUE)

#double check that the number of genes is normal
table(biggie_join$experimentID)





###################### redo except use biggie_file4.csv which has no duplicate rows and has ensembl
# and now this time use ensembl value as a 2nd factor in joining to make merged_df_mono_myeloid3.csv 

# read in regular mon o and join using ensembl and note the row number. Theoretically there should be no difference





