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
- [Data Visualization](https://serialmentor.com/dataviz/index.html)

## Log into compute resources 

1) Graphical User Interface (GUI) 

Enter the URL http://biostat-login.sph.umich.edu on Chrome or Firefox  
Enter your password and complete Duo login  
Interactive Apps >> RStudio
You can also submit jobs from here.  

2) Command line

Make sure you're on MWireless.
`ssh <yourUNIQNAME>@biostat-login.sph.umich.edu`  
Enter your password and complete Duo login
You can use `ssh -X <yourUNIQNAME>@biostat-login.sph.umich.edu` so that you can open figures interactive when you're running R from the  command line. For some users `ssh -Y` is required instead.
If you want to request resources for a long-running or memory intensive command, you will need to:  
1) submit a job using [sbatch](https://slurm.schedmd.com/sbatch.html)  
2) request an interactive job on a compute node using [srun](https://slurm.schedmd.com/srun.html)  
`srun --time=2:00:00 --mem=2GB --checkpoint=2:00 --pty /bin/bash`

If you want to log specifically into one of the login nodes. For example, you might want to run `htop` in the same login node that you are running a process. 
```
ssh <uniqname>@idran.bio.sph.umich.edu  
ssh <uniqname>@bajor.bio.sph.umich.edu  
```

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

We want to start an interactive session to request compute resources before we get started.  
`srun --time=2:00:00 --mem=2GB --pty /bin/bash`  
In an analysis directory in your home directory, launch R with `R`. Follow the R code and answer the questions [here](https://github.com/bnwolford/BDSI/blob/master/GTEx_DEC_step_by_step.R).  

### Population Genetics

`cd /home/bdsi2019/genomics/data/popgen`

### Mendelian Randomization

`cd /home/bdsi2019/genomics/data/mr`
