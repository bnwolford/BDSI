# UNIX

# Functions
```
sed
awk
wc 
cut
sort
uniq
```

# One-liners

#look  at more options for a function
`sed  --help`

#remove the header and  printt ever  
`less file | awk 'NR > 1 {print $0}' | wc -l `

#make a comma delimited file a tab delimited file  
`less file.csv | sed 's/,/\t/g' > file.tsv`

#how many unique entries in column 6
`less file | cut -f 6 | sort | uniq -c`

