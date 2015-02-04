message("Loading required libs...")
if (!require("data.table")) {
        install.packages("data.table")
        if (!require("data.table")) {
             stop("Unable to load 'data.table' library")   
        }
}
if (!require("dplyr")) {
        install.packages("dplyr")
        if (!require("dplyr")) {
                stop("Unable to load 'dplyr' library")   
        }
}
if (!require("lubridate")) {
        install.packages("lubridate")
        if (!require("lubridate")) {
                stop("Unable to load 'lubridate' library")   
        }
}
message("Reading in the file...")
hpc <- fread("household_power_consumption.txt", colClasses = "character",
                na.strings = c("", "?"))
message("Preparing data...")
hpc <- as.data.frame(hpc) %>%
        filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
        mutate(datetime = dmy_hms(paste(Date, Time, sep=" "))) %>%
        select(datetime, 3:ncol(hpc))

hpc[,2:ncol(hpc)] <- as.numeric(unlist(hpc[,2:ncol(hpc)]))
message("Plotting...")
png(file = "plot1.png", bg = "transparent")
with(hpc, hist(Global_active_power, col = "red", 
     main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))
dev.off()
message("Done")