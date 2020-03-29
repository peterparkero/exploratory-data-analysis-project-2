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

# Total emissions in Baltimore City by year
baltimore.emissions.by.year.type <- df.list$emissions %>%
  filter(fips == '24510') %>%
  group_by(year, type) %>%
  summarize(emissions.by.year.type = sum(Emissions, na.rm = TRUE))

# Plot
png(filename='plot3.png', width=480, height=480, units='px')

qplot(year,
      emissions.by.year.type,
      data = baltimore.emissions.by.year.type,
      facets = . ~ type) +  
  geom_line() +
  xlab("Year") +
  ylab("PM2.5 Emissions (tons)") +
  ggtitle("Total PM2.5 Emissions in Baltimore City")

dev.off()