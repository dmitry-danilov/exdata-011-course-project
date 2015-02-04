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

message("Aggregating data...")
plot_df <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year, type) %>%
        summarize(emissions_sum = sum(Emissions))

message("Plotting...")
p <- qplot(year, emissions_sum, data = plot_df, facets = . ~ type, 
      geom = c("point", "smooth"), method = "lm",
      xlab = "Year", ylab = "PM2.5 emission (tons)",
      main = "PM2.5 emission in the Baltimore City per source")
ggsave("plot3.png", p)
message("Done")