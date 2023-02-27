Chapter 3 Time series decomposition
================

- <a href="#31-transformations-and-adjustments"
  id="toc-31-transformations-and-adjustments">3.1 Transformations and
  Adjustments</a>
  - <a href="#calendar-adjustments" id="toc-calendar-adjustments">Calendar
    adjustments</a>
  - <a href="#population-adjustments"
    id="toc-population-adjustments">Population adjustments</a>
  - <a href="#inflation-adjustments"
    id="toc-inflation-adjustments">Inflation adjustments</a>
  - <a href="#mathematical-transformations"
    id="toc-mathematical-transformations">Mathematical transformations</a>
- <a href="#32-time-series-components"
  id="toc-32-time-series-components">3.2 Time series components</a>
  - <a href="#example-employment-in-the-us-retail-sector"
    id="toc-example-employment-in-the-us-retail-sector">Example: Employment
    in the US retail sector</a>
  - <a href="#seasonally-adjusted-data"
    id="toc-seasonally-adjusted-data">Seasonally adjusted data</a>

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

We generally consider three types of patterns in time series:

- trend
- seasonality
- cycles

trend and cycle are usually combined into a single trend-cycle component
often just called trend.

A time series can then be decomposed into:

- trend component
- seasonality component of which there may be multiple
- remainder component

# 3.1 Transformations and Adjustments

When decomposing a time series, it is sometimes helpful to first
transform or adjust the series in order to make the decomposition (and
later analysis) as simple as possible. So we will begin by discussing
transformations and adjustments.

## Calendar adjustments

Use average/month rather than raw totals

## Population adjustments

Convert to per capita data where appropriate.

``` r
global_economy |>
  filter(Country == "Australia") |>
  autoplot(GDP/Population) +
  labs(title = "GDP per capita", y = "$US")
```

![](Chapter3_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## Inflation adjustments

The Consumer Price Index (CPI) can be used to adjust current values for
inflation based on a prior time. The price index $z_t$ and the original
hose price in year $t$ as $y_t$ can be used to calculated the adjusted
value by $x_t=t_t/z_t*z_{2000}$ which would give the adjusted price
based on year 2000 dollar values.

As an example, we can look at the annual newspaper and book sales in
`aus_retail` and adjust the data for inflation using CPI from
`global_economy`

``` r
print_retail <- aus_retail |>
  filter(Industry == "Newspaper and book retailing") |>
  group_by(Industry) |>
  index_by(Year = year(Month)) |>
  summarise(Turnover = sum(Turnover))
aus_economy <- global_economy |>
  filter(Code == "AUS")
```

``` r
print_retail |>
  left_join(aus_economy, by = "Year") |>
  mutate(Adjusted_turnover = Turnover / CPI * 100) |>
  pivot_longer(c(Turnover, Adjusted_turnover),
               values_to = "Turnover") |>
  mutate(name = factor(name,
         levels=c("Turnover","Adjusted_turnover"))) |>
  ggplot(aes(x = Year, y = Turnover)) +
  geom_line() +
  facet_grid(name ~ ., scales = "free_y") +
  labs(title = "Turnover: Australian print media industry",
       y = "$AU")
```

    ## Warning: Removed 1 row containing missing values (`geom_line()`).

![](Chapter3_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

By adjusting for inflation we see that the industry is in steeper
decline than the raw data suggests.

## Mathematical transformations

**Logarithmic transformations** $w_t=\log({y_t})$, are useful when
variation increases and decreases with the level of the series.

**Power transformations** $w_t=y_t^p$ are also used but are more
difficult to interpret.

**Box-Cox transformations**

$$
\begin{equation}
  w_t  =
    \begin{cases}
      \log(y_t) & \text{if $\lambda=0$};  \\
      (\text{sign}(y_t)|y_t|^\lambda-1)/\lambda & \text{otherwise}.
    \end{cases}
\end{equation}
$$

In the modified Box-Cox used here negative values of $y_t$ are allowed
as long as $\lambda>0$

The logarithm used is $ln$.

$\lambda$ should be chosen to make the seasonal variation relatively
constant accross the series.

`gerrero` can be used to determine $\lambda$.

``` r
lambda <- aus_production |>
  features(Gas, features = guerrero) |>
  pull(lambda_guerrero)
lambda
```

    ## [1] 0.1095171

``` r
# install.packages("latex2exp")
aus_production |>
  autoplot(box_cox(Gas, lambda)) +
  labs(y = "",
       title = latex2exp::TeX(paste0(
         "Transformed gas production with $\\lambda$ = ",
         round(lambda,2)
       )))
```

![](Chapter3_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

# 3.2 Time series components

- Additive decomposition

Most appropriate if the magnitude of the seasonal fluctuations, or the
variation around the trend-cycle, does not vary with the level of the
time series.

$$
y_{t} = S_{t} + T_{t} + R_t
$$

where $y_t$ is the data, $S_t$ is the seasonal component, $T_t$ is the
trend-cycle component and $R_t$ is the remainder component all at period
$t$.

- Multiplicative decomposition

Appropriate whenthe variation in the seasonal pattern, or the variation
around the trend-cycle, appears to be proportional to the level of the
time series. This is common with economic time series.

$$
y_{t} = S_{t} \times T_{t} \times R_t
$$

Alternatively `log()` can first be used to stabilize the variation over
time and then the additive decomposition can be used to calculate the
multiplicative decomposition since

$$
y_{t} = S_{t} \times T_{t} \times R_t \quad\text{is equivalent to}\quad
  \log y_{t} = \log S_{t} + \log T_{t} + \log R_t
$$

## Example: Employment in the US retail sector

``` r
us_retail_employment <- us_employment |>
  filter(year(Month) >= 1990, Title == "Retail Trade") |>
  select(-Series_ID)
us_retail_employment
```

    ## # A tsibble: 357 x 3 [1M]
    ##       Month Title        Employed
    ##       <mth> <chr>           <dbl>
    ##  1 1990 Jan Retail Trade   13256.
    ##  2 1990 Feb Retail Trade   12966.
    ##  3 1990 Mar Retail Trade   12938.
    ##  4 1990 Apr Retail Trade   13012.
    ##  5 1990 May Retail Trade   13108.
    ##  6 1990 Jun Retail Trade   13183.
    ##  7 1990 Jul Retail Trade   13170.
    ##  8 1990 Aug Retail Trade   13160.
    ##  9 1990 Sep Retail Trade   13113.
    ## 10 1990 Oct Retail Trade   13185.
    ## # … with 347 more rows

``` r
autoplot(us_retail_employment, Employed) +
  labs(y = "Persons (thousands)",
       title = "Total employment in US retail")
```

![](Chapter3_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

We can decompose this with the **STL** method discussed later.

``` r
dcmp <- us_retail_employment |>
  model(stl = STL(Employed))
components(dcmp)
```

    ## # A dable: 357 x 7 [1M]
    ## # Key:     .model [1]
    ## # :        Employed = trend + season_year + remainder
    ##    .model    Month Employed  trend season_year remainder season_adjust
    ##    <chr>     <mth>    <dbl>  <dbl>       <dbl>     <dbl>         <dbl>
    ##  1 stl    1990 Jan   13256. 13288.      -33.0      0.836        13289.
    ##  2 stl    1990 Feb   12966. 13269.     -258.     -44.6          13224.
    ##  3 stl    1990 Mar   12938. 13250.     -290.     -22.1          13228.
    ##  4 stl    1990 Apr   13012. 13231.     -220.       1.05         13232.
    ##  5 stl    1990 May   13108. 13211.     -114.      11.3          13223.
    ##  6 stl    1990 Jun   13183. 13192.      -24.3     15.5          13207.
    ##  7 stl    1990 Jul   13170. 13172.      -23.2     21.6          13193.
    ##  8 stl    1990 Aug   13160. 13151.       -9.52    17.8          13169.
    ##  9 stl    1990 Sep   13113. 13131.      -39.5     22.0          13153.
    ## 10 stl    1990 Oct   13185. 13110.       61.6     13.2          13124.
    ## # … with 347 more rows

This output forms a “dabble” or decomposition table.

``` r
components(dcmp) |>
  as_tsibble() |>
  autoplot(Employed, colour = "gray") +
  geom_line(aes(y = trend), colour = "#D55E00") +
  labs(
    y = "Persons (thousands)",
    title = "Total employment in US retail"
  )
```

![](Chapter3_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

``` r
components(dcmp) |> autoplot()
```

![](Chapter3_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

The gray bars on the left indicate the relative scale of each graph.

## Seasonally adjusted data

Seasonally adjusted data is what’s left after removing the seasonal
component from the data, either by subraction or division.

``` r
components(dcmp) |>
  as_tsibble() |>
  autoplot(Employed, colour = "gray") +
  geom_line(aes(y=season_adjust), colour = "#0072B2") +
  labs(y = "Persons (thousands)",
       title = "Total employment in US retail")
```

![](Chapter3_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

Seasonally adjusted data is useful for unemployment data, for example,
because it’s the non-seasonal aspects which are usually more
interesting.

Remember that seasonally adjusted components still contain the trend and
remainder.
