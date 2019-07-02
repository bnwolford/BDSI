# UNIX

# Functions
```
sed
awk
wc 
cut
sort
uniq
less
zless
cat
zcat
gzip
```

# One-liners

#look  at more options for a function  
`sed  --help`  
`man sed`  

#remove the header and  print every line and then count how many lines  
`less file | awk 'NR > 1 {print $0}' | wc -l `

#make a comma delimited file into a tab delimited file by search and replace with sed 
`less file.csv | sed 's/,/\t/g' > file.tsv`

#how many unique entries in column 6  
`less file | cut -f 6 | sort | uniq -c`

#look at what processes you have running  
`htop -u <uniqname>`

#select certain columns from a file and write to a new file
`cat file | awk '{print $3"\t"$2"\t"$1}' > newfile.txt
