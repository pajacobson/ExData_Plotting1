## Plot 2

## Check that data frame "powercon" exists.
if (!exists("powercon")){
    ## Download and prepare data for plotting
    
    require(data.table)
    require(dplyr)
    require(dtplyr)
    require(lubridate)
    
    ## Set paths and filename
    dataname <- "household_power_consumption"
    datadir <- "powerdata"
    datapath <- file.path(datadir, paste0(dataname, ".txt"))
    
    ## Check for unzipped data.
    ## Download and unzip if required.
    if (!file.exists(datapath)) {
        zipdata <- paste0(dataname, ".zip")
        if (!file.exists(zipdata)) {
            fileurl <-
                "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
            download.file(fileurl, zipdata)
            rm(fileurl)
        }
        unzip(zipdata, exdir = datadir)
        rm(zipdata)
    }
    
    ## Read Date column
    req_dates <- tbl_dt(fread(datapath, sep = ";", select = "Date"))
    req_dates <- grep("^[12]\\/2\\/2007", req_dates$Date)
    
    ## Extract column names from file
    data_names <- names(fread(datapath, ";", na.strings = "?", nrows = 1))
    
    ## Read in required date range, merge date and time
    powercon <- tbl_df(fread(datapath, ";", na.strings = "?", skip = req_dates[1],
                             nrows = length(req_dates), col.names = data_names)) %>%
        mutate(Date = dmy_hms(paste0(Date,"-",Time)), Time = NULL)
    
    ## Clean up temp variables
    rm(req_dates, data_names, datadir, dataname, datapath)  
} 

## Generate Plot

png("plot2.png", bg = "transparent")
with(powercon, {
    plot(
        Date,
        Global_active_power,
        type = "l",
        ylab = "Global Active Power (kilowatts)",
        xlab = ""
    )
})
dev.off()