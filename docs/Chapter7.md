Chapter 7 Time series regression
================

- <a href="#71-the-linear-model" id="toc-71-the-linear-model">7.1 The
  linear model</a>
  - <a href="#simple-linear-regression"
    id="toc-simple-linear-regression">Simple linear regression</a>
  - <a href="#example-us-consumption-of-expenditure"
    id="toc-example-us-consumption-of-expenditure">Example: US consumption
    of expenditure</a>
  - <a href="#multiple-linear-regression"
    id="toc-multiple-linear-regression">Multiple linear regression</a>
  - <a href="#example-us-consumption-expenditure"
    id="toc-example-us-consumption-expenditure">Example: US consumption
    expenditure</a>
  - <a href="#assumptions" id="toc-assumptions">Assumptions</a>
- <a href="#72-least-squares-estimation"
  id="toc-72-least-squares-estimation">7.2 Least squares estimation</a>
  - <a href="#example-us-consumption-expenditures"
    id="toc-example-us-consumption-expenditures">Example: US consumption
    expenditures</a>
  - <a href="#fitted-values" id="toc-fitted-values">Fitted values</a>
  - <a href="#goodness-of-fit" id="toc-goodness-of-fit">Goodness-of-fit</a>
  - <a href="#example-us-consumption-expenditure-1"
    id="toc-example-us-consumption-expenditure-1">Example: US consumption
    expenditure</a>
  - <a href="#standard-error-of-the-regression"
    id="toc-standard-error-of-the-regression">Standard error of the
    regression</a>

In this chapter we discuss regression models. The basic concept is that
we forecast the time series of interest $y$ assuming that it has a
linear relationship with other time series $x$.

**Forecast variable $y$**: aka regressand, dependent or explained
variable.

**Predictor variables $x$** aka regressors, independent or explanatory
variables.

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

# 7.1 The linear model

## Simple linear regression

$$y_t = \beta_0 + \beta_1 x_t + \varepsilon_t$$

$\beta_0$: $y$-intercept, represents the predicted value of $y$ when
$x=0$

$\beta_1$: slope, represents the average predicted change in $y$
resulting from a one unit increase in $x$.

<img src="https://otexts.com/fpp3/fpp_files/figure-html/SLRpop1-1.png" />

We can think of each observation $y_t$ as consisting of the systematic
or explained part of the model, $\beta_0+\beta_1x_t$ and the random
“error” $\epsilon_t$. The “error” term does not imply a mistake, but a
deviation from the underlying straight line model. **$\epsilon_t$
captures anything that may affect $y_t$ other than $x_t$.**

## Example: US consumption of expenditure

``` r
us_change
```

    ## # A tsibble: 198 x 6 [1Q]
    ##    Quarter Consumption Income Production Savings Unemployment
    ##      <qtr>       <dbl>  <dbl>      <dbl>   <dbl>        <dbl>
    ##  1 1970 Q1       0.619  1.04      -2.45    5.30         0.9  
    ##  2 1970 Q2       0.452  1.23      -0.551   7.79         0.5  
    ##  3 1970 Q3       0.873  1.59      -0.359   7.40         0.5  
    ##  4 1970 Q4      -0.272 -0.240     -2.19    1.17         0.700
    ##  5 1971 Q1       1.90   1.98       1.91    3.54        -0.100
    ##  6 1971 Q2       0.915  1.45       0.902   5.87        -0.100
    ##  7 1971 Q3       0.794  0.521      0.308  -0.406        0.100
    ##  8 1971 Q4       1.65   1.16       2.29   -1.49         0    
    ##  9 1972 Q1       1.31   0.457      4.15   -4.29        -0.200
    ## 10 1972 Q2       1.89   1.03       1.89   -4.69        -0.100
    ## # … with 188 more rows

``` r
us_change |>
  pivot_longer(c(Consumption, Income), names_to = "Series") |>
  autoplot(value) +
  labs(y = "% change")
```

![](Chapter7_files/figure-gfm/unnamed-chunk-3-1.png)<!-- --> This shows
time series of quarterly percentage changes (growth rates) of real
personal consumption expenditure, $y$, and real personal disposable
income, $x$, for the US from 1970 Q1 to 2019 Q2.

``` r
us_change |>
  ggplot(aes(x = Income, y = Consumption)) +
  labs(y = "Consumption (quarterly % change)",
       x = "Income (quarterly % change)") +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](Chapter7_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

This is a scatter plot of consumption changes against income changes
along with the estimated regression line

$$\hat{y}_t=0.54 + 0.27x_t.$$

$\hat{y}$: value of $y$ predicted by the model.

The equation is estimated using the `TSLM()` function and shown with
**`report()`**

``` r
us_change |>
  model(TSLM(Consumption ~ Income)) |>
  report()
```

    ## Series: Consumption 
    ## Model: TSLM 
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -2.58236 -0.27777  0.01862  0.32330  1.42229 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  0.54454    0.05403  10.079  < 2e-16 ***
    ## Income       0.27183    0.04673   5.817  2.4e-08 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.5905 on 196 degrees of freedom
    ## Multiple R-squared: 0.1472,  Adjusted R-squared: 0.1429
    ## F-statistic: 33.84 on 1 and 196 DF, p-value: 2.4022e-08

The fitted line has a positive slope, reflecting the positive
relationship between income and consumption. The slope coefficient shows
that a one unit increase in $x$ (a 1% increase in personal disposable
income) results on average in 0.27 units increase in $y$ (an average
increase of 0.27% in personal consumption expenditure). Alternatively
the estimated equation shows that a value of 1 for $x$ (the percentage
increase in personal disposable income) will result in a forecast value
of $0.54+0.27×1=0.82$ for $y$ (the percentage increase in personal
consumption expenditure).

**The interpretation of the intercept requires that a value of $x=0$
makes sense.** In this case when $x=0$ (i.e., when there is no change in
personal disposable income since the last quarter) the predicted value
of $y$ is 0.54 (i.e., an average increase in personal consumption
expenditure of 0.54%). Even when $x=0$ does not make sense, the
intercept is an important part of the model. Without it, the slope
coefficient can be distorted unnecessarily. The intercept should always
be included unless the requirement is to force the regression line
“through the origin”. In what follows we assume that an intercept is
always included in the model.

## Multiple linear regression

$$
\begin{equation}
  y_t = \beta_{0} + \beta_{1} x_{1,t} + \beta_{2} x_{2,t} + \cdots + \beta_{k} x_{k,t} + \varepsilon_t,
  \tag{7.1}
\end{equation}
$$

where $y$ is the variable to be forecast and $x_1,\dots,x_k$ are the $k$
predictor variables. Each of the predictor variables must be numerical.
The coefficients $\beta_1, \dots, \beta_k$ measure the effect of each
predictor after taking into account the effects of all the other
predictors in the model. Thus, **the coefficients measure the marginal
effects of the predictor variables**.

## Example: US consumption expenditure

``` r
us_change |>
  select(-Consumption, -Income) |>
  pivot_longer(-Quarter) |>
  ggplot(aes(Quarter, value, colour = name)) +
  geom_line() +
  facet_grid(name ~ ., scales = "free_y") +
  guides(colour = "none") +
  labs(y="% change")
```

![](Chapter7_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

These are quarterly percentage changes in industrial production and
personal savings, and quarterly changes in the unemployment rate (as
this is already a percentage). Building a multiple linear regression
model can potentially generate more accurate forecasts as we expect
consumption expenditure to not only depend on personal income but on
other predictors as well.

``` r
us_change |>
  GGally::ggpairs(columns = 2:6)
```

![](Chapter7_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

This is a scatterplot matrix of five variables. The first column shows
the relationships between the forecast variable (consumption) and each
of the predictors. The scatterplots show positive relationships with
income and industrial production, and negative relationships with
savings and unemployment. The strength of these relationships are shown
by the correlation coefficients across the first row. The remaining
scatterplots and correlation coefficients show the relationships between
the predictors.

## Assumptions

1.  The model is a reasonable approximation to reality; that is, the
    relationship between the forecast variable and the predictor
    variables satisfies this linear equation.

2.  We make the following assumptions about the errors
    ${\epsilon_1,\dots,\epsilon_T}$

- they have mean zero; otherwise the forecasts will be systematically
  biased.
- they are not autocorrelated; otherwise the forecasts will be
  inefficient, as there is more information in the data that can be
  exploited.
- they are unrelated to the predictor variables; otherwise there would
  be more information that should be included in the systematic part of
  the model.

It is also useful to have the errors being normally distributed with a
constant variance $\sigma^2$ in order to easily produce prediction
intervals.

Another important assumption in the linear regression model is that each
predictor $x$ is not a random variable. If we were performing a
controlled experiment in a laboratory, we could control the values of
each $x$ (so they would not be random) and observe the resulting values
of $y$. With observational data (including most data in business and
economics), it is not possible to control the value of $x$, we simply
observe it. Hence we make this an assumption.

# 7.2 Least squares estimation

In practice, of course, we have a collection of observations but we do
not know the values of the coefficients
$\beta_0, \beta_1, \dots, \beta_k$ . These need to be estimated from the
data.

The least squares principle provides a way of choosing the coefficients
effectively by minimising the sum of the squared errors. That is, we
choose the values of $\beta_0, \beta_1, \dots, \beta_k$ that minimise

$$
\sum_{t=1}^T \varepsilon_t^2 = \sum_{t=1}^T (y_t -
  \beta_{0} - \beta_{1} x_{1,t} - \beta_{2} x_{2,t} - \cdots - \beta_{k} x_{k,t})^2.
$$

This is called **least squares estimation** because it gives the least
value for the sum of squared errors. **Finding the best estimates of the
coefficients is often called “fitting” the model to the data**, or
sometimes “learning” or “training” the model. The line shown above was
obtained in this way.

$\hat{\beta}_0, \hat{\beta}_1, \dots, \hat{\beta}_k$ are the **estimated
coefficients**.

`TSLM()` fits a linear regression model to time series data. It is
similar to `lm()` which is widely used for linear models, but `TSLM()`
provides additional facilities for handling time series.

## Example: US consumption expenditures

A multiple linear regression model for US consumption is

$$
y_t=\beta_0 + \beta_1 x_{1,t}+ \beta_2 x_{2,t}+ \beta_3 x_{3,t}+ \beta_4 x_{4,t}+\varepsilon_t,
$$

- $y$: % change in real personal consumption expenditure
- \$x_11 % change in real personal disposable income
- $x_2$ % change in industrial production
- $x_3$ % change in personal savings and
- $x_4$ change in the unemployment rate.

The following output provides information about the fitted model. The
first column of Coefficients gives an estimate of each $\beta$
coefficient and the second column gives its standard error (i.e., the
standard deviation which would be obtained from repeatedly estimating
the $\beta$ coefficients on similar data sets). The standard error gives
a measure of the uncertainty in the estimated $\beta$ coefficient.

``` r
fit_consMR <- us_change |>
  model(tslm = TSLM(Consumption ~ Income + Production + Unemployment + Savings))
report(fit_consMR)
```

    ## Series: Consumption 
    ## Model: TSLM 
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.90555 -0.15821 -0.03608  0.13618  1.15471 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   0.253105   0.034470   7.343 5.71e-12 ***
    ## Income        0.740583   0.040115  18.461  < 2e-16 ***
    ## Production    0.047173   0.023142   2.038   0.0429 *  
    ## Unemployment -0.174685   0.095511  -1.829   0.0689 .  
    ## Savings      -0.052890   0.002924 -18.088  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.3102 on 193 degrees of freedom
    ## Multiple R-squared: 0.7683,  Adjusted R-squared: 0.7635
    ## F-statistic:   160 on 4 and 193 DF, p-value: < 2.22e-16

The “t value” is the ratio of an estimated $\beta$ coefficient to its
standard error and the last column gives the p-value: the probability of
the estimated $\beta$ coefficient being as large as it is if there was
no real relationship between consumption and the corresponding
predictor. This is useful when studying the effect of each predictor,
but is not particularly useful for forecasting.

## Fitted values

Predictions of $y$ can be obtained by using the estimated coefficients
in the regression equation and setting the error term to zero. In
general we write,

$$
\begin{equation}
  \hat{y}_t = \hat\beta_{0} + \hat\beta_{1} x_{1,t} + \hat\beta_{2} x_{2,t} + \cdots + \hat\beta_{k} x_{k,t}.
  \tag{7.2}
\end{equation}
$$

Plugging in the values of $x_{1,t},\dots,x_{k,t}$ for $t=1,\dots,T$
returns predictions of $y_t$ within the training set, referred to as
fitted values. Note that **these are predictions of the data used to
estimate the model, not genuine forecasts of future values of $y$**. .
The following plots show the actual values compared to the fitted values
for the percentage change in the US consumption expenditure series. The
time plot shows that the fitted values follow the actual data fairly
closely. This is verified by the strong positive relationship shown by
the scatterplot

.

``` r
augment(fit_consMR) |>
  ggplot(aes(x = Quarter)) +
  geom_line(aes(y = Consumption, colour = "Date")) +
  geom_line(aes(y = .fitted, colour = "Fitted")) +
  labs(y = NULL,
       title = "Percent change in US consumption expenditure") +
  scale_colour_manual(values = c(Data = "black", Fitted = "#D55E00")) +
  guides(colour = guide_legend(title = NULL))
```

![](Chapter7_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

``` r
augment(fit_consMR) |>
  ggplot(aes(x = Consumption, y = .fitted)) +
  geom_point() +
  labs(
    y = "Fitted (predicted values)",
    x = "Data (actual values)",
    title = "Percent change in US consumption expenditure"
  ) +
  geom_abline(intercept = 0, slope = 1)
```

![](Chapter7_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

## Goodness-of-fit

A common way to summarise how well a linear regression model fits the
data is via the **coefficient of determination**, or $R^2$. This can be
calculated as the square of the correlation between the observed $y$
values and the predicted $\hat{y}$ values. Alternatively, it can also be
calculated as,

$$
R^2 = \frac{\sum(\hat{y}_{t} - \bar{y})^2}{\sum(y_{t}-\bar{y})^2},
$$

where the summations are over all observations. Thus, it reflects the
proportion of variation in the forecast variable that is accounted for
(or explained) by the regression model.

In simple linear regression, the value of $R^2$ is also equal to the
square of the correlation between $y$ and $x$ (provided an intercept has
been included).

If the predictions are close to the actual values, we would expect $R^2$
to be close to 1. On the other hand, if the predictions are unrelated to
the actual values, then $R^2=0$ (again, assuming there is an intercept).
In all cases, $R^2$ lies between 0 and 1.

The $R^2$ value is used frequently, though often incorrectly, in
forecasting. The value of $R^2$ will never decrease when adding an extra
predictor to the model and this can lead to over-fitting. There are no
set rules for what is a good $R^2$ value, and typical values of $R^2$
depend on the type of data used. Validating a model’s forecasting
performance on the test data is much better than measuring the $R^2$
value on the training data.

## Example: US consumption expenditure

Figure 7.7 plots the actual consumption expenditure values versus the
fitted values. The correlation between these variables is $r=0.877$
hence $R^2=0.768$ (shown in the output above). In this case, the model
does an excellent job as it explains 76.8% of the variation in the
consumption data. Compare that to the $R^2$ value of 0.15 obtained from
the simple regression with the same data set in Section 7.1. **Adding
the three extra predictors has allowed a lot more of the variation in
the consumption data to be explained.**

## Standard error of the regression

Another measure of how well the model has fitted the data is the
standard deviation of the residuals, which is often known as the
“residual standard error”. This is shown in the above output with the
value 0.31.

It is calculated

$$
\begin{equation}
  \hat{\sigma}_e=\sqrt{\frac{1}{T-k-1}\sum_{t=1}^{T}{e_t^2}},
  \tag{7.3}
\end{equation}
$$

where $k$ is the number of predictors in the model. Notice that we
divide by $T−k−1$ because we have estimated $k+1$ parameters (the
intercept and a coefficient for each predictor variable) in computing
the residuals.

The standard error is related to the size of the average error that the
model produces. We can compare this error to the sample mean of $y$ or
with the standard deviation of $y$ to gain some perspective on the
accuracy of the model.

The standard error will be used when generating prediction intervals,
discussed in Section 7.6.
