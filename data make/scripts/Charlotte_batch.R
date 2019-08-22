# Adds time (days) column, makes some other changes, then creates CSV files
# S. Hafner, modified 30/05/2016 C. Rennuit
# 31 May 2016

library(gdata)
library(lubridate)
library(plyr)

# Mass data has starting times, start with it
mass <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 4)

mass <- subset(mass, exper == 'rs2')

mass$date.time <- dmy_hm(paste(mass$date, mass$time))

mass <- ddply(mass, 'bottle', transform, start = min(date.time))

starts <- ddply(mass, 'bottle', summarise, start = min(date.time))

mass$days = signif(as.numeric(difftime(mass$date.time, mass$start, units = 'days')), 4)

mass <- mass[order(mass$date.time, mass$bottle), ]

head(mass)
tail(mass)

mass <- mass[ , c('date', 'time', 'days', 'bottle', 'mass')]

mass <- na.omit(mass)

write.csv(mass, '../output csvs/rs2_mass.csv', row.names = FALSE)

# Volume next
vol <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 2)
vol <- subset(vol, exper == 'rs2')

dfsumm(vol)

vol$date.time <- dmy_hm(paste(vol$date, vol$time))
vol <- merge(vol, starts)
head(vol)

vol$days = signif(as.numeric(difftime(vol$date.time, vol$start, units = 'days')), 4)

head(vol)
vol <- vol[ , c('date', 'time', 'days', 'bottle', 'vol')] 

vol <- vol[order(vol$days, vol$bottle), ]
head(vol)

write.csv(vol, '../output csvs/rs2_vol.csv', row.names = FALSE)

# Composition
comp <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 3, as.is = TRUE)
comp <- subset(comp, exper == 'rs2' & tolower(bottle) != 'st' )
comp$bottle <- as.integer(comp$bottle)

dfsumm(comp)
table(comp$bottle)

comp$date.time <- dmy_hm(paste(comp$date, comp$time))
comp <- merge(comp, starts)
head(comp)

comp$days = signif(as.numeric(difftime(comp$date.time, comp$start, units = 'days')), 4)

head(comp)

comp <- comp[order(comp$date.time, comp$bottle), ]

head(comp)

comp <- comp[ , c('bottle', 'date', 'time', 'days', 'xCH4')]

write.csv(comp, '../output csvs/rs2_comp.csv', row.names = FALSE)

# Setup
setup <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 1, as.is = TRUE)
setup <- subset(setup, exper == 'rs2')
setup

setup <- merge(setup, starts)

setup

descrips <- c(dig = 'digestate 2', sss = 'solids', cellu = 'cellulose', 
              inoc = 'inoculum', 'D+F' = 'digestate 1 + waste mix', 
              'S+F' = 'solids + waste mix', 'Ss+F' = 'stored solids + waste mix',
              'D+F+Ss' = 'digestate 2 + stored solids + waste mix')

setup$descrip <- descrips[setup$trt]

setup

setup <- setup[ , c('bottle', 'tare', 'descrip', 'start')]

write.csv(setup, '../output csvs/rs2_setup.csv', row.names = FALSE)

####
# Mass data has starting times, start with it
mass <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 4)

mass <- subset(mass, exper == 'tad4')

mass$date.time <- dmy_hm(paste(mass$date, mass$time))

mass <- ddply(mass, 'bottle', transform, start = min(date.time))

starts <- ddply(mass, 'bottle', summarise, start = min(date.time))

mass$days = signif(as.numeric(difftime(mass$date.time, mass$start, units = 'days')), 4)

mass <- mass[order(mass$date.time, mass$bottle), ]

head(mass)
tail(mass)

dfsumm(mass)

mass <- mass[ , c('date', 'time', 'days', 'bottle', 'mass')]



mass <- na.omit(mass)

write.csv(mass, '../output csvs/tad4_mass.csv', row.names = FALSE)

# Setup
setup <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 1, as.is = TRUE)
setup <- subset(setup, exper == 'tad4')
setup

setup <- merge(setup, starts)

setup

setup$descrip <- setup$trt

setup

setup <- setup[ , c('bottle', 'tare', 'descrip', 'start')]

write.csv(setup, '../output csvs/tad4_setup.csv', row.names = FALSE)

# Volume next
vol <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 2)
vol <- subset(vol, exper == 'tad4')

dfsumm(vol)

vol$date.time <- dmy_hm(paste(vol$date, vol$time))
vol <- merge(vol, starts)
head(vol)

vol$days = signif(as.numeric(difftime(vol$date.time, vol$start, units = 'days')), 4)

head(vol)
vol <- vol[ , c('date', 'time', 'days', 'bottle', 'vol')] 

vol <- vol[order(vol$days, vol$bottle), ]
head(vol)

write.csv(vol, '../output csvs/tad4_vol.csv', row.names = FALSE)

# Biogas composition
comp <- read.xls('../master data/Charlotte_batch.xlsx', sheet = 3)
comp <- subset(comp, exper == 'tad4')

dfsumm(comp)

comp$date.time <- dmy_hm(paste(comp$date, comp$time))
comp <- merge(comp, starts)
head(comp)

comp$days = signif(as.numeric(difftime(comp$date.time, comp$start, units = 'days')), 4)

head(comp)
comp <- comp[ , c('date', 'time', 'days', 'bottle', 'xCH4')] 

comp <- comp[order(comp$days, comp$bottle), ]
head(comp)

write.csv(comp, '../output csvs/tad4_comp.csv', row.names = FALSE)


