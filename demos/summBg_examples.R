# Demo of summBg() options
# S. Hafner
# 26 April 2019

# Need recent dev or main version from GitHub
# devtools::install_github('sashahafner/biogas')
# Or
# devtools::install_github('sashahafner/biogas', ref = 'dev')

library(biogas)

data(vol2)
data(comp2)
data(setup2)

# Get cumulative CH4 production 
cbg <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
             id.name = "bottle", time.name = "days", 
		         dat.name = "meas.vol", comp.name = "CH4.conc", 
             extrap = TRUE)

# Fixed time
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30)
s1

# Relative
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = "1p3d")
s1

# To see rates
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = "1p3d", show.rates = TRUE)
head(s1)

# When rate criterion is not met
cp <- subset(cbg, days < 20)
s1 <- summBg(vol = cp, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = '1p3d')

s1
attributes(s1)

# Flexible
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = "0.5p3d")
s1

# Final
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = "end")
s1

# Combination
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = list(30, "1p3d", "end"))
s1

# Measured times (yield curves)
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = "meas")

# Separate observations
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = 30, show.obs = TRUE)
s1

# Error prop
# Do not know VS std. error, so guess here for example
setup2$sub.vs.se <- 0.5
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", norm.se.name = 'sub.vs.se', 
       when = 'end')

s1

# Show more details
s1 <- summBg(vol = cbg, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", norm.se.name = 'sub.vs.se', 
       when = 'end', show.more = TRUE)

s1

# Compare different cumulative CH4 values (e.g., checking for importance of error in measurements)
# Pretend we are unsure about measurement temperature and pressure
cbg1 <- cumBg(vol2, comp = comp2, temp = 15, pres = 1.1, 
             id.name = "bottle", time.name = "days", 
		         dat.name = "meas.vol", comp.name = "CH4.conc", 
             extrap = TRUE)

cbg2 <- cumBg(vol2, comp = comp2, temp = 25, pres = 0.9, 
             id.name = "bottle", time.name = "days", 
		         dat.name = "meas.vol", comp.name = "CH4.conc", 
             extrap = TRUE)

cbgl <- list(a = cbg1, b = cbg2)

s1 <- summBg(vol = cbgl, setup = setup2, id.name = "bottle", 
       time.name = "days", descrip.name = "description", 
       inoc.name = "Inoculum", inoc.m.name = "inoc.mass", 
       norm.name = "sub.vs", when = "1p3d")
s1


