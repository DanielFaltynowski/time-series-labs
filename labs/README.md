# Laboratory 01: Removing Trend and Seasonality in Time Series

Download the data on Gross Value Added (GVA) for Poland from the [Eurostat](https://ec.europa.eu/eurostat) website. Perform a time series analysis and remove both the trend and seasonality using Excel and R. In your work, present the methods used and the formulas applied to remove the trend and seasonality.

# Laboratory 02: Analysis of Base-Year and Constant-Price Valuations

Retrieve data on Gross Value Added for 2020 (GVA2020) for Poland from [Eurostat](https://ec.europa.eu/eurostat) including quarterly data for gross value added at 2020 prices and annual data at current (nominal) prices.

From the available datasets, extract information for Poland and save it in CSV format for further analysis. Next, determine how the value of GVA changes over time by calculating chain-linked indices for both quarterly and annual data. Based on these indices, derive constant-price valuations of GVA relative to the base years 2024 and 2015.

Estimate the values of GVA for 2024-Q1 and 2015-Q1 using built-in estimation tools in Excel and R, ensuring that the results are consistent with the actual annual data at current prices.

Finally, use the dataset prepared in Laboratory 01 to compare how the shape of the time series has changed after accounting for constant prices. Present the results with clear charts and include a concise summary of the data sources, applied methods, and conclusions.

# Laboratory 03: Fitting Trend to Data

Retrieve data on Gross Value Added for Poland from [Eurostat](https://ec.europa.eu/eurostat) including quarterly data for gross value added prices.

Next, estimate the parameters of three econometric models:

- linear regression,
- power regression,
- exponential regression.

For each model, draw a plot showing the fit of the estimated function to the empirical data. Compute the standard errors of the estimated parameters for all three models. Perform the t-Student test to evaluate the statistical significance of the parameters. Compare your results with those obtained using the built-in Excel module: `Data -> Data Analysis -> Regression`. Based on the obtained measures of fit and the statistical correctness of the estimates, select the model that best describes the analyzed data and justify your choice.
