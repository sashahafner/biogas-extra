# For testing the biogas functions while writing help files
# S. Hafner and Nanna Løjborg

# Load data and functions
# This command may be different for different users
#setwd('../biogas-GH/')
setwd('../../biogas-package-GH/')

files <- list.files('biogas/R', full.names = TRUE)
for(i in files) source(i)

files <- list.files('biogas/data', full.names = TRUE)
for(j in files) load(j)

# Required packages
library(ggplot2)
library(gridExtra)
library(dplyr)

# cumBgMan() test 'long' data structure
cum.prodl.man <- cumBgMan(strawPressure, comp = strawComp, temp = 31,
                     data.struct = 'long',
                     id.name = "bottle", time.name = "time", 
                     dat.name = "pres", comp.name = "xCH4",
                     temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0.0,
                     headspace = strawSetup, vol.hs.name = "headspace",
                     pres.amb = 101.3, absolute = FALSE,
                     extrap = TRUE, addt0 = TRUE,
                     unit.pres = "kPa")

head(cum.prodl.man)

# cumBg() same data
cum.prodl <- cumBg(strawPressure, dat.type = "pres", comp = strawComp, temp = 31,
      id.name = "bottle", time.name = "time",
      dat.name = "pres", comp.name = "xCH4",
      temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0.0,
      headspace = strawSetup, vol.hs.name = "headspace",
      pres.amb = 101.3, absolute = FALSE,
      extrap = TRUE, addt0 = TRUE,
      unit.pres = "kPa")

head(cum.prodl)

# Compare results from cumBgMan() and cumBg()
all_equal(cum.prodl.man, cum.prodl, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# Plot results
ggplot.1 <- ggplot(cum.prodl.man, aes(time, cvCH4, colour = factor(bottle))) + 
  geom_point() +
  geom_line(aes(group = bottle)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle no.")  + 
  theme_bw() 

ggplot.2 <- ggplot(cum.prodl, aes(time, cvCH4, colour = factor(bottle))) + 
  geom_point() +
  geom_line(aes(group = bottle)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle no.")  + 
  theme_bw() 

grid.arrange(ggplot.1, ggplot.2, ncol=1)


# Sludge data. Longcombo data structure.
# cumBgMan()
cum.prodc.man <- cumBgMan(sludgeTwoBiogas, temp = 30, 
                          id.name = "id", time.name = "time.d", 
                          dat.name = "pres", comp.name = 'xCH4n',
                          temp.init = 30, pres.resid = 0, pres.init = 0.0,
                          headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                          pres.amb = 1013, absolute = FALSE,
                          extrap = FALSE, addt0 = TRUE, 
                          unit.pres = "mbar")
# cumBg()
cum.prodc <- cumBg(sludgeTwoBiogas, dat.type = 'pres', temp = 30, data.struct = 'longcombo',
                          id.name = "id", time.name = "time.d", 
                          dat.name = "pres", comp.name = 'xCH4n',
                          temp.init = 30, pres.resid = 0, pres.init = 0.0,
                          headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                          pres.amb = 1013, absolute = FALSE,
                          extrap = FALSE, addt0 = TRUE, 
                          unit.pres = "mbar")

# Test some options
# Omit temp, should throw error
cum.prodc.man <- cumBgMan(sludgeTwoBiogas, 
                          id.name = "id", time.name = "time.d", 
                          dat.name = "pres", comp.name = 'xCH4n',
                          temp.init = 30, pres.resid = 0, pres.init = 0.0,
                          headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                          pres.amb = 1013, absolute = FALSE,
                          extrap = FALSE, addt0 = TRUE, 
                          unit.pres = "mbar")

# Compare results from cumBgMan() and cumBg()
all_equal(cum.prodc.man, cum.prodc, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# Plot results
ggplot.1 <- ggplot(cum.prodc.man, aes(time.d, cvCH4, colour = factor(id))) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle id")  + 
  theme_bw() 

ggplot.2 <- ggplot(cum.prodc, aes(time.d, cvCH4, colour = factor(id))) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle id")  + 
  theme_bw() 

grid.arrange(ggplot.1, ggplot.2, ncol=1)
