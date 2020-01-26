# For testing gas density stuff
# S. Hafner

options(width = 70)

# Load data and functions
files <- list.files('../../biogas-package-GH/biogas/R', full.names = TRUE)
for(i in files) source(i)

files <- list.files('../../biogas-package-GH/biogas/data', full.names = TRUE)
for(j in files) load(j)

head(sludgeTwoBiogas)
dat <- sludgeTwoBiogas
dat$xCO2[dat$xCH4 + dat$xCO2 > 1] <- (1 - dat$xCH4)[dat$xCH4 + dat$xCO2 > 1]
dat$xN2 <- 1 - dat$xCH4 - dat$xCO2

args(calcBgGrav)
for(i in files) source(i)

cbgm2 <- calcBgGrav(dat = dat, 
           id.name = 'id', time.name = 'time.d', mass.name = 'mass.final', 
           xCH4.name = 'xCH4', xCO2.name = 'xCO2', xN2.name = 'xN2',
           temp = 30, pres = 1.5,
           pres.resid = 1,
           headspace = sludgeTwoSetup, vol.hs.name = 'vol.hs', cmethod = 'total')
cbgm1 <- calcBgGrav(dat = dat, 
           id.name = 'id', time.name = 'time.d', mass.name = 'mass.final', 
           xCH4.name = 'xCH4n', xCO2.name = 'xCO2', xN2.name = 'xN2',
           temp = 30, pres = 1.5,
           pres.resid = 1, cmethod = 'removed')


head(cbgm1)
head(cbgm2)

y <- merge(cbgm1, cbgm2, by = c('id', 'time.d'), suffixes = c('1', '2'))
head(y)
plot(vBg1 ~ vBg2, data = y)
abline(0, 1)
abline(0, 1.1)

plot(cvCH41 ~ cvCH42, data = y)
abline(0, 1)
abline(0, 1.05, col = 'red')

plot(vCH41 ~ vCH42, data = y)
abline(0, 1)
abline(0, 1.05, col = 'red')

# Very close!
