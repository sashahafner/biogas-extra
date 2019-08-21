# For testing the biogas functions while writing help files
# S. Hafner

options(width = 65)
library(ggplot2)

files <- list.files('biogas/R', full.names = TRUE)
for(i in files) source(i)
# NTS: if there is ever an error from old code, delete the stupid xxx.R~ files from Gedit!

files <- list.files('biogas/data', full.names = TRUE)
for(j in files) load(j)

#library(biogas)
library(ggplot2)

#------------------------------------------------------------

# gasDens()

gasDens('N2')
gasDens('CO2')
gasDens('CH4')
gasDens('H2')
gasDens('1N2:1CO2')
gasDens('40CO2:60N2')
gasDens('20CO2:80N2')
gasDens('1.5CO2:1N2')
gasDens('3CO2:2N2')
# Bigoas
gasDens('65CH4:35CO2')

# GDComp

arg(GDComp)
GDComp(1.07, 779, temp = 30, pres = 1.5)
GDComp(1.07, 779, temp = 30, pres = 1.5, vol.hs = 200, headcomp = 'N2', temp.init = 20, pres.init = 1)
# But no effect here:
GDComp(1.0, 779, temp = 30, pres = 1.5)
GDComp(1.0, 779, temp = 30, pres = 1.5, vol.hs = 200, headcomp = 'N2', temp.init = 20, pres.init = 1)
# Try different gas
x0 <- GDComp(2.39, 2030, temp = 30, pres = 1.5)
x1 <- GDComp(2.39, 2030, temp = 30, pres = 1.5, vol.hs = 380, headcomp = 'N2', temp.init = 20, pres.init = 1)
x2 <- GDComp(2.39, 2030, temp = 30, pres = 1.5, vol.hs = 380, headcomp = '40CO2:60N2', temp.init = 20, pres.init = 1)
x3 <- GDComp(2.39, 2030, temp = 30, pres = 1.5, vol.hs = 380, headcomp = '20CO2:80N2', temp.init = 20, pres.init = 1)
x1/x0
x2/x0
x3/x0


# Test new dat.type = 'gca' method
# Ilona data!
biogas  <- read.csv('GCA/Ilona_biogas.csv', skip = 1)

cp <- cumBg(biogas, id.name = 'id', time.name = 'time.d', dat.name = 'n1', mol.f.name = 'n2', vol.syr= 0.25,
            headspace = 58, dat.type = 'gca')

cp

png('GCA/Ilona.png', height = 4, width = 5, units = 'in', res = 400)
  print(ggplot(cp, aes(time.d, cvCH4, colour = id)) + geom_line() + geom_point())
dev.off()

# Test with different headspace for each bottle
setup <- data.frame(id = unique(biogas$id), vol.hs = 58)

head(biogas)

cp2 <- cumBg(biogas, id.name = 'id', time.name = 'time.d', dat.name = 'n1', mol.f.name = 'n2', vol.syr= 0.25,
            headspace = setup, vol.hs.name = 'vol.hs', dat.type = 'gca')

cp2
all.equal(cp, cp2)

head(cp2)

# Generate some data--two bottles with identical results
# Units for n1 and n2 are micromoles of CH4
biogas <- data.frame(id = rep(c('A', 'B'), each = 5), 
                     time.d = rep(1:5, 2), 
                     n1 = rep(c(1.1, 2.4, 3.8, 5.9, 2.3), 2), 
                     n2 = rep(c(NA, NA, NA, 1.2, NA), 2))

# Bottles were vented after the measurements on day 4
biogas

# Syringe volume is 0.25 mL
# Headspace volume is 50 mL

cp <- cumBg(biogas, id.name = 'id', time.name = 'time.d', 
            dat.name = 'n1', mol.f.name = 'n2', vol.syr= 0.25,
            headspace = 50, dat.type = 'gca')
cp

# Suppose the bottles had two difference headspace volumes
setup <- data.frame(id = c('A', 'B'), vol.hs = c(50, 60))

cp2 <- cumBg(biogas, id.name = 'id', time.name = 'time.d', 
            dat.name = 'n1', mol.f.name = 'n2', vol.syr= 0.25,
            headspace = setup, vol.hs.name = 'vol.hs', dat.type = 'gca')
cp2

# Test multiple when in summBg() (if problem)
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

#library(ggplot2)
#plotCumBg(cum.prod, x = 'days', groups = 'bottle', palette = 'YlOrRd')

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 1:3)
s1

# New split cumBg functions
cum.prod <- cumBgVol(vol2, comp = comp2, temp = 20, pres = 1, id.name = "bottle", time.name = "days", dat.name = "meas.vol", comp.name = "CH4.conc", extrap = TRUE, quiet = TRUE)

cum.prod <- cumBgVol(s3lcombo, temp = 25, pres = 1, id.name = 'id', time.name = 'time.d', data.struct = 'longcombo', dat.name = 'vol.ml', comp.name = 'xCH4', extrap = TRUE)

# Test 1p option in summBg()
# Selects BMP times where rate of (inoculum-corrected) production is <= 1% of cumulative
# First need to calculate cumulative methane production data
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE, quiet = TRUE)

#library(ggplot2)
#plotCumBg(cum.prod, x = 'days', groups = 'bottle', palette = 'YlOrRd')

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d')
s1
attributes(s1)

# Add minimum

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d', when.min = 30)
s1

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d', rate.crit = 'gross')
s1
attributes(s1)




summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d')

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p5d')
s1
attributes(s1)



# Note: to get rates use show.rates  and when no longer matters
x <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 10, show.rates = TRUE)

head(x)
tail(x)

ggplot(x, aes(days, cvCH4, colour = bottle)) + geom_line()

s2 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '0.5p')

s2



# Check relative rates with show.obs

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p', show.obs = TRUE)
head(s1)

s2 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p', show.more = TRUE)


tail(s1)
subset(s1, bottle == '2_1' & days > 20)

cp <- subset(cum.prod, days < 6)

s1 <- summBg(vol = cp, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d', show.rates = TRUE)

tail(s1)

# But this should give a warning

cp <- subset(cum.prod, days < 20)
s1 <- summBg(vol = cp, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d')

s1
attributes(s1)

s2 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 'meas')

s2

#plotBg(s2, x = 'days', y = 'mean', groups = 'description', sd = 'sd', 
#          xlab = 'Time (d)', ylab = expression(CH[4]))

# Compare to rates calculated manually
s <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       when = 'meas')
s$v <- s$mean
s$r <- c(NA, diff(s$v)/diff(s$days))/s$v*100
subset(s, description == 'Slaughterhouse waste')
subset(s, description == 'Cellulose')

# Without subtracting inoculum
s2 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       when = '1p')

s2

# Test input vol list in summBg()
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		              dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

cbg2 <- cum.prod
cbg2$cvCH4 <- cbg2$cvCH4/2
cpl <- list(e1 = cum.prod, e2 = cbg2)

s1 <- summBg(vol = cpl, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30)
s1

s1 <- summBg(vol = cpl, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30, set.name = 'test')
s1

# Test multiple response variables in summBg()

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
             vol.name = c('cvBg', 'cvCH4', 'rvCH4'),
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30, show.obs = TRUE)
s1

# Compare to
s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
             vol.name = 'rvCH4',
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30, show.obs = TRUE)
s1


# Without show.obs
s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
             vol.name = c('cvBg', 'cvCH4', 'rvCH4'),
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30, show.obs = FALSE)
s1

# But for 1p3d, only makes sense to use cv response
s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
             vol.name = c('cvBg', 'cvCH4'),
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d', show.obs = FALSE)
s1

# Try all times
s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
             vol.name = c('cvBg', 'cvCH4'),
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 'meas', show.obs = FALSE)
head(s1)

s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
             vol.name = c('cvBg', 'cvCH4'),
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 'meas', show.obs = TRUE)
head(s1)
tail(s1)



#----------------------------------------------------------------
# Test VS SD in setup
# First need to calculate cumulative methane production data
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

head(cum.prod)

# Cumulative CH4 production at 30 d, subtract inoculum contribution 
# and normalise by sub.vs column (mass of substrate VS here) (look at setup2).
# Without SD
s1 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 'end', show.more = TRUE)

attributes(s1)

# With VS SD
setup2$sub.vs.sd <- 1
s2 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", norm.sd.name = 'sub.vs.sd', when = 'end')

# Set sd to about 1/2 of shw VS
setup2$sub.vs.sd <- 3.6
s3 <- summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", norm.sd.name = 'sub.vs.sd', when = 'end')


# Compare
s1
s2
s3

# Looks good!
#-----------------------------------------------------------------------

# 2. data.struct argument

# Wide first
# Note that there are missing values in comp
#s3vol <- read.csv('../biogas_apps/TestData/sludge3_vol_wide.csv', skip = 1)
#s3comp <- read.csv('../biogas_apps/TestData/sludge3_comp_wide.csv', skip = 1)
#s3vol <- read.csv('C:/Users/cre/Dropbox/biogas_apps/TestData/sludge3_vol_wide.csv', skip = 1)
#s3comp <- read.csv('C:/Users/cre/Dropbox/biogas_apps/TestData/sludge3_comp_wide.csv', skip = 1)

s3volw
s3compw

data(s3volw)
data(s3compw)

cpw <- cumBg(s3volw, comp = s3compw, temp = 25, pres = 1,
            data.struct = 'wide', dat.name = 'D',
            comp.name = 'D', id.name = 'id', time.name = 'time.d', 
            check = FALSE, extrap = TRUE)
head(cpw)

# And with numeric comp?
cpw2 <- cumBg(s3vol, comp = 0.7, temp = 25, pres = 1,
            data.struct = 'wide', dat.name = 'D',
            id.name = 'id', time.name = 'ct', 
            check = FALSE, extrap = TRUE)
cpw2

# Now longcombo
# Some missing xCH4 values
#dat <- read.csv('../biogas_apps/TestData/sludge3_longcombo.csv', skip =1)
#dat <- read.csv('C:/Users/cre/Dropbox/biogas_apps/TestData/sludge3_longcombo.csv', skip =1)

# longcombo
s3lcombo

cplc <- cumBg(s3lcombo, temp = 25, pres = 1,
                  id.name = 'id', time.name = 'time.d',
                  data.struct = 'longcombo',
                  dat.name = 'vol.ml', comp.name = 'xCH4',
                  extrap = TRUE)

# Compare wide and longcombo to long (default)
s3voll
s3compl

cpl <- cumBg(s3lcombo, comp = s3compl, temp = 25, pres = 1,
                  id.name = 'id', time.name = 'time',
                  dat.name = 'vol', comp.name = 'xCH4',
                  extrap = TRUE)

# May not be identical because times differ between wide and long formats
# Not that cpw2 not included because the composition is fixed
cbind(cpl$cvCH4, cpw$cvCH4, cplc$cvCH4)

#-------------------------------------------------------------------------
# Help file tests of data struct

cum.prod <- cumBg(s3volw, comp = s3compw, temp = 25, pres = 1,
                  time.name = 'time.d',
                  data.struct = 'wide',
                  dat.name = 'D', comp.name = 'D',
                  extrap = TRUE)

cum.prod

# longcombo
s3lcombo

cum.prod <- cumBg(s3lcombo, temp = 25, pres = 1,
                  id.name = 'id', time.name = 'time.d',
                  data.struct = 'longcombo',
                  dat.name = 'vol.ml', comp.name = 'xCH4',
                  extrap = TRUE)

# Compare wide and longcombo to long (default)
s3voll
s3compl

cum.prod <- cumBg(s3lcombo, comp = s3compl, temp = 25, pres = 1,
                  id.name = 'id', time.name = 'time.d',
                  dat.name = 'vol.ml', comp.name = 'xCH4',
                  extrap = TRUE)

cum.prod

#----------------------------------------------------------------------
# Problem in summBg() help file

# First need to calculate cumulative methane production data
cum.prod <- cumBg(vol, comp = comp, temp = 20, pres = 1, 
                  time.name = "days", extrap = TRUE)

head(cum.prod)

# Cumulative methane production at 30 d (default) 
# Uses default names for some columns
summBg(vol = cum.prod, setup = setup, time.name = "days", when = 30)

# Or total cumulative biogas
summBg(vol = cum.prod, setup = setup, time.name = "days", 
       vol.name = "cvBg", when = 30)

# Cumulative CH4 only, subtract inoculum contribution
summBg(vol = cum.prod, setup = setup, time.name = "days", 
       inoc.name = "inoc", inoc.m.name = 'minoc', when = 30)





#--------------------------------------------------------------------------
# Test temp and pressure arguments as dat columns
cprod1 <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)

vol$temperature <- 20
vol$pressure <- 1
cprod2 <- cumBg(vol, temp = 'temperature', pres = 'pressure', comp = comp, time.name = 'days', extrap = TRUE)

head(cprod1)
head(cprod2)

all.equal(cprod1, cprod2)

# Change some values
vol$temperature[10] <- 15
vol$pressure[11] <- 1.1

cprod3 <- cumBg(vol, temp = 'temperature', pres = 'pressure', comp = comp, time.name = 'days', extrap = TRUE)

all.equal(cprod1, cprod3)
cbind(cprod1$vCH4, cprod3$vCH4)[1:12,]
# Looks reasonable

# All values differ
vol$temperature <- rnorm(nrow(vol), 20, 5)
vol$pressure <- rnorm(nrow(vol), 1, 0.05)
cprod4 <- cumBg(vol, temp = 'temperature', pres = 'pressure', comp = comp, time.name = 'days', extrap = TRUE)

all.equal(cprod1, cprod4)
plot(cprod1$vBg, cprod4$vBg)
abline(0, 1)
# Works

#------------------------------------------------------------------
# Manometric method

# With absolute pressure
cp1 <- cumBg(strawPressure, dat.type = 'pres', comp = strawComp, 
               temp = 35, 
               id.name = 'bottle', time.name ='time', 
               dat.name = 'pres', comp.name = 'xCH4',
               pres.resid = 'pres.resid', temp.init = 20, pres.init = 101.325,
               headspace = strawSetup, vol.hs.name = 'headspace', 
               extrap = TRUE, 
               unit.pres = 'kPa', pres.std = 101.325)

head(cp1)

# Try residual RH of 100%
cp1a <- cumBg(strawPressure, dat.type = 'pres', comp = strawComp, 
               temp = 35, 
               id.name = 'bottle', time.name ='time', 
               dat.name = 'pres', comp.name = 'xCH4',
               pres.resid = 'pres.resid', temp.init = 20, pres.init = 101.325,
               rh.resid = 1,
               headspace = strawSetup, vol.hs.name = 'headspace', 
               extrap = TRUE, 
               unit.pres = 'kPa', pres.std = 101.325)


head(cp1)
head(cp1a)

plot(cp1$cvCH4, cp1a$cvCH4)
abline(0, 1)
abline(0, 1.05, col = 'red')

# Try gauge pressure
sp <- strawPressure
sp$pres <- sp$pres - 101.325
sp$pres.resid <- sp$pres.resid - 101.325

cp2 <- cumBg(sp, dat.type = 'pres', comp = strawComp, 
               temp = 35, 
               id.name = 'bottle', time.name ='time', 
               dat.name = 'pres', comp.name = 'xCH4',
               pres.resid = 'pres.resid', temp.init = 20, pres.init = 0,
               absolute = FALSE,
               pres.amb = 101.325,
               headspace = strawSetup, vol.hs.name = 'headspace', 
               extrap = TRUE, 
               unit.pres = 'kPa', pres.std = 101.325)

head(cp1)
head(cp2)
x <- cbind(cp1$vCH4, cp2$vCH4, cp1$id, cp1$vCH4 -  cp2$vCH4)
cp1$vCH4 -  cp2$vCH4
head(x)
head(cp2)
options(width = 65)
# Looks great

# Mixed venting/no venting with imethod = 'f1'
# Manometric data only

dd <- data.frame(id = 'A', time = 0:9, pres = c(1 + 0:9/5), pres.resid = c(1 + 0:9/5), xCH4 = c(NA, NA, NA, 0.3, NA, NA, NA, NA, NA, 0.5))
hs <- data.frame(id = 'A', vol.hs = 100)
dd

args(cumBg)
cp3 <- cumBg(dd, dat.type = 'pres', pres.resid = 'pres.resid',
             data.struct = 'longcombo',
             comp.name = 'xCH4', temp = 35, 
             headspace = hs, imethod = 'f1', temp.init = 35, pres.init = 1)
cp3

# Approximate expected final cvCH4
1.8/1 * 0.85 * 100
plot(cvCH4 ~ time, data = cp3)
plot(vCH4 ~ time, data = cp3)
interp

# Pierre's data
# WIP, checking new cumBg() code for method 2 (cmethod total)
##library(biogas)
pvol <- read.csv('pierre.csv')
pvol <- subset(pvol, id == 1)
cp <- cumBg(pvol, dat.type = 'pres', data.struct = 'longcombo',
               temp = 'temp', 
               id.name = 'id', time.name ='time', 
               dat.name = 'pres', comp.name = 'xCH4',
               pres.resid = 'pres.resid', temp.init = 32, pres.init = 1057,
               absolute = TRUE,
               pres.amb = 1013.25,
               headspace = 789.4,
               cmethod = 'total',
               extrap = TRUE, 
               #rh.resid = 1,
               unit.pres = 'mbar')
cp
343.94/340.07


#---------------------------------------------------------------------
# Test new (8 Jan 2019) mixed cum/interval vol data
# WIP
vol <- data.frame(time = 1:10, id = rep('A', 10), vol = c(1:5*10, 1:5*10), xCH4 = c(rep(NA, 4), 0.6, rep(NA, 4), 0.7),
                  emptied = c(rep(FALSE, 4), TRUE, rep(FALSE, 5)))
vol

# Or with NA now!
vol <- data.frame(time = 1:10, id = rep('A', 10), vol = c(1:5*10, 1:5*10), xCH4 = c(rep(NA, 4), 0.6, rep(NA, 4), 0.7),
                  emptied = c(rep(NA, 4), TRUE, rep(NA, 5)))
vol

cbg <- cumBg(vol, data.struct = 'longcombo', comp.name = 'xCH4', empty.name = 'emptied', temp = 0, pres = 1, 
             dry = TRUE, extrap = TRUE)
cbg

# Test correct adding when T or P vary
vol <- data.frame(time = 1:10, id = rep('A', 10), vol = c(1:5*10, 1:5*10), xCH4 = c(rep(NA, 4), 0.6, rep(NA, 4), 0.7),
                  emptied = c(rep(NA, 4), TRUE, rep(NA, 5)),
                  temp = c(55, 45, 35, 25, 0, 0, 0, 35, 35, 35), pres = 1)
vol

cbg <- cumBg(vol, data.struct = 'longcombo', comp.name = 'xCH4', empty.name = 'emptied', temp = 'temp', pres = 'pres', 
             dry = TRUE, extrap = TRUE)
cbg

# What should imethod be?
# f1 is closest to truth I think, because there what happened before venting has no bearing on xCH4 after (gas is lost, not mixed in)
cbg <- cumBg(vol, data.struct = 'longcombo', comp.name = 'xCH4', empty.name = 'emptied', temp = 0, pres = 1, 
             dry = TRUE, extrap = TRUE, imethod = 'f1')
cbg

#---------------------------------------------------------------------
# Other tests: haven't looked at these in months :(

# cmethod = 'total' (now beta)
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE, cmethod = 'total',
                  headspace = 100)

head(cum.prod)

cum.prod2 <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

plot(cum.prod$cvCH4, cum.prod2$cvCH4)
abline(0, 1)

# Missing argument error check

# Missing comp, no error
cum.prod <- cumBg(vol2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

head(cum.prod)

# Missing temp
cum.prod <- cumBg(vol2, comp = comp2, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

head(cum.prod)


# 'when' too large
# First need to calculate cumulative methane production data
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

head(cum.prod)

# Cumulative CH4 production at 30 d, subtract inoculum contribution 
# and normalise by sub.vs column (mass of substrate VS here) (look at setup2).
summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 200)


# Check cumulative option
library(plyr)
vol2 <- vol2[order(vol2$bottle, vol2$days), ]
vol2cum <- ddply(vol2, 'bottle', transform, volcum = cumsum(meas.vol))
vol2cum

cum.prod1 <- cumBg(vol2cum, comp = 0.7, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "volcum",
                  extrap = TRUE, interval = FALSE)

head(cum.prod1)

cum.prod2 <- cumBg(vol2cum, comp = 0.7, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol",
                  extrap = TRUE)
head(cum.prod2)

all.equal(cum.prod1, cum.prod2)

plot(cum.prod1$vCH4, cum.prod2$vCH4)

# First need to calculate cumulative methane production data
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  dat.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)

head(cum.prod)

# Cumulative CH4 production at 30 d, subtract inoculum contribution 
# and normalise by sub.vs column (mass of substrate VS here) (look at setup2).
summBg(vol = cum.prod, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30)

traceback()

vmch4 <- 22360.588
vmco2 <- 22263.009
  res <- data.frame(id = rep('R_1', 6), time = c(0:5), vol = c(0, rep(20, 5)), xCH4 = c(NA, rep(0.6, 5)))
  res$vBg <- stdVol(c(0, rep(20,5)), temp = 35, pres = 1)
  res$vCH4 <- res$vBg*0.6*vmch4 / (0.6*vmch4 + 0.4*vmco2) 
  res$cvBg <- rep(0,6)
  for(i in 2:6){
    res[i, 'cvBg'] = res[i, 'vBg'] + res[i-1, 'cvBg'] 
  }
  res$cvCH4 <- res$cvBg*0.6*vmch4/ (0.6*vmch4 + 0.4*vmco2)
  res$rvBg <- c(NA, res[2:6, 'vBg']) # because time interval = 1
  res$rvCH4 <- c(NA, res[2:6, 'vCH4'])
  
  # add a reactor to res data frame 
  test.sum1 <- cbind(res[, 1:4], res[, -c(1:4)]*1.2)
  test.sum1$vol <- test.sum1$vol*1.2
  test.sum1$id <- rep('R_2', 6)
  
  test.sum2 <- cbind(res[, 1:4], res[, -c(1:4)]*3)
  test.sum2$vol <- test.sum2$vol*3
  test.sum2$id <- rep('R_3', 6)
  
  test.sum3 <- cbind(res[, 1:4], res[, -c(1:4)]*3.3)
  test.sum3$vol <- test.sum3$vol*3.3
  test.sum3$id <- rep('R_4', 6)
  
  test.sum <- rbind(res, test.sum1)
  test.sum <- rbind(test.sum, test.sum2)
  test.sum <- rbind(test.sum, test.sum3)

  setup <- data.frame( id = c('R_1', 'R_2', 'R_3', 'R_4'), descrip = c('inoc', 'inoc', 'A', 'A')) 
  
  res.test.sum <- 
    data.frame (descrip = c('inoc', 'A'), 
                time = c(5,5), 
                mean = 
                  c(mean(test.sum[test.sum$time == 5 & test.sum$id %in% c('R_1', 'R_2'), 'cvCH4']), 
                    mean(test.sum[test.sum$time == 5 & test.sum$id %in% c('R_3', 'R_4'), 'cvCH4']))
                )
  expect_equal(summBg(test.sum, setup, when = 5, sort = FALSE)[, 1:3], res.test.sum)


# Complex molMass (or predBg()) calls
molMass('CH3(CH2)3COOH')
molMass('CH3(CH2)1.79999COOH')
molMass('CdSiO3')
molMass('FeSO4(H2O)7')
molMass('(CHOOH)0.5 (CH3COOH)0.5')
predBg('(CHOOH)0.5 (CH3COOH)0.5')

# Konrad's dog food
args(sink)
sink('x.x', e)
predBg(mcomp = c(carbohydrate = 0.493, protein = 0.25, lipid = 0.16, ash = 0.062))
predBg(mcomp = c(carbohydrate = 0.493, protein = 0.25, lipid = 0.16, ash = 0.062), mass = 1)
predBg(mcomp = c(carbohydrate = 0.493, protein = 0.25, lipid = 0.16, ash = 0.097))
predBg(mcomp = c(carbohydrate = 0.493, C4H6.1O1.2N = 0.25, C51H98O6 = 0.16, ash = 0.097))
predBg(mcomp = c(carbohydrate = 0.493, C3.3H6.8O2NS0.003 = 0.25, C51H98O6 = 0.16, ash = 0.097))
sink()


setup <- setup[order(setup$descrip, decreasing = TRUE),]

cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)
summBg(vol = cprod, setup = setup, when = 30, time.name = 'days', inoc.name = 'inoc')
summBg(vol = cprod, setup = setup, when = 30, time.name = 'days', inoc.name = 'inoc', sort = FALSE)

vol <- subset(vol, days < 4)
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)

summBg(vol = cprod, setup = setup, when = 'meas', time.name = 'days', inoc.name = 'inoc')

summBg(vol = cprod, setup = setup, when = 10, time.name = 'days') # No results as expected
summBg(vol = cprod, setup = setup, when = 10, time.name = 'days', extrap = TRUE) # But why would you want to?

summBg(vol = cprod, setup = setup, when = 2, time.name = 'days')
 
summBg(vol = cprod, setup = setup, when = 'meas', time.name = 'days', inoc.name = 'inoc')
summBg(vol = cprod, setup = setup, when = 'end', time.name = 'days', inoc.name = 'inoc')

summBg(vol = cprod, setup = setup, when = 'meas', time.name = 'days', inoc.name = 'inoc', norm.name = 'mvs.sub')

summBg(vol = cprod, setup = setup, when = 'one.obs', time.name = 'days', inoc.name = 'inoc', norm.name = 'mvs.sub')

cum.prod <- cumBg(vol, comp = comp, temp = 20, pres = 1, id.name = "id", time.name = "days", 
                       comp.name = "xCH4", dat.name = "vol", extrap = TRUE)
     head(cum.prod)

unique(comp$id)
   

head(mass)
mass$mass[1:3] <- 1100

cum.prod <- cumBg(mass, dat.type = "mass", comp = comp, temp = 35, pres = 1, time.name = "days")
head(cum.prod, 10)


vol2mol(22400, 'CH4', 25, pres = 1)
vol2mol(22400, 'CH4', 0, pres = 1)
vol2mol(22400, 'H2O', 25, pres = 1)

# Compare to NIST values
vol2mol(1000, 'CH4', 0, pres = 1, unit.temp = 'C', unit.pres = 'atm')
# Expect 0.044722
vol2mol(1000, 'CH4', 298.8, pres = 1, unit.temp = 'K', unit.pres = 'atm')
vol2mol(1000, 'CH4', 308.21, pres = 1, unit.temp = 'K', unit.pres = 'atm')
vol2mol(1000, 'CH4', 328.16, pres = 1, unit.temp = 'K', unit.pres = 'atm')
# Max difference of 0.1133% at 55C

head(vol)
head(comp)

predBg(mcomp = c(vfa = 0.5, lipid = 0.4, protein = 0.1), value = 'all')


predBg(mcomp = c(vfa = 0.5, lipid = 0.4, protein = 0.1), value = 'reactionc')

# Ash in mcomp
predBg(mcomp = c(carbohydrate = 0.5, NaCl = 0.5), value = 'reactionn')
predBg(mcomp = c(carbohydrate = 0.5, NaCl = 0.5), value = 'CH4')
predBg(mcomp = c(carbohydrate = 1), value = 'CH4')
predBg(mcomp = c(carbohydrate = 0.5, NaCl = 0.5), value = 'all', mass = 1)
predBg(mcomp = c(carbohydrate = 0.5), value = 'all', mass = 1)
predBg(mcomp = c(carbohydrate = 1), value = 'all')
predBg(mcomp = c(carbohydrate = 0.5, ash = 0.5), value = 'all')

x <- predBg(mcomp = c(vfa = 1))
y <- predBg(mcomp = c(lipid = 1))
predBg(mcomp = c(vfa = 0.5, lipid = 0.5), value = 'all')
predBg(mcomp = c(vfa = 0.5, lipid = 0.5))
mean(c(x, y))
predBg('C1.2H5.4', value = 'all')
predBg('C1H5', value = 'all')

predBg('C6H12O6', fs = 0.1, value = 'reactionn')
predBg(c('C6H12O6', 'CH4'), fs = 0.1, value = 'reactionn')

predBg('C6H12O6', fs = 0.1, value = 'reactionc')
predBg(c('C6H12O6', 'CH4'), fs = 0.1, value = 'reactionc')

predBg(mcomp = c(vfa = 0.5, lipid = 0.5, CO2 = 0.1, C6H12O6 = 0.1))
predBg(mcomp = c(cellulose = 5, CO2 = 1, glucose = 0.1), value = 'all')

predBg()

# New COD options
predBg(COD = 1, value = 'all')
predBg('C6H12O6', COD = 1, value = 'all')

# Calculate cumulative production and rates from vol and comp
cum.prod <- cumBg(vol, comp = comp, temp = 20, pres = 1, id.name = "id", time.name = "days", comp.name = "xCH4", dat.name = "vol")
head(cum.prod)

# In this case, we can use default values for some column names, so this call is identical
cum.prod <- cumBg(vol, comp = comp, temp = 20, pres = 1, time.name = "days")

# Plot results
library(ggplot2)
qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", ylab = "Cumulative methane production (mL)",color = id, geom = "line")

# Omit added time zero rows
cum.prod <- cumBg(vol, comp = comp, temp = 20, pres = 1, time.name = "days", showt0 = FALSE)
head(cum.prod)

qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", ylab = "Cumulative methane production (mL)",color = id, geom = "line")

# Previous is different from never adding them in the first place (rates not calculated for first observations here)
cum.prod <- cumBg(vol, comp = comp, temp = 20, pres = 1, time.name = "days", addt0 = FALSE)
head(cum.prod)

qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", ylab = "Cumulative methane production (mL)",color = id, geom = "line")

# Can use POSIX objects for time (but cumBg cannot add t0 rows here)
class(vol$date.time)
class(comp$date.time)
cum.prod <- cumBg(vol, comp = comp, temp = 20, pres = 1, time.name = "date.time")
head(cum.prod)

qplot(x = date.time, y = cvCH4, data = cum.prod, xlab = "Time (d)", ylab = "Cumulative methane production (mL)",color = id, geom = "line")

# Can leave out composition data, and then CH4 is not included in results
cum.prod <- cumBg(vol, temp = 20, pres = 1, time.name = "days")
head(cum.prod)

# Leave out pres or temp, and results are not standardized
cum.prod <- cumBg(vol, time.name = "days")
head(cum.prod)

# Example with input data frames with different column names
data("vol2")
data("comp2")

head(vol2)
head(comp2)

cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, id.name = "bottle", time.name = "days", dat.name = "meas.vol", comp.name = "CH4.conc")
head(cum.prod)
tail(cum.prod)

# Note warnings and related NAs in results
warnings()

# Set extrap = TRUE to avoid
cum.prod <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, id.name = "bottle", time.name = "days", dat.name = "meas.vol", comp.name = "CH4.conc", extrap = TRUE)
head(cum.prod)

qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", ylab = "Cumulative methane production (mL)",color = bottle, geom = "line")

# Mass example
data("mass")

mass

# Need to specify data type with dat.type argument (using default values for id.name, dat.name, and comp.name)
cum.prod <- cumBg(mass, dat.type = "mass", comp = comp, temp = 35, pres = 1, time.name = "days")
cum.prod

# Drop time 0 rows
cum.prod <- cumBg(mass, dat.type = "mass", comp = comp, temp = 35, pres = 1, time.name = "days", showt0 = FALSE)
cum.prod

# Add initial headspace correction (alternatively, headspace could be a data frame with a different volume for each reactor)
cum.prod <- cumBg(mass, dat.type = "mass", comp = comp, temp = 35, pres = 1, time.name = "days", headspace = 300, headcomp = "N2", temp.init = 20, showt0 = FALSE)
cum.prod


# vol2mass
# mass loss from reactor for 100 mL biogas measured at 20 degrees C and 1.0 atm, headspace at 1.5 atm and 35 degrees C at the time of biogas exit
vol2mass(100, xCH4 = 0.65, temp.hs = 35, temp.vol = 20, pres.hs = 1.5, pres.vol = 1)

# If the measured volume has already been standardized to dry conditions at 0 C and 1 atm
vol2mass(100, xCH4 = 0.65, temp.hs = 35, temp.vol = 0, pres.hs = 1.5, pres.vol = 1, rh.vol = 0)

# Here vol2mass *is* numerically the inverse of mass2vol
vol2mass(mass2vol(1.234, xCH4 = 0.65, temp = 35, pres = 1.5, value = "Bg"), xCH4 = 0.65, temp.hs = 35, temp.vol = 0, pres.hs = 1.5, pres.vol = 1, rh.vol = 0)

# Check mass2vol (11 Aug 2019, fix to std temp and pres)
mass2vol(0.1, xCH4 = 0.65, temp = 35, pres = 150, unit.pres = "kPa")
plot(mass2vol(0.1, xCH4 = 0.65, temp = 35, pres = c(1:200)/2, unit.pres = "kPa"))
mass2vol(0.1, xCH4 = 0.65, temp = 35, pres = 1.5, unit.pres = "atm")
mass2vol(0.1, xCH4 = 0.65, temp = 35, pres = 1500, unit.pres = "mbar")

debug(mass2vol)

# Variations on comp for cumBg
# Typical use, with interpolation
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)
subset(cprod, id == '2_1')
# Single value for all
cprod <- cumBg(vol, temp = 20, pres = 1, comp = 0.7, time.name = 'days', extrap = TRUE)
subset(cprod, id == '2_1')
# Single value for each individual reactor
library(plyr)
comp2 <- ddply(comp, 'id', summarise, xCH4 = xCH4[1])
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp2, time.name = 'days', extrap = TRUE)
subset(cprod, id == '2_1')
subset(cprod, id == '2_2')

# Now to check for problems--these all should give errors
# No time column but > 1 obs per reactor
comp3 <- comp[, c('id', 'xCH4')]
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp3, time.name = 'days', extrap = TRUE)

# Use wrong column names
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'xxxx', extrap = TRUE)
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', comp.name = 'abc', extrap = TRUE)

# summBg
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)
names(cprod)
names(setup)

summBg(vol = cprod, setup = setup, when = c(10, 30), time.name = 'days', inoc.name = 'inoc', inoc.m.name = 'mvs.inoc')
summBg(vol = cprod, setup = setup, when = list(10, '1p3d'), time.name = 'days', inoc.name = 'inoc', inoc.m.name = 'mvs.inoc', norm.name = 'mvs.sub')
summBg(vol = cprod, setup = setup, when = 'end', time.name = 'days', inoc.name = 'inoc', inoc.m.name = 'mvs.inoc')
summBg(vol = cprod, setup = setup, when = 'meas', time.name = 'days', inoc.name = 'inoc', inoc.m.name = 'mvs.inoc')

files <- list.files('biogas/R', full.names = TRUE)
for(i in files) source(i)

stdVol(100, temp = 20, pres = 1, rh = 2)


# Should give errors
summBg(vol = cprod, setup = setup, when = 30, time.name = 'xx', inoc.name = 'inoc')
summBg(vol = cprod, setup = setup, when = 30, time.name = 'days', inoc.name = 'xx')
summBg(vol = cprod, setup = setup, when = 30, time.name = 'days', norm.name = 'xx')

# This one should work
x <- cprod[c(8, 29, 100), ]
# Error
summBg(vol = x, setup = setup, when = NULL, time.name = 'days', inoc.name = 'inoc')
summBg(vol = x, setup = setup, when = NULL, time.name = 'days')

summBg(vol = x, setup = setup, when = 'one', time.name = 'days', inoc.name = 'inoc')

summBg(vol = cprod, setup = setup, when = 'end', time.name = 'days', norm.name = 'msub')

summBg(vol = cprod, setup = setup, when = c(10, 30), time.name = 'days', inoc.name = 'inoc', norm.name = 'msub', show.obs = TRUE)
args(summBg)

# Set standard conditions
options(unit.temp = 'K', temp.std = 273.15, unit.pres = 'hPa', pres.std = 1013.25)
cprod1 <- cumBg(vol, temp = 273.15+20, pres = 1013.25, comp = comp, time.name = 'days', extrap = TRUE)
head(cprod1)
options(unit.temp = 'C', temp.std = 0, unit.pres = 'atm', pres.std = 1)
cprod2 <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)
head(cprod2)
all.equal(cprod1, cprod2)

# Should give warning about high temperature and pressure
cprod <- cumBg(vol, temp = 273.15+20, pres = 1013.25, comp = comp, time.name = 'days', extrap = TRUE, unit.temp = 'C', unit.pres = 'atm')

# Error screening
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)
head(cprod)
subset(cprod, outlier.rvCH4)
# Create errors
head(vol)
vol$vol[4] <- 22.5
comp$xCH4[6] <- 0.01
comp$xCH4[7] <- 71
head(comp, 10)
cprod <- cumBg(vol, temp = 20, pres = 1, comp = comp, time.name = 'days', extrap = TRUE)
head(cprod, 20)


# Tests in progress
calcCOD("CH3CH2OH")
calcCOD("CH3(CH2)2OH")
calcCOD(c("CH3CH2OH", "CH3(CH2)2OH"))

