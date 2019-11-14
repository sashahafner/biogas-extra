# Make GD data set from Sergi's measurements

options(width = 65)

library(readxl)
library(lubridate)
library(dplyr)

fp <- '../data/UQ2_GD.xlsx'
setup <- as.data.frame(read_xlsx(fp, sheet = 1, skip = 1))
biogas  <- as.data.frame(read_xlsx(fp, sheet = 2, skip = 1))
water  <- as.data.frame(read_xlsx(fp, sheet = 3, skip = 1))

# Make id a factor instead of a character
biogas$id <- factor(biogas$id)
setup$id <- factor(setup$id)

# Add leading zeros
biogas$date <- sprintf('%08i', biogas$date)
biogas$time <- sprintf('%04i', biogas$time)   

# Make a date/time column
biogas$date.time <- dmy_hm(paste(biogas$date, biogas$time))
if (sum(is.na(biogas$date.time)) > 0) stop('Date/time problem date8771')

# Make a cummulative date.time column
biogas <- as.data.frame(mutate(group_by(biogas, id), start.time = min(date.time)))
biogas$time.d <- as.numeric(difftime(biogas$date.time, biogas$start.time, units = 'days'))

# Select columns
biogas <- biogas[, c('id', 'time.d', 'vol', 'mass.init', 'mass.final')]

setup <- setup[, c('id', 'descrip2', 'm.inoc', 'm.sub', 'm.tot', 'vol.hs',
                   'm.sub.vs', 'isr')]
names(setup)[names(setup) == 'descrip2'] <- 'descrip'

# Export
UQGDSetup <- setup
save(UQGDSetup, file = '../output rda/UQGDSetup.rda')

UQGDBiogas <- biogas
save(UQGDBiogas, file = '../output rda/UQGDBiogas.rda')

## Test biogas calculations
#library(biogas)
#options(unit.pres = 'mbar', pres.std = 1013.25)

## GD calculations
#cbg.gdt <- biogas:::cumBgGD(biogas,
#                   temp.vol = 20, pres.vol = 1013.25,
#                   temp.grav = 30, pres.grav = 1500,
#                   id.name = 'id', vol.name = 'vol',
#                   m.pre.name = 'mass.init', m.post.name = 'mass.final',
#                   comp.name = 'xCH4', time.name = 'time.d',
#                   vented.mass = FALSE, averaging = 'final', vmethod = 'vol',
#                   extrap = TRUE,
#                   addt0 = TRUE, showt0 = TRUE)
#
#
#BMP <- summBg(cbg.gdt, setup, id.name = "id",
#               time.name = 'time.d', descrip.name = 'descrip',
#               inoc.name = "Inoculum", inoc.m.name = "m.inoc", norm.name = "m.sub.vs",
#               when = 'end', extrap = TRUE, set.name = 'method')
#
#BMP
