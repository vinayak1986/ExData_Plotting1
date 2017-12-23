library(data.table)
library(dplyr)
library(lubridate)
# Download the data file (in .zip) from UCI if not found in the current directory.
if(!file.exists("household_power_consumption.txt")){
  if(!file.exists("household_power_consumption.zip")){
    file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(file.url, destfile = "household_power_consumption.zip")
    unzip("household_power_consumption.zip")
  } else {
    unzip("household_power_consumption.zip")
  }
}
# Read the column headers first
headers <- fread("household_power_consumption.txt", nrows = 0)
# Read only the rows for Feb 1 - 2, 2007
power.consumption <- fread("household_power_consumption.txt", na.strings = "?", nrows = 2880, skip = 66637)
names(power.consumption) <- names(headers)
power.consumption <- power.consumption %>% 
  mutate(Date.Time = paste(Date, Time),
         Date = as.Date(Date, format = "%d/%m/%Y"),
         Time = dmy_hms(Date.Time)) %>%
  mutate(Date.Time = NULL)
# Plot 4
png(filename = "plot4.png")
par(mfrow = c(2,2))
plot(power.consumption$Time, 
     power.consumption$Global_active_power, 
     type = "l", 
     xlab='', 
     ylab = "Global Active Power")
plot(power.consumption$Time, 
     power.consumption$Voltage, 
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")
plot(power.consumption$Time, 
     power.consumption$Sub_metering_1, 
     type = "l",
     xlab = "",
     ylab = "Energy sub metering")
lines(power.consumption$Time, 
      power.consumption$Sub_metering_2, 
      type = "l", 
      col = "red")
lines(power.consumption$Time, 
      power.consumption$Sub_metering_3, 
      type = "l", 
      col = "blue")
legend("topright", 
       legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       bty = "n",
       lwd = c(1,1,1),
       col=c("black", "red" ,"blue"))
plot(power.consumption$Time, 
     power.consumption$Global_reactive_power, 
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")
dev.off()