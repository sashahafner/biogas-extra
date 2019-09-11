# Sort data and then creates rda and CSV files
# Nanna Løjborg and Sasha D. Hafner

### Longcombo

library(plyr)
library(readxl)
library(tidyr)

## Setup
setup <- as.data.frame(read_excel('../data/UQ_WW_sludge.xlsx', sheet = 1))

names(setup) <- tolower(names(setup))

names(setup)[names(setup) == "bottle id"] <- "id"
names(setup)[names(setup) == "inoculum (g)"] <- "m.inoc"
names(setup)[names(setup) == "description"] <- "descrip"
names(setup)[names(setup) == "substrate vs mass (g)"] <- "m.sub.vs"
names(setup)[names(setup) == "total (g)"] <- "m.tot"
names(setup)[names(setup) == "headspace (ml)"] <- "vol.hs"

#setup$id <- paste(setup$'bottle id', setup$description)

# Select columns
setup <- setup[ , c('id', 'descrip', 'vol.hs', 'm.inoc', 'm.sub.vs')]

# Drop duplicate conditions (b)
setup <- setup[setup$id < 22, ]

# Make csv file
write.csv(setup, '../output csv/sludgeTwoSetup.csv', row.names = FALSE)

# Make rda file
class(setup)

sludgeTwoSetup <- setup

save(sludgeTwoSetup, file = '../output rda/sludgeTwoSetup.rda')


## Biogas
biogas <- as.data.frame(read_excel('../data/UQ_WW_sludge.xlsx', sheet = 2))

names(biogas)

biogas <- setNames(biogas, tolower(names(biogas)))

names(biogas)[names(biogas) == "bottle id"] <- "id"
names(biogas)[names(biogas) == "pressure (mbar)"] <- "pres"
names(biogas)[names(biogas) == "methane (%)"] <- "xCH4"
names(biogas)[names(biogas) == "co2(%)"] <- "xCO2"
names(biogas)[names(biogas) == "xch4"] <- "xCH4n"
names(biogas)[names(biogas) == "time (d)"] <- "time.d"
names(biogas)[names(biogas) == "initial mass (g)"] <- "mass.init"
names(biogas)[names(biogas) == "final mass (g)"] <- "mass.final"

biogas <- biogas[ , c('id', 'time.d', 'pres', 'mass.init', 'mass.final', 'xCH4', 'xCO2', 'xCH4n')]

biogas$xCH4 <- biogas$xCH4/100
biogas$xCO2 <- biogas$xCO2/100

## Convert pressure from mbar to kPa 
#biogas$pres <- biogas$pres*0.1

# Fill in first initial mass
biogas[biogas$time.d == 0, 'mass.init'] <- biogas[biogas$time.d == 0, 'mass.final']
biogas[biogas$time.d == 0, 'xCH4n'] <- 0

# Drop duplicate conditions (b)
biogas <- biogas[biogas$id < 22, ]

# Make csv file
write.csv(biogas, '../output csv/sludgeTwoBiogas.csv', row.names = FALSE)

# Make rda file
sludgeTwoBiogas <- biogas

save(sludgeTwoBiogas, file = '../output rda/sludgeTwoBiogas.rda')

