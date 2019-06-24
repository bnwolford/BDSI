############################################################
## PART I. Collect the single cell RNAseq data set from Brain tissue
############################################################
## First, we need to obtain the single cell RNAseq data. Here, we will download a single cell RNAseq data obtained from brain tissue.
## This is the paper describing the single cell RNAseq data set:
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
## Second, we need to obtain the bulk RNAseq data. Here, we will focus on a bulk RNAseq data obtained from the GTEx study.
## A description of the GTEx study is available in the following papers and website:
## The Genotype-Tissue Expression (GTEx) project, Nature Genetics, 2013
## The Genotype-Tissue Expression (GTEx) pilot analysis: Multitissue gene regulation in humans, Science, 2015
## https://www.gtexportal.org/home/
#########################################################################
## GTEx data can be directly downloaded from the following website
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
##  Run deconvolution method. This step is to estimate the proportion of different cell types in the bulk RNAseq data, using the cell type specific gene expression from the single cell RNAseq data as a reference. For deconvolution method, we will use MuSiC as an example. Example code on the remaining ten deconvolution methods are available at: https://github.com/xzhoulab/DECComparison

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
#Go view this R script to see what the function DECMuSiC will do.

## STEP 3. run MuSiC
#Read more about MuSiC here: https://www.nature.com/articles/s41467-018-08023-x
#you will need to follow prompts to download/update requirements
res_music <-DECMuSiC(sc_counts=sc_counts, sc_cell_type=sc_annot_sample$cell_type1, bulk_counts=bulk_brain_counts)

## STEP 4. visualize the results of MuSiC
names(res_music)
str(res_music)
#Q: What data is in this object?

# Jitter plot of estimated cell type proportions
jitter.fig = Jitter_Est(list(data.matrix(res_music$Est.prop.weighted),
                             data.matrix(res_music$Est.prop.allgene)),
                        method.name = c('MuSiC', 'NNLS'), title = 'Jitter plot of Est Proportions')
jitter.fig

#Q: What are you visualizing? Interpret the differences. 
#HINT: NNLS is Nonnegative least squares and MuSiC is a new weighted NNLs method.


##############################
#### PART IV: Validation######
##############################
## Finally, we attempt to validate the deconvolution results. Here, we obtain single cell data for the same brain tissue in the GTEx project. We directly calculate the proportion of different neuronal cell types in this GTEx single cell data and treat it as the ``truth". We then compare these directly estimated proportions to the deconvolution results. While these single cell data are not collected for the exact same indivdiuals who have bulk RNAseq, they are performed in the same study and thus would serve as a reasonable validation.

## STEP 1. download data from GTEx Portal:
#wget https://storage.googleapis.com/gtex_additional_datasets/single_cell_data/GTEx_droncseq_hip_pcf.tar

## STEP 2. unzip the file
#tar xf GTEx_droncseq_hip_pcf.tar

## STEP 3. unzip the gene expression counts
#cd GTEx_droncseq_hip_pcf
#gunzip GTEx_droncseq_hip_pcf.umi_counts.txt.gz

dd<-"/home/bdsi2019/genomics/data/scrna/GTEx_droncseq_hip_pcf/"

## STEP 4. read the single-cell count data
sc_counts <- read.table(paste0(dd,"GTEx_droncseq_hip_pcf.umi_counts.txt"),header=T,row.names=1)
dim(sc_counts) 
#Q: How many cells are there? What are on the row and columns of this matrix?

## STEP 5. load the cell type information
#wget https://media.nature.com/original/nature-assets/nmeth/journal/v14/n10/extref/nmeth.4407-S10.xlsx
if (require(readxl)==FALSE){
  install.packages("readxl")
  library("readxl")
}
if (require(tidyr)==FALSE){
  install.packages("tidyr")
  library("tidyr")
}
sc_cell_type<-read_excel(paste0(dd,"nmeth.4407-S10.xlsx"),skip=20) 
names(sc_cell_type)<-c("cell_id","num_genes","num_transcripts","cluster_id","cluster_name") #make column names nicer

#make intelligible cell labels that also match the deconvolution cell types
sc_cell_type$cell<-NA
sc_cell_type[sc_cell_type$cluster_name=="exPFC1" | sc_cell_type$cluster_name=="exPFC2",]$cell<-"glutamatergic_neurons_from_the_PFC"
sc_cell_type[sc_cell_type$cluster_name=="exCA1" | sc_cell_type$cluster_name=="exCA3",]$cell<-"pyramidal_neurons_from_th_hip_CA_region"
sc_cell_type[sc_cell_type$cluster_name=="GABA1" | sc_cell_type$cluster_name=="GABA2",]$cell<-"GABAergic_interneurons"
sc_cell_type[sc_cell_type$cluster_name=="GABA1",]$cell<-"granule_neurons_from_the_hip_dentate_gyrus_region"
sc_cell_type[sc_cell_type$cluster_name=="ASC1" | sc_cell_type$cluster_name=="ASC2",]$cell<-"astrocytes"
sc_cell_type[sc_cell_type$cluster_name=="ODC1",]$cell<-"oligodendrocytes"
sc_cell_type[sc_cell_type$cluster_name=="OPC",]$cell<-"OPC" #oligodendrocyte_precursor_cells
sc_cell_type[sc_cell_type$cluster_name=="MG",]$cell<-"microglia"
sc_cell_type[sc_cell_type$cluster_name=="NSC",]$cell<-"neuronal_stem_cells"
sc_cell_type[sc_cell_type$cluster_name=="END",]$cell<-"endothelial"

#directly estimate proportions of cell types in our 'truth' data by counting cell types in the excel
table(sc_cell_type$cell)/nrow(sc_cell_type)

#make 'truth' into a data frame
truth<-data.frame(t(matrix(table(sc_cell_type$cell)/nrow(sc_cell_type))))
names(truth)<-data.frame(table(sc_cell_type$cell)/nrow(sc_cell_type))$Var1
truth$label<-"truth"

#make the estimated proportions from deconvolution with MuSiC into a data frame and merge with 'truth'
estimate<-data.frame(res_music$Est.prop.weighted)
estimate$label<-row.names(estimate)
row.names(estimate)<-NULL
compare<-bind_rows(truth,estimate)

#compare summary statistics like mean to the 'truth'
summary(estimate[,c("astrocytes","endothelial","OPC","oligodendrocytes")])
truth[,c("astrocytes","endothelial","OPC","oligodendrocytes")]

#Q: Using the compare data set or some of the intermediate datasets above, try to make a boxplot comparing the distribution of cellular proportions across GTEx samples to the benchmark 'truth' in the shared cell types (e.g. astrocytes, endothelial, microglia, oligodendrocytes). Or maybe a scatter plot!


##############
## After this excercise, we will try to use the other 10 different methods to analyze the data and compare the performance of different methods.
##############
