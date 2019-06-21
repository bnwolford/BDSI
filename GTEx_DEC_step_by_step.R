############################################################
## PART I. Collect the single cell RNAseq data set from Brain tissue
############################################################
## Darmanis, S. et al. A survey of human brain transcriptome diversity at the single cell level. 
## Proc. Natl. Acad. Sci. U. S. A. 112, 7285–7290 (2015)
####
# load the Darmains data set from Gene Expression Omnibus (GEO)
####=====
## STEP 0: set data directory
dd<-"/home/bdsi2019/genomics/data/scrna/"

## STEP 1. load the data from GEO
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE67nnn/GSE67835/matrix/GSE67835-GPL15520_series_matrix.txt.gz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE67nnn/GSE67835/matrix/GSE67835-GPL18573_series_matrix.txt.gz

## STEP 2. unzip the files
#gunzip GSE67835-GPL15520_series_matrix.txt.gz
#gunzip GSE67835-GPL18573_series_matrix.txt.gz

## STEP 3. prepocess the data sets via perl script (take ~1 minutes)
## perl code parse_series_matrix.pl can be downloaded from https://github.com/xzhoulab/DECComparison/tree/master/utils
#perl ~/DECComparison/utils/parse_series_matrix.pl GSE67835-GPL15520_series_matrix.txt > Ann_part1.txt
#mv ExprMat.txt ExprMat1.txt
#perl ~/DECComparison/utils/parse_series_matrix.pl GSE67835-GPL18573_series_matrix.txt > Ann_part2.txt
#mv ExprMat.txt ExprMat2.txt

##############
## STEP 4. combine the two count data togther via R script
### single-cell
data1 <- read.table(paste0(dd,"ExprMat1.txt"), header=T)
data2 <- read.table(paste0(dd,"ExprMat2.txt"), header=T)
sc_counts <- cbind(data1, data2)

## STEP 5. filter out the lowly expressed genes
keep_idx <- rowSums(sc_counts>5) > 10
sc_counts <- as.data.frame(sc_counts[keep_idx,])

sc_counts <- data.frame(GeneID=rownames(sc_counts), sc_counts)

sc_counts[1:5,1:5]

## STEP 6. combine the two count data togther via R script
ann1 <- read.table(paste0(dd,"Ann_part1.txt"), header=T)
ann2 <- read.table(paste0(dd,"Ann_part2.txt"), header=T)
sc_annot_sample <- as.data.frame(rbind(t(ann1), t(ann2)))
rownames(sc_annot_sample) <- NULL
colnames(sc_annot_sample) <- c("Source", "Species", "Tissue", "cell_type1", "age", "plate", "individual", "File")
table(sc_annot_sample$cell_type1)

#Q: How many cell types are there?
#Q: What tissues are there?


#########################################################################
## PART II. Collect the bulk RNAseq data set from GTEx database from Brain tissue
#########################################################################
## GTEx data download from the website
# https://gtexportal.org/home/datasets

## STEP 0: set data directory
dd<-"/home/bdsi2019/genomics/data/scrna/"

## STEP 1. load read counts 
#wget  https://storage.googleapis.com/gtex_analysis_v6p/rna_seq_data/GTEx_Analysis_v6p_RNA-seq_RNA-SeQCv1.1.8_gene_reads.gct.gz

## STEP 2. load sample annotation information
#wget https://storage.googleapis.com/gtex_analysis_v6p/annotations/GTEx_Data_V6_Annotations_SampleAttributesDS.txt

## STEP 3. load the data into R
library(data.table)
bulk_counts <- fread(paste0(dd,'GTEx_Analysis_v6p_RNA-seq_RNA-SeQCv1.1.8_gene_reads.gct.gz'))
annot_sample <- fread(paste0(dd,'GTEx_Data_V6_Annotations_SampleAttributesDS.txt'))
annot_sample <- annot_sample[, .(SAMPID,SMTS,SMTSD)]

#Q: in the SMTS column, how many tissues are represented in GTEx? 
#Go to https://www.gtexportal.org/home/ for more information on the study.

## STEP 4. get the data that is only from Brain
brain_sample <- annot_sample[SMTS=="Brain", SAMPID]
bulk_brain_counts <- bulk_counts[, intersect(names(bulk_counts), brain_sample), with=FALSE]

## STEP 5. filter out lowly expressed genes
keep_idx <- rowSums(bulk_brain_counts>5) > 10
bulk_brain_counts <- as.data.frame(bulk_brain_counts[keep_idx,])
bulk_counts <- bulk_counts[keep_idx,]
# add expression, gene id and symbol
rownames(bulk_brain_counts) <- sub("[.][0-9]+","",bulk_counts$Name)

#Q: Why would we want to filter out the lowly expressed genes?

bulk_brain_counts <- data.frame(GeneID = bulk_counts$Description, bulk_brain_counts)

bulk_brain_counts[1:4,1:5]

#Q: What are the ENSGXXXX numbers? 

######################################
##  PART III. Run deconvolution method -- MuSiC
######################################

## STEP 1. make sure the gene names of bulk RNAseq data and single-cell RNAseq are matched to each other
dim(bulk_brain_counts)
dim(sc_counts)

combined_data <- merge(bulk_brain_counts, sc_counts, by="GeneID")
bulk_brain_counts <- combined_data[,c(2:ncol(bulk_brain_counts))]
rownames(bulk_brain_counts) <- make.names(combined_data$GeneID, unique=TRUE)
sc_counts <- combined_data[, c((ncol(bulk_brain_counts)+2):ncol(combined_data))]
rownames(sc_counts) <- make.names(combined_data$GeneID, unique=TRUE)

dim(bulk_brain_counts)
dim(sc_counts)

#Q: What are the rows and what are the columns of these 2 datasets?

## STEP 2. load the deconvolution method -- MuSiC code
source("~/DECComparison/algorithms/dec_music.R")
## STEP 3. run MuSiC
#Read more about MuSiC here: https://www.nature.com/articles/s41467-018-08023-x
#you will need to follow prompts to download/update requirements
res_music <-DECMuSiC(sc_counts=sc_counts, sc_cell_type=sc_annot_sample$cell_type1, bulk_counts=bulk_brain_counts)

## STEP 4. visualize the results of MuSiC
names(res_music)
str(res_music)

# Jitter plot of estimated cell type proportions
jitter.fig = Jitter_Est(list(data.matrix(res_music$Est.prop.weighted),
                             data.matrix(res_music$Est.prop.allgene)),
                        method.name = c('MuSiC', 'NNLS'), title = 'Jitter plot of Est Proportions')
jitter.fig


##################
## PART IV:   ##
##################
## GOAL: using GTEx single cell data to deconvolute the GTEx 
## bulk RNAseq data using MuSiC, and compare the cell type proportions 
## from both different single-cell data sources
##


## STEP 1. download data from GTEx Portal:
wget https://storage.googleapis.com/gtex_additional_datasets/single_cell_data/GTEx_droncseq_hip_pcf.tar

## STEP 2. unzip the file
tar xf GTEx_droncseq_hip_pcf.tar

## STEP 3. unzip the gene expression counts
cd GTEx_droncseq_hip_pcf
gunzip GTEx_droncseq_hip_pcf.umi_counts.txt.gz

## STEP 4. read the single-cell count data
sc_counts <- read.table("GTEx_droncseq_hip_pcf.umi_counts.txt",header=T,row.names=1)

## STEP 5. load the cell type information 
https://media.nature.com/original/nature-assets/nmeth/journal/v14/n10/extref/nmeth.4407-S10.xlsx

sc_cell_type
