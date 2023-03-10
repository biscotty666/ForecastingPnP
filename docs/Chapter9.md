Chapter 9 ARIMA Models
================

- <a href="#91-starionarity-and-differencing"
  id="toc-91-starionarity-and-differencing">9.1 Starionarity and
  differencing</a>
  - <a href="#differencing" id="toc-differencing">Differencing</a>
  - <a href="#random-walk-model" id="toc-random-walk-model">Random walk
    model</a>
  - <a href="#second-order-differencing"
    id="toc-second-order-differencing">Second-order differencing</a>
  - <a href="#seasonal-differencing" id="toc-seasonal-differencing">Seasonal
    differencing</a>
  - <a href="#unit-root-tests" id="toc-unit-root-tests">Unit root tests</a>
- <a href="#92-backshift-notation" id="toc-92-backshift-notation">9.2
  Backshift notation</a>
- <a href="#93-autoregressive-models"
  id="toc-93-autoregressive-models">9.3 Autoregressive models</a>

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

<span style="background-color: #EEDEEE;">ARIMA models provide another
approach to time series forecasting. Exponential smoothing and ARIMA
models are the two most widely used approaches to time series
forecasting, and provide complementary approaches to the problem. While
exponential smoothing models are based on a description of the trend and
seasonality in the data, ARIMA models aim to describe the
**autocorrelations** in the data.</span>

Before we introduce ARIMA models, we must first discuss the concept of
**stationarity** and the technique of **differencing** time series.

# 9.1 Starionarity and differencing

<span style="background-color: #EEDEEE;">A **stationary time series** is
one whose statistical properties do not depend on the time at which the
series is observed.</span>16 Thus, time series with trends, or with
seasonality, are not stationary — the trend and seasonality will affect
the value of the time series at different times. On the other hand, a
white noise series is stationary — it does not matter when you observe
it, it should look much the same at any point in time.

Some cases can be confusing — a time series with cyclic behaviour (but
with no trend or seasonality) is stationary. This is because the cycles
are not of a fixed length, so before we observe the series we cannot be
sure where the peaks and troughs of the cycles will be.

In general, a stationary time series will have no predictable patterns
in the long-term. Time plots will show the series to be roughly
horizontal (although some cyclic behaviour is possible), with constant
variance.

<img src="https://otexts.com/fpp3/fpp_files/figure-html/stationary-1.png" />

Consider the nine series plotted in Figure 9.1. Which of these do you
think are stationary?

Obvious seasonality rules out series (d), (h) and (i). Trends and
changing levels rules out series (a), (c), (e), (f) and (i). Increasing
variance also rules out (i). That leaves only (b) and (g) as stationary
series.

At first glance, the strong cycles in series (g) might appear to make it
non-stationary. But these cycles are aperiodic — they are caused when
the lynx population becomes too large for the available feed, so that
they stop breeding and the population falls to low numbers, then the
regeneration of their food sources allows the population to grow again,
and so on. In the long-term, the timing of these cycles is not
predictable. Hence the series is stationary.

## Differencing

In Figure 9.1, note that the Google stock price was non-stationary in
panel (a), but the daily changes were stationary in panel (b). This
shows one way to make a non-stationary time series stationary — <span
style="background-color: #EEDEEE;">compute the differences between
consecutive observations. This is known as **differencing**.</span>

Transformations such as logarithms can help to stabilise the variance of
a time series. Differencing can help stabilise the mean of a time series
by removing changes in the level of a time series, and therefore
eliminating (or reducing) trend and seasonality.

As well as the time plot of the data, the ACF plot is also useful for
identifying non-stationary time series. <span
style="background-color: #EEDEEE;">For a stationary time series, the ACF
will drop to zero relatively quickly, while the ACF of non-stationary
data decreases slowly. Also, for non-stationary data, the value of $r_1$
is often large and positive.</span>

``` r
google_2015 <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) == 2015)
google_2015
```

    ## # A tsibble: 252 x 8 [!]
    ## # Key:       Symbol [1]
    ##    Symbol Date        Open  High   Low Close Adj_Close  Volume
    ##    <chr>  <date>     <dbl> <dbl> <dbl> <dbl>     <dbl>   <dbl>
    ##  1 GOOG   2015-01-02  526.  528.  521.  522.      522. 1447600
    ##  2 GOOG   2015-01-05  520.  521.  510.  511.      511. 2059800
    ##  3 GOOG   2015-01-06  512.  513.  498.  499.      499. 2899900
    ##  4 GOOG   2015-01-07  504.  504.  497.  498.      498. 2065100
    ##  5 GOOG   2015-01-08  495.  501.  488.  500.      500. 3353600
    ##  6 GOOG   2015-01-09  502.  502.  492.  493.      493. 2069400
    ##  7 GOOG   2015-01-12  492.  493.  485.  490.      490. 2322400
    ##  8 GOOG   2015-01-13  496.  500.  490.  493.      493. 2370500
    ##  9 GOOG   2015-01-14  492.  500.  490.  498.      498. 2235700
    ## 10 GOOG   2015-01-15  503.  503.  495.  499.      499. 2715800
    ## # … with 242 more rows

``` r
google_2015 |> ACF(Close) |>
  autoplot() + labs(subtitle = "Google closing stock price")
```

    ## Warning: Provided data has an irregular interval, results should be treated
    ## with caution. Computing ACF by observation.

![](Chapter9_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
google_2015 |> ACF(difference(Close)) |>
  autoplot() + labs(subtitle = "Changes in Google closing stock price")
```

    ## Warning: Provided data has an irregular interval, results should be treated
    ## with caution. Computing ACF by observation.

![](Chapter9_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
google_2015 |>
  mutate(diff_close = difference(Close)) |>
  features(diff_close, ljung_box, lag = 10)
```

    ## # A tibble: 1 × 3
    ##   Symbol lb_stat lb_pvalue
    ##   <chr>    <dbl>     <dbl>
    ## 1 GOOG      7.91     0.637

The ACF of the differenced Google stock price looks just like that of a
white noise series. Only one autocorrelation is outside of the 95%
limits, and the Ljung-Box $Q^*$ statistic has a p-value of 0.637 (for
$h=10$). This suggests that the daily change in the Google stock price
is essentially a random amount which is uncorrelated with that of
previous days.

## Random walk model

The differenced series is the change between consecutive observations in
the original series, and can be written as

$$y'_t = y_t - y_{t-1}.$$

The differenced series will have only $T−1$ values, since it is not
possible to calculate a difference $y′1$ for the first observation.

When the differenced series is white noise, the model for the original
series can be written as

$$y_t - y_{t-1} = \varepsilon_t,$$

where $\epsilon_t$ denotes white noise. Rearranging this leads to **the
“random walk” model**

$$y_t = y_{t-1} + \varepsilon_t.$$

<span style="background-color: #EEDEEE;">Random walk models are widely
used for non-stationary data, particularly financial and economic
data.</span> Random walks typically have:

- long periods of apparent trends up or down
- sudden and unpredictable changes in direction.

The forecasts from a random walk model are equal to the last
observation, as future movements are unpredictable, and are equally
likely to be up or down. Thus, <span
style="background-color: #EEDEEE;">the random walk model underpins
**naïve forecasts**, first introduced in Section 5.2.</span>

A closely related model allows the differences to have a non-zero mean.
Then

$$y_t - y_{t-1} = c + \varepsilon_t\quad\text{or}\quad {y_t = c + y_{t-1} + \varepsilon_t}\: .$$

The value of $c$ is the average of the changes between consecutive
observations. If $c$ is positive, then the average change is an increase
in the value of $y_t$. Thus, $y_t$ will tend to drift upwards. However,
if $c$ is negative, $y_t$ will tend to drift downwards.

<span style="background-color: #EEDEEE;">This is the model behind the
**drift method**, also discussed in Section 5.2.</span>

## Second-order differencing

Occasionally the differenced data will not appear to be stationary and
it may be necessary to difference the data a second time to obtain a
stationary series:

$$
\begin{align*}
  y''_{t}  &=  y'_{t}  - y'_{t - 1} \\
           &= (y_t - y_{t-1}) - (y_{t-1}-y_{t-2})\\
           &= y_t - 2y_{t-1} +y_{t-2}.
\end{align*}
$$

In this case, $y′′_t$ will have $T−2$ values. Then, we would model the
“change in the changes” of the original data. In practice, it is almost
never necessary to go beyond second-order differences.

## Seasonal differencing

A seasonal difference is the difference between an observation and the
previous observation from the same season. So

$$
y'_t = y_t - y_{t-m},
$$

where $m=$ the number of seasons. These are also called “lag-$m$
differences”, as we subtract the observation after a lag of $m$ periods.

If seasonally differenced data appear to be white noise, then an
appropriate model for the original data is

$$
y_t = y_{t-m}+\varepsilon_t.
$$

Forecasts from this model are equal to the last observation from the
relevant season. <span style="background-color: #EEDEEE;">That is, this
model gives **seasonal naïve forecasts**, introduced in Section
5.2.</span>

The bottom panel in Figure 9.3 shows the seasonal differences of the
logarithm of the monthly scripts for A10 (antidiabetic) drugs sold in
Australia. The transformation and differencing have made the series look
relatively stationary.

<img src="https://otexts.com/fpp3/fpp_files/figure-html/a10diff-1.png" />

To distinguish seasonal differences from ordinary differences, we
sometimes refer to ordinary differences as “first differences”, meaning
differences at lag 1.

Sometimes it is necessary to take both a seasonal difference and a first
difference to obtain stationary data. Figure 9.4 plots Australian
corticosteroid drug sales (\$AUD) (top panel). Here, the data are first
transformed using logarithms (second panel), then seasonal differences
are calculated (third panel). The data still seem somewhat
non-stationary, and so a further lot of first differences are computed
(bottom panel).

``` r
PBS |>
  filter(ATC2 == "H02") |>
  summarise(Cost = sum(Cost)/1e6) |>
  transmute(
    `Sales ($million)` = Cost,
    `Log sales` = log(Cost),
    `Annual change in log sales` = difference(log(Cost),12),
    `Doubly differenced log sales` =
      difference(difference(log(Cost), 12), 1)
  ) |>
  pivot_longer(-Month, names_to = "Type", values_to = "Sales") |>
  mutate(
    Type = factor(Type, levels = c(
      "Sales ($million)",
      "Log sales",
      "Annual change in log sales",
      "Doubly differenced log sales"
    ))
  ) |>
  ggplot(aes(x = Month, y = Sales)) +
  geom_line() +
  facet_grid(vars(Type), scales = "free_y") +
  labs(title = "Corticosteroid drug sales", y = NULL)
```

![](Chapter9_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

There is a degree of subjectivity in selecting which differences to
apply. The seasonally differenced data in Figure 9.3 do not show
substantially different behaviour from the seasonally differenced data
in Figure 9.4. In the latter case, we could have decided to stop with
the seasonally differenced data, and not done an extra round of
differencing. In the former case, we could have decided that the data
were not sufficiently stationary and taken an extra round of
differencing. Some formal tests for differencing are discussed below,
but there are always some choices to be made in the modelling process,
and different analysts may make different choices.

If $y′_t=y_t-y_{t−m}$ denotes a seasonally differenced series, then the
twice-differenced series is

$$
\begin{align*}
y''_t &= y'_t - y'_{t-1} \\
      &= (y_t - y_{t-m}) - (y_{t-1} - y_{t-m-1}) \\
      &= y_t -y_{t-1} - y_{t-m} + y_{t-m-1}\:
\end{align*}
$$

When both seasonal and first differences are applied, it makes no
difference which is done first—the result will be the same. However,
<span style="background-color: #EEDEEE;">if the data have a strong
seasonal pattern, we recommend that seasonal differencing be done first,
because the resulting series will sometimes be stationary and there will
be no need for a further first difference.</span> If first differencing
is done first, there will still be seasonality present.

Beware that applying more differences than required will induce false
dynamics or autocorrelations that do not really exist in the time
series. Therefore, <span style="background-color: #EEDEEE;">do as few
differences as necessary to obtain a stationary series.</span>

It is important that if differencing is used, the differences are
interpretable. First differences are the change between one observation
and the next. Seasonal differences are the change between one year to
the next. Other lags are unlikely to make much interpretable sense and
should be avoided.

## Unit root tests

One way to determine more objectively whether differencing is required
is to use a unit root test. These are statistical hypothesis tests of
stationarity that are designed for determining whether differencing is
required.

A number of unit root tests are available, which are based on different
assumptions and may lead to conflicting answers. In our analysis, we use
the Kwiatkowski-Phillips-Schmidt-Shin (KPSS) test (Kwiatkowski et al.,
1992). In this test, the null hypothesis is that the data are
stationary, and we look for evidence that the null hypothesis is false.
Consequently, <span style="background-color: #EEDEEE;">small p-values
(e.g., less than 0.05) suggest that differencing is required.</span> The
test can be computed using the `unitroot_kpss()` function.

For example, let us apply it to the Google stock price data.

``` r
google_2015 |>
  features(Close, unitroot_kpss)
```

    ## # A tibble: 1 × 3
    ##   Symbol kpss_stat kpss_pvalue
    ##   <chr>      <dbl>       <dbl>
    ## 1 GOOG        3.56        0.01

The p-value is reported as 0.01 if it is less than 0.01, and as 0.1 if
it is greater than 0.1. In this case, the test statistic (3.56) is
bigger than the 1% critical value, so the p-value is less than 0.01,
indicating that the null hypothesis is rejected. That is,
<span style="background-color: #EEDEEE;">the data are not
stationary</data>. We can difference the data, and apply the test again.

``` r
google_2015 |>
  mutate(diff_close = difference(Close)) |>
  features(diff_close, unitroot_kpss)
```

    ## # A tibble: 1 × 3
    ##   Symbol kpss_stat kpss_pvalue
    ##   <chr>      <dbl>       <dbl>
    ## 1 GOOG      0.0989         0.1

his time, the test statistic is tiny, and well within the range we would
expect for stationary data, so the p-value is greater than 0.1. <span
style="background-color: #EEDEEE;">We can conclude that the differenced
data appear stationary.</span>

This process of using a sequence of KPSS tests to determine the
appropriate number of first differences is carried out using the
`unitroot_ndiffs()` feature.

``` r
google_2015 |>
  features(Close, unitroot_ndiffs)
```

    ## # A tibble: 1 × 2
    ##   Symbol ndiffs
    ##   <chr>   <int>
    ## 1 GOOG        1

As we saw from the KPSS tests above, one difference is required to make
the google_2015 data stationary.

A similar feature for determining whether seasonal differencing is
required is `unitroot_nsdiffs()`, which uses the measure of seasonal
strength introduced in Section 4.3 to determine the appropriate number
of seasonal differences required. No seasonal differences are suggested
if $F_S<0.64$, otherwise one seasonal difference is suggested.

We can apply unitroot_nsdiffs() to the monthly total Australian retail
turnover.

``` r
aus_total_retail <- aus_retail |>
  summarise(Turnover = sum(Turnover))
aus_total_retail |>
  mutate(log_turnover = log(Turnover)) |>
  features(log_turnover, unitroot_nsdiffs)
```

    ## # A tibble: 1 × 1
    ##   nsdiffs
    ##     <int>
    ## 1       1

``` r
aus_total_retail |>
  mutate(log_turnover = difference(log(Turnover), 12)) |>
  features(log_turnover, unitroot_ndiffs)
```

    ## # A tibble: 1 × 1
    ##   ndiffs
    ##    <int>
    ## 1      1

Because unitroot_nsdiffs() returns 1 (indicating one seasonal difference
is required), we apply the unitroot_ndiffs() function to the seasonally
differenced data. These functions suggest we should do both a seasonal
difference and a first difference.

# 9.2 Backshift notation

The backward shift operator $B$ is a useful notational device when
working with time series lags:

$$B y_{t} = y_{t - 1} \: .$$

(Some references use $L$ for “lag” instead of $B$ for “backshift”.) In
other words, $B$, operating on $y_t$, has the effect of shifting the
data back one period. Two applications of $B$ to $y_t$ shifts the data
back two periods:

$$B(By_{t}) = B^{2}y_{t} = y_{t-2}\: .$$

For monthly data, if we wish to consider “the same month last year,” the
notation is $B^{12}y_t=y_{t−12}$.

<span style="background-color: #EEDEEE;">The backward shift operator is
convenient for describing the process of **differencing**.</span> A
first difference can be written as

$$
y'_{t} = y_{t} - y_{t-1} = y_t - By_{t} = (1 - B)y_{t}\: .
$$

So a first difference can be represented by $(1−B)$. Similarly, if
second-order differences have to be computed, then:

$$
y''_{t} = y_{t} - 2y_{t - 1} + y_{t - 2} = (1-2B+B^2)y_t = (1 - B)^{2} y_{t}\: .
$$

In general, a $d$th-order difference can be written as

$$(1 - B)^{d} y_{t}.$$

Backshift notation is particularly useful when combining differences, as
the operator can be treated using ordinary algebraic rules. In
particular, terms involving $B$ can be multiplied together.

For example, a seasonal difference followed by a first difference can be
written as

$$
\begin{align*}
(1-B)(1-B^m)y_t &= (1 - B - B^m + B^{m+1})y_t \\
&= y_t-y_{t-1}-y_{t-m}+y_{t-m-1},
\end{align*}
$$

the same result we obtained earlier.

# 9.3 Autoregressive models

In a multiple regression model, introduced in Chapter 7, we forecast the
variable of interest using a linear combination of predictors. <span
style="background-color: #EEDEEE;">In an autoregression model, we
forecast the variable of interest using **a linear combination of past
values of the variable**.</span> The term autoregression indicates that
it is a regression of the variable against itself.

Thus, an autoregressive model of order $p$ can be written as

$$
y_{t} = c + \phi_{1}y_{t-1} + \phi_{2}y_{t-2} + \dots + \phi_{p}y_{t-p} + \varepsilon_{t},
$$

where $\epsilon_t$ is white noise. <span
style="background-color: #EEDEEE;">This is like a multiple regression
but with lagged values of $y_t$ as predictors. We refer to this as an
**AR($p$) model**, an autoregressive model of order $p$.</span>

Autoregressive models are remarkably flexible at handling a wide range
of different time series patterns. The two series in Figure 9.5 show
series from an AR(1) model and an AR(2) model. Changing the parameters
$\phi_1,\dots,\phi_p$ results in different time series patterns. The
variance of the error term $\epsilon_t$ will only change the scale of
the series, not the patterns.

<img src="https://otexts.com/fpp3/fpp_files/figure-html/arp-1.png" />

<div style="background-color: #EFEFEF; text-align: center;">

Figure 9.5: Two examples of data from autoregressive models with
different parameters. Left: AR(1) with $y_t=18−0.8y_{t−1}+\epsilon_t$.
Right: AR(2) with $y_t=8+1.3y_{t−1}−0.7y_{t−2}+\epsilon_t.$ In both
cases, $\epsilon_t$ is normally distributed white noise with mean zero
and variance one.

</div>

or an AR(1) model:

- when $\phi_1=0$ and $c=0$, $y_t$ is equivalent to white noise;
- when $\phi_1=1$ and $c=0$, $y_t$ is equivalent to a random walk;
- when $\phi_1=1$ and $c≠0$, $y_t$ is equivalent to a random walk with
  drift;
- when $\phi_1<0$, $y_t$ tends to oscillate around the mean.

We normally restrict autoregressive models to stationary data, in which
case some constraints on the values of the parameters are required.

- For an AR(1) model: $-1<\phi_1<1$.
- For an AR(2) model: $−1<\phi_2<1$, $\phi_1+\phi_2<1, \phi_2−\phi_1<1$
  . When $p\le3$, the restrictions are much more complicated. The fable
  package takes care of these restrictions when estimating a model.
