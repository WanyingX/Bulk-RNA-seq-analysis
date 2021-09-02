#!/bin/env Rscript
##
library(DESeq2)
library(ggplot2)

# step1 :construct the metadata file which contains the conditions of each sample

# id: the index of your sample
# dex: condition of sample : WT vs KO / untreated vs treated 
# cell type: doesn't matter

metadata=data.frame(id=1:7,dex=rep(c("CTCF","RAD21"),c(3,4)),celltype='mESC',geo_id='')

# step2 : the raw reads count table
#  this table is combination of all results from htseq-count 
# So in general, you will have a matrix, each row is a gene and each column is a sample. ! The sample condition must agree with your metadata.

# !! the first column of the count table must be the gene id. 

# df : which is the combined gene * sample table. I make the first column as gene id

countdata=cbind(geneid=rownames(df),df)

dds <- DESeqDataSetFromMatrix(countData=countdata,
                              colData=metadata,
                              design=~dex, tidy = TRUE)
#use deseq function
dds <- DESeq(dds)

# this will give you the results, P, logFC
res=results(dds)
# got the normalized read
norm=counts(dds, normalized=TRUE)

temp=data.frame(gene=gene)
data_list=list(CTCF=df1,RAD21=df2)
for(d in names(data_list)){
df=data_list[[d]]
data1=data.frame(gene=gene)
rownames(data1)=gene
for(i in 2:(ncol(df)+1)){
	data1[,i]=0
	ind=intersect(rownames(df),rownames(data1))
	data1[ind,i]=df[ind,i-1]
}
colnames(data1)[2:ncol(data1)]=colnames(df)
temp=cbind(temp,data1[2:ncol(data1)])
}


