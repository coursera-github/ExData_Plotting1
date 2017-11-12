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
with(df, {
  plot(Sub_metering_1,x = DateTime, col="black", type="l", ylab="Energy sub metering")
  lines(Sub_metering_2,x = DateTime, col="red")
  lines(Sub_metering_3,x = DateTime, col="blue")
  legend(x='topright', lty=1,
          legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
          col = c("black", "red", "blue")
        )
})

# Output
dev.copy(png, 'plot3.png')
dev.off()
