# -*- coding: utf-8 -*-

#################################################################
##                       Dingqi Zhang                          ##
##                    School of Pharmacy,                      ##
##         Macau University of Science and Technology          ##
##                       2020.05.30                            ##
#################################################################

#change working directory to a designated folder
setwd(choose.dir())
#read pre-processed survey data as a dataframe
survey=read.csv("readydata.csv")
#import a third party module for analysis of contingency tables and odds ratio calculation
library(epitools)

#confd2-indvar7 vs each other
dataset1 <- data.frame(stringsAsFactors=FALSE)
for(m in 3:11){
  for(n in 3:11){
    if(m<n){
      #create a contingency table for data of any combination of the 9 variables, with no duplicate match.
      con_tab=table(survey[,m],survey[,n])
      #the table method above produced a 3×3 table with column 1 and row 1 being zeros.
      #it must be substracted & inverted to become a 2×2 contingency table
      con_tab=con_tab[3:2,3:2]
      #analyze contingency table and calculate odds ratio
      result=epitools::oddsratio(con_tab,rev="c",verbose=TRUE)
      #extract information from result of analysis to be a row in a dataframe
      row=c(
        names(survey[m]),
        names(survey[n]),
        result$data[1,2],
        result$data[1,1],
        result$data[2,2],
        result$data[2,1],
        result$measure[2,1],
        result$measure[2,2],
        result$measure[2,3],
        result$p.value[2,1],
        result$p.value[2,2],
        result$p.value[2,3]
      )
      #append the row to the dataframe
      dataset1=rbind(dataset1,row,stringsAsFactors=FALSE)}}}
#rename coloumn in the dataframe
names(dataset1)=c('m','n','a','b','c','d','OR','OR_lower','OR_upper','p_midp','p_fisher','p_chi2')
#export dataframe as a csv file
write.csv(dataset1,"cormatrix_3:11.csv")

#confd1(year1,2,3,4) vs confd2-indvar7
dataset2=data.frame(stringsAsFactors=FALSE)
for(var in 3:11){
  #first extract a 4×2 table from data of class and a variable
  fourbytwotab=table(survey[,2],survey[,var])
  fourbytwotab=fourbytwotab[2:5,3:2]
  for(i in 1:4){
    for(j in 1:4){
      if(i<j){
        #from that 4×2 table, six 2×2 contingency tables are derived.
        twobytwotab=fourbytwotab[c(i,j),]
        #analyze each 2×2 contingency tables
        result=epitools::oddsratio(twobytwotab,rev="c",verbose=TRUE)
        #extract information from result of analysis to be a row in a dataframe
        row=c(
          i,
          j,
          var,
          result$data[1,2],
          result$data[1,1],
          result$data[2,2],
          result$data[2,1],
          result$measure[2,1],
          result$measure[2,2],
          result$measure[2,3],
          result$p.value[2,1],
          result$p.value[2,2],
          result$p.value[2,3]
        )
        dataset2=rbind(dataset2,row,stringsAsFactors=FALSE)}}}}
names(dataset2)=c('row1','row2','var','a','b','c','d','OR','OR_lower','OR_upper','p_midp','p_fisher','p_chi2')
write.csv(dataset2,"cor_class_and_vars.csv")



#convert table for plotting correlation matrix
vars=c("confd2","confd3","indvar1","indvar2","indvar3","indvar4","indvar5","indvar6","indvar7")
#create a row with 9 zeros as basis for rows in the final dataset
zeros=c(0,0,0,0,0,0,0,0,0)
#create an empty dataframe with 9 columns as basis for the final dataset
heatmap_matrix1_OR_P=data.frame(row.names=vars,stringsAsFactors=FALSE)
allrownames=c()
for(var1 in vars){
  print(var1)
  varsubset=dataset1[which(dataset1$m==var1),c("n","OR","p_fisher")]
  subrowvalues=zeros
  nrows=nrow(varsubset)
  print(nrows)
  if(nrows>0){
    for(row in 1:nrows){
      print(row)
      subrow=varsubset[nrows+1-row,]
      #a value in the final csv file will be OR and p value joint by an asterisk.
      #example:0.510071982336732*0.282621597327686
      #They will be seperated in the python script for plotting correlation matrix.
      combined_value=paste(subrow[2],subrow[3],sep="*")
      print(combined_value)
      subrowvalues[10-row]=combined_value}
    }
  heatmap_matrix1_OR_P=cbind(heatmap_matrix1_OR_P,subrowvalues,stringsAsFactors=FALSE)
  }
names(heatmap_matrix1_OR_P)=vars
write.csv(heatmap_matrix1_OR_P,"heatmap_matrix1_OR-P.csv")

#convert table for plotting correlation matrix
heatmap_matrix2_OR_P=data.frame(stringsAsFactors=FALSE)
allrownames=c()
for(x in 3:11){
  varsubset=dataset2[which(dataset2$var==x),c("row1","row2","OR","p_fisher")]
  subrowvalues=c()
  for(y in 1:6){
    subrow=varsubset[y,]
    combined_value=paste(subrow[3],subrow[4],sep="*")
    subrowvalues=append(subrowvalues,combined_value)
  }
  rowname=paste('var',x)
  allrownames=append(allrownames,rowname)
  heatmap_matrix2_OR_P=rbind(heatmap_matrix2_OR_P,subrowvalues,stringsAsFactors=FALSE)
}
names(heatmap_matrix2_OR_P)=c('Year2/Year1','Year3/Year1','Year4/Year1','Year3/Year1','Year4/Year2','Year4/Year3')
rownames(heatmap_matrix2_OR_P)=allrownames
write.csv(heatmap_matrix2_OR_P,"heatmap_matrix2_OR-P.csv")