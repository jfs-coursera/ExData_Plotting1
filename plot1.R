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

# my data file is in the parent directory, so "../hpc.txt".
data <- read.csv("../hpc.txt", sep=';', na.strings = '?') 


# create a png file, so open png device
png("plot1.png")

# it's a histogram
hist(data$Global_active_power,  ## the column we use
     main = "Global Active Power",  ## the main title
     xlab = "Global Active Power (kilowatts)",  ## the x-axis label
     col = "red")  ## the color of the bars

# don't forget to close the device
dev.off()
