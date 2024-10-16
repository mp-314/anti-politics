# This replicates the charts shown in the article

# Preamble: Load data and packages ------------------------------------------------------------
library(tidyverse)
library(QuickCoefPlot)
library(countrycode)
df <- data.frame(read_csv('output-data/partisanship.csv'))

# Break Germany into FDR and DEU
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

# Add net migration as % of population
df$net_migration_percent_of_pop <- 100*df$net_migration/df$population

# Make milex a bit more interpretable
df$milex_percent_of_gdp_3yr_pretty <- df$milex_percent_of_gdp_3yr*100

# Ensure no duplicates:
df_full <- df
df <- df[!duplicated(paste0(df$iso3c, '_', df$year)), ]

# Restrict to country-years were we have negative partisanship data:
df <- df[!is.na(df$OUTPARTY), ]

# Add region variable
df$region <- countrycode(df$iso3c, 'iso3c', 'continent')
df$region[df$iso3c == 'DEU_FRG'] <- 'Europe'

# Pre-amble chart:
# For the raw data by country, see:

# Plots: Partisanship data by country
ggplot(df, aes(x=year, col=country))+geom_point(aes(y=INPARTY, col='in-party'))+
  geom_point(aes(y=OUTPARTY, col='out-party'))+
  geom_point(aes(y=INPARTY-OUTPARTY, col='negative partisanship'))+
  geom_line(aes(y=INPARTY-OUTPARTY, col='negative partisanship'))+ylab('Positive feeling, 0-10 scale')+xlab('')+
  facet_wrap(.~country)+scale_x_continuous(breaks = seq(1960, max(df$year), by = 30), 
                                           labels = seq(1960, max(df$year), by = 30))+geom_hline(aes(yintercept = 4))


# Panel 1 ---------------------------

# Panel 1, Chart 1: Inparty feeling
ggplot(df, aes(x=year, y=INPARTY, col=country, size = population, weight=population))+
  geom_point(alpha = 0.5)+
  geom_smooth(aes(col='black'), col='black', method = 'loess', size = 2, span = 0.5)+guides(col = 'none', size= 'none')+xlim(c(1961, 2024))+
  ylab('black = average')+xlab('In-party sentiment compared to average for that country')

# Panel 1, Chart 2: Outparty feeling
ggplot(df, aes(x=year, y=OUTPARTY, col=country, size = population, weight=population))+
  geom_point(alpha = 0.5)+
  geom_smooth(data = df, aes(col='black'), col='black', method = 'loess', size = 2, span = 0.5)+guides(col = 'none', size= 'none')+xlim(c(1960, 2024))+
  ylab('black = average')+xlab('Out-party sentiment compared to average for that country')

# Panel 1, Chart 3: Affection gap
ggplot(df, aes(x=year, y=negative_partisanship_index, col=country, size = population, weight=population))+
  geom_line(alpha = 0.5)+
  geom_smooth(aes(col='black'), col='black', method = 'loess', size = 2, span = 0.5)+guides(col = 'none', size= 'none')+
  ylab('black = average')+xlab('Affection gap between in and out party, compared to average for that country')

# Panel 2 ---------------------------

# Panel 2, Chart 1: Military spending

plot_data <- df[df$iso3c != 'USA', c('country', 'iso3c', 'population', 'milex_percent_of_gdp_3yr_pretty', 'negative_partisanship_index', 'INPARTY_index', 'OUTPARTY_index', 'year')]
plot_data$milex_percent_of_gdp_3yr_pretty_within_country <- ave(plot_data$milex_percent_of_gdp_3yr_pretty, plot_data$iso3c, FUN = function(x) x-mean(x, na.rm = T))
ggplot(plot_data, aes(x=milex_percent_of_gdp_3yr_pretty_within_country, y=negative_partisanship_index, col=iso3c, size = population))+
  geom_point()+
  geom_smooth(method = 'lm', aes(group = 1, weight = population))+ggtitle('Negative partisanship v military spending as % of GDP, \n1960-2021, relative to country mean')+
  xlab('Military spending, % of GDP\nNote: dots are countries, sized by population.\nLine is linear trend weighted by population. Excludes US where spending dominated by Iraq / Afgh wars.')+ylab('')+theme_minimal()+theme(legend.position = 'none')

# Panel 2, Chart 2: Perceived government effectiveness
plot_data <- df[, c('country', 'iso3c', 'population', 'gov_effectiveness_wb', 'negative_partisanship_index', 'INPARTY_index', 'OUTPARTY_index', 'year')]
plot_data$gov_effectiveness_wb_within_country <- ave(plot_data$gov_effectiveness_wb, plot_data$iso3c, FUN = function(x) x-mean(x, na.rm = T))
ggplot(plot_data, aes(x=gov_effectiveness_wb_within_country, y=negative_partisanship_index, col=iso3c, size = population))+
  geom_point()+
  geom_smooth(method = 'lm', aes(group = 1, weight = population))+ggtitle('Negative partisanship v Perceived gov. effectiveness, \n1960-2021, relative to country mean')+
  xlab('Perceived gov. effectiveness\nNote: dots are countries, sized by population.\nLine is linear trend weighted by population')+ylab('')+theme_minimal()+theme(legend.position = 'none')

# Panel 2, Chart 3: Net migration
plot_data <- df[, c('country', 'iso3c', 'population', 'net_migration_percent_of_pop', 'negative_partisanship_index', 'INPARTY_index', 'OUTPARTY_index', 'year')]
plot_data$net_migration_percent_of_pop_within_country <- ave(plot_data$net_migration_percent_of_pop, plot_data$iso3c, FUN = function(x) x-mean(x, na.rm = T))
ggplot(plot_data, aes(x=net_migration_percent_of_pop_within_country, y=negative_partisanship_index, col=iso3c, size = population))+
  geom_point()+
  geom_smooth(method = 'lm', aes(group = 1, weight = population))+ggtitle('Negative partisanship v net migration as % of population, \n1960-2021, relative to country mean')+
  xlab('net migration as % of population\nNote: dots are countries, sized by population.\nLine is linear trend weighted by population')+ylab('')+theme_minimal()+theme(legend.position = 'none')