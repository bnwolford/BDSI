# BDSI Genomics Group Questions and Answers  

**Q:** I was taught that with multiple testing the p-value was 0.05/(# SNPs tested), so why is the genome wide significance threshold 5e-08?  
**A:** This threshold was established in seminal papers in [2005](https://www.ncbi.nlm.nih.gov/pubmed/16255080) and [2008](https://www.ncbi.nlm.nih.gov/pubmed/18348202). You can read more [here](https://academic.oup.com/ije/article/41/1/273/647338). Essentially, we estimate that due to linkage disequlibrium, the number of independent SNPs tested in GWAS is 1 million. So 0.05/1,000,000 is 5e-8. Now that GWAS is performed on very densely imputed markers (e.g. > 75 million SNPs tested) and across multiple phenotypes, there is some discussion of establishing a lower threshold to account for more independent tests. 

**Q:** How long should it take for us to expect natural resistance to develop for complex and dangerous diseases, and by then what new diseases will have either evolved or been generated/noticed in human society?  
**A:**  

**Q:** What is the procedure/algorithm for selecting SNPs for PRS? For eg ,they can be correlated , so calculating p values should be done having regressed out (in some sense) the effect of neighboring SNPs.  
**A:**  This could be an entire review paper and is touched on in this [review paper](https://www.biorxiv.org/content/biorxiv/early/2018/09/14/416545.full.pdf).
1) Just choose the lead SNPs
2) LD pruning
3) LD clumping
4) [LDpred](http://www.cell.com/ajhg/abstract/S0002-9297(15)00365-1) 
5) LASSO as done [here]()

**Q:** How do I run commands using R in the terminal. How do I "save" said R file and then re-access it?  
**A:** From the command line type `R` and press enter. An interactive session of R will start and you will see `>` prompts in which you can execute R commands. I would suggest creating a plain text file with nano, vim, or emacs on the cluster or a basic text editor on your computer to record the relevant lines of R code that you are executing. When you exit R with `q()` or control-d you will be prompted to save your R session which you can read more about [here](https://www.r-bloggers.com/using-r-dont-save-your-workspace/).

**Q:** How do you discern when a trait is from a polygenic or monogenic etiology?  
**A:**  Monogenic diseases run in families based on Mendelian laws and are generally the result of 1 mutation causing 1 phenotype. Complex diseases have a less clear inheritance pattern and how much genetic risk an individual has impacts disease onset and severity. Some traits have both monogenic and polygenic etiology. For example, thoracic aortic aneurysm/dissection (TAAD) is a trait associated from Mendelian mutations like those in *FBN1* which cause Marfan Syndrome. But there are also many cases of TAAD which do not have a mutation in known TAAD genes and are likely a combination polygenic risk + environment. Some genes are linked with both monogenic/polygenic traits as well--common variants in *APOB* are linked to coronary artery disease (polygenic) while some rare variants are causal for Hypobetalipoproteinemia (monogenic). 

**Q:** How to use .csv tables in plink?  
**A:** You can't! Different plink commands require specifically formatted input files which you can read about [here](https://www.cog-genomics.org/plink2).

**Q:** How to open .bim files?   
**A:** You can use `less <file.bim>` to view the .bim file.

**Q:** How to efficiently cut and paste columns between tables.  
**A:** There are many ways to do this. One option is to open each table in R and use [dplyr](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) to manipulate the columns to a data frame format of your choice.  You can also use a combination of command line tools like `cut` and  `paste`.
