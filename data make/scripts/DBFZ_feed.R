# Sort data and then creates CSV files
# Nanna Løjborg and Sasha D. Hafner

library(plyr)
library(readxl)
library(tidyr)

# Setup
setup <- read_excel('../data/DBFZ_feed.xlsx', sheet = 1)

setup[is.na(setup)] <- 0

colnames(setup)
names(setup)[names(setup) == "Bottle key"] <- "id"
names(setup)[names(setup) == "Substrate"] <- "descrip"
names(setup)[names(setup) == "Inoculum mass (g)"] <- "m.inoc"
names(setup)[names(setup) == "Substrate VS mass (g)"] <- "m.sub.vs"

setup <- setNames(setup, tolower(names(setup)))

setup


# Volume
vol <- read_excel('../data/DBFZ_feed.xlsx', sheet = 2)

class(vol)
vol <- as.data.frame(vol)

vol <- gather(vol, c("1":"12"), key = "id", value = "vol.mL")

vol <- merge(vol, setup, by = "id")

colnames(vol)
names(vol)[names(vol) == "vol.mL"] <- "vol"

vol <- vol[ , c('id', 'time.d', 'vol')]


# Make csv files
write.csv(setup, '../output csv/DBFZ_feed_setup.csv', row.names = FALSE)

write.csv(vol, '../output csv/DBFZ_feed_vol.csv', row.names = FALSE)

# Make rda file
# Setup
setup <- setup[ , c('id', 'descrip', 'm.inoc', 'm.sub.vs')]

class(setup)
setup <- as.data.frame(setup)

feedSetup <- setup

save(feedSetup, file = '../output rda/feedSetup.rda')

# Vol
feedVol <- vol

save(feedVol, file = '../output rda/feedVol.rda')
