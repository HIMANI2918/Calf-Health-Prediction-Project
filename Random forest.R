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



CHTrain <- makeClassifTask(data=CHData, target="Response")
rfLearn <- makeLearner("classif.ranger", predict.type = "prob")


listMeasures("classif")
#possibilities: ber, bac, brier, mcc,kappa, f1

msrs = list(ber)


#Tuning the model
PSrf <- makeParamSet(
  makeIntegerParam("mtry", lower=2, upper=round(sum(CHTrain$task.desc$n.feat)/2))
)

contrlRF <-makeTuneControlGrid(resolution=round(sum(CHTrain$task.desc$n.feat)/2-1))
tunedRF <- tuneParams(rfLearn, CHTrain, par.set = PSrf, control=contrlRF, cv5, measures = msrs)
rfLearn <- setHyperPars(rfLearn, par.vals = list(mtry = tunedRF$x$mtry))
rfTrained <- train(rfLearn, CHTrain)

#getting accuracy of the classification RF model
rfPredTrain <- predict(rfTrained, CHTrain)
roc_measures_train <- calculateROCMeasures(rfPredTrain)
print(roc_measures_train) 



```

