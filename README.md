# BDSI | Genomics
Big Data Summer Institute 2019 | Genomics  
bwolford@umich.edu  

## Resources

- [Reproductive Research Demo](https://github.com/statgen/bdsi-demo-2019)
- [Canvas](https://canvas.umich.edu/gateway/)
- [Slack](https://bdsiworkspace.slack.com)
- [BDSI Wiki](http://bigdatasummerinst.sph.umich.edu/wiki/index.php/Main_Page)  

## Log into compute resources 

1) Graphical User Interface (GUI) 

Enter the URL http://biostat-login.sph.umich.edu on Chrome or Firefox  
Enter your password and complete Duo login

2) Command line

`ssh <yourUNIQNAME>@biostat-login.sph.umich.edu`  
Enter your password and complete Duo login

## Access this git repo from your home directory
`cd ~/`  
`git clone https://github.com/bnwolford/BDSI.git`  
`cd BDSI`  
Now you find yourself in a folder that mirrors the code and files in this repo.  

## Project-specific notes

### Polygenic risk scores

`cd /home/bdsi2019/genomics/data/prs`

### Single Cell RNAseq
To access code from the [GitHub](https://github.com/xzhoulab/DECComparison), you can clone the repo into your home directory.  
`git clone https://github.com/xzhoulab/DECComparison.git`  

`Rscript data_download_tcga.R`  
`Rscript data_download_geo.R`  
These have package dependencies you will have to install: 	
`install.packages("BiocManager")`  
`BiocManager::install("TCGAbiolinks")`  
`BiocManager::install("SummarizedExperiment")`  


`cd /home/bdsi2019/genomics/data/scrna`



### Population Genetics

`cd /home/bdsi2019/genomics/data/popgen`

### Mendelian Randomization

`cd /home/bdsi2019/genomics/data/mr`

