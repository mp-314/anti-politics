library(tidyverse)
library(ggplot2)
library(data.table)
library(readr)
library(dfadjust)
library(haven)


##Data
D <- read_dta("...Garzia, Ferreira da Silva, Maye_AP.dta")

# Table 1  ----

### AP partisans
# Australia
APp1 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="1")
lmp1 <- lm(AP_partisans~ YEAR, data=APp1)
dfadjustSE(lmp1)

# Canada
APp3 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="3")
lmp3 <- lm(AP_partisans~ YEAR, data=APp3)
dfadjustSE(lmp3)

# Denmark
APp5 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="5")
lmp5 <- lm(AP_partisans~ YEAR, data=APp5)
dfadjustSE(lmp5)

# Finland
APp7 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="7")
lmp7 <- lm(AP_partisans~ YEAR, data=APp7)
dfadjustSE(lmp7)

# France
APp8 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="8")
lmp8 <- lm(AP_partisans~ YEAR, data=APp8)
dfadjustSE(lmp8)# Germany

#Germany
APp9 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="9")
lmp9 <- lm(AP_partisans~ YEAR, data=APp9)
dfadjustSE(lmp9)

# Greece
APp10 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="10")
lmp10 <- lm(AP_partisans~ YEAR, data=APp10)
dfadjustSE(lmp10)

# Italy
APp14 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="14")
lmp14 <- lm(AP_partisans~ YEAR, data=APp14)
dfadjustSE(lmp14)

# Netherlands
APp17 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="17")
lmp17 <- lm(AP_partisans~ YEAR, data=APp17)
dfadjustSE(lmp17)

# New Zealand
APp18 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="18")
lmp18 <- lm(AP_partisans~ YEAR, data=APp18)
dfadjustSE(lmp18)

# Norway
APp19 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="19")
lmp19 <- lm(AP_partisans~ YEAR, data=APp19)
dfadjustSE(lmp19)

# Portugal
APp20 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="20")
lmp20 <- lm(AP_partisans~ YEAR, data=APp20)
dfadjustSE(lmp20)

# Spain
APp24 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="24")
lmp24 <- lm(AP_partisans~ YEAR, data=APp24)
dfadjustSE(lmp24)

# Sweden
APp25 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="25")
lmp25 <- lm(AP_partisans~ YEAR, data=APp25)
dfadjustSE(lmp25)

# Switzerland
APp26 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="26")
lmp26 <- lm(AP_partisans~ YEAR, data=APp26)
dfadjustSE(lmp26)

# United Kingdom
APp27 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="27")
lmp27 <- lm(AP_partisans~ YEAR, data=APp27)
dfadjustSE(lmp27)

# United States
APp28 <- D %>% select(COUNTRY, YEAR, AP_partisans) %>% 
  filter(COUNTRY=="28")
lmp28 <- lm(AP_partisans~ YEAR, data=APp28)
dfadjustSE(lmp28)

### AP partisans (Party FT only)
# Australia
APpp1 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="1")
lmpp1 <- lm(PAP_partisans~ YEAR, data=APpp1)
dfadjustSE(lmpp1)

# Canada
APpp3 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="3")
lmpp3 <- lm(PAP_partisans~ YEAR, data=APpp3)
dfadjustSE(lmpp3)

# Denmark
APpp5 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="5")
lmpp5 <- lm(PAP_partisans~ YEAR, data=APpp5)
dfadjustSE(lmpp5)

# Finland
APpp7 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="7")
lmpp7 <- lm(PAP_partisans~ YEAR, data=APpp7)
dfadjustSE(lmpp7)

# France
APpp8 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="8")
lmpp8 <- lm(PAP_partisans~ YEAR, data=APpp8)
dfadjustSE(lmpp8)# Germany

#Germany
APpp9 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="9")
lmpp9 <- lm(PAP_partisans~ YEAR, data=APpp9)
dfadjustSE(lmpp9)

# Greece
APpp10 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="10")
lmpp10 <- lm(PAP_partisans~ YEAR, data=APpp10)
dfadjustSE(lmpp10)

# Italy
APpp14 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="14")
lmpp14 <- lm(PAP_partisans~ YEAR, data=APpp14)
dfadjustSE(lmpp14)

# Netherlands
APpp17 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="17")
lmpp17 <- lm(PAP_partisans~ YEAR, data=APpp17)
dfadjustSE(lmpp17)

# New Zealand
APpp18 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="18")
lmpp18 <- lm(PAP_partisans~ YEAR, data=APpp18)
dfadjustSE(lmpp18)

# Norway
APpp19 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="19")
lmpp19 <- lm(PAP_partisans~ YEAR, data=APpp19)
dfadjustSE(lmpp19)

# Portugal
APpp20 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="20")
lmpp20 <- lm(PAP_partisans~ YEAR, data=APpp20)
dfadjustSE(lmpp20)

# Sweden
APpp25 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="25")
lmpp25 <- lm(PAP_partisans~ YEAR, data=APpp25)
dfadjustSE(lmpp25)

# Switzerland
APpp26 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="26")
lmpp26 <- lm(PAP_partisans~ YEAR, data=APpp26)
dfadjustSE(lmpp26)

# United Kingdom
APpp27 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="27")
lmpp27 <- lm(PAP_partisans~ YEAR, data=APpp27)
dfadjustSE(lmpp27)

# United States
APpp28 <- D %>% select(COUNTRY, YEAR, PAP_partisans) %>% 
  filter(COUNTRY=="28")
lmpp28 <- lm(PAP_partisans~ YEAR, data=APpp28)
dfadjustSE(lmpp28)

### AP electorate
# Australia
Ape1 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="1")
lme1 <- lm(AP_electorate~ YEAR, data=Ape1)
dfadjustSE(lme1)

# Belgium
Ape2 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="2")
lme2 <- lm(AP_electorate~ YEAR, data=Ape2)
dfadjustSE(lme2)

# Canada
Ape3 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="3")
lme3 <- lm(AP_electorate~ YEAR, data=Ape3)
dfadjustSE(lme3)

# Denmark
Ape5 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="5")
lme5 <- lm(AP_electorate~ YEAR, data=Ape5)
dfadjustSE(lme5)

# Finland
Ape7 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="7")
lme7 <- lm(AP_electorate~ YEAR, data=Ape7)
dfadjustSE(lme7)

# France
Ape8 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="8")
lme8 <- lm(AP_electorate~ YEAR, data=Ape8)
dfadjustSE(lme8)# Germany

#Germany
Ape9 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="9")
lme9 <- lm(AP_electorate~ YEAR, data=Ape9)
dfadjustSE(lme9)

# Greece
Ape10 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="10")
lme10 <- lm(AP_electorate~ YEAR, data=Ape10)
dfadjustSE(lme10)

# Italy
Ape14 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="14")
lme14 <- lm(AP_electorate~ YEAR, data=Ape14)
dfadjustSE(lme14)

# Netherlands
Ape17 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="17")
lme17 <- lm(AP_electorate~ YEAR, data=Ape17)
dfadjustSE(lme17)

# New Zealand
Ape18 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="18")
lme18 <- lm(AP_electorate~ YEAR, data=Ape18)
dfadjustSE(lme18)

# Norway
Ape19 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="19")
lme19 <- lm(AP_electorate~ YEAR, data=Ape19)
dfadjustSE(lme19)

# Portugal
Ape20 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="20")
lme20 <- lm(AP_electorate~ YEAR, data=Ape20)
dfadjustSE(lme20)

# Spain
Ape24 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="24")
lme24 <- lm(AP_electorate~ YEAR, data=Ape24)
dfadjustSE(lme24)

# Sweden
Ape25 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="25")
lme25 <- lm(AP_electorate~ YEAR, data=Ape25)
dfadjustSE(lme25)

# Switzerland
Ape26 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="26")
lme26 <- lm(AP_electorate~ YEAR, data=Ape26)
dfadjustSE(lme26)

# United Kingdom
Ape27 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="27")
lme27 <- lm(AP_electorate~ YEAR, data=Ape27)
dfadjustSE(lme27)

# United States
Ape28 <- D %>% select(COUNTRY, YEAR, AP_electorate) %>% 
  filter(COUNTRY=="28")
lme28 <- lm(AP_electorate~ YEAR, data=Ape28)
dfadjustSE(lme28)

### AP electorate (Party FT only)
# Australia
Apep1 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="1")
lmep1 <- lm(PAP_electorate~ YEAR, data=Apep1)
dfadjustSE(lmep1)

# Belgium
Apep2 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="2")
lmep2 <- lm(PAP_electorate~ YEAR, data=Apep2)
dfadjustSE(lmep2)

# Canada
Apep3 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="3")
lmep3 <- lm(PAP_electorate~ YEAR, data=Apep3)
dfadjustSE(lmep3)

# Denmark
Apep5 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="5")
lmep5 <- lm(PAP_electorate~ YEAR, data=Apep5)
dfadjustSE(lmep5)

# Finland
Apep7 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="7")
lmep7 <- lm(PAP_electorate~ YEAR, data=Apep7)
dfadjustSE(lmep7)

# France
Apep8 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="8")
lmep8 <- lm(PAP_electorate~ YEAR, data=Apep8)
dfadjustSE(lmep8)# Germany

#Germany
Apep9 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="9")
lmep9 <- lm(PAP_electorate~ YEAR, data=Apep9)
dfadjustSE(lmep9)

# Greece
Apep10 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="10")
lmep10 <- lm(PAP_electorate~ YEAR, data=Apep10)
dfadjustSE(lmep10)

# Italy
Apep14 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="14")
lmep14 <- lm(PAP_electorate~ YEAR, data=Apep14)
dfadjustSE(lmep14)

# Netherlands
Apep17 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="17")
lmep17 <- lm(PAP_electorate~ YEAR, data=Apep17)
dfadjustSE(lmep17)

# New Zealand
Apep18 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="18")
lmep18 <- lm(PAP_electorate~ YEAR, data=Apep18)
dfadjustSE(lmep18)

# Norway
Apep19 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="19")
lmep19 <- lm(PAP_electorate~ YEAR, data=Apep19)
dfadjustSE(lmep19)

# Portugal
Apep20 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="20")
lmep20 <- lm(PAP_electorate~ YEAR, data=Apep20)
dfadjustSE(lmep20)

# Spain
Apep24 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="24")
lmep24 <- lm(PAP_electorate~ YEAR, data=Apep24)
dfadjustSE(lmep24)

# Sweden
Apep25 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="25")
lmep25 <- lm(PAP_electorate~ YEAR, data=Apep25)
dfadjustSE(lmep25)

# Switzerland
Apep26 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="26")
lmep26 <- lm(PAP_electorate~ YEAR, data=Apep26)
dfadjustSE(lmep26)

# United Kingdom
Apep27 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="27")
lmep27 <- lm(PAP_electorate~ YEAR, data=Apep27)
dfadjustSE(lmep27)

# United States
Apep28 <- D %>% select(COUNTRY, YEAR, PAP_electorate) %>% 
  filter(COUNTRY=="28")
lmep28 <- lm(PAP_electorate~ YEAR, data=Apep28)
dfadjustSE(lmep28)
          