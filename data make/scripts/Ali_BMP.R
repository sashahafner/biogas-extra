# Adds time (days) column, makes some other changes, then creates CSV files
# S. Hafner
# 22 May 2016

library(gdata)
library(lubridate)
library(plyr)

# Setup
setup <- read.xls('../master data/Ali_BMP.xlsx', sheet = 1)

setup <- setup[ , c('bottle', 'description', 'inoc_mass_g', 'sub_VS_mass_g')]

setup

write.csv(setup, '../output csvs/BMP_setup.csv', row.names = FALSE)

# Volume
vol <- read.xls('../master data/Ali_BMP.xlsx', sheet = 2)

vol

write.csv(vol, '../output csvs/BMP_vol.csv', row.names = FALSE)

# Composition
comp <- read.xls('../master data/Ali_BMP.xlsx', sheet = 3)

comp
head(comp)

write.csv(comp, '../output csvs/BMP_comp.csv', row.names = FALSE)

# Mean comp
comp.mn <- ddply(comp, 'bottle', summarise, CH4_frac = signif(mean(CH4_frac), 3))

write.csv(comp.mn, '../output csvs/BMP_one_comp.csv', row.names = FALSE)
