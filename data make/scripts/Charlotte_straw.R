# Adds time (days) column, makes some other changes, then creates CSV files
# S. Hafner
# 22 May 2016

library(gdata)
library(lubridate)
library(plyr)

# Setup
setup <- read.xls('../master data/Charlotte_straw_TSR1.xlsx', sheet = 1)

setup

# Make CSV
write.csv(setup, '../output csvs/straw_setup.csv', row.names = FALSE)

# Make rda file
setup <- setup[ , c('bottle', 'treatment', 'start', 'sub.mass', 'inoc.mass', 'headspace')]
setup$headspace <- signif(setup$headspace, 4)

strawSetup <- setup

save(strawSetup, file = '../output rda/strawSetup.rda')

# Pressure
pressure <- read.xls('../master data/Charlotte_straw_TSR1.xlsx', sheet = 2)

head(pressure)

# Convert to kPa
pressure$pres <- pressure$pres*101325
pressure$pres.resid <- pressure$pres.resid*101325

pressure$time <- round(pressure$time, 2)

write.csv(pressure, '../output csvs/straw_pressure.csv', row.names = FALSE)

pressure <- pressure[ , c('bottle', 'date.time', 'time', 'pres', 'pres.resid')]

strawPressure <- pressure

save(strawPressure, file = '../output rda/strawPressure.rda')

# Mass
mass <- read.xls('../master data/Charlotte_straw_TSR1.xlsx', sheet = 3)

mass

write.csv(mass, '../output csvs/straw_mass.csv', row.names = FALSE)

mass$time <- round(mass$time, 2)

mass <- mass[ , c('bottle', 'date.time', 'time', 'mass')]

strawMass <- mass

save(strawMass, file = '../output rda/strawMass.rda')

# Composition
comp <- read.xls('../master data/Charlotte_straw_TSR1.xlsx', sheet = 4)

comp
head(comp)

comp$time <- round(comp$time, 2)
comp$xCH4 <- signif(comp$xCH4, 4)

write.csv(comp, '../output csvs/straw_comp.csv', row.names = FALSE)

comp <- comp[ , c('bottle', 'date.time', 'time', 'xCH4')]

strawComp <- comp

save(strawComp, file = '../output rda/strawComp.rda')
