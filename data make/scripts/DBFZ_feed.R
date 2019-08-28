# Sort data and then creates CSV files
# Nanna Løjborg and Sasha D. Hafner
# 26 August 2019

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

setup$'bottle id' <- paste(setup$id, setup$substrate)

setup


# Volume
vol <- read_excel('../data/DBFZ_feed.xlsx', sheet = 2)

class(vol)
vol <- as.data.frame(vol)

vol <- gather(vol, c("1":"12"), key = "id", value = "vol.mL")

vol <- merge(vol, setup, by = "id")

vol <- vol[ , c('bottle id', 'time.d', 'vol.mL')]


names(setup)[names(setup) == "bottle id"] <- "id"
names(vol)[names(vol) == "bottle id"] <- "id"

# Make csv files
write.csv(setup, '../output csv/DBFZ_feed_setup.csv', row.names = FALSE)

write.csv(vol, '../output csv/DBFZ_feed_vol.csv', row.names = FALSE)

# Make rda file
# Setup
setup <- setup[ , c('id', 'm.inoc', 'm.sub.vs')]

class(setup)
setup <- as.data.frame(setup)

DBFZfeedSetup <- setup

save(DBFZfeedSetup, file = '../output rda/DBFZfeedSetup.rda')

# Vol
DBFZfeedVol <- vol

save(DBFZfeedVol, file = '../output rda/DBFZfeedVol.rda')
