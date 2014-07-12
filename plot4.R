# ======
# NOTICE
# ======
# The size of the data file is 20Mb, so I downloaded and unzipped it manually,
# but we could do something like the following:

## download.file("https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip", destfile = "hpc.zip")
## unzip("hpc.zip")

# and we get the file "household_power_consumption.txt" (126Mb) in the working directory.
# Actually, I put the datafile in the parent directory.



# I found this in the forum of the course.
# I know SQL, and I find it to be the most practical way of extracting data.
# But, on my machine/system/setup it takes forever, so I discard it.
## library(sqldf)
## data <- read.csv2.sql("../household_power_consumption.txt",sql="SELECT * FROM file WHERE Date='1/2/2007' OR Date='2/2/2007'",sep=";",na.strings="?" )


# We can use the internal grep command on the the data file while reading line by line:
## data <- grep("^[12]/2/2007", readLines("../household_power_consumption.txt"), value=TRUE)
# But this reads the whole file, and takes a looooooong time.


# Another way to do that is to extract the data manually with a regular expression, on the operating system command line.
# First, we retrieve the headers, and then, we concatenate the data we need.
# On Unix/Linux/BSD (on Mac too?):
##   $ head -n 1 household_power_consumption.txt > hpc.txt
##   $ grep -e '^[12]\/2\/2007' household_power_consumption.txt >> hpc.txt
# Description of the regex:
#   ^[12]\/2\/2007 : - match at the beginning of the line : ^
#                    - a 1 or a 2 : [12]
#                    - followed by a forward slash : \/
#                      (the forward slash needs to be escaped, hence the backward slash)
#                    - followed by a 2 : 2 
#                    - followed by a forward slash : \/ (once again)
#                    - followed by 2007 : 2007
# So the regex is supposed to match strings like 1/2/2007 and 2/2/2007 at the beginning of the lines,
# and grep extracts the whole lines.
# The resulting data file, named "hpc.txt" here, is 2880 lines long, and 176 Kb.
# This is the method I choose. So I work on a small file.
# On Linux/Unix/BSD I probably could run the command directly from R, but I am on Windows right now...
# =============
# END OF NOTICE
# =============


# Now, for the actual R script.

# tweak to get the weekdays in English (my default locale is Spanish) 
Sys.setlocale("LC_TIME", "C")

#################################
# read and prepare data
#################################
# my data file is in the parent directory, so "../hpc.txt".
data <- read.csv("../hpc.txt", sep=';', na.strings = '?') 

#convert Time content to DateTime object
data$Time <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")  ## day/month/year hour:minute:second as POSIXlt object


#################################
# Gather the plots as functions
#################################

# this function draws the same as plot2.R
plot2 <- function() {
    plot(data$Time, data$Global_active_power,  ## the data we use
         type = 'l',  ## lines
         xlab = "",  ## the x-axis label is empty
         ylab = "Global Active Power (kilowatts)")  ## the y-axis label
}

# this function draws the same as plot3.R, but with no border for the legend box
plot3 <- function() {
    # get the names of the three variables we are going to use
    variables <- names(data)[7:9]
    # specify the colors we are going to use for each variable
    colors <- c("black", "red", "blue")

    # create the plot, empty at the beginning
    plot(data$Time, data[[ variables[1] ]],  ## the data we use
         type = 'n',  ## emplty plot for now
         xlab = "",  ## the x-axis label is empty
         ylab = "Energy sub metering")  ## the y-axis label

    # add the lines, for each variable, with the corresponding color
    for (i in 1:length(variables)) {
        lines(data$Time, data[[ variables[i] ]], col = colors[i])
    }

    # We also add the legend
    legend("topright", variables, col = colors, lty = 1, bty = 'n')
}


# third plot
plotA <- function() {
    plot(data$Time, data$Voltage,  ## the data we use
         type = 'l',  ## lines
         xlab = "datetime",  ## the x-axis label
         ylab = "Voltage")  ## the y-axis label
}

# fourth plot
plotB <- function() {
    plot(data$Time, data$Global_reactive_power,  ## the data we use
         type = 'l',  ## lines
         xlab = "datetime",  ## the x-axis label
         ylab = "Global_reactive_power")  ## the y-axis label
}
#################################
# end of plot functions
#################################


#################################
# Main
#################################
# create a png file, so open png device
png("plot4.png")

# we want a 2x2 image
par(mfcol = c(2, 2))  ## mfcol instead of mfrow... my choice
with(data, {
     # first column
     plot2()
     plot3()
     # second column
     plotA()
     plotB()
})

# don't forget to close the device
dev.off()

