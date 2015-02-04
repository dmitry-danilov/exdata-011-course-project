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
hpc <- subset(as.data.frame(hpc), Date == "1/2/2007" | Date == "2/2/2007")

hpc <- hpc %>%
        mutate(Datetime = dmy_hms(paste(hpc$Date, hpc$Time, sep=" "))) %>%
        select(Datetime, 3:ncol(hpc))

hpc[,2:ncol(hpc)] <- as.numeric(unlist(hpc[,2:ncol(hpc)]))
message("Plotting...")
png(file = "plot2.png", bg = "transparent")
with(hpc, plot(Datetime, Global_active_power, 
               type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()
message("Done")