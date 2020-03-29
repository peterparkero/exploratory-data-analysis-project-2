# Load libraries
library(dplyr)
library(magrittr)
library(ggplot2)

# Source functions
sapply(list.files("./src", full.names = TRUE), source)

# Define Variables
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
target.folder = "./data"

# Load data
df.list <- load_data(url, target.folder)  # Check ./src/load_data.R

# LA, baltimore emissions by year
city.emissions.by.year <- df.list$emissions %>%
  filter(type == "ON-ROAD",
         fips %in% c("24510", "06037")) %>%
  group_by(year, fips) %>%
  summarize(city.emissions.by.year = sum(Emissions, na.rm = TRUE)) %>%
  mutate(city = ifelse(fips == "24510", "Baltimore City (24510)", "Los Angeles (06037)")) # Filtered to have 2 cities remaining earlier

# Plot
png(filename='plot6.png', width=480, height=480, units='px')

qplot(
  year,
  city.emissions.by.year,
  data = city.emissions.by.year, 
  facets = . ~ city) +  
  geom_line() +
  xlab("Year") +
  ylab('PM2.5 Emissions (tons)') +
  ggtitle('Total PM2.5 Emissions in Los Angeles (06037) and Baltimore City (24510)')

dev.off()