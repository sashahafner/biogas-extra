# Sort data and then creates CSV files
# Nanna Løjborg and Sasha D. Hafner
# 26 August 2019

### Longcombo

library(plyr)
library(readxl)
library(tidyr)

## Setup
setup <- read_excel('../data/UQ_WW_sludge.xlsx', sheet = 1)

colnames(setup)

setup <- setNames(setup, tolower(names(setup)))

names(setup)[names(setup) == "inoculum (g)"] <- "m.inoc"
names(setup)[names(setup) == "substrate vs mass (g)"] <- "m.sub.vs"
names(setup)[names(setup) == "total (g)"] <- "m.tot"
names(setup)[names(setup) == "headspace (ml)"] <- "vol.hs"

setup$id <- paste(setup$'bottle id', setup$description)

setup <- setup[ , c('bottle id', 'id', 'm.inoc', 'm.sub.vs', 'vol.hs')]

setup

# Make csv file
write.csv(setup, '../output csv/sludgeTwoBiogasSetup.csv', row.names = FALSE)

# Make rda file
class(setup)
setup <- as.data.frame(setup)

sludgeTwoSetup <- setup

save(sludgeTwoSetup, file = '../output rda/sludgeTwoSetup.rda')


## Pressure
pressure <- read_excel('../data/UQ_WW_sludge.xlsx', sheet = 2)

colnames(pressure)

pressure <- setNames(pressure, tolower(names(pressure)))

names(pressure)[names(pressure) == "pressure (mbar)"] <- "pres"
names(pressure)[names(pressure) == "xch4"] <- "xCH4"
names(pressure)[names(pressure) == "time (d)"] <- "time.d"

pressure <- pressure[ , c('bottle id', 'time.d', 'pres', 'xCH4')]

# Merge pressure and setup data frame to introduce 'id' column in pressure
pressure <- merge(pressure, setup, by = "bottle id")

pressure <- pressure[ , c('id', 'time.d', 'pres', 'xCH4')]

head(pressure)

# Convert to pressure from mbar to kPa 
pressure$pres <- pressure$pres*0.1

# Add residual pressure (gauge). Assumed to be atmospheric.
pressure$pres.resid <- 0


# Make csv file
write.csv(pressure, '../output csv/sludgeTwoBiogasPres.csv', row.names = FALSE)

# Make rda file
class(pressure)
pressure <- as.data.frame(pressure)

sludgeTwoBiogasPres <- pressure

save(sludgeTwoBiogasPres, file = '../output rda/sludgeTwoBiogasPres.rda')


## Mass
mass <- read_excel('../data/UQ_WW_sludge.xlsx', sheet = 2)

colnames(mass)

mass <- setNames(mass, tolower(names(mass)))

names(mass)[names(mass) == "initial mass (g)"] <- "mass.init"
names(mass)[names(mass) == "final mass (g)"] <- "mass.final"
names(mass)[names(mass) == "xch4"] <- "xCH4"
names(mass)[names(mass) == "time (d)"] <- "time.d"

# Merge mass and setup data frame to introduce 'id' column in mass
mass <- merge(mass, setup, by = "bottle id")

mass <- mass[ , c('id', 'time.d', 'mass.init', 'mass.final', 'xCH4')]

mass

mass$mass <- mass$mass.init - mass$mass.final

mass <- na.omit(mass)

# Make csv file
write.csv(mass, '../output csv/sludgeTwoBiogasMass.csv', row.names = FALSE)

# Make rda file
class(mass)

sludgeTwoBiogasMass <- mass

save(sludgeTwoBiogasMass, file = '../output rda/sludgeTwoBiogasMass.rda')

