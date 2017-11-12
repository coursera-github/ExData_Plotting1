# Source data
url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
filename <- 'household_power_consumption.txt'

get_data <- function(url, filename, ...) {
    tmp <- tempfile()
    on.exit(unlink(tmp))
    download.file(url, tmp)
    read.table(unz(tmp, filename), ...)
}

df <- get_data(url, filename,
               sep = ";", header = TRUE, stringsAsFactors = FALSE, na.strings = "?",
               colClasses = c(rep("character", 2), rep("numeric", 7)))

# Tidy
df$DateTime <- strptime(paste(df$Date, df$Time), format = "%d/%m/%Y %H:%M:%S")
df$Date <- as.Date(df$Date, format = "%d/%m/%Y")
df$Time <- strptime(df$Time, format = "%H:%M:%S")

# Subset
df <- df[df$Date %in% as.Date(c("2007-02-01", "2007-02-02")), ]

# Plot
hist(df$Global_active_power, col = "red",
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

# Output
dev.copy(png, 'plot1.png')
dev.off()
