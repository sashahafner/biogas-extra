# For testing the biogas functions while writing help files
# S. Hafner and Nanna Løjborg

# Load data and functions
# This command may be different for different users
setwd('../biogas-GH/')

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
                     id.name = "bottle", time.name = "time", 
                     dat.name = "pres", comp.name = "xCH4",
                     temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0.0,
                     headspace = strawSetup, vol.hs.name = "headspace",
                     pres.amb = 1.01, absolute = FALSE,
                     extrap = TRUE, addt0 = TRUE)

head(cum.prodl.man)

# cumBg() same data
cum.prodl <- cumBg(strawPressure, dat.type = "pres", comp = strawComp, temp = 31,
      id.name = "bottle", time.name = "time",
      dat.name = "pres", comp.name = "xCH4",
      temp.init = 21.55, pres.resid = "pres.resid", pres.init = 0.0,
      headspace = strawSetup, vol.hs.name = "headspace",
      pres.amb = 1.01, absolute = FALSE,
      extrap = TRUE,
      addt0 = TRUE)

head(cum.prodl)

# Compare results from cumBgMan() and cumBg()
all_equal(cum.prodl.man, cum.prodl, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# Plot results
ggplot.1 <- ggplot(cum.prodl.man, aes(time, cvCH4, colour = bottle)) + 
  geom_point() +
  geom_line(aes(group = bottle)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle no.")  + 
  theme_bw() 

ggplot.2 <- ggplot(cum.prodl, aes(time, cvCH4, colour = bottle)) + 
  geom_point() +
  geom_line(aes(group = bottle)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "Bottle no.")  + 
  theme_bw() 

grid.arrange(ggplot.1, ggplot.2, ncol=1)

