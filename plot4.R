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

# seting the global graphic parameter to make 4 plots
par(mfcol=c(2,2))

##########The first plot
#convert the globl active power column to a numeric
subData$Global_active_power <- as.numeric(subData$Global_active_power)

# plot what we need without initial labling the x axix -> xaxt="n"
plot(subData$DateTime,subData$Global_active_power, type = "l", xaxt="n", ylab = "Global Active Power (kilowatts)", xlab = "")
r <- as.POSIXct(round(range(subData$DateTime), "days"))
axis.POSIXct(1, at = seq(r[1], r[2], by = "days"), format = "%a")

##########The second plot
# converting the three related column to this question to numeric:
subData$Sub_metering_1 <- as.numeric(subData$Sub_metering_1)
subData$Sub_metering_2 <- as.numeric(subData$Sub_metering_2)
subData$Sub_metering_3 <- as.numeric(subData$Sub_metering_3)

# making the plot for the three columns
plot(subData$DateTime, subData$Sub_metering_1, xaxt="n", type ="n", xlab="", ylab="Energy sub metering")
lines(subData$DateTime, subData$Sub_metering_1, col="black" )
lines(subData$DateTime, subData$Sub_metering_2, col="red" )
lines(subData$DateTime, subData$Sub_metering_3, col="blue" )

#adjusting the x-axis
r <- as.POSIXct(round(range(subData$DateTime), "days"))
axis.POSIXct(1,at=seq(r[1],r[2],by ="days"), "%a" )

#making the legends
legend("topright",inset=0.001, pch="___", col= c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n")

##########The third plot
subData$Voltage <- as.numeric(subData$Voltage)

#making the plot
plot(subData$DateTime, subData$Voltage, xaxt="n",xlab="datetime", ylab="Voltage", type="l")
#adjusting the x-axis
r <- as.POSIXct(round(range(subData$DateTime), "days"))
axis.POSIXct(1,at=seq(r[1],r[2],by ="days"), "%a" )

##########The forth plot
subData$Global_reactive_power <- as.numeric(subData$Global_reactive_power)
plot(subData$DateTime, subData$Global_reactive_power, xaxt="n",xlab="datetime", ylab="Global_reactive_power", type="l")
#adjusting the x-axis
r <- as.POSIXct(round(range(subData$DateTime), "days"))
axis.POSIXct(1,at=seq(r[1],r[2],by ="days"), "%a" )


#Save the plot as a png file
dev.copy(png, file = "plot4.png")
dev.off()