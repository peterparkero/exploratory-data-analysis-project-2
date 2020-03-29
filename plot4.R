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

# Coal combustion-related sources
coal.combustion.by.year <- df.list$emission.source %>%
  filter(grepl('coal', Short.Name)) %>%
  dplyr::select(SCC) %>% 
  mutate(SCC = as.character(SCC)) %>%
  distinct() %>% # Get SCC for coal combustion-related sources
  left_join(df.list$emissions, by = "SCC") %>% # Add emissions data
  group_by(year) %>%
  summarize(emissions.by.year = sum(Emissions, na.rm = TRUE))

# Plot
png(filename='plot4.png', width=480, height=480, units='px')

barplot(
  (coal.combustion.by.year$emissions.by.year),
  names.arg = coal.combustion.by.year$year,
  xlab = "Year",
  ylab = "PM2.5 Emissions (tons)",
  main = "Total PM2.5 Emissions from Coal Combustion Sources in USA"
)

dev.off()