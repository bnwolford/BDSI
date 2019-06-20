#UNIX one-liners

#Functions
```
sed
awk
wc 
cut
sort
uniq
```

#remove the header and  printt ever
`less file | awk 'NR > 1 {print $0}' | wc -l `

#make a comma delimited file a tab delimited file
`less file.csv | sed 's/,/\t/g' > file.tsv`

