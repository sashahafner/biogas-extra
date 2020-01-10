# Testing grav method
# S. Hafner

setwd('../../biogas-package-GH/')

files <- list.files('biogas/R', full.names = TRUE)
for(i in files) source(i)

files <- list.files('biogas/data', full.names = TRUE)
for(j in files) load(j)

# Required packages
library(ggplot2)
library(gridExtra)
library(dplyr)

# Mass example
#data("sludgeTwoBiogas")

head(sludgeTwoBiogas)

# Need to specify data type with dat.type argument (using default 
# values for id.name, dat.name, and comp.name)
args(cumBg)
cum.prod <- cumBg(sludgeTwoBiogas, dat.type = "mass", 
                  temp = 30, pres = 1.5, 
                  data.struct = "longcombo",
                  id.name = "id", time.name = "time.d", 
                  dat.name = "mass.final", comp.name = "xCH4n")
head(cum.prod)

# Add initial headspace correction (alternatively, headspace could 
# be a data frame with a different volume for each reactor)
cum.prod2 <- cumBg(sludgeTwoBiogas, dat.type = "mass", 
                  temp = 30, pres = 1.5, 
                  data.struct = "longcombo",
                  id.name = "id", time.name = "time.d", 
                  dat.name = "mass.final", comp.name = "xCH4n",
                  headcomp = "N2", headspace = sludgeTwoSetup, 
                  vol.hs.name = "vol.hs", temp.init = 20, pres.init = 1)

plot(cum.prod$cvCH4 ~ cum.prod2$cvCH4)
abline(0, 1)

# Try very dense headspace
cum.prod3 <- cumBg(sludgeTwoBiogas, dat.type = "mass", 
                  temp = 30, pres = 1.5, 
                  data.struct = "longcombo",
                  id.name = "id", time.name = "time.d", 
                  dat.name = "mass.final", comp.name = "xCH4n",
                  headcomp = "99CO2:1N2", headspace = sludgeTwoSetup, 
                  vol.hs.name = "vol.hs", temp.init = 20, pres.init = 1)

plot(cum.prod$cvCH4 ~ cum.prod3$cvCH4)
abline(0, 1)

# Headspace similar to actual biogas means no correction
# As long as initial T is the same too
mean(sludgeTwoBiogas$xCH4n)

cum.prod4 <- cumBg(sludgeTwoBiogas, dat.type = "mass", 
                  temp = 30, pres = 1.5, 
                  data.struct = "longcombo",
                  id.name = "id", time.name = "time.d", 
                  dat.name = "mass.final", comp.name = "xCH4n",
                  headcomp = "62CH4:38CO2", headspace = sludgeTwoSetup, 
                  vol.hs.name = "vol.hs", temp.init = 30, pres.init = 1)

plot(cum.prod$cvCH4 ~ cum.prod4$cvCH4)
abline(0, 1)

#Looks great
