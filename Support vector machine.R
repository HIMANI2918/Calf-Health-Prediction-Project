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

svmLearn = makeLearner("classif.svm", predict.type = "prob")
svmConstant <- makeRemoveConstantFeaturesWrapper(svmLearn)
svmDummy <- svmLearn %>% 
  makeDummyFeaturesWrapper() %>%
  makeRemoveConstantFeaturesWrapper()

PSsvm <- makeParamSet(
  makeNumericParam("cost", lower=0, upper=5, trafo = function(x) 10^x),
  makeNumericParam("gamma", lower=-5, upper = -1, trafo = function(x)10^x)
)

contrlSVM <-makeTuneControlMBO(budget=50)
tunedSVM <- tuneParams(svmDummy, CHTrain, par.set = PSsvm, control=contrlSVM, cv5, measures = msrs)

svmDummy <- setHyperPars(svmDummy, par.vals = tunedSVM$x)
svmTrain <- mlr::train(svmDummy, CHTrain)

#getting accuracy of the classification SVM model

predsvmTrain <- predict(svmTrain, CHTrain)
roc_measures_train <- calculateROCMeasures(predsvmTrain)
print(roc_measures_train)  



``````{r}
