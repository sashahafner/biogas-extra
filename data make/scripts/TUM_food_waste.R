# Sort data and then creates CSV files
# Nanna Løjborg and Sasha D. Hafner
# 26 August 2019

library(plyr)
library(readxl)
library(tidyr)

# Setup
setup <- read_excel('../data/TUM_food_waste.xlsx', sheet = 1, skip = 1)

setup[is.na(setup)] <- 0

setup

# Make csv file
write.csv(setup, '../output csv/TMP_food_waste_setup.csv', row.names = FALSE)

# Make rda file
setup <- setup[ , c('id', 'substrate', 'm.inoc', 'm.sub.vs')]

class(setup)
setup <- as.data.frame(setup)

TUMSetup <- setup

save(TUMSetup, file = '../output rda/TUMSetup.rda')


# Volume
vol <- read_excel('../data/TUM_food_waste.xlsx', sheet = 2, skip = 1)

class(vol)
vol <- as.data.frame(vol)

vol <- gather(vol, `blank1`, `blank2`, `blank3`, `cell1`, `cell2`, `cell3`, `fw1`, `fw2`, `fw3`, key = "id", value = "vol.mL")

# Make csv file
write.csv(vol, '../output csv/TMP_food_waste_vol.csv', row.names = FALSE)

# Make rda file
TUMvol <- vol

save(TUMvol, file = '../output rda/TUMVolCum.rda')
