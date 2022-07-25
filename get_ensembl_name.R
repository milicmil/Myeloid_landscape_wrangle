
#converting the gene names to ensembl

#library("org.Hs.eg.db") # remember to install it if you don't have it already

BiocManager::install("mygene")
library(data.table)
library(tidyverse)
library(readxl)
library(conflicted)

library(mygene)
library(mygene)

setwd("C:\\Users\\milos_milic\\Desktop\\datasets\\ADNI\\blood matching\\ROSMAP genes\\gene_list_2000\\")


biggie3 <- read.csv("biggie_file3.csv", na.strings = c("", "NA"),header =TRUE)

#see data frame structure

dup_rows_biggie <-biggie3 %>% dplyr::group_by_all() %>% dplyr::summarise(COUNT = n()) %>% dplyr::filter (COUNT >1)

#biggie3 has gene names

gene_names <- biggie3 %>% dplyr::select(gene) %>%  distinct()
#gene_names<- as.character(gene_names$gene)
#library("org.Hs.eg.db") # remember to install it if you don't have it already
##https://www.biostars.org/p/441386/
#
#symbols <- mapIds(org.Hs.eg.db, 
#                  keys = gene_names$gene, 
#                  keytype = "ENSEMBL", 
#                  column="SYMBOL")
#

#select(hgu95av2.db, keys=k, columns=c("SYMBOL","GENENAME"), keytype="PROBEID")


#use this package and convert gene names.
#https://www.biostars.org/p/22/
#https://www.biostars.org/p/16505/
#https://bioinformatics.stackexchange.com/questions/488/converting-gene-names-from-one-public-database-format-to-another

#gene name to ensebl isnt the same https://www.biostars.org/p/447677/

xli <-  c('DDX26B','CCDC83',  'MAST3', 'RPL11', 'ZDHHC20',  'LUC7L3',  'SNORD49A',  'CTSH', 'ACOT8')
queryMany(xli, scopes="symbol", fields=c("uniprot", "ensembl.gene", "reporter"), species="human")


#now converting all of the gene names? It is doable
queryMany(gene_names$gene, scopes="symbol", fields=c( "ensembl.gene" ), species="human")
