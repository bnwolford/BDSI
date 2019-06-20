# BDSI | Genomics
Big Data Summer Institute 2019 | Genomics  
bwolford@umich.edu  

## Resources

- [Reproductive Research Demo](https://github.com/statgen/bdsi-demo-2019)
- [Canvas](https://canvas.umich.edu/gateway/)
- [Slack](https://bdsiworkspace.slack.com)
- [BDSI Wiki](http://bigdatasummerinst.sph.umich.edu/wiki/index.php/Main_Page)  
- [UNIX tutorial](http://www.ee.surrey.ac.uk/Teaching/Unix/)
- [Useful UNIX one-liners](https://github.com/bnwolford/BDSI/blob/master/UNIX_oneliners.md)
- [Nano tutorial](https://www.howtogeek.com/howto/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/)
- [Download MobaXterm](https://mobaxterm.mobatek.net)

## Log into compute resources 

1) Graphical User Interface (GUI) 

Enter the URL http://biostat-login.sph.umich.edu on Chrome or Firefox  
Enter your password and complete Duo login  
Interactive Apps >> RStudio

2) Command line

Make sure you're on MWireless.
`ssh <yourUNIQNAME>@biostat-login.sph.umich.edu`  
Enter your password and complete Duo login

## Access this repository from your home directory
```
#head to your home directory
cd ~/
#clone the repo
git clone https://github.com/bnwolford/BDSI.git
#move into the new folder that  has been  created
cd BDSI
```
Now you find yourself in a folder that mirrors the code and files in this repo.  

## Project-specific notes

### Polygenic risk scores

`cd /home/bdsi2019/genomics/data/prs`

### Single Cell RNAseq
To access code from the [Zhou lab GitHub](https://github.com/xzhoulab/DECComparison), you can clone the repo into your home directory.  
`cd ~/`  
`git clone https://github.com/xzhoulab/DECComparison.git`   
`cd DECComparison`  

We want to practice a typical workflow which involves sharing a cenral dataset and performing indpeendent analyses in our own directories. For this reason, I've downloaded the GEO and TCGA data for you. For your information:  

I navigated to the relevant directory:  
`cd /home/bdsi2019/genomics/data/scrna`  
I installed package dependencies interactively within R:
`install.packages("BiocManager")`  
`BiocManager::install("TCGAbiolinks")`  
`BiocManager::install("SummarizedExperiment")`  
`BiocManager::install("GEOquery")` 
I made a required directory 
`mkdir GDC`
I executed the following scripts:   
`Rscript data_download_tcga.R #bulk RNAseq data and their meta information`  
`Rscript data_download_geo.R #scRNAseq data` 

I also downloaded some tissue specific signature matrices (.csv files) which have been already constructed by cloning another github repository.
```
git clone https://github.com/xzhoulab/ImmuCC.git
cd /home/bdsi2019/genomics/data/scrna/ImmuCC/tissue_Immucc/SignatureMatrix
ls *csv
```

Relevant files include:
1)
2)
3) 

Now you can use a deconvolution method in `~/DECComparison/algorithms` to perform deconvolution. You will need to perform various manipulation of the input files and create your code to get these methods up and running.

### Population Genetics

`cd /home/bdsi2019/genomics/data/popgen`

### Mendelian Randomization

`cd /home/bdsi2019/genomics/data/mr`

