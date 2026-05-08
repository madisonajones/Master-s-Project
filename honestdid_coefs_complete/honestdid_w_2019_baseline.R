
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

# setwd('C:/Git root/Master-s-Project/honestdid_coefs')

# loading in coefficient files
load_betas <- function(path, grades = c(3, 4, 5, 6, 7, 8)) {
  setwd(path)
  
  beta_list <- list()
  
  for (g in grades) {
    file_name <- paste0("beta_grade", g, ".csv")
    
    beta_list[[paste0("beta", g)]] <- as.numeric(
      read.csv(file_name, header = FALSE)$V1
    )
  }
  
  return(beta_list)
}

betas <- load_betas("C:/Git root/Master-s-Project/honestdid_coefs_complete")

beta3 <- betas$beta3
beta4 <- betas$beta4
beta5 <- betas$beta5
beta6 <- betas$beta6
beta7 <- betas$beta7
beta8 <- betas$beta8



# loading in covariance matrices
load_cov <- function(path, grades = c(3, 4, 5, 6, 7, 8)) {
  setwd(path)
  
  cov_list <- list()
  
  for (g in grades) {
    file_name <- paste0("vcov_grade", g, ".csv")
    
    cov_list[[paste0("vcov", g)]] <- as.matrix(
      read.csv(file_name, header = FALSE)
    )
  }
  
  return(cov_list)
}

vcovs <- load_cov("C:/Git root/Master-s-Project/honestdid_coefs_complete")


vcov3 <- vcovs$vcov3
vcov4 <- vcovs$vcov4
vcov5 <- vcovs$vcov5
vcov6 <- vcovs$vcov6
vcov7 <- vcovs$vcov7
vcov8 <- vcovs$vcov8


# function to compute delta RM results for a given beta and covariance matrix
delta_rm_results_func <- function(beta, sigma) {
  delta_rm_results <- createSensitivityResults_relativeMagnitudes(
    betahat = beta, #coefficients
    sigma = sigma, #covariance matrix
    numPrePeriods = 1, #num. of pre-treatment coefs
    numPostPeriods = 1, #num. of post-treatment coefs
    Mbarvec = seq(0.5,2,by=0.25) #values of Mbar
  )
  return(delta_rm_results)
}


# compute and print results for each grade model

for (g in 3:8) {
  beta <- get(paste0("beta", g))
  vcov <- get(paste0("vcov", g))
  
  cat(sprintf("Results for g%d:\n", g))
  print(delta_rm_results_func(beta, vcov))
  cat("\n")
}

# formatting results for better readability

for (g in 3:8) {
  beta <- get(paste0("beta", g))
  vcov <- get(paste0("vcov", g))
  
  results <- delta_rm_results_func(beta, vcov)
  
  cat(sprintf("\nResults for g%d:\n", g))
  cat(sprintf("%-8s %-12s %-12s %-20s\n", "Mbar", "LB", "UB", "Significant"))
  
  for (i in 1:nrow(results)) {
    sig <- ifelse(results$ub[i] < 0, "Yes", "No")
    
    cat(sprintf("%-8.1f %-12.4f %-12.4f %-20s\n",
                results$Mbar[i],
                results$lb[i],
                results$ub[i],
                sig))
  }
}
