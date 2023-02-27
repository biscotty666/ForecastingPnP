library(fpp3)

gafa_stock

gafa_stock |>
  autoplot(Close) +
  labs(title = "Closing price for various stocks",
       subtitle = "2014-2019",
       y = "")

PBS

PBS |> 
  select(Month, Cost) |>
  summarise(TotalCost = sum(Cost)) |>
  autoplot(TotalCost) +
    labs(title = "Cost of various pharmaceuticals",
       y = "")
vic_elec
vic_elec |>
  autoplot(Temperature) +
  labs(title = "Temperatures in Melborne (30 minute intervals)", y="")

pelt

pelt |>
  autoplot(Hare) +
  labs(title = "Annual hare pelts harvested",
       y = "Year")

pelt |>
  autoplot(Lynx) +
  labs(title = "Annual lynx pelts harvested",
       y = "Year")

aapl_stock <- filter(gafa_stock, Symbol == "AAPL")
summary(aapl_stock[,"Close"])
aapl_stock_max <- max(aapl_stock[,"Close"])
aapl_stock_max

aapl_stock |>
  filter(Close == aapl_stock_max)

amzn_stock <- filter(gafa_stock, Symbol == "AMZN")
max(amzn_stock[,"Close"]) -> amzn_stock_max
amzn_stock |>
  filter(Close == amzn_stock_max)
fb_stock <- filter(gafa_stock, Symbol == "FB")
max(fb_stock[,"Close"]) -> fb_stock_max
fb_stock |>
  filter(Close == fb_stock_max)

goog_stock <- filter(gafa_stock, Symbol == "GOOG")
max(goog_stock[,"Close"]) -> goog_stock_max
goog_stock |>
  filter(Close == goog_stock_max)

tute1 <- readr::read_csv("tute1.csv")
tute1

tute_ts <- tute1 |>
  mutate(Quarter = yearquarter(Quarter)) |>
  as_tsibble(index = Quarter)
tute_ts

tute_ts |>
  pivot_longer(-Quarter) |>
  ggplot(aes(x = Quarter, y = value, colour = name)) +
  geom_line() +
  facet_grid(name ~ ., scales = "free_y")
