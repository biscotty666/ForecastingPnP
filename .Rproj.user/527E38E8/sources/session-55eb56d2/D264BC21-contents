Ch 2 Time series graphics
================

- <a href="#21-tsibble-objects" id="toc-21-tsibble-objects">2.1
  <code>tsibble</code> objects</a>
  - <a href="#the-index-variable" id="toc-the-index-variable">The index
    variable</a>
  - <a href="#the-key-variables" id="toc-the-key-variables">The key
    variables</a>
  - <a href="#working-with-tsibble-objects"
    id="toc-working-with-tsibble-objects">Working with <code>tsibble</code>
    objects</a>
    - <a href="#select" id="toc-select"><code>select()</code></a>
    - <a href="#filter" id="toc-filter"><code>filter()</code></a>
    - <a href="#summarise" id="toc-summarise"><code>summarise()</code></a>
    - <a href="#mutate" id="toc-mutate"><code>mutate()</code></a>
  - <a href="#read-a-csv-file-and-convert-to-a-tsibble"
    id="toc-read-a-csv-file-and-convert-to-a-tsibble">Read a csv file and
    convert to a <code>tsibble</code></a>
  - <a href="#the-seasonal-period" id="toc-the-seasonal-period">The seasonal
    period</a>
- <a href="#22-time-plots" id="toc-22-time-plots">2.2 Time plots</a>
- <a href="#23-time-series-patterns" id="toc-23-time-series-patterns">2.3
  Time series patterns</a>
- <a href="#24-seasonal-plots" id="toc-24-seasonal-plots">2.4 Seasonal
  plots</a>
  - <a href="#multiple-seasonal-periods"
    id="toc-multiple-seasonal-periods">Multiple seasonal periods</a>
- <a href="#25-seasonal-subseries-plots"
  id="toc-25-seasonal-subseries-plots">2.5 Seasonal subseries plots</a>
  - <a href="#example-australian-holiday-tourism"
    id="toc-example-australian-holiday-tourism">Example: Australian holiday
    tourism</a>
- <a href="#26-scatterplots" id="toc-26-scatterplots">2.6 Scatterplots</a>
  - <a href="#correlation" id="toc-correlation">Correlation</a>
  - <a href="#scatterplot-matrices"
    id="toc-scatterplot-matrices">Scatterplot matrices</a>
- <a href="#27-lag-plots" id="toc-27-lag-plots">2.7 Lag plots</a>
- <a href="#28-autocorrelation" id="toc-28-autocorrelation">2.8
  Autocorrelation</a>
  - <a href="#trend-and-seasonality-in-acf-plots"
    id="toc-trend-and-seasonality-in-acf-plots">Trend and seasonality in ACF
    plots</a>
- <a href="#29-white-noise" id="toc-29-white-noise">2.9 White noise</a>

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
library(tsibble)
```

# 2.1 `tsibble` objects

## The index variable

``` r
y <- tsibble(
  Year = 2015:2019,
  Observation = c(123, 39, 78, 52, 110),
  index = Year
)
y
```

    ## # A tsibble: 5 x 2 [1Y]
    ##    Year Observation
    ##   <int>       <dbl>
    ## 1  2015         123
    ## 2  2016          39
    ## 3  2017          78
    ## 4  2018          52
    ## 5  2019         110

`tsibble` introduces temporal structure to tidy data frames.

A regular `tibble` can be converted to a `tsibble` object

``` r
z <- tibble(
  Month = c("2019 Jan", "2019 Feb", "2019 Mar", "2019 Apr", "2019 May"),
  Observation = c(50, 23, 34, 30, 25)
)
z
```

    ## # A tibble: 5 × 2
    ##   Month    Observation
    ##   <chr>          <dbl>
    ## 1 2019 Jan          50
    ## 2 2019 Feb          23
    ## 3 2019 Mar          34
    ## 4 2019 Apr          30
    ## 5 2019 May          25

``` r
z |>
  mutate(Month = yearmonth(Month)) |>
  as_tsibble(index = Month)
```

    ## # A tsibble: 5 x 2 [1M]
    ##      Month Observation
    ##      <mth>       <dbl>
    ## 1 2019 Jan          50
    ## 2 2019 Feb          23
    ## 3 2019 Mar          34
    ## 4 2019 Apr          30
    ## 5 2019 May          25

`mutate()` converts the “Month” column to the appropriate variable type,
in this case `yearmonth`. `as_tsibble()` sets the index for the
`tsibble` object

| Frequency | Function                     |
|-----------|------------------------------|
| Annual    | start:end                    |
| Quarterly | `yearquarter()`              |
| Monthly   | `yearmonth()`                |
| Weekly    | `yearweek()`                 |
| Daily     | `as_date()`, `ymd()`         |
| Sub-Daily | `as_datetime()`, `ymd_hms()` |

## The key variables

``` r
olympic_running
```

    ## # A tsibble: 312 x 4 [4Y]
    ## # Key:       Length, Sex [14]
    ##     Year Length Sex    Time
    ##    <int>  <int> <chr> <dbl>
    ##  1  1896    100 men    12  
    ##  2  1900    100 men    11  
    ##  3  1904    100 men    11  
    ##  4  1908    100 men    10.8
    ##  5  1912    100 men    10.8
    ##  6  1916    100 men    NA  
    ##  7  1920    100 men    10.8
    ##  8  1924    100 men    10.6
    ##  9  1928    100 men    10.8
    ## 10  1932    100 men    10.3
    ## # … with 302 more rows

The summary shows that the `tsibble` object has 312 rows, 4 columns, and
the index is in 4 year intervals. Additionally there are 14 seperate
time series uniquely identified by the keys `Length` and `Sex`.
`distinct()` can be used to show categories and combinations of each
variable.

``` r
olympic_running |> distinct(Sex)
```

    ## # A tibble: 2 × 1
    ##   Sex  
    ##   <chr>
    ## 1 men  
    ## 2 women

``` r
olympic_running |> distinct(Length)
```

    ## # A tibble: 7 × 1
    ##   Length
    ##    <int>
    ## 1    100
    ## 2    200
    ## 3    400
    ## 4    800
    ## 5   1500
    ## 6   5000
    ## 7  10000

## Working with `tsibble` objects

`dplyr` functions include mutate()`,`filter()`,`select()`,`summarise()\`

``` r
PBS
```

    ## # A tsibble: 67,596 x 9 [1M]
    ## # Key:       Concession, Type, ATC1, ATC2 [336]
    ##       Month Concession   Type        ATC1  ATC1_desc ATC2  ATC2_…¹ Scripts  Cost
    ##       <mth> <chr>        <chr>       <chr> <chr>     <chr> <chr>     <dbl> <dbl>
    ##  1 1991 Jul Concessional Co-payments A     Alimenta… A01   STOMAT…   18228 67877
    ##  2 1991 Aug Concessional Co-payments A     Alimenta… A01   STOMAT…   15327 57011
    ##  3 1991 Sep Concessional Co-payments A     Alimenta… A01   STOMAT…   14775 55020
    ##  4 1991 Oct Concessional Co-payments A     Alimenta… A01   STOMAT…   15380 57222
    ##  5 1991 Nov Concessional Co-payments A     Alimenta… A01   STOMAT…   14371 52120
    ##  6 1991 Dec Concessional Co-payments A     Alimenta… A01   STOMAT…   15028 54299
    ##  7 1992 Jan Concessional Co-payments A     Alimenta… A01   STOMAT…   11040 39753
    ##  8 1992 Feb Concessional Co-payments A     Alimenta… A01   STOMAT…   15165 54405
    ##  9 1992 Mar Concessional Co-payments A     Alimenta… A01   STOMAT…   16898 61108
    ## 10 1992 Apr Concessional Co-payments A     Alimenta… A01   STOMAT…   18141 65356
    ## # … with 67,586 more rows, and abbreviated variable name ¹​ATC2_desc

This data set contains monthly data on Medicare Australia prescription
data from July 1991 to June 2008.

### `select()`

``` r
PBS |>
  filter(ATC2 == "A10")
```

    ## # A tsibble: 816 x 9 [1M]
    ## # Key:       Concession, Type, ATC1, ATC2 [4]
    ##       Month Concession   Type        ATC1  ATC1_d…¹ ATC2  ATC2_…² Scripts   Cost
    ##       <mth> <chr>        <chr>       <chr> <chr>    <chr> <chr>     <dbl>  <dbl>
    ##  1 1991 Jul Concessional Co-payments A     Aliment… A10   ANTIDI…   89733 2.09e6
    ##  2 1991 Aug Concessional Co-payments A     Aliment… A10   ANTIDI…   77101 1.80e6
    ##  3 1991 Sep Concessional Co-payments A     Aliment… A10   ANTIDI…   76255 1.78e6
    ##  4 1991 Oct Concessional Co-payments A     Aliment… A10   ANTIDI…   78681 1.85e6
    ##  5 1991 Nov Concessional Co-payments A     Aliment… A10   ANTIDI…   70554 1.69e6
    ##  6 1991 Dec Concessional Co-payments A     Aliment… A10   ANTIDI…   75814 1.84e6
    ##  7 1992 Jan Concessional Co-payments A     Aliment… A10   ANTIDI…   64186 1.56e6
    ##  8 1992 Feb Concessional Co-payments A     Aliment… A10   ANTIDI…   75899 1.73e6
    ##  9 1992 Mar Concessional Co-payments A     Aliment… A10   ANTIDI…   89445 2.05e6
    ## 10 1992 Apr Concessional Co-payments A     Aliment… A10   ANTIDI…   97315 2.23e6
    ## # … with 806 more rows, and abbreviated variable names ¹​ATC1_desc, ²​ATC2_desc

### `filter()`

``` r
PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost)
```

    ## # A tsibble: 816 x 4 [1M]
    ## # Key:       Concession, Type [4]
    ##       Month Concession   Type           Cost
    ##       <mth> <chr>        <chr>         <dbl>
    ##  1 1991 Jul Concessional Co-payments 2092878
    ##  2 1991 Aug Concessional Co-payments 1795733
    ##  3 1991 Sep Concessional Co-payments 1777231
    ##  4 1991 Oct Concessional Co-payments 1848507
    ##  5 1991 Nov Concessional Co-payments 1686458
    ##  6 1991 Dec Concessional Co-payments 1843079
    ##  7 1992 Jan Concessional Co-payments 1564702
    ##  8 1992 Feb Concessional Co-payments 1732508
    ##  9 1992 Mar Concessional Co-payments 2046102
    ## 10 1992 Apr Concessional Co-payments 2225977
    ## # … with 806 more rows

Note that `Month`, `Concession` and `Type` would be returned
automatically to ensure that each row contains a unique combination of
index and keys.

### `summarise()`

``` r
PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost))
```

    ## # A tsibble: 204 x 2 [1M]
    ##       Month  TotalC
    ##       <mth>   <dbl>
    ##  1 1991 Jul 3526591
    ##  2 1991 Aug 3180891
    ##  3 1991 Sep 3252221
    ##  4 1991 Oct 3611003
    ##  5 1991 Nov 3565869
    ##  6 1991 Dec 4306371
    ##  7 1992 Jan 5088335
    ##  8 1992 Feb 2814520
    ##  9 1992 Mar 2985811
    ## 10 1992 Apr 3204780
    ## # … with 194 more rows

### `mutate()`

Used to create new variables

``` r
PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC/1e6) # Convert from dollars to millions of dollars
```

    ## # A tsibble: 204 x 3 [1M]
    ##       Month  TotalC  Cost
    ##       <mth>   <dbl> <dbl>
    ##  1 1991 Jul 3526591  3.53
    ##  2 1991 Aug 3180891  3.18
    ##  3 1991 Sep 3252221  3.25
    ##  4 1991 Oct 3611003  3.61
    ##  5 1991 Nov 3565869  3.57
    ##  6 1991 Dec 4306371  4.31
    ##  7 1992 Jan 5088335  5.09
    ##  8 1992 Feb 2814520  2.81
    ##  9 1992 Mar 2985811  2.99
    ## 10 1992 Apr 3204780  3.20
    ## # … with 194 more rows

Save the `tsibble` object

``` r
PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC/1e6) -> a10
```

## Read a csv file and convert to a `tsibble`

``` r
prison <- readr::read_csv("https://OTexts.com/fpp3/extrafiles/prison_population.csv")
```

    ## Rows: 3072 Columns: 6
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (4): State, Gender, Legal, Indigenous
    ## dbl  (1): Count
    ## date (1): Date
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
prison
```

    ## # A tibble: 3,072 × 6
    ##    Date       State Gender Legal     Indigenous Count
    ##    <date>     <chr> <chr>  <chr>     <chr>      <dbl>
    ##  1 2005-03-01 ACT   Female Remanded  ATSI           0
    ##  2 2005-03-01 ACT   Female Remanded  Non-ATSI       2
    ##  3 2005-03-01 ACT   Female Sentenced ATSI           0
    ##  4 2005-03-01 ACT   Female Sentenced Non-ATSI       5
    ##  5 2005-03-01 ACT   Male   Remanded  ATSI           7
    ##  6 2005-03-01 ACT   Male   Remanded  Non-ATSI      58
    ##  7 2005-03-01 ACT   Male   Sentenced ATSI           5
    ##  8 2005-03-01 ACT   Male   Sentenced Non-ATSI     101
    ##  9 2005-03-01 NSW   Female Remanded  ATSI          51
    ## 10 2005-03-01 NSW   Female Remanded  Non-ATSI     131
    ## # … with 3,062 more rows

When converting the table to a `tsibble` object we define the index and
key columns. Note that the data is quarterly but is stored as individual
days.

``` r
prison <- prison |>
  mutate(Quarter = yearquarter(Date)) |>
  select(-Date) |>
  as_tsibble(key = c(State, Gender, Legal, Indigenous),
             index = Quarter)

prison
```

    ## # A tsibble: 3,072 x 6 [1Q]
    ## # Key:       State, Gender, Legal, Indigenous [64]
    ##    State Gender Legal    Indigenous Count Quarter
    ##    <chr> <chr>  <chr>    <chr>      <dbl>   <qtr>
    ##  1 ACT   Female Remanded ATSI           0 2005 Q1
    ##  2 ACT   Female Remanded ATSI           1 2005 Q2
    ##  3 ACT   Female Remanded ATSI           0 2005 Q3
    ##  4 ACT   Female Remanded ATSI           0 2005 Q4
    ##  5 ACT   Female Remanded ATSI           1 2006 Q1
    ##  6 ACT   Female Remanded ATSI           1 2006 Q2
    ##  7 ACT   Female Remanded ATSI           1 2006 Q3
    ##  8 ACT   Female Remanded ATSI           0 2006 Q4
    ##  9 ACT   Female Remanded ATSI           0 2007 Q1
    ## 10 ACT   Female Remanded ATSI           1 2007 Q2
    ## # … with 3,062 more rows

## The seasonal period

Common periods for time intervals

| Data     | Minute | Hour | Day   | Week    | Year     |
|----------|--------|------|-------|---------|----------|
| Quarters |        |      |       |         | 4        |
| Months   |        |      |       |         | 12       |
| Weeks    |        |      |       |         | 52       |
| Days     |        |      |       | 7       | 365.25   |
| Hours    |        |      | 24    | 168     | 8766     |
| Minutes  |        | 60   | 1440  | 10080   | 525960   |
| Seconds  | 60     | 3600 | 86400 | 6048000 | 31557600 |

More complicated and unusual seasonal patterns can be specified using
`period()` in the `lubricate` package.

# 2.2 Time plots

``` r
ansett
```

    ## # A tsibble: 7,407 x 4 [1W]
    ## # Key:       Airports, Class [30]
    ##        Week Airports Class    Passengers
    ##      <week> <chr>    <chr>         <dbl>
    ##  1 1989 W28 ADL-PER  Business        193
    ##  2 1989 W29 ADL-PER  Business        254
    ##  3 1989 W30 ADL-PER  Business        185
    ##  4 1989 W31 ADL-PER  Business        254
    ##  5 1989 W32 ADL-PER  Business        191
    ##  6 1989 W33 ADL-PER  Business        136
    ##  7 1989 W34 ADL-PER  Business          0
    ##  8 1989 W35 ADL-PER  Business          0
    ##  9 1989 W36 ADL-PER  Business          0
    ## 10 1989 W37 ADL-PER  Business          0
    ## # … with 7,397 more rows

Let’s look at the weekly economy passenger load on Ansett Airlines
between their two largest cities.

``` r
melsyd_economy <- ansett |>
  filter(Airports == "MEL-SYD", Class == "Economy") |>
  mutate(Passengers = Passengers/1000)
autoplot(melsyd_economy, Passengers) +
  labs(title = "Ansett airlines economy class",
       subtitle = "Melbourne-Sydney",
       y = "Passengers (,000)")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

Note:

- The period in 1989 when no passengers were carried - d/t an industrial
  dispute
- Reduced load in 1992 - d/t a trial program which replaced economy
  seats by business class seats
- Large increase in passenger load in second half 1991 - unexplained
- Large dips in load around the start of each year - holiday effects
- Long-term fluctuations with an increase in level in 1987, decrease in
  1989, increase through 1990 and 1991

A model needs to take all these features into account.

Looking at our simpler time series from 2.1:

``` r
PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC/1e6) -> a10
autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

This shows a clear and increasing trend.

# 2.3 Time series patterns

- Trend: long-term increase or decrease in the data. Does not have to be
  linear
- Seasonal: patterns of a fixed, known period
- Cyclic: rises and falls which are not fixed but usually at least 2
  years in length

<img src="https://otexts.com/fpp3/fpp_files/figure-html/fourexamples-1.png" />

1.  The upper left image shows strong seasonality within each year and
    cyclic behaviour with a period between 6-10 year.
2.  The upper right shows no seasonality but a clear downward trend.
3.  The bottom left shows both seasonality and trend but no apparent
    cyclical nature
4.  The bottom left shows neither trend, seasonality or cyclic aspects.

# 2.4 Seasonal plots

``` r
a10 |>
  gg_season(Cost, labels = "both") +
  labs(y = "$ (millions)",
       title = "Seasonal plot: Antidiabetic drug sales")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

Useful for identifying Years with with unusual patterns. In this case we
see 2008 dipping lower than usual in March 2008. The low figure in June
could be the result of incomplete data.

## Multiple seasonal periods

`period` can be used for data with multiple seasonal patterns by
specifying daily, weekly or yearly patterns

``` r
vic_elec
```

    ## # A tsibble: 52,608 x 5 [30m] <Australia/Melbourne>
    ##    Time                Demand Temperature Date       Holiday
    ##    <dttm>               <dbl>       <dbl> <date>     <lgl>  
    ##  1 2012-01-01 00:00:00  4383.        21.4 2012-01-01 TRUE   
    ##  2 2012-01-01 00:30:00  4263.        21.0 2012-01-01 TRUE   
    ##  3 2012-01-01 01:00:00  4049.        20.7 2012-01-01 TRUE   
    ##  4 2012-01-01 01:30:00  3878.        20.6 2012-01-01 TRUE   
    ##  5 2012-01-01 02:00:00  4036.        20.4 2012-01-01 TRUE   
    ##  6 2012-01-01 02:30:00  3866.        20.2 2012-01-01 TRUE   
    ##  7 2012-01-01 03:00:00  3694.        20.1 2012-01-01 TRUE   
    ##  8 2012-01-01 03:30:00  3562.        19.6 2012-01-01 TRUE   
    ##  9 2012-01-01 04:00:00  3433.        19.1 2012-01-01 TRUE   
    ## 10 2012-01-01 04:30:00  3359.        19.0 2012-01-01 TRUE   
    ## # … with 52,598 more rows

``` r
vic_elec |> gg_season(Demand, period = "day") +
  theme(legend.position = "none") +
  labs(y = "Mwh", title = "Electricity demain in Victoria")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

``` r
vic_elec |> gg_season(Demand, period = "week") +
  theme(legend.position = "none") +
  labs(y = "Mwh", title = "Electricity demain in Victoria")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

``` r
vic_elec |> gg_season(Demand, period = "year") +
  theme(legend.position = "none") +
  labs(y = "Mwh", title = "Electricity demain in Victoria")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

# 2.5 Seasonal subseries plots

``` r
a10 |>
  gg_subseries(Cost) +
  labs(
    y = "$ (million)",
    title = "Australian antidibetic drug sales"
  )
```

![](Chapter2_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

This plot collects each season into seperate mini time plots. The blue
line indicates the mean. This plot is useful to clearly view the
underlying seasonal pattern and shows the changes in seasonality over
time. In this case it is not very interesting.

## Example: Australian holiday tourism

``` r
tourism
```

    ## # A tsibble: 24,320 x 5 [1Q]
    ## # Key:       Region, State, Purpose [304]
    ##    Quarter Region   State           Purpose  Trips
    ##      <qtr> <chr>    <chr>           <chr>    <dbl>
    ##  1 1998 Q1 Adelaide South Australia Business  135.
    ##  2 1998 Q2 Adelaide South Australia Business  110.
    ##  3 1998 Q3 Adelaide South Australia Business  166.
    ##  4 1998 Q4 Adelaide South Australia Business  127.
    ##  5 1999 Q1 Adelaide South Australia Business  137.
    ##  6 1999 Q2 Adelaide South Australia Business  200.
    ##  7 1999 Q3 Adelaide South Australia Business  169.
    ##  8 1999 Q4 Adelaide South Australia Business  134.
    ##  9 2000 Q1 Adelaide South Australia Business  154.
    ## 10 2000 Q2 Adelaide South Australia Business  169.
    ## # … with 24,310 more rows

Lets consider the total visitor nights on holiday for each quarter.

``` r
holidays <- tourism |>
  filter(Purpose == "Holiday") |>
  group_by(State) |>
  summarise(Trips = sum(Trips))
holidays
```

    ## # A tsibble: 640 x 3 [1Q]
    ## # Key:       State [8]
    ##    State Quarter Trips
    ##    <chr>   <qtr> <dbl>
    ##  1 ACT   1998 Q1  196.
    ##  2 ACT   1998 Q2  127.
    ##  3 ACT   1998 Q3  111.
    ##  4 ACT   1998 Q4  170.
    ##  5 ACT   1999 Q1  108.
    ##  6 ACT   1999 Q2  125.
    ##  7 ACT   1999 Q3  178.
    ##  8 ACT   1999 Q4  218.
    ##  9 ACT   2000 Q1  158.
    ## 10 ACT   2000 Q2  155.
    ## # … with 630 more rows

``` r
autoplot(holidays, Trips) +
  labs(y = "Overnight trips",
       title = "Australian domestic holidays")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

The plot shows strong seasonality for most states but the peaks do not
necessarily coincide.To see the timing of those seasonal peaks use a
`gg_season()` plot.

``` r
gg_season(holidays, Trips) +
  labs(y = "Overnight trips ('000)",
       title = "Austrlian domestic holidays")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

And a `gg_subseries()` plot

``` r
gg_subseries(holidays, Trips) +
  labs(y = "Overnight trips ('000)",
       title = "Austrlian domestic holidays")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

Here we see the increase in Western Australia in recent years. Also
Victoria’s strong increas in Q1 and Q4 but not in the other quarters.

# 2.6 Scatterplots

The above plots are used to explore individual time series. Scatterplots
can explore the relationship between two time series.

The following shows half-hourly electricity demand and temperature for
2014 in Victoria Australia.

``` r
vic_elec |>
  filter(year(Time) == 2014) |>
  autoplot(Demand) +
  labs(y = "GW",
       title = "Half-hourly electricity demand: Victoria")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

``` r
vic_elec |>
  filter(year(Time) == 2014) |>
  autoplot(Temperature) +
  labs(
    y = "Degrees Celsius",
    title = "Half-hourly temperatures: Melbourne, Australia"
  )
```

![](Chapter2_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

``` r
vic_elec |>
  filter(year(Time) == 2014) |>
  ggplot(aes(x = Temperature, y = Demand)) +
  geom_point() +
  labs(x = "Temperature (degrees Celsius)",
       y = "Electricity demand")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

This shows a high demand when temperatures are high as well as when they
are low.

## Correlation

The **correlation coefficients** measure the strength of the linear
relationship between two variables.

$$
r = \frac{\sum (x_{t} - \bar{x})(y_{t}-\bar{y})}{\sqrt{\sum(x_{t}-\bar{x})^2}\sqrt{\sum(y_{t}-\bar{y})^2}}
$$

for $r$ between -1 and 1.

<img src="https://otexts.com/fpp3/fpp_files/figure-html/corr-1.png" />

The correlation coefficient only measures the strenght of the **linear**
relationship.

<img src="https://otexts.com/fpp3/fpp_files/figure-html/anscombe-1.png" />

These plots all have correlation coefficients of 0.82 but have very
different relationships. Plots are important. Do not rely on correlation
values alone.

## Scatterplot matrices

A useful starting point is to plot each variable agains each other
variable.

``` r
visitors <- tourism |>
  group_by(State) |>
  summarise(Trips = sum(Trips))
visitors |>
  ggplot(aes(x = Quarter, y = Trips)) +
  geom_line() +
  facet_grid(vars(State), scales = "free_y") +
  labs(title = "Australian domestic tourism",
       y= "Overnight trips ('000)")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

``` r
visitors |>
  pivot_wider(values_from=Trips, names_from=State) |>
  GGally::ggpairs(columns = 2:9)
```

    ## Registered S3 method overwritten by 'GGally':
    ##   method from   
    ##   +.gg   ggplot2

![](Chapter2_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

# 2.7 Lag plots

``` r
recent_production <- aus_production |>
  filter(year(Quarter) >= 2000)
recent_production |>
  gg_lag(Beer, geom = "point") +
  labs(x = "lag(Beer, k)")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

Note the strong positive relationship at lags 4 and 8 reflecting
seasonality. The strong negative correlations in lags 2 and 6 reflect
peaks in Q4 being plotted against troughs in Q2.

# 2.8 Autocorrelation

Autocorrelation measures the linear relationship between **lagged
values** of a time series.

There are several autocorrelation coefficients corresponding to each
panel in the lag plots. Eg. $r_1$ measures the relationship between
$y_t$ and $y_{t-1}$, $r_2$ for $y_t$ and $y_{t-2}$, etc.

$$
r_{k} = \frac{\sum\limits_{t=k+1}^T (y_{t}-\bar{y})(y_{t-k}-\bar{y})}
{\sum\limits_{t=1}^T (y_{t}-\bar{y})^2}
$$

where $T$ is the length of the time series. The **autocorrelation
function** `ACF()` can be used to compute the coefficients.

``` r
recent_production |> ACF(Beer, lag_max = 9)
```

    ## # A tsibble: 9 x 2 [1Q]
    ##        lag      acf
    ##   <cf_lag>    <dbl>
    ## 1       1Q -0.0530 
    ## 2       2Q -0.758  
    ## 3       3Q -0.0262 
    ## 4       4Q  0.802  
    ## 5       5Q -0.0775 
    ## 6       6Q -0.657  
    ## 7       7Q  0.00119
    ## 8       8Q  0.707  
    ## 9       9Q -0.0888

The acf column contains $r_1, r_2,\dots,r_9$. We can plot these with a
**correlogram**.

``` r
recent_production |>
  ACF(Beer) |>
  autoplot() + labs(title = "Australian beer production")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->

- $r_4$ and $r_2$ show the peaks and troughs which are each four
  quarters apart, with the troughs occurring 2 quarters after the peaks.
- The dashed blue lines indicate whether the correlations are
  significantly beyond zero.

## Trend and seasonality in ACF plots

For data with a **trend** there is strong autocorrelation for small lags
because observations near in time are also near in value. Therefore the
ACF will ususally show positive values which slowly decrease as the lags
increase.

When data are **seasonal** the autocorrelation will be larger for
seasonal lags (multiples of the seasonal period).

`a10` is an example of a time series with both seasonal and trend
components.

``` r
a10 |>
  ACF(Cost, lag_max = 48) |>
  autoplot() +
  labs(title = "Australian antidiabetic drug sales")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-38-1.png)<!-- -->

# 2.9 White noise

**White noise** refers to data with no autocorrelation

``` r
set.seed(30)
y <- tsibble(sample = 1:50, 
             wn = rnorm(50), 
             index = sample)
y |> autoplot(wn) + labs(title = "White noise", y = "")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

``` r
y |>
  ACF(wn) |>
  autoplot() + labs(title = "White noise")
```

![](Chapter2_files/figure-gfm/unnamed-chunk-40-1.png)<!-- -->

For white noise each autocorrelation value should be close to zero. More
specifically 95% of the spikes should lie within $\pm 2/\sqrt{T}$ where
$T$ is the length of the time series. If one or more large spikes or
more than 5% of spikes lie outside the 95% bounds it is probably not
pure white noise.
