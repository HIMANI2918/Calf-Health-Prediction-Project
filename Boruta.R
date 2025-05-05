---
  title: "Calf Health Prediction"
author: "Himani Joshi"
date: "`r Sys.Date()`"
output:
  word_document: default
html_document: default
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)


library(mlr)
library(dplyr)
library(parallelMap)
library(Boruta)
library(pROC)

CHData <- read.csv("./Presence_Absence.csv", header=TRUE)       #For Presence_Absence_matrix
CHData <- read.csv("./Relative_Abundance.csv", header=TRUE)       #For Relative_Abundance_matrix

#Boruta algorithm will be trained on the whole dataset for best feature selection

CHData$Response=as.factor(CHData$Response)
CHData$Animal_Group=as.factor(CHData$Animal_Group)
CHData$Animal_ID=as.factor(CHData$Animal_ID)
CHData$Sex=as.factor(CHData$Sex)
CHData$Birth_Weight=as.factor(CHData$Birth_Weight)
CHData$Sample_ID=as.factor(CHData$Sample_ID)
CHData$Sequencing_depths=as.numeric(CHData$Sequencing_depths)

#convert Presence_Absence to factors only in case of Presence_Absence_matrix
CHData[,1:290]=lapply(CHData[,1:290],factor)
str(CHData)

#Use Boruta to estimate feature importance
```{r run Boruta to select important features}

library(Boruta) 

features <- FullData[,-c(ncol(CHData):(ncol(CHData)-1))]

Li.train <- Boruta(y =(CHData[,ncol(CHData)]),
                   x = features,
                   doTrace = 0, #Verbosity, 0 = min, 3 = max
                   maxRuns=300, 
                   ntree=1000)

Li.final <- TentativeRoughFix(Li.train)
print(Li.final)
plot(Li.final)

#Remove the "Rejected" features
tmp <- Li.final$finalDecision=="Rejected"
data_Boruta <- features[,!tmp]

#Reattach the Species column
CHData <- cbind(Response = CHData$Response, data_Boruta)
```
List features ranked by importance
```{r}
mImp <- attStats(Li.final)
smImp <- order(mImp$meanImp, decreasing = T)
mImp[smImp[1:20],]
```
