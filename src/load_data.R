retrieve_data <- function(url, target.folder) {
  
  # Download file and unzip to data
  # 
  # Args:
  #  url (str): URL to getting data zip file
  #  target.folder (str): Path to data
  #
  
  # Download and Unzip
  temp.file <- tempfile()
  download.file(url, temp.file)
  unzip(temp.file, exdir = target.folder)
  file.remove(temp.file)
  
}


read_data <- function(target.folder) {
  
  # Read data from text file returning relevant rows
  #
  # Args:
  #  target.folder (str): Path to data
  #
  # Returns:
  #  df (data.table): data with relevant rows
  
  # Read emissions dataset
  emissions.df <- readRDS(file.path(target.folder, 'summarySCC_PM25.rds'))
  
  # Read emission source dataset
  scc.df <- readRDS(file.path(target.folder, 'Source_Classification_Code.rds'))
  
  return(list('emissions' = emissions.df,
              'emission.source' = scc.df))
}


load_data <- function(url, target.folder, force.reload = FALSE) {
  
  # Load data set for plotting.  Combination of downloading and reading data.
  #
  # Args:
  #  url (str): URL to getting data zip file
  #  target.folder (str): Path to data
  #  force.reload (bool): Whether or not to force a reloading of the data.
  #                       If FALSE, and data is already available, then cached data will be loaded.
  #                       If TRUE, data will always be read from sources.
  #
  # Returns:
  #  df (data.table): data with relevant rows
  
  # Download Data if not already downloaded
  if (!dir.exists(target.folder)) {
    retrieve_data(url, target.folder)
  }
  
  if (force.reload | ! exists("emissions.df") | ! exists("scc.df") ) {
    # Read data
    df.list <- read_data(target.folder)
    emissions.df <<- df.list$emissions  # Save to global variable
    scc.df <<- df.list$emission.source
    
  } else {
    df.list <- list('emissions' = emissions.df,
                    'emission.source' = scc.df)
  }
  
  return (df.list)
}
