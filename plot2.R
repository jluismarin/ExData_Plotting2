## The script bellow writes to disk the plot2.png file which is useful to answer question 2
## The output is a 480x480 png
## The script does the following steps
##    (1) Downloads and unzips data from  EPA National Emissions Inventory web site if not yet in working directory
##    (2) Reads data file to dataframe
##    (3) Subsets data for Baltimore City and aggregates PM25 values by year 
##    (4) Writes PM2.5 by year plot in Baltimore City in png graphic device using base plotting system


## Usage:
##  (1) Run the script "plot2.R"

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

## Aggregates PM25 values by year
PM25Data <- aggregate(Dataset$Emissions, by=list(year=Dataset$year), FUN=sum)
names(PM25Data)[2] <- 'PM25'

## Open png graphic device with right options
png(filename = 'plot2.png', width = 480, height = 480)

## Print graph in png graphic device
plot(PM25Data$year, PM25Data$PM25, xlab = 'Year', ylab = 'PM2.5 total emissions', type='o', xaxt='n', ylim = c(0, max(PM25Data$PM25)*1.2))
axis(1, at = seq(1999, 2008, by = 3))
title(main='PM2.5 total emissions by year in Baltimore City')

## close device
dev.off()