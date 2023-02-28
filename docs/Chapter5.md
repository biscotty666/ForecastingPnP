Chapter 5 The forecaster’s toolbox
================

- <a href="#51-a-tidy-forecasting-workflow"
  id="toc-51-a-tidy-forecasting-workflow">5.1 A tidy forecasting
  workflow</a>
  - <a href="#data-preparation-tidy" id="toc-data-preparation-tidy">Data
    preparation (tidy)</a>
  - <a href="#visualize-the-data" id="toc-visualize-the-data">Visualize the
    data</a>
  - <a href="#specify-a-model" id="toc-specify-a-model">Specify a model</a>
  - <a href="#train-the-model-estimate"
    id="toc-train-the-model-estimate">Train the model (estimate)</a>
  - <a href="#evaluate-model-performance"
    id="toc-evaluate-model-performance">Evaluate model performance</a>
  - <a href="#produce-forecasts" id="toc-produce-forecasts">Produce
    forecasts</a>
- <a href="#52-some-simple-forecasting-methods"
  id="toc-52-some-simple-forecasting-methods">5.2 Some simple forecasting
  methods</a>
  - <a href="#mean-method" id="toc-mean-method">Mean method</a>
  - <a href="#naive-method" id="toc-naive-method">Naive method</a>
  - <a href="#seasonal-naive-method" id="toc-seasonal-naive-method">Seasonal
    naive method</a>
  - <a href="#drift-method" id="toc-drift-method">Drift method</a>
  - <a href="#example-australian-quarterly-beer-production"
    id="toc-example-australian-quarterly-beer-production">Example:
    Australian quarterly beer production</a>
  - <a href="#example-googles-daily-closing-stock-price"
    id="toc-example-googles-daily-closing-stock-price">Example: Google’s
    daily closing stock price</a>
    - <a href="#re-index-based-on-trading-days"
      id="toc-re-index-based-on-trading-days">Re-index based on trading
      days</a>
    - <a href="#filter-the-year-of-interest"
      id="toc-filter-the-year-of-interest">Filter the year of interest</a>
    - <a href="#fit-the-models" id="toc-fit-the-models">Fit the models</a>
    - <a href="#produce-forecasts-for-the-trading-days-in-january-2016"
      id="toc-produce-forecasts-for-the-trading-days-in-january-2016">Produce
      forecasts for the trading days in January 2016</a>
    - <a href="#plot-the-forecasts" id="toc-plot-the-forecasts">Plot the
      forecasts</a>
- <a href="#53-fitted-values-and-residuals"
  id="toc-53-fitted-values-and-residuals">5.3 Fitted values and
  residuals</a>
- <a href="#54-residual-diagnostics" id="toc-54-residual-diagnostics">5.4
  Residual diagnostics</a>
- <a href="#55-distributional-forecasts-and-predictions"
  id="toc-55-distributional-forecasts-and-predictions">5.5 Distributional
  forecasts and predictions</a>
- <a href="#56-forecasting-using-transformations"
  id="toc-56-forecasting-using-transformations">5.6 Forecasting using
  transformations</a>
- <a href="#57-forecasting-with-decomosition"
  id="toc-57-forecasting-with-decomosition">5.7 Forecasting with
  decomosition</a>
- <a href="#58-evaluating-point-forecast-accuracy"
  id="toc-58-evaluating-point-forecast-accuracy">5.8 Evaluating point
  forecast accuracy</a>
- <a href="#59-evaluating-distributional-forecast-accuracy"
  id="toc-59-evaluating-distributional-forecast-accuracy">5.9 Evaluating
  distributional forecast accuracy</a>
- <a href="#510-time-series-cross-validation"
  id="toc-510-time-series-cross-validation">5.10 Time series
  cross-validation</a>

The feasts package includes functions for computing FEatures And
Statistics from Time Series.

``` r
library(fpp3)
```

    ## ── Attaching packages ────────────────────────────────────────────── fpp3 0.5 ──

    ## ✔ tibble      3.1.8     ✔ tsibble     1.1.3
    ## ✔ dplyr       1.1.0     ✔ tsibbledata 0.4.1
    ## ✔ tidyr       1.3.0     ✔ feasts      0.3.0
    ## ✔ lubridate   1.9.2     ✔ fable       0.3.2
    ## ✔ ggplot2     3.4.1     ✔ fabletools  0.3.2

    ## ── Conflicts ───────────────────────────────────────────────── fpp3_conflicts ──
    ## ✖ lubridate::date()    masks base::date()
    ## ✖ dplyr::filter()      masks stats::filter()
    ## ✖ tsibble::intersect() masks base::intersect()
    ## ✖ tsibble::interval()  masks lubridate::interval()
    ## ✖ dplyr::lag()         masks stats::lag()
    ## ✖ tsibble::setdiff()   masks base::setdiff()
    ## ✖ tsibble::union()     masks base::union()

``` r
library(feasts)
```

# 5.1 A tidy forecasting workflow

To illustrate the process, we will fit linear trend models to national
GDP data stored in `global_economy`.

## Data preparation (tidy)

The first step in forecasting is to prepare data in the correct format.
This process may involve loading in data, identifying missing values,
filtering the time series, and other pre-processing tasks. The
functionality provided by `tsibble` and other packages in the
`tidyverse` substantially simplifies this step.

If we want to model GDP per capita over time we must first compute the
variable

``` r
gdppc <- global_economy |>
  mutate(GDP_per_capita = GDP / Population)
gdppc
```

    ## # A tsibble: 15,150 x 10 [1Y]
    ## # Key:       Country [263]
    ##    Country     Code   Year      GDP Growth   CPI Imports Exports Popul…¹ GDP_p…²
    ##    <fct>       <fct> <dbl>    <dbl>  <dbl> <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ##  1 Afghanistan AFG    1960   5.38e8     NA    NA    7.02    4.13  9.00e6    59.8
    ##  2 Afghanistan AFG    1961   5.49e8     NA    NA    8.10    4.45  9.17e6    59.9
    ##  3 Afghanistan AFG    1962   5.47e8     NA    NA    9.35    4.88  9.35e6    58.5
    ##  4 Afghanistan AFG    1963   7.51e8     NA    NA   16.9     9.17  9.53e6    78.8
    ##  5 Afghanistan AFG    1964   8.00e8     NA    NA   18.1     8.89  9.73e6    82.2
    ##  6 Afghanistan AFG    1965   1.01e9     NA    NA   21.4    11.3   9.94e6   101. 
    ##  7 Afghanistan AFG    1966   1.40e9     NA    NA   18.6     8.57  1.02e7   138. 
    ##  8 Afghanistan AFG    1967   1.67e9     NA    NA   14.2     6.77  1.04e7   161. 
    ##  9 Afghanistan AFG    1968   1.37e9     NA    NA   15.2     8.90  1.06e7   130. 
    ## 10 Afghanistan AFG    1969   1.41e9     NA    NA   15.0    10.1   1.09e7   130. 
    ## # … with 15,140 more rows, and abbreviated variable names ¹​Population,
    ## #   ²​GDP_per_capita

## Visualize the data

Let’s look at the data for one country

``` r
gdppc |>
  filter(Country == "Sweden") |>
  autoplot(GDP_per_capita) +
  labs(y = "$US", title = "GDP per capita for Sweden")
```

![](Chapter5_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

## Specify a model

There are many different time series models that can be used for
forecasting, and much of this book is dedicated to describing various
models. Specifying an appropriate model for the data is essential for
producing appropriate forecasts.

Models in fable are specified using model functions, which each use a
formula (y \~ x) interface. The response variable(s) are specified on
the left of the formula, and the structure of the model is written on
the right.

For example, a linear trend model (to be discussed in Chapter 7) for GDP
per capita can be specified with

``` r
TSLM(GDP_per_capita ~ trend())
```

    ## <TSLM model definition>

In this case the model function is `TSLM()` (time series linear model),
the response variable is `GDP_per_capita` and it is being modelled using
`trend()` (a “special” function specifying a linear trend when it is
used within `TSLM()`). We will be taking a closer look at how each model
can be specified in their respective sections.

The special functions used to define the model’s structure vary between
models (as each model can support different structures). The “Specials”
section of the documentation for each model function lists these special
functions and how they can be used.

The left side of the formula also supports the transformations discussed
in Section 3.1, which can be useful in simplifying the time series
patterns or constraining the forecasts to be between specific values
(see Section 13.3).

## Train the model (estimate)

Once an appropriate model is specified, we next train the model on some
data. One or more model specifications can be estimated using the
model() function.

``` r
fit <- gdppc |>
  model(trend_model = TSLM(GDP_per_capita ~ trend()))
```

    ## Warning: 7 errors (1 unique) encountered for trend_model
    ## [7] 0 (non-NA) cases

``` r
fit
```

    ## # A mable: 263 x 2
    ## # Key:     Country [263]
    ##    Country             trend_model
    ##    <fct>                   <model>
    ##  1 Afghanistan              <TSLM>
    ##  2 Albania                  <TSLM>
    ##  3 Algeria                  <TSLM>
    ##  4 American Samoa           <TSLM>
    ##  5 Andorra                  <TSLM>
    ##  6 Angola                   <TSLM>
    ##  7 Antigua and Barbuda      <TSLM>
    ##  8 Arab World               <TSLM>
    ##  9 Argentina                <TSLM>
    ## 10 Armenia                  <TSLM>
    ## # … with 253 more rows

This fits a linear trend model to the GDP per capita data for each
combination of key variables in the `tsibble`. In this example, it will
fit a model to each of the 263 countries in the dataset. The resulting
object is a model table or a “**mable**”.

## Evaluate model performance

Once a model has been fitted, it is important to check how well it has
performed on the data. There are several diagnostic tools available to
check model behaviour, and also accuracy measures that allow one model
to be compared against another. Sections 5.8 and 5.9 go into further
details.

## Produce forecasts

With an appropriate model specified, estimated and checked, it is time
to produce the forecasts using forecast(). The easiest way to use this
function is by specifying the number of future observations to forecast.
For example, forecasts for the next 10 observations can be generated
using h = 10. We can also use natural language; e.g., h = “2 years” can
be used to predict two years into the future.

In other situations, it may be more convenient to provide a dataset of
future time periods to forecast. This is commonly required when your
model uses additional information from the data, such as exogenous
regressors. Additional data required by the model can be included in the
dataset of observations to forecast.

``` r
fit |> forecast(h = "3 years")
```

    ## # A fable: 789 x 5 [1Y]
    ## # Key:     Country, .model [263]
    ##    Country        .model       Year   GDP_per_capita  .mean
    ##    <fct>          <chr>       <dbl>           <dist>  <dbl>
    ##  1 Afghanistan    trend_model  2018     N(526, 9653)   526.
    ##  2 Afghanistan    trend_model  2019     N(534, 9689)   534.
    ##  3 Afghanistan    trend_model  2020     N(542, 9727)   542.
    ##  4 Albania        trend_model  2018  N(4716, 476419)  4716.
    ##  5 Albania        trend_model  2019  N(4867, 481086)  4867.
    ##  6 Albania        trend_model  2020  N(5018, 486012)  5018.
    ##  7 Algeria        trend_model  2018  N(4410, 643094)  4410.
    ##  8 Algeria        trend_model  2019  N(4489, 645311)  4489.
    ##  9 Algeria        trend_model  2020  N(4568, 647602)  4568.
    ## 10 American Samoa trend_model  2018 N(12491, 652926) 12491.
    ## # … with 779 more rows

This is a forecast table, or “**fable**”. Each row corresponds to one
forecast period for each country. The `GDP_per_capita` column contains
the **forecast distribution**, while the `.mean` column contains the
**point forecast**. The point forecast is the mean (or average) of the
forecast distribution.

The forecasts can be plotted along with the historical data using
autoplot() as follows.

``` r
fit |>
  forecast(h = "3 years") |>
  filter(Country == "Sweden") |>
  autoplot(gdppc) +
  labs(y = "$US", title = "GDP per capita for Sweden")
```

![](Chapter5_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

# 5.2 Some simple forecasting methods

Some forecasting methods are extremely simple and surprisingly
effective. We will use four simple forecasting methods as benchmarks
throughout this book.

To illustrate them, we will use quarterly Australian clay brick
production between 1970 and 2004.

The `filter_index()` function is a convenient shorthand for extracting a
section of a time series.

``` r
bricks <- aus_production |>
  filter_index("1970 Q1" ~ "2004 Q4") |>
  select(Bricks)
bricks
```

    ## # A tsibble: 140 x 2 [1Q]
    ##    Bricks Quarter
    ##     <dbl>   <qtr>
    ##  1    386 1970 Q1
    ##  2    428 1970 Q2
    ##  3    434 1970 Q3
    ##  4    417 1970 Q4
    ##  5    385 1971 Q1
    ##  6    433 1971 Q2
    ##  7    453 1971 Q3
    ##  8    436 1971 Q4
    ##  9    399 1972 Q1
    ## 10    461 1972 Q2
    ## # … with 130 more rows

## Mean method

Here, the forecasts of all future values are equal to the average (or
“mean”) of the historical data. If we let the historical data be denoted
by $y_1,\dots,y_T$, then we can write the forecasts as

$$\hat{y}_{T+h|T}=\bar{y}=(y_1+\dots+y_T)/T.$$ The notation
$\hat{y}_{T+h|T}$ is a short-hand for the estimate of $y_{T+h}$ based on
the data $y_1,\dots,y_T$

``` r
bricks |> model(MEAN(Bricks))
```

    ## # A mable: 1 x 1
    ##   `MEAN(Bricks)`
    ##          <model>
    ## 1         <MEAN>

## Naive method

All forecasts set to the value of the last observation.

$$\hat{y}_{T+h|T} = y_{T}$$

This method works well for many economic/financial forecasts.

``` r
bricks |> model(NAIVE(Bricks))
```

    ## # A mable: 1 x 1
    ##   `NAIVE(Bricks)`
    ##           <model>
    ## 1         <NAIVE>

## Seasonal naive method

A similar method is useful for highly seasonal data. In this case, we
set each forecast to be equal to the last observed value from the same
season (e.g., the same month of the previous year). Formally, the
forecast for time $T+h$ is written as

$$\hat{y}_{T+h|T} = y_{T+h-m(k+1)}$$

where $m=$ the seasonal period, and $k$ is the integer part of $(h−1)/m$
(i.e., the number of complete years in the forecast period prior to time
$T+h$). This looks more complicated than it really is. For example, with
monthly data, the forecast for all future February values is equal to
the last observed February value. With quarterly data, the forecast of
all future Q2 values is equal to the last observed Q2 value (where Q2
means the second quarter). Similar rules apply for other months and
quarters, and for other seasonal periods.

``` r
bricks |> model(SNAIVE(Bricks ~ lag("year")))
```

    ## # A mable: 1 x 1
    ##   `SNAIVE(Bricks ~ lag("year"))`
    ##                          <model>
    ## 1                       <SNAIVE>

The `lag()` function is optional here as bricks is quarterly data and so
a seasonal naïve method will need a one-year lag. However, for some time
series there is more than one seasonal period, and then the required lag
must be specified.

## Drift method

A variation on the naïve method is to allow the forecasts to increase or
decrease over time, where the amount of change over time (called the
**drift**) is set to be the average change seen in the historical data.
Thus the forecast for time $T+h$ is given by

$$\hat{y}_{T+h|T} = y_{T} + \frac{h}{T-1}\sum_{t=2}^T (y_{t}-y_{t-1}) = y_{T} + h \left( \frac{y_{T} -y_{1}}{T-1}\right)$$

This is equivalent to drawing a line between the first and last
observations, and extrapolating it into the future.

``` r
bricks |> model(RW(Bricks ~ drift()))
```

    ## # A mable: 1 x 1
    ##   `RW(Bricks ~ drift())`
    ##                  <model>
    ## 1          <RW w/ drift>

## Example: Australian quarterly beer production

The first three methods applied to Australian quarterly beer production
from 1992 to 2006, with the forecasts compared against actual values in
the next 3.5 years.

``` r
# Set training data from 1992 to 2006
train <- aus_production |>
  filter_index("1992 Q1" ~ "2006 Q4")
# Fit the models
beer_fit <- train |>
  model(
    Mean = MEAN(Beer),
    `Naïve` = NAIVE(Beer),
    `Seasonal naïve` = SNAIVE(Beer)
  )
# Generate forecasts for 14 quarters
beer_fc <- beer_fit |> forecast(h = 14)
# Plot forecasts against actual values
beer_fc |>
  autoplot(train, level = NULL) +
  autolayer(
    filter_index(aus_production, "2007 Q1" ~ .),
    colour = "black"
  ) +
  labs(
    y = "Megalitres",
    title = "Forecasts for quarterly beer production"
  ) +
  guides(colour = guide_legend(title = "Forecast"))
```

    ## Plot variable not specified, automatically selected `.vars = Beer`

![](Chapter5_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

In this case, only the seasonal naïve forecasts are close to the
observed values from 2007 onwards

## Example: Google’s daily closing stock price

The non-seasonal methods are applied to Google’s daily closing stock
price in 2015, and used to forecast one month ahead. Because stock
prices are not observed every day, we first set up a **new time index
based on the trading days rather than calendar days**.

### Re-index based on trading days

``` r
google_stock <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) >= 2015) |>
  mutate(day = row_number()) |>
  update_tsibble(index = day, regular = TRUE)
google_stock
```

    ## # A tsibble: 1,006 x 9 [1]
    ## # Key:       Symbol [1]
    ##    Symbol Date        Open  High   Low Close Adj_Close  Volume   day
    ##    <chr>  <date>     <dbl> <dbl> <dbl> <dbl>     <dbl>   <dbl> <int>
    ##  1 GOOG   2015-01-02  526.  528.  521.  522.      522. 1447600     1
    ##  2 GOOG   2015-01-05  520.  521.  510.  511.      511. 2059800     2
    ##  3 GOOG   2015-01-06  512.  513.  498.  499.      499. 2899900     3
    ##  4 GOOG   2015-01-07  504.  504.  497.  498.      498. 2065100     4
    ##  5 GOOG   2015-01-08  495.  501.  488.  500.      500. 3353600     5
    ##  6 GOOG   2015-01-09  502.  502.  492.  493.      493. 2069400     6
    ##  7 GOOG   2015-01-12  492.  493.  485.  490.      490. 2322400     7
    ##  8 GOOG   2015-01-13  496.  500.  490.  493.      493. 2370500     8
    ##  9 GOOG   2015-01-14  492.  500.  490.  498.      498. 2235700     9
    ## 10 GOOG   2015-01-15  503.  503.  495.  499.      499. 2715800    10
    ## # … with 996 more rows

### Filter the year of interest

``` r
google_2015 <- google_stock |> filter(year(Date) == 2015)
google_2015
```

    ## # A tsibble: 252 x 9 [1]
    ## # Key:       Symbol [1]
    ##    Symbol Date        Open  High   Low Close Adj_Close  Volume   day
    ##    <chr>  <date>     <dbl> <dbl> <dbl> <dbl>     <dbl>   <dbl> <int>
    ##  1 GOOG   2015-01-02  526.  528.  521.  522.      522. 1447600     1
    ##  2 GOOG   2015-01-05  520.  521.  510.  511.      511. 2059800     2
    ##  3 GOOG   2015-01-06  512.  513.  498.  499.      499. 2899900     3
    ##  4 GOOG   2015-01-07  504.  504.  497.  498.      498. 2065100     4
    ##  5 GOOG   2015-01-08  495.  501.  488.  500.      500. 3353600     5
    ##  6 GOOG   2015-01-09  502.  502.  492.  493.      493. 2069400     6
    ##  7 GOOG   2015-01-12  492.  493.  485.  490.      490. 2322400     7
    ##  8 GOOG   2015-01-13  496.  500.  490.  493.      493. 2370500     8
    ##  9 GOOG   2015-01-14  492.  500.  490.  498.      498. 2235700     9
    ## 10 GOOG   2015-01-15  503.  503.  495.  499.      499. 2715800    10
    ## # … with 242 more rows

### Fit the models

``` r
google_fit <- google_2015 |>
  model(
    Mean = MEAN(Close),
    `Naïve` = NAIVE(Close),
    Drift = NAIVE(Close ~ drift())
  )
google_fit
```

    ## # A mable: 1 x 4
    ## # Key:     Symbol [1]
    ##   Symbol    Mean   Naïve         Drift
    ##   <chr>  <model> <model>       <model>
    ## 1 GOOG    <MEAN> <NAIVE> <RW w/ drift>

### Produce forecasts for the trading days in January 2016

``` r
google_jan_2016 <- google_stock |>
  filter(yearmonth(Date) == yearmonth("2016 Jan"))
google_fc <- google_fit |>
  forecast(new_data = google_jan_2016)
```

### Plot the forecasts

``` r
google_fc |>
  autoplot(google_2015, level = NULL) +
  autolayer(google_jan_2016, Close, colour = "black") +
  labs(y = "$US",
       title = "Google daily closing stock prices",
       subtitle = "(Jan 2015 - Jan 2016") +
  guides(colour = guide_legend(title = "Forecast"))
```

![](Chapter5_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

Sometimes one of these simple methods will be the best forecasting
method available; but in many cases, these methods will serve as
**benchmarks** rather than the method of choice. That is, any
forecasting methods we develop will be compared to these simple methods
to ensure that the new method is better than these simple alternatives.
If not, the new method is not worth considering.

# 5.3 Fitted values and residuals

# 5.4 Residual diagnostics

# 5.5 Distributional forecasts and predictions

# 5.6 Forecasting using transformations

# 5.7 Forecasting with decomosition

# 5.8 Evaluating point forecast accuracy

# 5.9 Evaluating distributional forecast accuracy

# 5.10 Time series cross-validation
