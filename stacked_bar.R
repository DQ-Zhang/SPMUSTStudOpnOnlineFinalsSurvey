category_names=c("Year1","Year2","Year3","Year4","Yes","No")
labels=c("confd1","confd2","confd3","indvar1","indvar2","indvar3","indvar4","indvar5","indvar6","indvar7")
Year1=c(24.73,0,0,0,0,0,0,0,0,0)
Year2=c(23.63,0,0,0,0,0,0,0,0,0)
Year3=c(24.73,0,0,0,0,0,0,0,0,0)
Year4=c(26.91,0,0,0,0,0,0,0,0,0)
Yes=c(0,27.47,37.36,87.36,87.91,70.33,32.97,80.77,77.47,81.32)
No =c(0,72.53,62.64,12.64,12.09,29.67,67.03,80.77,22.53,18.68)
colours=c("#CCFFCC","#FFCCFF","#99CCFF","#FF7C80","#CC00FF","#FFFF66")
data=data.frame(Year1,Year2,Year3,Year4,Yes,No,row.names=labels,stringsAsFactors=False)
data2=as.matrix(data)

barplot(data2,
        col=colours,
        space=1,
        horiz=TRUE,
        legend.text=TRUE,
        border=NA,
        )





