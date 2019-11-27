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

head(sludgeTwoBiogas)
head(sludgeTwoSetup)

# Calculate cumulative production and rates 
# Pressure is gauge (not absolute) so absolute argument needed
# Data structure is default of longcombo
cbg <- calcBgMan(sludgeTwoBiogas, temp = 30,
                 id.name = "id", time.name = "time.d", 
                 pres.name = "pres", comp.name = "xCH4n",
                 temp.init = 30, pres.resid = 0, pres.init = 0,
                 headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                 pres.amb = 1013, absolute = FALSE,
                 unit.pres = "mbar")
head(cbg)

# Plot results
\dontrun{
  # Not run just because it is a bit slow
  library(ggplot2)

  ggplot(cbg, aes(time.d, cvCH4, colour = factor(id))) + 
    geom_point() +
    geom_line(aes(group = id)) +
    labs(x = "Time (d)", y = "Cumulative methane production  (mL)", colour = "Bottle id")  + 
    theme_bw() 
}

# This sludgeTwoBiogas dataset has original xCH4 as well as normalized values
# So "method 2" can also be used by changing comp.name and cmethod arguments
cbg2 <- calcBgMan(sludgeTwoBiogas, temp = 30,
                  id.name = "id", time.name = "time.d", 
                  pres.name = "pres", comp.name = "xCH4",
                  temp.init = 30, pres.resid = 0, pres.init = 0,
                  headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                  pres.amb = 1013, cmethod = 'total', absolute = FALSE,
                  unit.pres = "mbar")
head(cbg2)

# Compare
quantile(cbg2$vCH4 - cbg$vCH4)
# Median difference of 0.2 mL

# Example with long structured input data frame
data("strawPressure")
data("strawComp")
data("strawSetup")

# Need to specify data structure with \code{data.struct} argument
# Using default values for time.name, pres.name
cbg <- calcBgMan(strawPressure, comp = strawComp, temp = 31,
                 data.struct = "long",
                 id.name = "bottle", comp.name = "xCH4",
                 temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0,
                 headspace = strawSetup, vol.hs.name = "headspace",
                 pres.amb = 101.3, absolute = FALSE,
                 unit.pres = "kPa")

# Because of missing composition measurements at last time for some bottles
# CH4 volume will be missing
# Can estimate xCH4 here by extrapolation using argument of same name

cbg2 <- calcBgMan(strawPressure, comp = strawComp, temp = 31,
                 data.struct = "long",
                 id.name = "bottle", comp.name = "xCH4",
                 temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0,
                 headspace = strawSetup, vol.hs.name = "headspace",
                 pres.amb = 101.3, absolute = FALSE, 
                 extrap = TRUE, unit.pres = "kPa")


# For example with wide structured input data frame cumBgVol() help file

---------------------
# cumBgMan() test 'long' data structure
cbgl.man <- cumBgMan(strawPressure, comp = strawComp, temp = 31,
                     data.struct = 'long',
                     id.name = "bottle", time.name = "time", 
                     dat.name = "pres", comp.name = "xCH4",
                     temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0,
                     headspace = strawSetup, vol.hs.name = "headspace",
                     pres.amb = 101.3, absolute = FALSE,
                     extrap = TRUE, addt0 = TRUE,
                     unit.pres = "kPa")

head(cbgl.man)

# cumBg() same data
cbgl <- cumBg(strawPressure, dat.type = "pres", comp = strawComp, temp = 31,
      id.name = "bottle", time.name = "time",
      dat.name = "pres", comp.name = "xCH4",
      temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0,
      headspace = strawSetup, vol.hs.name = "headspace",
      pres.amb = 101.3, absolute = FALSE,
      extrap = TRUE, addt0 = TRUE,
      unit.pres = "kPa")

head(cbgl)

# Compare results from cumBgMan() and cumBg()
all_equal(cbgl.man, cbgl, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# Plot results
ggplot.1 <- ggplot(cbgl.man, aes(time, cvCH4, colour = factor(bottle))) + 
  geom_point() +
  geom_line(aes(group = bottle)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle no.")  + 
  theme_bw() 

ggplot.2 <- ggplot(cbgl, aes(time, cvCH4, colour = factor(bottle))) + 
  geom_point() +
  geom_line(aes(group = bottle)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle no.")  + 
  theme_bw() 

grid.arrange(ggplot.1, ggplot.2, ncol=1)


# Sludge data. Longcombo data structure.
# cumBgMan()
cbgc.man <- cumBgMan(sludgeTwoBiogas, temp = 30, 
                          id.name = "id", time.name = "time.d", 
                          dat.name = "pres", comp.name = 'xCH4n',
                          temp.init = 30, pres.resid = 0, pres.init = 0,
                          headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                          pres.amb = 1013, absolute = FALSE,
                          extrap = FALSE, addt0 = TRUE, 
                          unit.pres = "mbar")
# cumBg()
cbgc <- cumBg(sludgeTwoBiogas, dat.type = 'pres', temp = 30, data.struct = 'longcombo',
                          id.name = "id", time.name = "time.d", 
                          dat.name = "pres", comp.name = 'xCH4n',
                          temp.init = 30, pres.resid = 0, pres.init = 0,
                          headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                          pres.amb = 1013, absolute = FALSE,
                          extrap = FALSE, addt0 = TRUE, 
                          unit.pres = "mbar")

# Test some options
# Omit temp, should throw error
cbgc.man <- cumBgMan(sludgeTwoBiogas, 
                          id.name = "id", time.name = "time.d", 
                          dat.name = "pres", comp.name = 'xCH4n',
                          temp.init = 30, pres.resid = 0, pres.init = 0,
                          headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                          pres.amb = 1013, absolute = FALSE,
                          extrap = FALSE, addt0 = TRUE, 
                          unit.pres = "mbar")

# Omit composition, should run with warning
# First longcombo
cbgc.man <- cumBgMan(sludgeTwoBiogas, temp = 30,
                          id.name = "id", time.name = "time.d", 
                          dat.name = "pres", comp.name = NULL,
                          temp.init = 30, pres.resid = 0, pres.init = 0,
                          headspace = sludgeTwoSetup, vol.hs.name = "vol.hs",
                          pres.amb = 1013, absolute = FALSE,
                          extrap = FALSE, addt0 = TRUE, 
                          unit.pres = "mbar")

head(cbgc.man)

# And long
cbgl.man <- cumBgMan(strawPressure, temp = 31,
                     data.struct = 'long',
                     id.name = "bottle", time.name = "time", 
                     dat.name = "pres", 
                     temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0,
                     headspace = strawSetup, vol.hs.name = "headspace",
                     pres.amb = 101.3, absolute = FALSE,
                     extrap = TRUE, addt0 = TRUE,
                     unit.pres = "kPa")

#options(warn = 2)
#options(warn = 0)
#traceback()

# Compare results from cumBgMan() and cumBg()
all_equal(cbgc.man, cbgc, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# Plot results
ggplot.1 <- ggplot(cbgc.man, aes(time.d, cvCH4, colour = factor(id))) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle id")  + 
  theme_bw() 

ggplot.2 <- ggplot(cbgc, aes(time.d, cvCH4, colour = factor(id))) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle id")  + 
  theme_bw() 

grid.arrange(ggplot.1, ggplot.2, ncol=1)
