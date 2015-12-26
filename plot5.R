## The script bellow writes to disk the plot5.png file which is useful to answer question 5
## The output is a 480x480 png
## The script does the following steps
##    (1) Downloads and unzips data from  EPA National Emissions Inventory web site if not yet in working directory
##    (2) Reads data file to dataframe
##    (3) Subsets data for motor vehicle sources in Baltimore City and aggregates PM25 values by year
##    (4) Writes PM2.5 from motor vehicles sources in Baltimore City in png graphic device


## Usage:
##  (1) Run the script "plot5.R"

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

## Codes for motor vehicle sources sources
Sources <- as.character(SCC[grep('.*vehicle.*', SCC$EI.Sector, ignore.case = TRUE), 1])

## Subset Baltimore City data
Dataset <- subset(Dataset, fips=='24510')

## Subset coal motor vehicle sources sources data
Dataset <- subset(Dataset, SCC %in% Sources)

PM25Data <- aggregate(Dataset$Emissions, by=list(year=Dataset$year), FUN=sum)
names(PM25Data)[2] <- 'PM25'

## Open png graphic device with right options
png(filename = 'plot5.png', width = 480, height = 480)

## Print graph in png graphic device
library(ggplot2)

plot <- ggplot(PM25Data, aes(y=PM25, x=factor(year))) + 
    geom_bar(stat='identity', position=position_dodge(), fill='steelblue') + 
    xlab('Year') + 
    labs(title = "PM2.5 from motor vehicles sources in Baltimore City")
print(plot)

## close device
dev.off()