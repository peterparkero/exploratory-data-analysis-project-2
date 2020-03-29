# Load libraries
library(dplyr)
library(magrittr)

# Source functions
sapply(list.files("./src", full.names = TRUE), source)

# Define Variables
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
target.folder = "./data"

# Load data
df.list <- load_data(url, target.folder)  # Check ./src/load_data.R

# baltimore motor emissions by year
baltimore.motor.emissions.by.year <- df.list$emissions %>%
  filter(type == "ON-ROAD",
         fips == "24510") %>%
  group_by(year) %>%
  summarize(emissions.by.year = sum(Emissions, na.rm = TRUE))

# Plot
png(filename='plot5.png', width=480, height=480, units='px')

barplot(
  (baltimore.motor.emissions.by.year$emissions.by.year),
  names.arg = baltimore.motor.emissions.by.year$year,
  xlab = "Year",
  ylab = "PM2.5 Emissions (tons)",
  main = "Total PM2.5 Emissions from Motor Vehicle Sources in Baltimore City"
)

dev.off()