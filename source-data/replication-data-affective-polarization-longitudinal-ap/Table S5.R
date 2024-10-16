library(tidyverse)
library(ggplot2)
library(data.table)
library(readr)
library(dfadjust)
library(haven)


##Data
D <- read_dta("...Garzia, Ferreira da Silva, Maye_AP.dta")

#Germany - original estimates (European Voter)
DE1 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="9")
DE_EV <- lm(AP_electorate~ YEAR, data=DE1)
dfadjustSE(DE_EV)

#Germany - revised estimates for 1983, 1987, and 1990
DE2 <- D %>% select(COUNTRY, YEAR, GLES_AP) %>% 
  filter(COUNTRY=="9")
DE_GLES <- lm(GLES_AP~ YEAR, data=DE2)
dfadjustSE(DE_GLES)