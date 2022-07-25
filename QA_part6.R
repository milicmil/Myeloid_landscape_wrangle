library(data.table)
library(tidyverse)
library(readxl)

library(dplyr)



setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")

mono <- read.csv('mono_blood_for_myeloidlandscape.csv', na.strings = c("", "NA"),header =TRUE)

#dropped 2 columns
mono <- mono[,-c(2,4)]

colnames(mono) <- c("phenotype","geneID","mono_blood_p_value")

#drops the phenotype column
mono_drop <- mono[,-c(1)]

#now let us find the duplicates and remove the higher P values, Only keep the lowest

#https://stackoverflow.com/questions/12805964/remove-duplicates-keeping-entry-with-largest-absolute-value
#https://statisticsglobe.com/delete-duplicate-rows-based-on-column-values-r
#data_ordered <- mono_drop[order(mono_drop$mono_blood_p_value, decreasing = FALSE), ] 

#kept the smallest on top
data_ordered <- mono_drop[order(mono_drop$geneID, abs(mono_drop$mono_blood_p_value)), ]

#done, removed the higher values for each gene, we are looking for lowest p irrespecive of phenotype
data_ordered2 <- data_ordered[ !duplicated(data_ordered$geneID), ]  

#now get the phenotype back, works !
data_ordered2 <- merge(data_ordered2, mono, by = c("geneID", "mono_blood_p_value"))



#rename col names for biggie file
# old "gene","sourceID","comp_id","adjp","log2"

#The ultimate merge, the biggie file and then the dan's gene expression values

# new "geneID","experimentID","test","pvalue","coefficient"

biggie <- read.csv("biggie_file.csv", na.strings = c("", "NA"),header =TRUE)


biggie_small <- read.csv("merged_df_mono_myeloid.csv", na.strings = c("", "NA"),header =TRUE)


####################QC testing

df_uniq <- unique(data_ordered$geneID)
length(df_uniq)

df_uniq <- unique(biggie$gene)
length(df_uniq)

df_uniq <- unique(biggie_small$experimentID)
length(df_uniq)





#have sept and march genes in data frames (excel renaming convention)?


#search fo rthem and check specific data frames that were fixed manually (in binding_csv part5)
data2 <- biggie_small[biggie_small$experimentID %like% "GSE75246", ]        # Extract matching rows with %like%
head(data2)

data2 <- biggie_small[biggie_small$geneID %like% "Sept", ]        # Extract matching rows with %like%
head(data2)

#no evidence yet



#check files 2018 GSE52564_complete.csv missing log2 E-MTAB-2660_complete.csv(capitalise)


# 2020 GSE99074_complete.csv (has max cook) GSE75246_complete.csv(has max cook,not capitalised genes,) GSE75431_complete.csv (missing log2, not capitalised genes)
setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020\\experiment_list_auto_combined2\\part3\\part4")

test<- read.csv("GSE99074_complete.csv", na.strings = c("", "NA"),header =TRUE)

data2 <- test[test$gene %like% "Sept", ]        # Extract matching rows with %like%
head(data2)

#issues with non capitalised gene names 

#go over 2020 part4 and capitalise it and then bind again

#doubles of data frames


#see 75246_2018
#looking at gene numbers in each of the copies
test2<- read.csv("75246_2020.csv", na.strings = c("", "NA"),header =FALSE)
test<- read.csv("75246_2018.csv", na.strings = c("", "NA"),header =FALSE)

length(unique(test2[[1]]))


#look at the 'mono_blood_for_myeloidlandscape.csv' and "biggie_file3.csv" 
# and see ifthere are duplicate gene entries in same experiment

biggie3 <- read.csv("biggie_file3.csv", na.strings = c("", "NA"),header =TRUE)

#https://stackoverflow.com/questions/51272510/how-to-count-unique-rows-in-a-data-frame
big_count <- biggie3 %>% group_by_all() %>% summarise(COUNT = n())

#so lots of doubles in gene names, some are blank. Biggie_file3 is not joined
big_counter <- big_count   %>% filter(COUNT > 1)

##############how to remove the double entries read biggie4


biggie3 <- read.csv("biggie_file3.csv", na.strings = c("", "NA"),header =TRUE)

#see data frame structure

dup_rows_biggie <-biggie3 %>% group_by_all() %>% summarise(COUNT = n()) %>% filter (COUNT >1)

#biggie3 has gene names

gene_names <- biggie3 %>% select(gene) %>%  distinct()





#so about 34000 gene names

#I want to see if the crappy sept and march genes are in there

#tested for SPET and MARCH and found them. looked for the integers

gene_names[grep("^[0-9]", gene_names$gene), ]
#found the  crap, some genes ar econverted
#https://robaboukhalil.medium.com/how-to-fix-excels-gene-to-date-conversion-5c98d0072450

var reg = /^\d+$/;

gene_names[grep("MARCH", gene_names$gene), ]

gene_names[grep("-MAR", gene_names$gene), ]

#so mono is fine
mono[grep("ENSG00000198060", mono$gene), ]

#var reg = /^\d+$/;


#see in Biggie the -MAR and -SEP

bad_mar <- biggie3[grep("-MAR", biggie3$gene), ]

bad_sep <- biggie3[grep("-SEP", biggie3$gene), ]

bad_dec <- biggie3[grep("-DEC", biggie3$gene), ]

########################################
#See if the number of genes is the same in the 3 big xcel sheets and how to make the gene ID data frames for both

#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\alzheimers paper2020")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes")
#setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018")

dude2 <- read_excel("mmc4_2020.xlsx",col_names = FALSE)
dude3 <- read_excel("mmc4_2020.xlsx",col_names = FALSE)

#selecting the gene id columnsfor dude 2
gene_cols <- dude2[,c(1,2,12)]
#take out one extra row  , this data frame is tacked onto 2018 results
gene_cols_2018 <- gene_cols[-c(2),]



setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\ensembl_genes")
fwrite(gene_cols,"gene_names_2020.csv", col.names = FALSE)
fwrite(gene_cols_2018,"gene_names_2018.csv", col.names = FALSE)

#these bind to the individual data sets

########################################################################
#selecting the rows we need
#gene_cols <- gene_cols[-c(1:11),]

#gene_cols_names <- gene_cols %>% select(c(1)) %>%  distinct()
#gene_cols_entrez <- gene_cols %>% select(c(2)) %>%  distinct()
#gene_cols_ensembl <- gene_cols %>% select(c(3)) %>%  distinct()

#make the gene name



#so out of 30729 rows we have 30729 entrez, 24303 ensembl and 30594 distinct gene names

gene_cols3 <- dude3[,c(1,2,12)]
#selecting the rows we need



gene_cols3 <- gene_cols3[-c(1:11),]

#gene_cols_names3 <- gene_cols3 %>% select(c(1)) %>%  distinct()
#gene_cols_entrez3 <- gene_cols3 %>% select(c(2)) %>%  distinct()
#gene_cols_ensembl3 <- gene_cols3 %>% select(c(3)) %>%  distinct()


setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\Diverse Brain2018")

dude2018 <- read_excel("mmc3_2018.xlsx",col_names = FALSE)

gene_cols2018 <- dude2018[,c(1,2)]






#gene_cols2018 <- gene_cols2018[-c(1:10),]

#gene_cols_names2018 <- gene_cols2018 %>% select(c(1)) %>%  distinct()
# <- gene_cols2018 %>% select(c(2)) %>%  distinct()


#see if gene names are exatly the same across rows and 125050, yes they are

#yes they are
name_test <- dude2[,c(1,22)]
name_test <- name_test[-c(1:13),]

setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")
#do loop to see if row indices are repeated
write_xlsx(name_test,"C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\name_test.xlsx")


library("writexl")
