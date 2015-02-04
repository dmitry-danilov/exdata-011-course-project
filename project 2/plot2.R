if (!require("dplyr")) {
        install.packages("dplyr")
        if (!require("dplyr")) {
                stop("Unable to load 'dplyr' library")   
        }
}

message("Reading files...")
NEI <- readRDS("summarySCC_PM25.rds")

message("Aggregating data...")
plot_df <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarize(emissions_sum = sum(Emissions))

message("Plotting...")
png(filename = "plot2.png")
with (plot_df, plot(year, emissions_sum, type = "o", lwd = 2, pch = 16,  
                         xlab = "Year", ylab = "PM2.5 emission (tons)"))
title(main = "Total PM2.5 emission in the  Baltimore City")
model <- lm(emissions_sum ~ year, plot_df)
abline(model, lwd = 1, col = "red", lty = "dashed")
dev.off()
message("Done")