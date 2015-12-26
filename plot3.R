## The script bellow writes to disk the plot3.png file which is useful to answer question 3
## The output is a 480x480 png
## The script does the following steps
##    (1) Downloads and unzips data from  EPA National Emissions Inventory web site if not yet in working directory
##    (2) Reads data file to dataframe
##    (3) Subsets data for Baltimore City and aggregates PM25 values by year and type
##    (4) Writes plot for Baltimore City yearly emissions by source type in png graphic device


## Usage:
##  (1) Run the script "plot3.R"

## Download and unzip data from repository to './data/' directory if not downloaded yet
## This code is common for all code files in the assignment

DownloadURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
LocalZipPath <- './data/exdata%2Fdata%2FNEI_data.zip'
LocalNEIPath <- './data/summarySCC_PM25.rds'
LocalSCCPath <- './data/Source_Classification_Code.rds'

if(!dir.exists('./data/')) dir.create('./data/')
if(!file.exists(LocalZipPath)) download.file(DownloadURL, destfile = LocalZipPath)
if(!file.exists(basename(LocalNEIPath))) unzip(LocalZipPath, basename(LocalNEIPath), exdir = './data/')
if(!file.exists(basename(LocalSCCPath))) unzip(LocalZipPath, basename(LocalSCCPath), exdir = './data/')

## Read data file to dataframe
Dataset <- readRDS(LocalNEIPath)

## Read Source Classification Code Table
SCC <- readRDS(LocalSCCPath)

## Subset Baltimore City data
Dataset <- subset(Dataset, fips=='24510')
Dataset$year <- as.factor(Dataset$year)

## Aggregates PM25 values by year and type
PM25Data <- aggregate(Dataset$Emissions, by=list(year=Dataset$year, type=Dataset$type), FUN=sum)
names(PM25Data)[3] <- 'PM25'

## Open png graphic device with right options
png(filename = 'plot3.png', width = 480, height = 480)

## Print graph in png graphic device
library(ggplot2)

#ggplot(PM25Data, aes(y=PM25, x=as.numeric(year)), group=type) + geom_line(aes(colour = type), size=1.5) + geom_point(size=3)
plot <- ggplot(PM25Data, aes(y=PM25, x=type,fill=year)) + 
    geom_bar(stat='identity', position=position_dodge()) + 
    labs(title = "PM2.5 by source type in Baltimore City")
print(plot)

## close device
dev.off()