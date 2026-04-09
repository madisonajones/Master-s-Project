
rm(list = ls())


library(here)
library(dplyr)
# install.packages('did')
library(did)
library(haven)
library(ggplot2)
# install.packages('fixest')
library(fixest)
library(readr)
library(tidyverse)
library(readxl)
library(stringr)
library(HonestDiD)

setwd('C:/Git root/Master-s-Project/honestdid_coefs')

beta <- as.numeric(
  read.csv(paste0("beta_grade3.csv"), header=FALSE)$V1
)
vcov <- as.matrix(
  read.csv(paste0("vcov_grade3.csv"), header=FALSE)
)
