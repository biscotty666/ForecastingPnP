Chapter 8.2 Exponential smoothing (8.5-8.7)
================

- <a href="#85-innovations-state-space-models-for-exponential-smoothing"
  id="toc-85-innovations-state-space-models-for-exponential-smoothing">8.5
  Innovations state space models for exponential smoothing</a>
  - <a href="#etsann-simple-exponential-smoothing-with-additive-errors"
    id="toc-etsann-simple-exponential-smoothing-with-additive-errors">ETS(A,N,N):
    simple exponential smoothing with additive errors</a>
  - <a
    href="#etsmnn-simple-exponential-smoothing-with-multiplicative-errors"
    id="toc-etsmnn-simple-exponential-smoothing-with-multiplicative-errors">ETS(M,N,N):
    simple exponential smoothing with multiplicative errors</a>
  - <a href="#etsaan-holts-linear-method-with-additive-errors"
    id="toc-etsaan-holts-linear-method-with-additive-errors">ETS(A,A,N):
    Holt’s linear method with additive errors</a>
  - <a href="#etsman-holts-linear-method-with-multiplicative-errors"
    id="toc-etsman-holts-linear-method-with-multiplicative-errors">ETS(M,A,N):
    Holt’s linear method with multiplicative errors</a>
  - <a href="#other-ets-models" id="toc-other-ets-models">Other ETS
    models</a>

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

# 8.5 Innovations state space models for exponential smoothing

In the rest of this chapter, we study the statistical models that
underlie the exponential smoothing methods we have considered so far.
The exponential smoothing methods presented in Table 8.6 are algorithms
which generate point forecasts. The statistical models in this section
generate the same point forecasts, but can also generate prediction (or
forecast) intervals. <span style="background-color:#ffffb3;">A
statistical model is a stochastic (or random) data generating process
that can produce an entire forecast distribution.</span> We will also
describe how to use the model selection criteria introduced in Chapter 7
to choose the model in an objective manner.

<span style="background-color:#ffffb3;">Each model consists of</span> a
measurement equation that describes <span
style="background-color:#ffffb3;">the observed data, and some state
equations that describe how the unobserved components or states (level,
trend, seasonal) change over time.</span> Hence, these are referred to
as **state space models**.

For each method there exist two models: one with additive errors and one
with multiplicative errors. The point forecasts produced by the models
are identical if they use the same smoothing parameter values. They
will, however, generate different prediction intervals.

To distinguish between a model with additive errors and one with
multiplicative errors (and also to distinguish the models from the
methods), we add a third letter to the classification of Table 8.5. We
label each state space model as $ETS(\cdot,\cdot,\cdot)$ for (Error,
Trend, Seasonal). This label can also be thought of as **ExponenTial
Smoothing**. Using the same notation as in Table 8.5, the possibilities
for each component (or state) are: Error$=\{A,M\}$, Trend$=\{N,A,A_d\}$
and Seasonal$=\{N,A,M\}$.

## ETS(A,N,N): simple exponential smoothing with additive errors

$$
\begin{align*}
  \text{Forecast equation}  && \hat{y}_{t+1|t} & = \ell_{t}\\
  \text{Smoothing equation} && \ell_{t}        & = \alpha y_{t} + (1 - \alpha)\ell_{t-1}.
\end{align*}
$$

If we re-arrange the smoothing equation for the level, we get the “error
correction” form,

$$
\begin{align*}
\ell_t &= \ell_{t-1}+\alpha( y_{t}-\ell_{t-1})\\
         &= \ell_{t-1}+\alpha e_{t},
\end{align*}
$$

where $e_t=y_t−\ell_{t−1}=y_t−\hat{y}_{t\lvert t−1}$ is the residual at
time $t$.

<span style="background-color:#ffffb3;">The training data errors lead to
the adjustment of the estimated level throughout the smoothing process
for $t=1,\dots,T$.</span> For example, if the error at time $t$ is
negative, then $y_t\lt\hat{y}_{t\lvert t−1}$ and so the level at time
$t−1$ has been over-estimated. The new level $\ell_t$ is then the
previous level $\ell_{t-1}$ adjusted downwards. <span
style="background-color:#ffffb3;">The closer $\alpha$ is to one, the
“rougher” the estimate of the level (large adjustments take place). The
smaller the $\alpha$, the “smoother” the level (small adjustments take
place).</span>

We can also write $y_t=\ell_{t−1}+e_t$, so that each observation can be
represented by the previous level plus an error. To make this into an
innovations state space model, all we need to do is specify the
probability distribution for $e_t$. For a model with additive errors, we
assume that residuals (the one-step training errors) $e_t$ are normally
distributed white noise with mean 0 and variance $\sigma^2$. A
short-hand notation for this is
$e_t=\epsilon_t\sim \text{NID}(0,\sigma^2)$; <span
style="background-color:#ffffb3;">NID stands for “normally and
independently distributed”.</span>

Then the equations of the model can be written as

$$
\begin{align}
  y_t &= \ell_{t-1} + \varepsilon_t \tag{8.3}\\
  \ell_t&=\ell_{t-1}+\alpha \varepsilon_t. \tag{8.4}
\end{align}
$$

<span style="background-color:#ffffb3;">We refer to (8.3) as the
measurement (or observation) equation and (8.4) as the state (or
transition) equation.</span> These two equations, together with the
statistical distribution of the errors, form a fully specified
statistical model. Specifically, these constitute an innovations state
space model underlying simple exponential smoothing.

<span style="background-color:#ffffb3;">The term “innovations” comes
from the fact that all equations use the same random error
process</span>, $\epsilon_t$. For the same reason, this formulation is
also referred to as a **“single source of error” model**. There are
alternative multiple source of error formulations which we do not
present here.

The measurement equation shows the relationship between the observations
and the unobserved states. In this case, observation $y_t$ is a linear
function of the level $\ell_{t-1}$, the predictable part of $y_t$, and
the error $\epsilon_t$, the unpredictable part of $y_t$. For other
innovations state space models, this relationship may be nonlinear.

The state equation shows the evolution of the state through time. The
influence of the smoothing parameter $\alpha$ is the same as for the
methods discussed earlier. For example, $\alpha$ governs the amount of
change in successive levels: high values of $\alpha$ allow rapid changes
in the level; low values of $\alpha$ lead to smooth changes. If
$\alpha=0$, the level of the series does not change over time; if
$\alpha=1$, the model reduces to a random walk model,
$y_t=y_{t−1}+\epsilon_t$. (See Section 9.1 for a discussion of this
model.)

## ETS(M,N,N): simple exponential smoothing with multiplicative errors

In a similar fashion, we can specify models with multiplicative errors
by writing the one-step-ahead training errors as relative errors

$$
\varepsilon_t = \frac{y_t-\hat{y}_{t|t-1}}{\hat{y}_{t|t-1}}
$$

where $\epsilon_t\sim\text{NID}(0,\sigma^2)$. Substituting
$\hat{y}_{t\vert t-1}=\ell_{t-1}$ gives
$y_t=\ell_{t-1}+\ell_{t-1}\varepsilon_t$ and
$e_t = y_t - \hat{y}_{t|t-1} = \ell_{t-1}\varepsilon_t$.

Then we can write the multiplicative form of the state space model as

$$
\begin{align*}
  y_t&=\ell_{t-1}(1+\varepsilon_t)\\
  \ell_t&=\ell_{t-1}(1+\alpha \varepsilon_t).
\end{align*}
$$

## ETS(A,A,N): Holt’s linear method with additive errors

For this model, we assume that the one-step-ahead training errors are
given by
$\varepsilon_t=y_t-\ell_{t-1}-b_{t-1} \sim \text{NID}(0,\sigma^2)$.
Substituting this into the error correction equations for Holt’s linear
method we obtain

$$
\begin{align*}
y_t&=\ell_{t-1}+b_{t-1}+\varepsilon_t\\
\ell_t&=\ell_{t-1}+b_{t-1}+\alpha \varepsilon_t\\
b_t&=b_{t-1}+\beta \varepsilon_t,
\end{align*}
$$ where for simplicity we have set $\beta=\alpha\beta^*$.

## ETS(M,A,N): Holt’s linear method with multiplicative errors

Specifying one-step-ahead training errors as relative errors such that

$$
\varepsilon_t=\frac{y_t-(\ell_{t-1}+b_{t-1})}{(\ell_{t-1}+b_{t-1})}
$$

and following an approach similar to that used above, the innovations
state space model underlying Holt’s linear method with multiplicative
errors is specified as

$$
\begin{align*}
y_t&=(\ell_{t-1}+b_{t-1})(1+\varepsilon_t)\\
\ell_t&=(\ell_{t-1}+b_{t-1})(1+\alpha \varepsilon_t)\\
b_t&=b_{t-1}+\beta(\ell_{t-1}+b_{t-1}) \varepsilon_t,
\end{align*}
$$

where again $\beta=\alpha\beta^*$ and
$\varepsilon_t \sim \text{NID}(0,\sigma^2)$.

## Other ETS models

In a similar fashion, we can write an innovations state space model for
each of the exponential smoothing methods of Table 8.6. Table 8.7
presents the equations for all of the models in the ETS framework.

<img src="https://otexts.com/fpp3/figs/statespacemodels-1.png" />
