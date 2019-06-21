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

We want to practice a typical workflow which involves sharing a cenral dataset and performing indpeendent analyses in our own directories. For this reason, I've downloaded the data for you, and those steps are now commented out (i.e. # is placed at the front of the code line). 

We want to start tan interactive session to request compute resources before we get started.
`srun --time=2:00 --mem=4000MB --pty /bin/bash`
In an analysis directory in your home directory, launch R with `R`. Follow the R code and answer the questions [here]().

### Population Genetics

`cd /home/bdsi2019/genomics/data/popgen`

### Mendelian Randomization

`cd /home/bdsi2019/genomics/data/mr`
