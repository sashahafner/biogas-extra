# Sort data and then creates CSV files
# Nanna Løjborg and Sasha D. Hafner
# 30 August 2019

library(plyr)
library(readxl)
library(tidyr)

# Setup
setup <- read_excel('../data/DBFZ_feed.xlsx', sheet = 1)

setup[is.na(setup)] <- 0

colnames(setup)
names(setup)[names(setup) == "Bottle key"] <- "id"
names(setup)[names(setup) == "Inoculum mass (g)"] <- "m.inoc"
names(setup)[names(setup) == "Substrate VS mass (g)"] <- "m.sub.vs"

setup <- setNames(setup, tolower(names(setup)))

setup


# Volume
vol <- read_excel('../data/DBFZ_feed.xlsx', sheet = 2)

class(vol)
vol <- as.data.frame(vol)

vol

# Make csv files
write.csv(setup, '../output csv/DBFZ_feed_setup_w.csv', row.names = FALSE)

write.csv(vol, '../output csv/DBFZ_feed_vol_w.csv', row.names = FALSE)

# Make rda file
# Setup
setup <- setup[ , c('id', 'm.inoc', 'm.sub.vs')]

class(setup)
setup <- as.data.frame(setup)

DBFZfeedSetupW <- setup

save(DBFZfeedSetupW, file = '../output rda/DBFZfeedSetupW.rda')

# Vol
DBFZfeedVolW <- vol

save(DBFZfeedVolW, file = '../output rda/DBFZfeedVolW.rda')


