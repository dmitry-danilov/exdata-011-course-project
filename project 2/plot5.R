if (!require("ggplot2")) {
        install.packages("ggplot2")
        if (!require("ggplot2")) {
                stop("Unable to load 'ggplot2' library")   
        }
}
if (!require("dplyr")) {
        install.packages("dplyr")
        if (!require("dplyr")) {
                stop("Unable to load 'dplyr' library")   
        }
}

message("Reading files...")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

message("Joining the two data frames...")
joined_df <- merge(NEI, SCC, by = "SCC")

message("Aggregating plot data...")
plot_df <- joined_df %>%
        filter(grepl("[Vv]ehicle", EI.Sector) & fips == "24510") %>%
        group_by(year) %>%
        summarize(emissions_sum = sum(Emissions))

message("Plotting...")
p <- qplot(year, emissions_sum, data = plot_df, 
           geom = c("point", "smooth"), method = "lm",
           xlab = "Year", ylab = "PM2.5 emission (tons)",
           main = "PM2.5 emission from motor vehicle sources in the Baltimore City")
ggsave("plot5.png", p)
message("Done")