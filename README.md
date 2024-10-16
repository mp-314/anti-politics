Here’s the updated README with the requested sections for citation, sources, and a check on dependencies:

---

# Replication Package: Analysis of Anti-Politics and Negative Partisanship

This replication package accompanies the article in *The Economist* on anti-politics and negative partisanship. It includes the necessary scripts to reproduce the data, charts, and key analyses referenced in the article.

## Overview

The package contains three R scripts located in the `scripts` folder:
1. **data-generation.R**
2. **chart-replication.R**
3. **analysis-replication.R**

To fully replicate the analysis, you should run these scripts **in order**:

1. **data-generation.R**  
   This script processes and constructs the datasets used in the analysis. It pulls together various data sources on partisanship, electoral systems, government effectiveness, military spending, migration, and other variables relevant to the study.

2. **chart-replication.R**  
   After generating the data, this script replicates the visualizations featured in the article. It reproduces the key figures related to partisanship sentiment, affection gaps, and political attitudes over time across different countries. 

3. **analysis-replication.R**  
   This final script performs the main statistical analyses described in the article. It includes regressions and stress-tests that explore relationships between negative partisanship, military spending, migration, economic growth, and other variables.  
   **Note:** The analysis is descriptive and correlational; it does not establish causality. Readers are encouraged to explore the data further and experiment with different model specifications.

## Running the Scripts

To replicate the analysis, you should execute the scripts in the following order:

1. **data-generation.R**: Prepares the data for analysis.
2. **chart-replication.R**: Produces the charts and figures used in the article.
3. **analysis-replication.R**: Replicates the regression analysis and other statistical results.

### Dependencies

Before running the scripts, ensure that the following R packages are installed:

- `tidyverse`
- `ggplot2`
- `QuickCoefPlot`
- `countrycode`
- `haven`
- `readstata13`
- `readxl`
- `progress` (used for displaying progress bars in the data-generation process)

You can install all the required packages using the following R command:

```R
install.packages(c('tidyverse', 'ggplot2', 'QuickCoefPlot', 'countrycode', 'haven', 'readstata13', 'readxl', 'progress'))
```

## Variables

The key variables used in the analysis include:

- **INPARTY**: Measures the positive feelings respondents have towards their in-party (0-10 scale).
- **OUTPARTY**: Measures the positive feelings respondents have towards their out-party (0-10 scale).
- **negative_partisanship**: Calculated as the difference between in-party and out-party affection (INPARTY - OUTPARTY).
- **optimism_current_state**: A measure of respondents' current optimism regarding their country's direction.
- **net_migration_percent_of_pop**: Net migration as a percentage of the country's population.
- **milex_percent_of_gdp**: Military expenditure as a percentage of GDP, averaged over three years.
- **gov_effectiveness_wb**: World Bank's measure of perceived government effectiveness.
- **refugee_pop_over_population**: Percentage of refugees in the population.
- **dalton_polarization**: A measure of ideological polarization within a country.

Each script builds on these variables to create visualizations or conduct statistical analysis. For more details on the variables and how they are constructed, refer to the data-generation script.

## Sources

This project uses various publicly available data sources, including but not limited to:

- **World Bank** for government effectiveness and economic indicators.
- **V-Dem Institute** for electoral system data and political polarization measures.
- **CSES** (Comparative Study of Electoral Systems) for in-party and out-party affection data.
- **SIPRI** (Stockholm International Peace Research Institute) for military expenditure data.
- **United Nations** for population and migration data.
- **Edelman Trust Barometer** and **Gallup** for public sentiment data.

These sources have been combined and processed to create a comprehensive dataset for the analysis.

## Suggested Citation

If you use this replication package in your work, please cite it as follows:

> The Economist Data Team (2024). Replication package for the analysis of anti-politics and negative partisanship. *The Economist*. Available at: [GitHub link]

For referencing the original article, please cite:

> The Economist Data Team (2024). "Anti-Politics and Negative Partisanship: A Global Study". *The Economist*.

## Acknowledgments

We would like to extend our thanks to the following academics, whose expertise in the field of negative partisanship was invaluable in conducting this analysis:

- **Diego Garzia** (University of Lausanne), a leading expert in negative partisanship, whose work informed much of the partisanship data used in this analysis.
- **André Blais** (University of Montreal), an authority on electoral systems and political behavior.
- **J. Horne** (University of Cambridge), whose work on public opinion surveys helped guide our understanding of party affection gaps.

Their contributions to this field have been critical in shaping the analysis presented here.

## Contact and Further Information

If you encounter any issues or have questions about the replication package, feel free to reach out via the GitHub issue tracker or contact the team behind the analysis.

---

Let me know if this version is ready to go!