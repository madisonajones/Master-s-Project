
rm(list = ls())

#### sources for code ####
# https://gist.github.com/valerievossen/3d2da7ad280f4b148d9223b33fa33545
# https://github.com/asheshrambachan/HonestDiD


library(here)
library(dplyr)
library(did)
library(haven)
library(ggplot2)
library(fixest)
library(readr)
library(tidyverse)
library(readxl)
library(stringr)
library(HonestDiD)

setwd('C:/Git root/Master-s-Project/honestdid_coefs')


# coefficients from PanelOLS Python
beta3 <- as.numeric(
  read.csv(paste0("beta_grade3.csv"), header=FALSE)$V1
)
beta4 <- as.numeric(
  read.csv(paste0('beta_grade4'), header=FALSE)$V1
)





# covariance matrix from PanelOLS Python
sigma3 <- as.matrix(
  read.csv(paste0("vcov_grade3.csv"), header=FALSE)
)

sigma3
set.seed(1)

# relative magnitude bounds 
## lower bound and upper bound, breaks when CI includes 0
delta_rm_results3 <- createSensitivityResults_relativeMagnitudes(
  betahat = beta3, #coefficients
  sigma = sigma3, #covariance matrix
  numPrePeriods = 1, #num. of pre-treatment coefs
  numPostPeriods = 1, #num. of post-treatment coefs
  Mbarvec = seq(0.5,2,by=0.5) #values of Mbar
)

delta_rm_results3
# original confidence interval
originalResults3 <-  HonestDiD::constructOriginalCS(betahat = beta3,
                                                   sigma = sigma3,
                                                   numPrePeriods = 1,
                                                   numPostPeriods = 1)

# plot
plot_rm <- HonestDiD::createSensitivityPlot_relativeMagnitudes(delta_rm_results3, originalResults3)
plot_rm


