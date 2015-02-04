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
mv_emission_bwi_lax <- joined_df %>%
        filter(grepl("[Vv]ehicle", EI.Sector) &
                       (fips == "24510" | fips == "06037")) %>%
        group_by(year, fips) %>%
        summarize(emissions_sum = sum(Emissions)) %>% 
        group_by(fips) %>%
        mutate(change_over_time =
                       (abs(emissions_sum - emissions_sum[[1]]) / 
                                emissions_sum[[1]]) * 100, 
               county = ifelse(fips == "24510", "Baltimore", "Los Angeles"))

bwi_df <- mv_emission_bwi_lax[which(mv_emission_bwi_lax$fips == "24510"),]
lax_df <- mv_emission_bwi_lax[which(mv_emission_bwi_lax$fips == "06037"),]

hline_y <- c(max(bwi_df$change_over_time), max(lax_df$change_over_time))

message("Drawing plot...")    
p <- ggplot(data = mv_emission_bwi_lax, 
            aes(x = year, y = change_over_time, colour = county)) + 
        geom_line(size = 1) + geom_point(size = 3) +
        geom_hline(yintercept = hline_y, linetype = 
                           c("dashed", "dashed"), size = 0.5) +
        annotate("text", 2000, hline_y + 3, 
                 label = c("Baltimore max change", 
                           "Los Angeles max change"), size = 3) +
        labs(x = "", y = "Changes over time (%)") +
        labs(title = "Vehicle emission changes over time")

ggsave("plot6.png", plot = p)
message("Done")