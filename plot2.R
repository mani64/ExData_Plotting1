# reading the data
temp <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, temp)

data <- read.table(unz(temp,"household_power_consumption.txt"), header = TRUE, sep = ";", stringsAsFactors = FALSE)

#combine the information in Date and Time columns
Conbined_Date_Time <- paste(data$Date, data$Time)
# convert the conbined_Date_Time to a valid dateTime using lubricate library
#and add the information as a new column to the data
library(lubridate)
data$DateTime <- parse_date_time(Conbined_Date_Time, "%d%m%Y %H%M%S")

#subset of data from 2007-02-01 to 2007-02-02
subData <- subset(data, as.Date(DateTime) >= as.Date("2007-02-01") & as.Date(DateTime) <= as.Date("2007-02-02"))

#convert the globl active power column to a numeric
subData$Global_active_power <- as.numeric(subData$Global_active_power)

# plot what we need without initial labling the x axix -> xaxt="n"
plot(subData$DateTime,subData$Global_active_power, type = "l", xaxt="n", ylab = "Global Active Power (kilowatts)", xlab = "")
r <- as.POSIXct(round(range(subData$DateTime), "days"))
axis.POSIXct(1, at = seq(r[1], r[2], by = "days"), format = "%a")

#Save the plot as a png file
dev.copy(png, file = "plot2.png")
dev.off()