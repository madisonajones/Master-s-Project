

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

cat(sprintf("Grade 3"))
cat(sprintf("β_pre  (2018): %.4f\n", beta[1]))
cat(sprintf("β_post (2022): %.4f\n", beta[2]))

original_ci <- HonestDiD::constructOriginalCS(
  betahat        = beta,
  sigma          = vcov,
  numPrePeriods  = 1,
  numPostPeriods = 1,
  alpha          = 0.05
)

cat(sprintf("\nOriginal CI: [%.4f, %.4f]\n", 
            original_ci$lb, original_ci$ub))

rm_results <- HonestDiD::createSensitivityResults_relativeMagnitudes(
  betahat        = beta,
  sigma          = vcov,
  numPrePeriods  = 1,
  numPostPeriods = 1,
  Mbarvec        = seq(0, 2, by = 0.5),
  alpha          = 0.05
)

crosses_zero <- rm_results %>%
  filter(lb <= 0 & ub >= 0) %>%
  slice(1) %>%
  pull(Mbar)


breakdown <- ifelse(
  length(crosses_zero) == 0,
  "> 2.0 (fully robust)",
  as.character(crosses_zero)
)

cat("\nHonestDiD Sensitivity — Relative Magnitudes\n")
cat(strrep("=", 55), "\n")
cat(sprintf("%-8s %-12s %-12s %-20s\n",
            "M", "Lower CI", "Upper CI", "Still significant?"))
cat(strrep("-", 55), "\n")

for (i in 1:nrow(rm_results)) {
  sig <- ifelse(rm_results$ub[i] < 0, "Yes", "No  ← breaks here")
  cat(sprintf("%-8.1f %-12.4f %-12.4f %-20s\n",
              rm_results$Mbar[i],
              rm_results$lb[i],
              rm_results$ub[i],
              sig))
}

# honestdid breaks when the confidence interval includes 0 !!!!

plot_rm <- HonestDiD::createSensitivityPlot_relativeMagnitudes(rm_results, original_ci)
plot_rm


# https://gist.github.com/valerievossen/3d2da7ad280f4b148d9223b33fa33545
# https://github.com/asheshrambachan/HonestDiD

