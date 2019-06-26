# BDSI Genomics Group Questions and Answers  

**Q:** I was taught that with multiple testing the p-value was 0.05/(# SNPs tested), so why is it should be 5e-08?  
**A:** 

**Q:** How long should it take for us to expect natural resistance to develop for complex and dangerous diseases, and by then what new diseases will have either evolved or been generated/noticed in human society?  
**A:**  

**Q:** What is the procedure/algorithm for selecting SNPs for PRS? For eg ,they can be correlated , so calculating p values should be done having regressed out (in some sense) the effect of neighboring SNPs.  
**A:**  

**Q:** How do I run commands using R in the terminal. How do I "save" said R file and then re-access it?  
**A:** From the command line type `R` and press enter. An interactive session of R will start and you will see `>` prompts which you can execute R commands. I would suggest creating a plain text file with nano, vim, emacs on the cluster or a basic text editor on your computer to record the relevant lines of R code that you are executing. When you exit R with q() or control-d you will be prompted to save your R session which you can read more about [here](https://www.r-bloggers.com/using-r-dont-save-your-workspace/).

**Q:** Discerning when a trait is from a polygenic or monogenic etiology?  
**A:**  

**Q:** How to use .csv tables in plink?  
**A:** You can't! Different plink commands require specifically formatted input files which you can read about [here](https://www.cog-genomics.org/plink2).

**Q:** How to open .bim files?   
**A:** You can use `less <file.bim>` to view the .bim file.

**Q:** How to efficiently cut and paste columns between tables.
**A:** There are many ways to do this. One option is to open each table in R and use dplyr to manipulate the columns to a data frame format of your choice.  You can also use a combination of command line tools `cut` and  `paste`.
