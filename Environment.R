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

```
