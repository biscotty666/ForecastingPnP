library(fpp3)
library(tsibble)

y <- tsibble(
  Year = 2015:2019,
  Observation = c(123, 39, 78, 52, 110),
  index = Year
)
y

z <- tibble(
  Month = c("2019 Jan", "2019 Feb", "2019 Mar", "2019 Apr", "2019 May"),
  Observation = c(50, 23, 34, 30, 25)
)
z

z |>
  mutate(Month = yearmonth(Month)) |>
  as_tsibble(index = Month)

olympic_running

olympic_running |> distinct(Sex)

olympic_running |> distinct(Length)

PBS

PBS |>
  filter(ATC2 == "A10")

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost)

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost))

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC/1e6) # Convert from dollars to millions of dollars

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC/1e6) -> a10

prison <- readr::read_csv("https://OTexts.com/fpp3/extrafiles/prison_population.csv")
prison

prison <- prison |>
  mutate(Quarter = yearquarter(Date)) |>
  select(-Date) |>
  as_tsibble(key = c(State, Gender, Legal, Indigenous),
             index = Quarter)

prison

ansett

melsyd_economy <- ansett |>
  filter(Airports == "MEL-SYD", Class == "Economy") |>
  mutate(Passengers = Passengers/1000)
autoplot(melsyd_economy, Passengers) +
  labs(title = "Ansett airlines economy class",
       subtitle = "Melbourne-Sydney",
       y = "Passengers (,000)")

PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarise(TotalC = sum(Cost)) |>
  mutate(Cost = TotalC/1e6) -> a10
autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales")

a10 |>
  gg_season(Cost, labels = "both") +
  labs(y = "$ (millions)",
       title = "Seasonal plot: Antidiabetic drug sales")

vic_elec

vic_elec |> gg_season(Demand, period = "day") +
  theme(legend.position = "none") +
  labs(y = "Mwh", title = "Electricity demain in Victoria")
vic_elec |> gg_season(Demand, period = "week") +
  theme(legend.position = "none") +
  labs(y = "Mwh", title = "Electricity demain in Victoria")
vic_elec |> gg_season(Demand, period = "year") +
  theme(legend.position = "none") +
  labs(y = "Mwh", title = "Electricity demain in Victoria")

a10 |>
  gg_subseries(Cost) +
  labs(
    y = "$ (million)",
    title = "Australian antidibetic drug sales"
  )

tourism

holidays <- tourism |>
  filter(Purpose == "Holiday") |>
  group_by(State) |>
  summarise(Trips = sum(Trips))
holidays
autoplot(holidays, Trips) +
  labs(y = "Overnight trips",
       title = "Australian domestic holidays")

gg_season(holidays, Trips) +
  labs(y = "Overnight trips ('000)",
       title = "Austrlian domestic holidays")

gg_subseries(holidays, Trips) +
  labs(y = "Overnight trips ('000)",
       title = "Austrlian domestic holidays")

vic_elec |>
  filter(year(Time) == 2014) |>
  autoplot(Demand) +
  labs(y = "GW",
       title = "Half-hourly electricity demand: Victoria")

vic_elec |>
  filter(year(Time) == 2014) |>
  autoplot(Temperature) +
  labs(
    y = "Degrees Celsius",
    title = "Half-hourly temperatures: Melbourne, Australia"
  )

vic_elec |>
  filter(year(Time) == 2014) |>
  ggplot(aes(x = Temperature, y = Demand)) +
  geom_point() +
  labs(x = "Temperature (degrees Celsius)",
       y = "Electricity demand")

visitors <- tourism |>
  group_by(State) |>
  summarise(Trips = sum(Trips))
visitors |>
  ggplot(aes(x = Quarter, y = Trips)) +
  geom_line() +
  facet_grid(vars(State), scales = "free_y") +
  labs(title = "Australian domestic tourism",
       y= "Overnight trips ('000)")

visitors |>
  pivot_wider(values_from=Trips, names_from=State) |>
  GGally::ggpairs(columns = 2:9)

recent_production <- aus_production |>
  filter(year(Quarter) >= 2000)
recent_production |>
  gg_lag(Beer, geom = "point") +
  labs(x = "lag(Beer, k)")

recent_production |> ACF(Beer, lag_max = 9)

recent_production |>
  ACF(Beer) |>
  autoplot() + labs(title = "Australian beer production")

a10 |>
  ACF(Cost, lag_max = 48) |>
  autoplot() +
  labs(title = "Australian antidiabetic drug sales")

set.seed(30)
y <- tsibble(sample = 1:50, 
             wn = rnorm(50), 
             index = sample)
y |> autoplot(wn) + labs(title = "White noise", y = "")

y |>
  ACF(wn) |>
  autoplot() + labs(title = "White noise")
