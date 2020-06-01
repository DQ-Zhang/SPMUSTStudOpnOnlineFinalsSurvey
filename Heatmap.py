# -*- coding: utf-8 -*-

#################################################################
##                       Dingqi Zhang                          ##
##                    School of Pharmacy,                      ##
##         Macau University of Science and Technology          ##
##                       2020.05.31                            ##
#################################################################

import os,pandas,plotly
import plotly.figure_factory as ff
from numpy import ndarray

#change working directory to script directory. Put csv files in the same directory as the script is.
os.chdir(os.path.dirname(os.path.realpath(__file__)))

def cor_matrix(csv,xaxis,yaxis,title,colorscale):
    """
    Function to plot a correlation matrix as a heatmap from processed dataset.
    This is dedicated to analyzing data from a survey on SPMUST students' opinions on onlin final exams.
    params:
        csv -> file name of a csv file to be read.
        xaxis -> x-axis tags on the heatmap.
        yaxis -> y-axis tags on the heatmap.
        title -> title of the graph.
    """
    m1=pandas.read_csv(csv,index_col=0).to_numpy()
    print(m1)

    pvalue_color_mapping={
        pandas.Interval(0.05,1,closed='both'):0,
        pandas.Interval(0.005,0.05,closed='left'):1,
        pandas.Interval(0.001,0.005,closed='left'):2,
        pandas.Interval(0,0.001):3
        }

    OR_tab=[]
    p_tab=[]
    for i in m1:
        OR_row=[]
        p_row=[]
        for j in i:
            
            #deal with missing values
            if str(j)!="0":
                values=str(j).split('*')
                print(i,j,values)
                values=[round(float(values[0]),2),float(values[1])]
            else:
                values=[1,1]
            
            #convert p values to numbers that indicate color
            for p_range in pvalue_color_mapping:
                if values[1] in p_range:
                    values[1]=pvalue_color_mapping[p_range]
            
            #for negative correlations, color numbers are negative. 
            if values[0]<1:
                values=[values[0],-values[1]]
            
            OR_row.append(float(values[0]))
            p_row.append(int(values[1]))
        OR_tab.append(OR_row)
        p_tab.append(p_row)
    print(OR_tab)
    print(p_tab)

    #Heatmap annotated with OR
    fig = ff.create_annotated_heatmap(p_tab,x=xaxis,y=yaxis,annotation_text=OR_tab,colorscale=colorscale,font_colors=["rgb(255,255,255)"])
    fig.update_layout(title_text=title)
    fig.show()


csv1="heatmap_matrix1_OR-P.csv"
axes=["confd2","confd3","indvar1","indvar2","indvar3","indvar4","indvar5","indvar6","indvar7"]
title1='Prevalence of Opinions and Binary Confounders in Association with Each Other'

#Color scale for negative correlation(red), no significant correlation(white) and positive correlation(red).
#darker of color indicates smaller p values.
colorscale1=[
    "rgb(150,0,0)","rgb(200,0,0)","rgb(255,100,100)",
    "rgb(255,255,255)",
    "rgb(100,255,100)","rgb(0,200,0)","rgb(0,150,0)"
    ]

csv2="heatmap_matrix2_OR-P.csv"
xaxis2=["Year1/Year2","Year1/Year3","Year1/Year4","Year2/Year3","Year2/Year4","Year3/Year4"]
title2='Prevalence of Opinions in Relation to Class'

colorscale2=[
    "rgb(150,0,0)","rgb(200,0,0)","rgb(255,100,100)",
    "rgb(255,255,255)",
    "rgb(100,255,100)"
    ]

#call function to plot the correlation matrix
#cor_matrix(csv1,axes,axes,title1,colorscale1)
cor_matrix(csv2,xaxis2,axes,title2,colorscale2)
