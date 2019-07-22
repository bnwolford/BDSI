
#calculate odds ratio between high risk and rest of the population 
odds_ratio<-function(df,qtile=0.95,prev_col,grs_col){
  q<-quantile(df[[grs_col]],qtile) #take quantile in score of interest
  df$dist<-2
  df$dist<-ifelse(df[[grs_col]]>q,1,0) #1 if in top, 0 in bottom
  df[df$dist==2]$dist<-NA
  dist_col<-which(names(df)=="dist")
  m<-as.matrix(table(df[[prev_col]],df[[dist_col]])) #2 by 2 table of binary phenotype and binary top/bottom of distribution
  print(m)
  OR<-(m[2,2]/m[1,2])/(m[2,1]/m[1,1])  #case/control top distribution over case/control bottom distribution
  SE<-sqrt(sum(1/m)) #log odds scale
  LB<-exp(log(OR)-1.96*SE)
  UB<-exp(log(OR)+1.96*SE)
  return(c(OR,LB,UB))
}
cutpts<-c(0.99,0.975,0.95,0.9,0.8)
lapply(cutpts,odds_ratio,df=df,GRS_col=grs,prev_col=pheno)

ggplot(df,aes(x=OR,y=as.factor(cutpt)) + geom_point() + theme_bw() +
    geom_errorbarh(aes(xmin=df$LB,xmax=df$UB))
 
 ####################################  
 ####################################  
 ####################################  
 
 prev_per_quantile<-function(df,GRS_col,prev_col,qtile){
    if (!sum(unique(df[[prev_col]])==c(0,1))==2) {
        print("Column for calculating prevalence of trait must be a binary variable. Expects 0 (controls) and 1 (cases).")
    }
    if (sum(qtile)<2*length(qtile)){ #check qtile
        print("q-quantiles should be number of divisions for data set and must be greater than 1")
    }
    ##initialize data structures
    p<-(100/qtile)/100
    index<-c(seq(from=0,to=1,by=p)*100)
    prevalences<-rep(NA,qtile+1) #initialize prevalence vector
    ns<-rep(NA,qtile+1) #initialize count vector
    ses<-rep(NA,qtile+1)#initialize se vector
    tiles<-quantile(df[[GRS_col]],seq(from=0,to=1,by=p)) #quantile values
    for (i in 1:length(index)-1) {
        prev_list<-df[df[[GRS_col]] > tiles[i] & df[[GRS_col]] <= tiles[i+1],][[prev_col]]
        prevalences[i]<-sum(prev_list)/length(prev_list) #how many affected in given quantile
        ns[i]<-length(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/length(prev_list)) #what is SE for this prevalence
    }
    ##create object
    pq<-list(prev=prevalences,se=ses,i=index,n=ns,tiles=tiles)
    class(pq)<-"prev_quantile_obj"
    return(pq)
}

#1-based indices for your grs and pheno column
pq<-prev_per_quantile(df=subset,GRS_col=grs_col,prev_col=pheno_col,qtile=10)

pqdf<-data.frame(prev=pq$prev,se=pq$se,i=pq$i,tiles=pq$n,pq$tiles)

pqdf$frac=pqdf$i/100
pqdf<-pqdf[pqdf$frac!=1.00,]
pqdf$ub<-pqdf$prev+(1.96*pqdf$se)
pqdf$lb<-pqdf$prev-(1.96*pqdf$se)
ymax<-max(pqdf$ub) 


main<-"Prevalence in GRS deciles"
xlab<-"GRS"
ylab<-"Phenotype prevalence"

pdf(file="prev_plot.pdf",height=5,width=5,useDingbats=FALSE)
ggplot(pqdf,aes(x=frac,y=prev,color=as.factor(1))) + geom_point() +
           scale_color_manual(values=c("grey")) +
           geom_errorbar(aes(ymin=pqdf$lb,ymax=pqdf$ub),color="grey")  +
              theme_bw() + labs(title=main) + xlab(xlab) + ylab(ylab)  + 
                     coord_cartesian(ylim=c(0,ymax)) +
                     theme(legend.position="none")
 dev.off()
 
 ####################################  
 ####################################  
 ####################################  
    
    
 #load libraries 
library(pROC)
library(RColorBrewer)

######### SET YOUR VARIABLES ###########
k<-5 #number of folds
out<-"" #output file prefix
#add YOUR column names as  strings
pheno<-"" #phenotype  of interest
age<-""
sex<-""
score<-""
#Note: if your column name is the same as one of the variable names above you will get an error

#Randomly shuffle the data after setting seed
set.seed(1234)
shufData<-yourData[sample(nrow(yourData)),]

#Create k equally sized folds
folds <- cut(seq(1,nrow(shufData)),breaks=k,labels=FALSE)

#initialize list for saving data
roc_list<-list()				   
				   
#Perform k fold cross validation
for(i in 1:k){
    #Segment your data by fold using the which() function 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- shufData[testIndexes, ]
    trainData <- shufData[-testIndexes, ]
	#fit model on training data
  	glm.obj <-glm(get(pheno) ~ get(age) + get(sex) + get(score), data = trainData, family = "binomial")
	#predict in testing data
	testPreds<-predict(glm.obj,testData)
	pdf(file=paste0(out,"ROC",i,".pdf"),height=6,width=6)					  
	roc.obj<-roc(testData[[pheno]], testPreds, plot=TRUE,print.auc=TRUE,ci=TRUE)
	dev.off()					  
	roc_list[[i]]<-roc.obj	#save ROC  object				  
}
#you can customize  your plot above by playing wtih options seeen at ?plot.roc

#parse the object
avgAUC<-mean(unlist(lapply(roc_list,auc)))
print(avgAUC)

#######################################

# set seed and shuffle again so we get the same order as before, this time we are  going to plot all together
#Randomly shuffle the data after setting seed
set.seed(1234)
shufData<-yourData[sample(nrow(yourData)),]
folds <- cut(seq(1,nrow(shufData)),breaks=k,labels=FALSE)
	
#pick k colors for plots
#you can pick different palette here: https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf
colors<-brewer.pal(k, "Set3")	
				   
#Perform k fold cross validation and plot all together
pdf(file=paste0(out,"_ROC_all_folds.pdf"),height=6,width=6)
for(i in 1:k){
    #Segment your data by fold using the which() function 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- shufData[testIndexes, ]
    trainData <- shufData[-testIndexes, ]
	#fit model on training data
  	glm.obj<-glm(get(pheno) ~ get(age) + get(sex) + get(score), data = trainData, family = "binomial")
	#use on testing data
	testPreds<-predict(glm.obj,testData)
	if (i==1){				  
		roc(testData[[pheno]], testPreds, plot=TRUE,ci=TRUE,col=colors[i],print.auc=TRUE,print.auc.col=colors[i],print.auc.y=0.5-(i*0.05))
	} else {
		roc(testData[[pheno]], testPreds, plot=TRUE,ci=TRUE,add=TRUE,col=colors[i],print.auc=TRUE,print.auc.col=colors[i],print.auc.y=0.5-(i*0.05))
	}			  
}
dev.off()
						  
### try changing what covariates  you put in the glm calls above. Change the pdf file names by changing the 'out' variable so as not to overwrite what you've made.   
