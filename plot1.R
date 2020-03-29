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

# Aggregate
emissions.by.year <- df.list$emissions %>%
  group_by(year) %>%
  summarize(emissions.by.year = sum(Emissions, na.rm = TRUE))

# Plot
png("plot1.png",width=480,height=480,units="px",bg="transparent")

barplot(
  (emissions.by.year$emissions.by.year)/10^6,
  names.arg = emissions.by.year$year,
  xlab="Year",
  ylab="PM2.5 Emissions (tons)",
  main="Total PM2.5 Emissions in U.S.A.')"
)

dev.off()
