# ---------------------------------------------------------
# Data construction script ---------------------------------
# ---------------------------------------------------------

library(tidyverse)
library(readstata13)
library(readxl)
library(countrycode)
library(haven)
use_WDI_cache <- T
use_prox_cache <- T
vdem_cache <- T
unpop_cache <- T

# Each section of this script load source data, and saves the data output data as a iso3c-year CSV file.

## Negative partisanship variables --------------------------------------------------------

# Load raw data on in-party and out-party affection
cses <- read.dta13('source-data/garzia-and-ferreira-da-silva/eco_cses.dta', nonint.factors = T)
wev <- read.dta13('source-data/garzia-and-ferreira-da-silva/eco_wev.dta', nonint.factor = T)
horne <- read_csv('source-data/horne-et-al/cses5cl.csv')
colnames(horne)[1:4] <- c("COUNTRY", "YEAR", 'OUTPARTY', "INPARTY")
horne[, setdiff(colnames(cses), colnames(horne))] <- NA

cses$source <- 'cses'
wev$source <- 'wev'
partisanship <- rbind(wev, cses, horne[, colnames(cses)])
rm(cses)
rm(wev)
rm(horne)
partisanship$COUNTRY[partisanship$COUNTRY == 'Great Britain'] <- 'United Kingdom'
partisanship$COUNTRY[partisanship$COUNTRY == 'United States of America'] <- 'United States'
partisanship <- partisanship[!is.na(partisanship$YEAR), ]

# Prefer data from election surveys if both election survey and CSES are present at the same time (as recommened by Diego Garzia), and then supplementing with data from Horne et al if both are missing:
partisanship <- partisanship[!duplicated(paste0(partisanship$COUNTRY, '_', partisanship$YEAR)), ]
partisanship <- partisanship %>% rename(country = COUNTRY,
                                         year = YEAR) %>% mutate(iso3c = countrycode(country, 'country.name', 'iso3c'))
partisanship_bc <- partisanship

write_csv(partisanship[, c('year', 'country', 'INPARTY', 'OUTPARTY')], 'output-data/plot-replication-data/plot_data_small_multiples.csv')
ggplot(partisanship, aes(x=year, col=country))+geom_point(aes(y=INPARTY, col='in-party'))+
  geom_point(aes(y=OUTPARTY, col='out-party'))+
  geom_point(aes(y=INPARTY-OUTPARTY, col='affection gap'))+
  geom_line(aes(y=INPARTY-OUTPARTY, col='affection gap'))+
  facet_wrap(.~country)+theme(legend.pos = 'bottom')+ylab('')+xlab('')

# The following loads alternative measures of partisanship, or perhaps more accurately, the data sources on which the above draw on:
if(F){
  # Load data from Diego Garzia et al (APSR, 2023):
  apsr <- read.dta13('source-data/replication-data-affective-polarization-apsr/PAP_LAP_dataset.dta')
  # ggplot(apsr, aes(x=Year, y=VoterAPI_Party, col=Country))+
  #   geom_line()+
  #   facet_wrap(.~Country)+
  #   geom_point()+
  #   geom_line(aes(y=VoterAPI_Leader), col='black', alpha = 0.5, size = 1.2)+
  #   geom_point(aes(y=VoterAPI_Leader), col='black', alpha = 0.5)
  
  # Load data from Diego Garzia et al (AP, 2023):
  ap <- read.dta13('source-data/replication-data-affective-polarization-longitudinal-ap/Garzia, Ferreira da Silva, Maye_AP.dta', nonint.factors = T)
  # ggplot(ap[ap$YEAR >= 1995, ], aes(x=YEAR, y=PAP_electorate, col=COUNTRY))+
  #   geom_line()+
  #   facet_wrap(.~COUNTRY)+
  #   geom_point()+
  #   geom_line(aes(y=LAP_electorate), col='black', alpha = 0.5, size = 1.2)+
  #   geom_point(aes(y=LAP_electorate), col='black', alpha = 0.5)
  
  # If overlap: prefer longitudal which is directly from election survey rather than the ad-hoc world-wide election survey project
  
  # Load data from Diego Garzia et al (APSR, under review)
  apsrf <- read.dta13('source-data/replication-data-quantity-and-quality-of-affective-polarization-in-comparative-perspective-under-review/theeconomist.dta', nonint.factors = T)
  # ggplot(apsrf, aes(x=IMD5025_3, y=quality2, col=IMD1006_NAM))+geom_point()+facet_wrap(.~IMD1006_NAM)
  
  temp <- ap[, c('COUNTRY', 'YEAR', 'PAP_electorate')]
  temp2 <- apsr[, c('Country', "Year", 'VoterAPI_Leader')]
  
  colnames(temp) <- colnames(temp2) <- c('country','year','polarization')
  temp$source <- 'ap'
  temp2$source <- 'apsr'
  temp2$country[temp2$country == 'United States of America'] <- 'United States'
  
  apsrf <- rbind(temp, temp2)
  apsrf$iso3c <- countrycode(apsrf$country, 'country.name', 'iso3c')
  apsrf$polarization_apsrf <- apsrf$polarization
  apsrf <- apsrf[, c('iso3c', 'year', 'polarization_apsrf')]
  
  rm(temp)
  rm(temp2)
  # ggplot(pdat, aes(x=year, y=polarization, col=source))+geom_point(alpha = 0.5)+facet_wrap(.~country)
  
  ap$iso3c <- countrycode(ap$COUNTRY, 'country.name', 'iso3c')
  ap$year <- ap$YEAR
  ap$STUDYID <- NULL
  ap <- ap[, c('iso3c', 'year',  "PAP_partisans",
               "PAP_electorate", 
               "PAP_partisans_alt",
               "PAP_electorate_alt",
               "LAP_partisans",
               "LAP_electorate",
               "LAP_partisans_alt", 
               "LAP_electorate_alt",
               "partisan_affect_polarization", 
               "AP_partisans",
               "AP_electorate")]
  
  
  partisanship <- merge(partisanship, ap, by = c('iso3c', 'year'), all = T)
  partisanship <- merge(partisanship, apsrf, by = c('iso3c', 'year'), all = T)
  
  partisanship$temp_polarisation <- partisanship$INPARTY - partisanship$OUTPARTY
  ggplot(partisanship, aes(x=year, y=temp_polarisation, col=country))+geom_line()+facet_wrap(.~country)+geom_point(aes(y=PAP_electorate))
  
}

## Economic, demography (inc. age), and refugee/migration indicators section --------------------------------------------------------

# This loads in data from WDI (which also has refugee/migrant variables)
if(!use_WDI_cache){
  library(WDI)
  wdi_data <- WDI(indicator = 
                  c('age_over_65' = 'SP.POP.65UP.TO',
                    'age_below_15' = 'SP.POP.0014.TO', 
                    'gdp_per_capita_ppp' = 'NY.GDP.PCAP.PP.KD',#const 2017
                    'gdp_ppp' = 'NY.GDP.MKTP.PP.KD',#const 2017
                    'gdp' = 'NY.GDP.MKTP.KD', #const 2017
                    'gdp_per_capita' = 'NY.GDP.PCAP.KD', #const 2015
                    'gdp_growth' = 'NY.GDP.MKTP.KD.ZG',
                    'infant_mort_rate' = 'SP.DYN.IMRT.IN',
                    'population' = 'SP.POP.TOTL',
                    'net_migration' = 'SM.POP.NETM',
                    'int_migrant_percent' = 'SM.POP.TOTL.ZS',
                    'int_refugee_pop' = 'SM.POP.REFG'))
wdi_data$source <- 'WDI'
write_csv(wdi_data, 'source-data/cache/econ_demography_refugees_data.csv')
} else {
  wdi_data <- read_csv('source-data/cache/econ_demography_refugees_data.csv')
}
wdi_data <- wdi_data %>% select(-country, -iso2c, -source) %>% 
  mutate(age_over_65_percent = 100*age_over_65 / population,
         age_under_15_percent = 100*age_below_15 / population,
         refugee_pop_over_population = 100*int_refugee_pop/population)

# Append data for Taiwan
# Create vectors for years and population
years <- c(1981:2020)
population <- c(18193955, 18515754, 18790538, 19069194, 19313825, 19509082, 19725010, 19954397, 20156587, 20401305,
                20605831, 20802622, 20995416, 21177874, 21357431, 21525433, 21742815, 21928591, 22092387, 22276672,
                22405568, 22520776, 22604550, 22689122, 22770383, 22876527, 22958360, 23037031, 23119772, 23162123,
                23224912, 23315822, 23373517, 23433753, 23492074, 23539816, 23571227, 23588932, 23600903, 23539588)

# Create the dataframe and append the ISO code
twn <- data.frame(year = years, population = population, iso3c = "TWN")
for(i in setdiff(colnames(wdi_data), colnames(twn))){twn[, i] <- NA}

wdi_data <- rbind(wdi_data, twn)


# More demography data:
# Source: https://population.un.org/wpp/Download/Standard/MostUsed/ -- Single Ages	
# Population by Single Age - Both Sexes (XLSX, 160.91 MB)
# Total population (both sexes combined) by single age. De facto population as of 1 July of the year indicated classified by single age (0, 1, 2, ..., 99, 100+). Data are presented in thousands.
if(!unpop_cache){
  unpop <- read_xlsx('source-data/un-pop/WPP2022_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx', skip = 16)
  unpop_projections <- read_xlsx('source-data/un-pop/WPP2022_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx', skip = 16, sheet = 2)
  unpop <- rbind(unpop, unpop_projections)
  
  unpop$country <- unpop$`Region, subregion, country or area *`
  unpop <- unpop[!unpop$`Region, subregion, country or area *` %in% c('Less developed regions, excluding China',
                                                                      "Oceania (excluding Australia and New Zealand)",              
                                                                      "Australia/New Zealand"), ]
  unpop$iso3c <- countrycode(unpop$country, 'country.name', 'iso3c')
  unpop <- unpop[!is.na(unpop$iso3c), ]
  unpop <- pivot_longer(unpop, cols = 12:112)
  unpop <- unpop %>% rename(age = name,
                            year = Year)
  unpop$age[unpop$age == '100+'] <- 100
  unpop$age <- as.numeric(unpop$age)
  unpop$value <- as.numeric(unpop$value)
  unpop <- unpop[order(unpop$age), c('iso3c', 'year', 'age', 'value')]
  unpop$country_year <- paste0(unpop$year, '-', unpop$iso3c)
  unpop$total <- ave(unpop$value, unpop$country_year, FUN = function(x) sum(x, na.rm = T))
  unpop <- unpop[unpop$year < 2025, ]
  
  library(progress)
  timer <- progress_bar$new(total = length(unique(unpop$country_year)))
  
  median_ages <- lapply(unique(unpop$country_year), FUN = function(i){
    temp <- unpop[unpop$country_year == i, ]
    prob <- cumsum(temp$value)/temp$total
    timer$tick()
    return(temp$age[which(abs(prob-0.5) == min(abs(prob-0.5)))][1])
  })
  median_ages <- data.frame(median_age = unlist(median_ages), country_year = unique(unpop$country_year))

  unpop <- merge(unpop, median_ages, by='country_year', all = T)


  # Various age groups:
  unpop$total_pop_20_to_40 <- ifelse(unpop$age %in% 20:40, unpop$value, 0)
  unpop$total_pop_20_to_40 <- ave(unpop$total_pop_20_to_40, unpop$country_year, FUN = sum)
  unpop$total_pop_40_to_60 <- ifelse(unpop$age %in% 40:60, unpop$value, 0)
  unpop$total_pop_40_to_60 <- ave(unpop$total_pop_40_to_60, unpop$country_year, FUN = sum)
  unpop$total_pop_30_to_50 <- ifelse(unpop$age %in% 30:50, unpop$value, 0)
  unpop$total_pop_30_to_50 <- ave(unpop$total_pop_30_to_50, unpop$country_year, FUN = sum)
  unpop$total_pop_18_to_65 <- ifelse(unpop$age %in% 18:65, unpop$value, 0)
  unpop$total_pop_18_to_65 <- ave(unpop$total_pop_18_to_65, unpop$country_year, FUN = sum)
  unpop$total_pop <- unpop$total
  
  for(i in c('total_pop_20_to_40', 
             'total_pop_40_to_60',
             'total_pop_30_to_50',
             'total_pop_18_to_65')){
    unpop[, gsub('total', 'percent', i)] <- unpop[, i]/unpop$total_pop
  }
  
  write_csv(unpop, 'source-data/cache/unpop_cache.csv')
  write_csv(unique(unpop[, c('iso3c', 'year', 'total_pop', 'median_age', 
                             'total_pop_20_to_40', 
                             'total_pop_40_to_60',
                             'total_pop_30_to_50',
                             'total_pop_18_to_65',
                             'percent_pop_20_to_40', 
                             'percent_pop_40_to_60',
                             'percent_pop_30_to_50',
                             'percent_pop_18_to_65')]), 'source-data/cache/unpop_small_cache.csv')
  unpop <- unique(unpop[, c('iso3c', 'year', 'total_pop', 'median_age', 
                            'total_pop_20_to_40', 
                            'total_pop_40_to_60',
                            'total_pop_30_to_50',
                            'total_pop_18_to_65', 
                            'percent_pop_20_to_40', 
                            'percent_pop_40_to_60',
                            'percent_pop_30_to_50',
                            'percent_pop_18_to_65')])
  
  ggplot(unpop[unpop$iso3c %in% sample(unpop$iso3c, 9), ], aes(x=year, y=median_age, col=iso3c))+geom_line()
} else {
  unpop <- read_csv('source-data/cache/unpop_small_cache.csv')
}


## External threat variables --------------------------------------------------------
# This chunk calculates six types of external threat variables
milex <- read_csv('source-data/sipri-data/the_economist_military_spending.csv')
milex <- milex[milex$type == 'Constant 2021 USD (m)' & milex$country != 'USSR', c('iso3c', 'year', 'military_spending')]

# Source: Peter Robertson (2022)
milexppp <- read_csv('source-data/milppp-data/the_economist_military_spending_2000_2022.csv')
milexppp <- milexppp[milexppp$type == 'Constant 2021 USD (m)' , c('iso3c', 'year', 'military_spending_PPP')]

# Military spending as % of GDP:
milpercent <- read_csv('source-data/military-spending/the_economist_military_spending.csv')[, c('iso3c', 'year', 'percent_of_gdp')]
names(milpercent)[names(milpercent) == "percent_of_gdp"] <- "milex_percent_of_gdp"
milpercent$milex_percent_of_gdp <- as.numeric(milpercent$milex_percent_of_gdp)

# Military spending in Russia, Soviet Union, China, United States:
other_milex <- read_csv('source-data/military-spending/the_economist_military_spending.csv')
other_milex <- other_milex[other_milex$iso3c %in% c('USA', 'USR', 'RUS', 'CHN') & !is.na(other_milex$iso3c) & other_milex$type == 'Constant 2022 USD (m)', ]
other_milex <- other_milex[!(other_milex$year > 1990 & other_milex$country == 'USSR') & !(other_milex$year <= 1990 & other_milex$country == 'Russia'), ]
other_milex <- other_milex %>% select(iso3c, year, military_spending, percent_of_gdp) %>% mutate(
  percent_of_gdp = as.numeric(percent_of_gdp)) %>%
  pivot_wider(
    names_from = iso3c,
    values_from = c(military_spending, percent_of_gdp),
    names_sep = "_"
    )  %>% rename(
    military_spending_percent_of_gdp_RUS = percent_of_gdp_RUS,
    military_spending_percent_of_gdp_USA =percent_of_gdp_USA,
    military_spending_percent_of_gdp_CHN = percent_of_gdp_CHN
  )
other_milex <- other_milex[!duplicated(other_milex$year), ]

milex <- merge(milex, milexppp, by= c('iso3c', 'year'), all=T)
milex <- merge(milex, milpercent, by= c('iso3c', 'year'), all=T)
milex <- merge(milex, other_milex, by='year', all.x=T)

use_prox_cache <- T
if(!use_prox_cache){
  # Install and load necessary packages
  library(cshapes)
  library(sp)
  library(rgeos)
  library(dplyr)
  
  # Function to get neighboring countries
  get_neighbors <- function(country_iso3c, buffer = 50000, worldmap){
    library(sf)
    near <- c()
    for(i in setdiff(worldmap$iso3c, country_iso3c)){
      if(as.numeric(st_distance(worldmap[worldmap$iso3c == country_iso3c, ],
                              worldmap[worldmap$iso3c == i, ],
                              by_element = TRUE)) < buffer){
        near <- c(near, i)
      }
    }
    return(near)
  }
  
  # This wrapper gets all neighbors for all countries in a given year
  get_all_neighbors_by_year <- function(year, buffer_in_m = 50000){
    worldmap <- cshp(date=as.Date(paste0(ifelse(year < 2020, year, 2019), "-1-1")))
    worldmap <- st_transform(worldmap, crs = 3395)  # EPSG:3395 is a metric CRS
    worldmap$iso3c <- countrycode(worldmap$gwcode, 'gwn', 'iso3c')
    worldmap <- worldmap[!is.na(worldmap$iso3c), ]
    res <- data.frame()
    cat('Calculating for: ')
    for(iso3c in unique(worldmap$iso3c)){
      cat(iso3c)
      cat('...')
      res <- rbind(res, 
                   data.frame(year = year, iso3c = iso3c, 
                              neighbors = paste0(get_neighbors(country_iso3c = iso3c,
                                                             buffer = buffer_in_m,
                                                             worldmap = worldmap), collapse = ', ')))
    }
    return(res)}
  
  # Loop through years:
  prox_df <- data.frame()
  for(i in 1970:2023){
    prox_df <- rbind(prox_df, get_all_neighbors_by_year(year = i))
  }
  write_csv(prox_df, 'source-data/cache/prox_df.csv')
  prox_df <- prox_df %>%
    separate_rows(neighbors, sep = ",\\s*")
  } else {
  prox_df <- read_csv('source-data/cache/prox_df.csv')
  prox_df <- prox_df %>%
    separate_rows(neighbors, sep = ",\\s*")
}

# Define function to get sum in neighbors:
sum_in_neighbors <- function(variable, prox_df, data){
  library(cli)
  cli_progress_bar("Data cleaning", total = nrow(data), clear = TRUE)
  res <- rep(NA, nrow(data))
  for(i in 1:nrow(data)){
    res[i] <- sum(data[data$iso3c %in% 
                         prox_df$neighbors[prox_df$iso3c == data$iso3c[i]  &
                                             prox_df$year == data$year[i]] & 
                         data$year == data$year[i], variable], na.rm = T)
    cli_progress_update()
  }
  return(res)
}

## Military spending in neighbouring countries
milex$military_spending_PPP_in_neighbouring_countries <- sum_in_neighbors(variable = 'military_spending_PPP',
                                                                         prox_df = prox_df, 
                                                                         data = milex) 
milex$military_spending_in_neighbouring_countries <- sum_in_neighbors(variable = 'military_spending',
                                                                          prox_df = prox_df, 
                                                                          data = milex) 


## Load data on great powers:
gp <- read_delim('source-data/cache/tech_data.tab') # https://dataverse.harvard.edu/file.xhtml?fileId=4330691&version=1.0
gp <- unique(gp[, c('ccode', 'year', 'majpow')]) 
most_recent_data <- max(gp$year)
for(i in (most_recent_data+1):2024){
  temp <- gp[gp$year==most_recent_data, ]
  temp$year <- i
  gp <- rbind(gp, temp)
}
rm(temp)
gp$iso3c <- countrycode(gp$ccode, 'cown', 'iso3c')
milex <- merge(milex, gp[, c('iso3c', 'year', 'majpow')], all.x = T, by=c('iso3c', 'year'))

## Military spending by great powers
majpow_spending <- tapply(milex$military_spending[milex$majpow == 1], milex$year[milex$majpow == 1], FUN = function(x) sum(x, na.rm = T))
majpow_spending_ppp <-  tapply(milex$military_spending_PPP[milex$majpow == 1], milex$year[milex$majpow == 1], FUN = function(x) sum(x, na.rm = T)) 
majpow_spending <- merge(data.frame(year = names(majpow_spending),
                                    majpow_spending = as.vector(majpow_spending)),
                         data.frame(year = names(majpow_spending_ppp),
                                    majpow_spending_PPP = as.vector(majpow_spending_ppp)), by="year")
majpow_spending$majpow_spending_PPP[majpow_spending$year < min(milex$year[!is.na(milex$military_spending_PPP) & milex$majpow == 1], na.rm = T)] <- NA

## Military spending in neighbouring countries (change)
change_function <- function(x){(x - c(NA, x)[1:length(x)])}

milex <- milex[order(milex$year), ]
for(i in c('military_spending',
           'military_spending_PPP',
           'milex_percent_of_gdp',
           'military_spending_in_neighbouring_countries',
           'military_spending_PPP_in_neighbouring_countries')){
  milex[, paste0(i, '_change')] <- ave(milex[, i], milex$iso3c, FUN = change_function)
  # if past military spending is 0, set change as NA. (alleviates problem in source data)
  milex[!is.finite(milex[, paste0(i, '_change')]), paste0(i, '_change')] <- NA
}

## Military spending by great powers (change)
majpow_spending <- majpow_spending[order(majpow_spending$year), ]
majpow_spending$majpow_spending_change <- change_function(majpow_spending$majpow_spending)
majpow_spending$majpow_spending_PPP_change <- change_function(majpow_spending$majpow_spending_PPP)

## MIDs
mids <- read_csv('source-data/MIDs/MIDB 5.0.csv')
mids$iso3c <- countrycode(mids$ccode, 'cown', 'iso3c')
mids$iso3c[mids$stabb == 'GFR'] <- 'DEU' # Fix for West Germany
mids <- mids[!is.na(mids$iso3c), ]

mid_data <- na.omit(expand.grid(iso3c = unique(c(mids$iso3c, partisanship$iso3c)),
                        year = min(mids$styear, na.rm = T):max(mids$endyear, na.rm = T)))
mid_data$n_mids <- NA
mid_data$n_fatal_mids <- NA
mid_data <- merge(mid_data, gp[, c('iso3c', 'year', 'majpow')], all.x = T, by=c('iso3c', 'year'))
mid_data$majpow[is.na(mid_data$majpow)] <- 0

for(i in 1:nrow(mid_data)){
  mid_data$n_mids[i] <- sum(mid_data$year[i] >= mids$styear &
                              mid_data$year[i] <= mids$endyear &
                              mid_data$iso3c[i] == mids$iso3c)
  mid_data$n_fatal_mids[i] <- sum(mid_data$year[i] >= mids$styear &
                              mid_data$year[i] <= mids$endyear &
                              mid_data$iso3c[i] == mids$iso3c &
                              (mids$fatality > 0 | (mids$fatality == -9 & mids$hostlev >= 4)))
}

## MIDs in neighbouring countries
mid_data$n_mids_in_neighbouring_countries <- sum_in_neighbors(variable = 'n_mids',
                                              prox_df = prox_df, 
                                              data = mid_data) 
mid_data$n_fatal_mids_in_neighbouring_countries <- sum_in_neighbors(variable = 'n_fatal_mids',
                                                              prox_df = prox_df, 
                                                              data = mid_data) 

## Worldwide MIDs
mids <- read_csv('source-data/MIDS/MIDB 5.0.csv')
mid_data$ww_mids <- NA
mid_data$ww_fatal_mids <- NA
mid_data$ww_majpow_mids <- NA
mid_data$ww_majpow_fatal_mids <- NA

for(i in min(mid_data$year):max(mid_data$year)){
  mid_data$ww_mids[mid_data$year == i] <- sum(i >= mids$styear & i <= mids$endyear)
  mid_data$ww_fatal_mids[mid_data$year == i] <- sum(i >= mids$styear & i <= mids$endyear & mids$fatality > 0)
  
  # Great power MIDs
  mid_data$ww_majpow_mids[mid_data$year == i] <- sum(mid_data$n_mids[mid_data$majpow == 1 & mid_data$year %in% i], na.rm = T)
  mid_data$ww_majpow_fatal_mids[mid_data$year == i] <- sum(mid_data$n_fatal_mids[mid_data$majpow == 1 & mid_data$year %in% i], na.rm = T)
}
mid_data$majpow <- NULL

rm(mids)
rm(gp)
rm(prox_df)
rm(milexppp)

## Optimism variables --------------------------------------------------------
# This loads in data from the surveys on optimism

# Please imagine a ladder with steps numbered from 0 at the bottom to 10 at the top. Suppose we say that the top of the ladder represents the best possible life for you, and the bottom of the ladder represents the worst possible life for you. On which step of the ladder would you say you personally feel you stand at this time, assuming that the higher the step the better you feel about your life, and the lower the step the worse you feel about it? Which step comes closest to the way you feel?
gallup_now <- read_xlsx('source-data/gallup-data/Gallup World Poll Data Trends_The Economist 032423.xlsx', sheet = 1, skip = 7)
gallup_now$optimism_current_state <- gallup_now$Value
gallup_now$iso3c <- countrycode(gallup_now$Geography, 'country.name', 'iso3c')
gallup_now$iso3c[gallup_now$Geography == 'Northern Cyprus'] <- NA
gallup_now$iso3c[gallup_now$Geography == 'Türkiye'] <- 'TUR'
gallup_now$year <- gallup_now$Time

# Please imagine a ladder with steps numbered from 0 at the bottom to 10 at the top. Suppose we say that the top of the ladder represents the best possible life for you, and the bottom of the ladder represents the worst possible life for you. Just your best guess, on which step do you think you will stand on in the future, say about five years from now?
gallup_in_five_years <- read_xlsx('source-data/gallup-data/Gallup World Poll Data Trends_The Economist 032423.xlsx', sheet = 2, skip = 7)
gallup_in_five_years$optimism_future_state_5yr_from_now <- gallup_in_five_years$Value
gallup_in_five_years$iso3c <- countrycode(gallup_in_five_years$Geography, 'country.name', 'iso3c')
gallup_in_five_years$iso3c[gallup_in_five_years$Geography == 'Northern Cyprus'] <- NA
gallup_in_five_years$iso3c[gallup_in_five_years$Geography == 'Türkiye'] <- 'TUR'
gallup_in_five_years$year <- gallup_in_five_years$Time


# The Life Evaluation Index measures respondents’ perceptions of where they stand now and in the future.
gallup_thrive <- read_xlsx('source-data/gallup-data/Gallup World Poll Data Trends_The Economist 032423.xlsx', sheet = 7, skip = 7)
gallup_thrive$thriving_percent <- gallup_thrive$Thriving
gallup_thrive$iso3c <- countrycode(gallup_thrive$Geography, 'country.name', 'iso3c')
gallup_thrive$iso3c[gallup_thrive$Geography == 'Northern Cyprus'] <- NA
gallup_thrive$iso3c[gallup_thrive$Geography == 'Türkiye'] <- 'TUR'
gallup_thrive$year <- gallup_thrive$Time



optimism <- merge(gallup_in_five_years[, c('iso3c', 'year', 'optimism_future_state_5yr_from_now')],
                  gallup_now[, c('iso3c', 'year', 'optimism_current_state')], all = T, by=c('iso3c', 'year'))
optimism <- merge(optimism, gallup_thrive, all = T, by=c('iso3c', 'year'))
optimism <- optimism[!is.na(optimism$iso3c), ]
optimism$expected_increase_in_optimism_ladder_5yr <- optimism$optimism_future_state_5yr_from_now - optimism$optimism_current_state
optimism$year <- as.numeric(optimism$year)

# Linearly interpolate for missing years:
optimism <- merge(optimism, expand.grid(year = unique(optimism$year), iso3c = unique(optimism$iso3c)), all = T)

optimism <- optimism[order(optimism$year), ]
for(i in c("optimism_future_state_5yr_from_now", "optimism_current_state", 
           "expected_increase_in_optimism_ladder_5yr")){
  
  optimism[, i] <- ave(optimism[, i], optimism$iso3c, FUN = function(x){
    if(sum(!is.na(x)) >= 2){
    replace <- approx(x, xout = which(is.na(x)))
    x[replace$x] <- replace$y
    x
    } else {x}
  })
}

# Add delta features:
for(i in c("optimism_future_state_5yr_from_now", "optimism_current_state", 
           "expected_increase_in_optimism_ladder_5yr")){
  optimism[, paste0(i, '_change')] <- ave(optimism[, i], optimism$iso3c, FUN = function(x){
    x <- x - c(NA, x)[1:length(x)]
    x
  })
  }

rm(gallup_in_five_years)
rm(gallup_now)

# ggplot(optimism[optimism$iso3c %in% sample(unique(optimism$iso3c), 9), ], aes(x=year))+
#   geom_line(aes(y=optimism_future_state_5yr_from_now, col='future state expectation'))+
#   geom_line(aes(y=optimism_current_state, col='current state'))+facet_wrap(iso3c~.)

# World Values Survey
wvs <- readRDS('source-data/world-values-survey/WVS_TimeSeries_4_0.rds')
wvs$optimism_current_state_wvs <- wvs$A170
wvs$iso3c <- wvs$COUNTRY_ALPHA
wvs$interest_in_politics <- wvs$E023
wvs$pride_in_nation <- wvs$G006
wvs$pride_in_nation[!as.numeric(wvs$pride_in_nation) %in% 1:4] <- NA
wvs$science_gives_more_opportunties_for_next_generation <- wvs$E218
wvs$revolutionary_action <- as.numeric(as.numeric(wvs$E034) == 1)
wvs$revolutionary_action[as.numeric(wvs$E034) < 0] <- NA
wvs$war_worries <- wvs$H006_03
wvs$civil_war_worries <- wvs$H006_05
wvs$year <- wvs$S020

wvs <- data.frame(wvs[, c('year', 'optimism_current_state_wvs', 'iso3c', 'interest_in_politics', 'pride_in_nation', 'science_gives_more_opportunties_for_next_generation', 'revolutionary_action',
                          'war_worries', 'civil_war_worries')])
wvs$year <- as.numeric(unlist(wvs$year))

wvs$optimism_current_state_wvs <- ave(as.numeric(wvs$optimism_current_state_wvs), paste0(wvs$iso3c, '_', wvs$year), FUN = function(x) 
  mean(x[x >= 0], na.rm = T))
wvs$interest_in_politics <- ave(as.numeric(wvs$interest_in_politics), paste0(wvs$iso3c, '_', wvs$year), FUN = function(x) 
  4-mean(x[x >= 0], na.rm = T)) # 4 is lowest in original scale
wvs$pride_in_nation <- ave(as.numeric(wvs$pride_in_nation), paste0(wvs$iso3c, '_', wvs$year), FUN = function(x) 
  4-mean(x[x >= 0], na.rm = T)) # 4 is lowest in original scale
wvs$science_gives_more_opportunties_for_next_generation <- ave(as.numeric(wvs$science_gives_more_opportunties_for_next_generation), paste0(wvs$iso3c, '_', wvs$year), FUN = function(x) 
  mean(x[x >= 0], na.rm = T))
wvs$revolutionary_action <- ave(as.numeric(wvs$revolutionary_action), paste0(wvs$iso3c, '_', wvs$year), FUN = function(x) 
  mean(x[x >= 0], na.rm = T))
wvs$war_worries <- ave(as.numeric(wvs$war_worries), paste0(wvs$iso3c, '_', wvs$year), FUN = function(x) 
  4-mean(x[x >= 0], na.rm = T)) # 4 is lowest in original scale
wvs$civil_war_worries <- ave(as.numeric(wvs$civil_war_worries), paste0(wvs$iso3c, '_', wvs$year), FUN = function(x) 
  4-mean(x[x >= 0], na.rm = T)) # 4 is lowest in original scale

# Deduplicate:
wvs <- wvs[!duplicated( paste0(wvs$iso3c, '_', wvs$year)), ]


for(i in colnames(wvs)){
  wvs[is.nan(wvs[, i]), i] <- NA
}

wvs$iso3c <- as.character(wvs$iso3c)

# ggplot(wvs_cy, aes(x=year, y=interest_in_politics, col=iso3c))+geom_point()+facet_wrap(.~iso3c)
ggplot(wvs, aes(x=year, y=pride_in_nation, col=iso3c))+geom_point()+facet_wrap(.~iso3c)+theme(legend.position = 'none')
ggplot(wvs, aes(x=year, y=optimism_current_state_wvs, col=iso3c))+geom_point()+facet_wrap(.~iso3c)+theme(legend.position = 'none')
ggplot(wvs, aes(x=year, y=science_gives_more_opportunties_for_next_generation, col=iso3c))+geom_point()+facet_wrap(.~iso3c)+theme(legend.position = 'none')


## VDEM variables  --------------------------------------------------------
if(!vdem_cache){
  library(vdemdata)
  saveRDS(vdem, 'source-data/cache/vdem_cache.RDS')
} else {
  vdem <- readRDS('source-data/cache/vdem_cache.RDS')
  vdem$common_good_policies <- vdem$v2dlcommon
  vdem$pol_elites_give_gives_reasoned_justifications_for_policies <- vdem$v2dlreason
  vdem$pol_elites_respect_counterarguments <- vdem$v2dlcountr
  vdem$means_tested_or_universalistic_welfare <- vdem$v2dlunivl
  vdem$vdem_political_polarisation <- vdem$v2cacamps
  vdem$vote_buying <- vdem$v2elvotbuy
  vdem$vote_other_irregularities <- vdem$v2elirreg
  vdem$iso3c <- countrycode(vdem$country_name, 'country.name', 'iso3c')
}



## Ideology variable --------------------------------------------------------
ideology <- read.dta13('source-data/replication-data-affective-polarization-apsr/PAP_LAP_dataset.dta')
ideology <- ideology[, c('Country', 'Year', 'LR_Polarization_perceived', 'Age_of_democracy')]
ideology$iso3c <- countrycode(ideology$Country, 'country.name', 'iso3c')
ideology$year <- ideology$Year
ideology <- ideology[, c('iso3c', 'year', 'LR_Polarization_perceived', 'Age_of_democracy')]
ideology$LR_Polarization_perceived <- ave(ideology$LR_Polarization_perceived, paste0(ideology$iso3c, '_', ideology$year), 
                                          FUN = mean)
ideology$Age_of_democracy <- ave(ideology$Age_of_democracy, paste0(ideology$iso3c, '_', ideology$year), 
                                          FUN = mean)
ideology <- unique(ideology)

# Adding in data where this is missing from Dalton 2017
dalton <- read_xlsx('source-data/dalton-et-al-2017/RJD_PolarizationDatabase1-4.xlsx')
dalton <- dalton[!is.na(dalton$Polarization), ]
dalton$Country[dalton$Country == 'United Kindom'] <- "United Kingdom"

dalton <- dalton %>% mutate(year = Year,
                            iso3c = countrycode(Country, 'country.name', 'iso3c'),
                            dalton_polarization = Polarization) %>%
  select(iso3c, year, dalton_polarization) %>% unique()

## Regime performance variable --------------------------------------------------------
reg <- read.dta13('source-data/wgidataset-stata/wgidataset.dta')
reg$gov_effectiveness_wb <- reg$gee
reg <- reg[, c('code', 'year', 'gov_effectiveness_wb')]
reg <- reg %>% rename(iso3c = code)

## Country going in the right direction (IPSOS): --------------------------------------------------------
ipsos <- read_xlsx('source-data/ipsos/Right direction scores 10 year trend.xlsx')
ipsos <- ipsos %>% pivot_longer(cols = 2:ncol(ipsos))
ipsos$year <- NA
for(i in 1:nrow(ipsos)){
  ipsos$year[i] <- strsplit(ipsos$name[i], '\n')[[1]][2]
}
ipsos$year <- as.numeric(ipsos$year)
colnames(ipsos) <- c('country', 'date', 'right_direction_percent', 'year')
ipsos$right_direction_percent <- ave(ipsos$right_direction_percent, paste0(ipsos$year, ipsos$country), FUN = function(x) mean(x, na.rm = T))
ipsos$country[ipsos$country == 'The US'] <- 'United States'
ipsos$iso3c <- countrycode(ipsos$country, 'country.name', 'iso3c')

ggplot(ipsos, aes(x=year, y=right_direction_percent, col=country))+geom_line()+facet_wrap(.~country)
ipsos <- unique(ipsos[!is.na(ipsos$iso3c), c('iso3c', 'year', 'right_direction_percent')])

## Edelman trust index ------------------------------------------------------------
edelman <- read_xlsx('source-data/edelman-trust-survey/Edelman Trust Barometer_Economist Data.xlsx')

## Corruption perceptions index
corruption <- read_csv('source-data/corruption.csv')

## Combine all data sources: --------------------------------------------------------

partisanship <- merge(partisanship, ideology, by = c('year', 'iso3c'), all = T)
partisanship <- merge(partisanship, mid_data[, c('iso3c', 'year', 'n_mids', 'n_fatal_mids', 'n_mids_in_neighbouring_countries', 'n_fatal_mids_in_neighbouring_countries')], by = c('year', 'iso3c'), all = T)
partisanship <- merge(partisanship, unique(mid_data[, c('year', 'ww_mids', 'ww_fatal_mids', 'ww_majpow_mids', 'ww_majpow_fatal_mids')]), by = c('year'), all = T)
partisanship <- merge(partisanship, milex, by = c('year', 'iso3c'), all = T)
partisanship <- merge(partisanship, reg, by = c('year', 'iso3c'), all = T)
partisanship <- merge(partisanship, wdi_data[!is.na(wdi_data$iso3c), ], by = c('year', 'iso3c'), all = T)
partisanship <- merge(partisanship, majpow_spending, by = c('year'), all = T)
partisanship <- merge(partisanship, optimism, by = c('year', 'iso3c'), all = T)
partisanship <- merge(partisanship, corruption, by = c('year', 'iso3c'), all.x = T)
partisanship <- merge(partisanship, wvs, by = c('year', 'iso3c'), all = T)
partisanship <- merge(partisanship, vdem[, c('iso3c', 'year', 'common_good_policies', 'pol_elites_give_gives_reasoned_justifications_for_policies', 'pol_elites_respect_counterarguments', 'means_tested_or_universalistic_welfare', 'vdem_political_polarisation', 'vote_buying', 'vote_other_irregularities')], by = c('year', 'iso3c'), all.x = T)
partisanship <- merge(partisanship, unpop, by = c('iso3c', 'year'), all.x = T)
partisanship <- merge(partisanship, dalton, by = c('iso3c', 'year'), all.x = T)
partisanship <- merge(partisanship, ipsos[, c('iso3c', 'right_direction_percent', 'year')], all.x= T)

# Generate averages for a few key variables:
past_three_years_average <- function(x) {
  # Initialize the vector to store the moving averages
  temp <- rep(NA, length(x))
  
  # Calculate the moving average using a loop
  for(i in 1:length(x)){
    # Create a vector of current and previous two elements
    if (i == 1) {
      values <- c(NA, NA, x[i])
    } else if (i == 2) {
      values <- c(NA, x[i-1], x[i])
    } else {
      values <- c(x[i-2], x[i-1], x[i])
    }
    
    # Calculate the mean, ignoring NA values
    temp[i] <- mean(values, na.rm = TRUE)
  }
  
  return(temp)
}


# Generate averages for a few key variables:
past_five_years_average <- function(x) {
  # Initialize the vector to store the moving averages
  temp <- rep(NA, length(x))
  
  # Calculate the moving average using a loop
  for(i in 1:length(x)){
    # Create a vector of current and previous two elements
    if (i == 1) {
      values <- c(NA, NA, x[i])
    } else if (i == 2) {
      values <- c(NA, x[i-1], x[i])
    } else if (i == 3) {
      values <- c(x[i-2], x[i-1], x[i])
    } else if (i == 4) {
      values <- c(x[i-3], x[i-2], x[i-1], x[i])
    } else {
      values <- c(x[i-4], x[i-3], x[i-2], x[i-1], x[i])
    }
    
    # Calculate the mean, ignoring NA values
    temp[i] <- mean(values, na.rm = TRUE)
  }
  
  return(temp)
}


partisanship <- partisanship[order(partisanship$year), ]
for(i in c('military_spending',
           'military_spending_change',
           'military_spending_PPP',
           'military_spending_PPP_change',
           'milex_percent_of_gdp',
           'milex_percent_of_gdp_change', 
           'military_spending_PPP_in_neighbouring_countries',
           'military_spending_in_neighbouring_countries',
           'military_spending_PPP_in_neighbouring_countries_change',
           'military_spending_in_neighbouring_countries_change',
           'ww_mids',
           'ww_fatal_mids',
           'ww_majpow_mids',
           'ww_majpow_fatal_mids',
           'n_mids',
           'n_fatal_mids',
           'n_mids_in_neighbouring_countries',
           'n_fatal_mids_in_neighbouring_countries',
           "optimism_future_state_5yr_from_now_change",
           "optimism_current_state_change",
           "expected_increase_in_optimism_ladder_5yr_change",
           'pride_in_nation',
           'optimism_current_state_wvs',
           'war_worries', 'civil_war_worries',
           'science_gives_more_opportunties_for_next_generation',
           'revolutionary_action',
           'interest_in_politics',
           'right_direction_percent',
           'dalton_polarization')){
  partisanship[, paste0(i, '_3yr')] <- ave(partisanship[, i], partisanship$iso3c, FUN = past_three_years_average)
  partisanship[, paste0(i, '_5yr')] <- ave(partisanship[, i], partisanship$iso3c, FUN = past_five_years_average)
  
}

write_csv(partisanship, 'output-data/partisanship.csv')
