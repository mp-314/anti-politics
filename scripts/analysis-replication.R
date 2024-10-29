# This script contains regressions and other analysis supporting the key assertions made in the text of the article. The below is a very small set of the statistical analysis conducted overall, meant to illustrate our main results. This means that the various robustness checks and auxiliary analysis we conducted to increase our confidence in these results is for the most part not included here. We again stress, as we do in the article, that these are not directional relationships (i.e. causal relationships). We hope other researchers will find these results interesting and explore them further.

# For details on the variables used, please see the data generation script. 

# Load data and packages
library(tidyverse)
library(QuickCoefPlot)
df <- data.frame(read_csv('output-data/partisanship.csv'))

# Break Germany into FRG and DEU
df$iso3c[df$iso3c == 'DEU' & df$year <= 1989] <- 'DEU_FRG'
df$country[df$iso3c == 'DEU_FRG' & df$year <= 1989] <- 'Germany (FRG)'

df$INPARTY_index <- ave(df$INPARTY, df$iso3c, FUN = function(x) x - mean(x, na.rm = T))
df$OUTPARTY_index <- ave(df$OUTPARTY, df$iso3c, FUN = function(x) x - mean(x, na.rm = T))
df$optimism_index <- ave(df$optimism_current_state, df$iso3c, FUN = function(x) x - mean(x, na.rm = T))
df$optimism_future_index <- ave(df$optimism_future_state_5yr_from_now, df$iso3c, FUN = function(x) x - mean(x, na.rm = T))

# Define affection gap variable
df$negative_partisanship <- df$INPARTY - df$OUTPARTY
df$negative_partisanship_index <- df$INPARTY_index - df$OUTPARTY_index

# Define cold war variable
df$cold_war <- df$year <= 1990
df$cold_war_x_year <- df$year*df$cold_war

# Restrict to country-years were we have negative partisanship data:
df_full <- df
df <- df[!duplicated(paste0(df$iso3c, '_', df$year)), ]
df <- df[!is.na(df$OUTPARTY), ]

# Exclude US as robustness check (if you would like -- just uncomment the below line) 
# df <- df[!df$iso3c == 'USA', ]

# 1: Scope of analysis: ------------------------------------------------------------

# Number of elections
nrow(df)

# Countries included (total number depending a bit on how one counts)
unique(df$country)

# Years included
summary(df$year)

# 2: Robustness of main result (world-wide trends) ------------------------------------------------------------

# This part of the script will replicate the smoothed line in the main charts under various stress-test conditions. These are:
# 1. Dropping 10 countries at a time, cycling through all countries
# 2. Dropping all anglo countries
# 3. Showing only FPP systems
# 4. Showing only PR systems
# For each stress-test, it will show how many countries are included, and if less than 6, name them. 
# For each stress-test, it will give both the population-weighted and the not-population-weighted average.
# It will then produce a new "main chart" with all these lines included.

# The statistic in question is the smoothed line in each of the plots below. 

# Plot: Affection gap
ggplot(df, aes(x=year, y=negative_partisanship_index, col=country, size = population, weight=population))+
  geom_line(alpha = 0.5)+
  geom_smooth(aes(col='black'), col='black', method = 'loess', size = 2, span = 0.25)+guides(col = 'none', size= 'none')+
  ylab('black = average')+xlab('Affection gap between in and out party, compared to average for that country')

# Plot: Outparty feeling
ggplot(df, aes(x=year, y=OUTPARTY_index, col=country, size = population, weight=population))+
  geom_line(alpha = 0.5)+
  geom_smooth(aes(col='black'), col='black', method = 'loess', size = 2, span = 0.25)+guides(col = 'none', size= 'none')+
  ylab('black = average')+xlab('Out-party sentiment compared to average for that country')

# Plot: Inparty feeling
ggplot(df, aes(x=year, y=INPARTY_index, col=country, size = population, weight=population))+
  geom_line(alpha = 0.5)+
  geom_smooth(aes(col='black'), col='black', method = 'loess', size = 2, span = 0.5)+guides(col = 'none', size= 'none')+
  ylab('black = average')+xlab('In-party sentiment compared to average for that country')


# We first define a function to extract the line in question:
# Load necessary libraries
library(ggplot2)

# Remove observatiosn without population values:
df <- df[!is.na(df$population), ]

# Making it into a data frame:
df <- data.frame(df)

# Ensure population is numeric
df$population <- as.numeric(df$population)

extract_trends <- function(test_sample = df, sample = 'all observations'){
  # Fit the loess model manually
  loess_fit <- loess(negative_partisanship_index ~ year, data = test_sample, span = 0.25, weights = test_sample$population)
  
  # Extract the fitted values (y-values for the smooth line) and the corresponding x-values
  smooth_values <- data.frame(year = test_sample$year, sample = sample, n_in_sample = length(unique(test_sample$country)), negative_partisanship_index_trend = predict(loess_fit))
  
  loess_fit <- loess(INPARTY_index ~ year, data = test_sample, span = 0.25, weights = test_sample$population)
  
  smooth_values$INPARTY_index_trend <- predict(loess_fit)
  
  loess_fit <- loess(OUTPARTY_index ~ year, data = test_sample, span = 0.25, weights = test_sample$population)
  
  smooth_values$OUTPARTY_index_trend <- predict(loess_fit)
  
  return(smooth_values)
}

#  This shows that this process works:
# Extract plan
full_sample <- extract_trends(test_sample = df, sample = 'all observations')

# Original plot
p <- ggplot(df, aes(x=year, y=negative_partisanship_index, col=country, size = population, weight=population)) +
  geom_line(alpha = 0.5) +
  geom_smooth(aes(col='black'), col='black', method = 'loess', size = 2, span = 0.25) +
  guides(col = 'none', size= 'none') +
  ylab('black = average') +
  xlab('Affection gap between in and out party, compared to average for that country')

# Add the manually extracted smooth line as a dotted red line, removing unnecessary aesthetics
p + geom_line(data = full_sample, aes(x = year, y = negative_partisanship_index_trend), col = "red", linetype = "dotted", size = 1.5, inherit.aes = FALSE)

# We are now ready to go through different samples of our data
# Define the list of Anglo countries
anglo_countries <- c("United Kingdom", "Canada", "United States", "Australia", "New Zealand", "Ireland")

# Define FPP and PR systems 
vdem <- readRDS('source-data/cache/vdem_cache.RDS')
vdem <- vdem[, c('country_name', 'year', 'v2elloelsy')]
vdem$PR <- !vdem$v2elloelsy %in% c(0, 1, 2, 3, 4) 
vdem$PR[is.na(vdem$v2elloelsy)] <- NA
vdem <- vdem[vdem$year >= 1960, ]
vdem$country_name[vdem$country_name == 'United States of America'] <- "United States"
vdem$country_name[vdem$country_name == 'South Korea'] <- "Republic of Korea"
vdem$country_name[vdem$country_name == 'Czechia'] <- "Czech Republic"
vdem$country_name[vdem$country_name == 'Germany' & vdem$year < 1990] <- "Germany (FRG)"
vdem <- vdem[vdem$country_name %in% df$country, ]

df <- merge(df, vdem[, c('country_name', 'year', 'PR')], by.x=c('country', 'year'), by.y=c('country_name', 'year'), all.x = T)
# We fill in the data where missing in VDEM, conservatively assuming it has not missed any changes in electoral systems. In New Zealand, there was a change after 1993 to a PR system. 
df$PR <- ave(df$PR, df$country, FUN = function(x) na.omit(x)[1])
df$PR[df$country == 'New Zealand'] <- ifelse(df$year[df$country == 'New Zealand'] <= 1993, F, T)

# 0. All countries, and all countries except the US
trends <- data.frame()
trends <- rbind(trends, extract_trends(test_sample = df, sample = 'all observations'))
trends <- rbind(trends, extract_trends(test_sample = df[df$country != 'United States', ], sample = '- Dropped United States'))
ggplot(trends, aes(x=year, y=negative_partisanship_index_trend, col=sample))+geom_line()

# 1. Dropping 10 countries at a time
set.seed(11235)
countries <- unique(df$country)
countries <- countries %>% sample(length(countries))
results <- list()

for (i in seq(1, length(countries), by=11)) {
  drop_countries <- countries[i:min(i+10, length(countries))]
  print(drop_countries)
  print('...')
  df_subset <- df %>% filter(!country %in% drop_countries)
  trends <- rbind(trends, extract_trends(test_sample = df_subset, sample = "- Dropping 1/5 of countries in data randomly (5 series)"))
}

# 2. Dropping all Anglo countries
df_no_anglo <- df %>% filter(!country %in% anglo_countries)
trends <- rbind(trends, extract_trends(test_sample = df_no_anglo, sample = '- No Anglo countries (UK, US, Can, Aus, NZ, Ireland, S. Africa)'))

# 3. Showing only FPP systems
df_fpp <- df %>% filter(!PR)
trends <- rbind(trends, extract_trends(test_sample = df_fpp, sample = '- Only FPP electoral systems'))

# 4. Showing only PR systems
df_pr <- df %>% filter(PR)
trends <- rbind(trends, extract_trends(test_sample = df_pr, sample = '- Only PR electoral systems'))

# 5. All observations, but no population weights
df_no_weights <- df %>% mutate(population = 1)
trends <- rbind(trends, extract_trends(test_sample = df_no_weights, sample = '- all observations, but average not weighted by population'))

# 6. Only America
df_us <- df %>% filter(country == 'United States')
trends <- rbind(trends, extract_trends(test_sample = df_us, sample = '- only the United States'))

# Plot all
ggplot(trends, aes(x=year, y=OUTPARTY_index_trend, col=sample))+geom_line(data=trends[trends$sample == 'all observations', ], col='black', size = 2, aes(linetype='All observations'))+geom_line()+theme(legend.title = element_blank())+ggtitle('Outparty feeling')+ylim(c(-2.2, 2.2))+ylab('')+xlab('')
ggplot(trends, aes(x=year, y=INPARTY_index_trend, col=sample))+geom_line(data=trends[trends$sample == 'all observations', ], col='black', size = 2, aes(linetype='All observations'))+geom_line()+theme(legend.title = element_blank())+ggtitle('Inparty feeling')+ylim(c(-2.2, 2.2))+ylab('')+xlab('')
ggplot(trends, aes(x=year, y=negative_partisanship_index_trend, col=sample))+geom_line(data=trends[trends$sample == 'all observations', ], col='black', size = 2, aes(linetype='All observations'))+geom_line()+theme(legend.title = element_blank())+ggtitle('Affection gap')+ylim(c(-2.2, 2.2))+ylab('')+xlab('')


# 3: Non-relationships ------------------------------------------------------------
library(QuickCoefPlot)  # This package allows us to quickly conduct and plot regressions with clustered standard errors
# Note: a cold war control is not added when no observations before the cold war are available. Interested readers should experiment with different regression specifications (we only give a sample of those we tried below)

# Negative partisanship and ideological differences:
qcp(lm(negative_partisanship~dalton_polarization_3yr+as.factor(iso3c)+year, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
# Though note apparently better views of both parties 
qcp(lm(OUTPARTY~dalton_polarization_3yr+as.factor(iso3c)+year, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(INPARTY~dalton_polarization_3yr+as.factor(iso3c)+year, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')

# Negative partisanship and refugee flows:
# Looking across countries, refugee populations as % are associated with more positive feelings towards out-party. However, within-country, no clear link to anything
ggplot(df, aes(x=refugee_pop_over_population, y=OUTPARTY, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1))+scale_x_continuous(trans='pseudo_log')
qcp(lm(OUTPARTY~refugee_pop_over_population+as.factor(iso3c)+year*cold_war, data = df, weights = population), include.only = 1:4, cluster = 'iso3c')
qcp(lm(INPARTY~refugee_pop_over_population+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(negative_partisanship~refugee_pop_over_population+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')

# Negative partisanship and respect for political opponents:
# Elites respecting counter-arguments appears related to out-party affection when comparing countries. But there is no clear patterns on a within-country basis i.e. - it does not appear to moderate the affection gap within countries.
ggplot(df, aes(x=pol_elites_respect_counterarguments, y=negative_partisanship, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1))
qcp(lm(negative_partisanship~pol_elites_respect_counterarguments+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(OUTPARTY~pol_elites_respect_counterarguments+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(INPARTY~pol_elites_respect_counterarguments+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')

# Negative partisanship and booming economies:
# Looking across countries link there is no clear link between negative partisanship and economic growth
ggplot(df, aes(x=gdp_growth, y=negative_partisanship, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1))

# There is also no clear link within-country
qcp(lm(OUTPARTY~gdp_growth+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c') 
qcp(lm(INPARTY~gdp_growth+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(negative_partisanship~gdp_growth+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')

# 3: Negative partisanship and external threat ------------------------------------------------------------
# First, define military spending per capita variable:
df$military_spending_3yr_per_capita <- df$military_spending_3yr*1e6 / df$population

# And second, total and fatal mids in last three years variable:
df$n_fatal_mids_3yr_01 <- df$n_fatal_mids_3yr > 0
df$n_mids_3yr_01 <- df$n_mids_3yr > 0

# Hard-coding a few variables to make results easier to interpret
df$milex_percent_of_gdp_3yr_pretty <- df$milex_percent_of_gdp_3yr*100
df$log_gdp_pretty <- log(df$gdp/1e6)

# Define alternative military expenditure variable for robustness test below (US spending excluding Iraq and Afghanistan war OCO spending by State/DoD):
# Source: https://watson.brown.edu/costsofwar/files/cow/imce/papers/2021/Costs%20of%20War_U.S.%20Budgetary%20Costs%20of%20Post-9%2011%20Wars_9.1.21.pdf page 17

# Create the data
years <- 2001:2022
afghanistan <- c(9.0, 14.0, 17.6, 15.2, 20.9, 18.8, 31.4, 38.8, 57.2, 107, 119, 110, 83.7, 88.1, 57.8, 52.1, 58.6, 57.5, 47.8, 49.0, 37.1, 22.9)
iraq_syria <- c(0, 0, 51.0, 76.6, 79.1, 95.6, 130, 143, 91.8, 65.3, 47.1, 14.7, 3.7, 4.1, 8.4, 11.6, 26.3, 23.0, 17.4, 37.6, 30.3, 19.4)

# Combine into a data frame
war_spend <- data.frame(Year = years, Afghanistan = afghanistan, Iraq_Syria = iraq_syria)
war_spend$yearly_in_m <- 1000*(war_spend$Iraq_Syria+war_spend$Afghanistan)
# ggplot(war_spend, aes(x=Year, y=Afghanistan))+geom_line()+geom_line(aes(y=Iraq_Syria, col='Iraq/Syria'))

df$milex_percent_of_gdp_alt <- df$milex_percent_of_gdp
for(i in 1:nrow(war_spend)){
  df$milex_percent_of_gdp_alt[df$iso3c == 'USA' & df$year == war_spend$Year[i]] <- (df$milex_percent_of_gdp[df$iso3c == 'USA' & df$year == war_spend$Year[i]]) *(1 - war_spend$yearly_in_m[i]/df$military_spending[df$iso3c == 'USA' & df$year == war_spend$Year[i]])
  print((1 - war_spend$yearly_in_m[i]/df$military_spending[df$iso3c == 'USA' & df$year == war_spend$Year[i]]))
}

# Generate average:
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

df$milex_percent_of_gdp_alt_3yr <- ave(df$milex_percent_of_gdp_alt, df$iso3c, FUN = past_three_years_average)


# Negative partisanship and military spending:

# Comparing countries:
ggplot(df, aes(x=milex_percent_of_gdp_3yr_pretty, y=negative_partisanship, col=iso3c, size=population))+geom_point()+geom_smooth(method = 'lm', aes(group = 1, weight=population))

# Within countries:
# Excluding the US, as mentioned in text
qcp(lm(negative_partisanship~milex_percent_of_gdp_3yr_pretty+
         year+
         as.factor(iso3c), data = df[!df$iso3c %in% c('USA'), ], weights = population), include.only = 1:5, cluster = 'iso3c',
    hide.summary.lines = T, iv.vars.names = c('Military spending, % of GDP', 'Time trend'), plot.title = 'Effects on negative partisanship, within-country analysis', xlab = '', ylab= '')

# Adding some more controls:
qcp(lm(negative_partisanship~milex_percent_of_gdp_3yr_pretty+log_gdp_pretty+gdp_growth+
         year+cold_war+
         as.factor(iso3c), data = df[df$iso3c != 'USA', ], weights = population), include.only = 1:5, cluster = 'iso3c',
    hide.summary.lines = T, iv.vars.names = c('Military spending, % of GDP', 'GDP', 'GDP growth', 'Time trend', 'Cold war effect'), plot.title = 'Effects on negative partisanship, within-country analysis', xlab = '', ylab= '')

# With the US (all spending)
qcp(lm(negative_partisanship~milex_percent_of_gdp_3yr_pretty+year+
         as.factor(iso3c), data = df[, ], weights = population), include.only = 1:5, cluster = 'iso3c',
    hide.summary.lines = T, iv.vars.names = c('Military spending, % of GDP', 'Time trend'), plot.title = 'Effects on negative partisanship, within-country analysis', xlab = '', ylab= '')

# With the US (excluding Afg / Iraq wars)
qcp(lm(negative_partisanship~milex_percent_of_gdp_alt_3yr+
         year+
         as.factor(iso3c), data = df[, ], weights = population), include.only = 1:5, cluster = 'iso3c',
    hide.summary.lines = T, iv.vars.names = c('Military spending, % of GDP', 'GDP', 'GDP growth', 'Time trend', 'Cold war effect'), plot.title = 'Effects on negative partisanship, within-country analysis', xlab = '', ylab= '')

# Revolution (caution, very low N)
qcp(lm(negative_partisanship~revolutionary_action_3yr+as.factor(iso3c)+year+cold_war, data=df, weights = population), include.only = 1:5, cluster = 'iso3c')

# War worries (caution, very low N)
qcp(lm(negative_partisanship~war_worries_5yr+as.factor(iso3c)+year+cold_war, data=df, weights = population), include.only = 1:5, cluster = 'iso3c')

# Deadly militarized disputes, number (caution, very few countries experience this):
ggplot(df[!is.na(df$n_fatal_mids_3yr), ], aes(x=n_fatal_mids_3yr, y=negative_partisanship, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1))

# Deadly military disputes, any (caution, very few countries experience this):
ggplot(df[!is.na(df$n_fatal_mids_3yr_01), ], aes(x=n_fatal_mids_3yr_01, y=negative_partisanship, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1))

# Note: There is a lot of other evidence in this vein. For instance: stronger effects for countries bordering Russia, some evidence of effects of military spending in surrounding countries, and so on. We hope future research my expand on these investigations. 

# 4: Negative partisanship and beliefs about politics ------------------------------------------------------------

# Negative partisanship and perceived government effectiveness
ggplot(df, aes(x=gov_effectiveness_wb, y=OUTPARTY, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1), weights = population)
ggplot(df, aes(x=gov_effectiveness_wb, y=negative_partisanship, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1), weights = population)

# Within-country:
qcp(lm(OUTPARTY~gov_effectiveness_wb+as.factor(iso3c)+year, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')

# Net migration / population:
df$net_migration_percent_of_pop <- 100*df$net_migration/df$population
ggplot(df, aes(x=net_migration_percent_of_pop, y=negative_partisanship, col=iso3c, size = population))+geom_point()+geom_smooth(aes(group = 1, weight = population), method = 'lm')+theme(legend.position = 'none')

# Within-country
qcp(lm(negative_partisanship~net_migration_percent_of_pop+year+as.factor(iso3c), weights = population, data = df[, ]), 
    include.only = 1:4, cluster = 'iso3c')
# with a few more controls:
qcp(lm(negative_partisanship~net_migration_percent_of_pop+gdp_growth+log(gdp)+refugee_pop_over_population+
         year+cold_war+log(gdp_per_capita)+as.factor(iso3c), weights = population, data = df[, ]), 
    include.only = 1:4, cluster = 'iso3c')
qcp(lm(negative_partisanship~net_migration_percent_of_pop+milex_percent_of_gdp+year+cold_war, weights = population, data = df), 
    include.only = 1:4, cluster = 'iso3c')

# More universalistic welfare policies
# note: these are policies (where all could, at least potentially, benefit) 
ggplot(df, aes(x=means_tested_or_universalistic_welfare, y=negative_partisanship, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1, weight=population))

qcp(lm(OUTPARTY~means_tested_or_universalistic_welfare+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(INPARTY~means_tested_or_universalistic_welfare+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(negative_partisanship~means_tested_or_universalistic_welfare+as.factor(iso3c)+year*cold_war, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')

# Perceptions of vote-buying brings more animosity:
# Against in-parties
qcp(lm(INPARTY~
         vote_buying+as.factor(iso3c)+year+cold_war, weights = population, data = df[, ]), 
    include.only = 1:4, cluster = 'iso3c')
# But even more against out-parties
qcp(lm(OUTPARTY~
         vote_buying+as.factor(iso3c)+year+cold_war, weights = population, data = df[, ]), 
    include.only = 1:4, cluster = 'iso3c')
# For a larger gap overall
qcp(lm(negative_partisanship~
         vote_buying+as.factor(iso3c)+year+cold_war, weights = population, data = df[, ]), 
    include.only = 1:4, cluster = 'iso3c')


# Negative partisanship and optimism (ratings of current life situation)
ggplot(df, aes(x=optimism_current_state, y=OUTPARTY, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1), weights = population)
ggplot(df, aes(x=optimism_current_state, y=negative_partisanship, col=iso3c))+geom_point()+geom_smooth(method = 'lm', aes(group = 1), weights = population)

# Within-country:
qcp(lm(OUTPARTY~optimism_current_state+as.factor(iso3c)+year, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
qcp(lm(INPARTY~optimism_current_state+as.factor(iso3c)+year, weights = population, data = df), include.only = 1:4, cluster = 'iso3c')
# Improves affection towards both parties, but especially out-parties. 