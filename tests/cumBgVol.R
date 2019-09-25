# For testing the biogas functions while writing help files
# S. Hafner and Nanna Løjborg

# Load data and functions
# This command may be different for different users
setwd('../../biogas-package-GH/')

options(width = 70)

files <- list.files('biogas/R', full.names = TRUE)
for(i in files) source(i)

files <- list.files('biogas/data', full.names = TRUE)
for(j in files) load(j)

# Required packages
library(ggplot2)
library(gridExtra)
library(dplyr)


# cumBgVol tests
# longcombo data structure
cpc <- cumBgVol(s3lcombo, temp = 25, pres = 1,
             id.name = 'id', time.name = 'time.d',
             dat.name = 'vol.ml', comp.name = 'xCH4',
             extrap = TRUE)

# wide data structure
cpw <- cumBgVol(s3volw, comp = s3compw, temp = 25, pres = 1,
         time.name = 'time.d',
         data.struct = 'wide',
         dat.name = 'D', comp.name = 'D',
         extrap = TRUE)

# Long data structure
cpl <- cumBgVol(s3voll, comp = s3compl, temp = 25, pres = 1,
             data.struct = 'long',
             id.name = 'id', time.name = 'time.d',
             dat.name = 'vol.ml', comp.name = 'xCH4',
             extrap = TRUE)

head(cpc)
head(cpw)
head(cpl)

# Test some options
# Omit temp and pres
cpc <- cumBgVol(s3lcombo, 
             id.name = 'id', time.name = 'time.d',
             dat.name = 'vol.ml', comp.name = 'xCH4',
             extrap = TRUE)
head(cpc)

# Omit composition (no comp argument)
# First for long
cpl <- cumBgVol(s3voll, temp = 25, pres = 1,
             data.struct = 'long',
             id.name = 'id', time.name = 'time.d',
             dat.name = 'vol.ml',
             extrap = TRUE)
head(cpl)
# And longcombo data structure
cpc <- cumBgVol(s3lcombo, temp = 25, pres = 1,
             id.name = 'id', time.name = 'time.d',
             dat.name = 'vol.ml', comp.name = NULL,
             extrap = TRUE)
head(cpc)

# Omit comp for wide
cpw <- cumBgVol(feedVol, temp = 0, pres = 1,
                time.name = 'time.d',
                data.struct = 'wide',
                dat.name = '1',
                dry = TRUE,
                interval = FALSE)

head(cpw)


# Compare results from cumBgVol() and cumBg()
# long data structure 
# cumBgVol()
cum.prodl <- cumBgVol(vol2, comp = comp2, temp = 20, pres = 1,
                     data.struct = 'long',
                     id.name = "bottle", time.name = "days", 
                     dat.name = "meas.vol", comp.name = "CH4.conc", 
                     extrap = TRUE)

# cumBg()
cum.prodln <- cumBg(vol2, comp = comp2, temp = 20, pres = 1, 
                      id.name = "bottle", time.name = "days", 
                      dat.name = "meas.vol", comp.name = "CH4.conc", 
                      extrap = TRUE)

head(cum.prodl)
head(cum.prodln)

all_equal(cum.prodln, cum.prodl, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# longcombo data structure
# cumBgVol()
cum.prodc <- cumBgVol(s3lcombo, temp = 25, pres = 1, 
                     id.name = 'id', time.name = 'time.d', 
                     dat.name = 'vol.ml', 
                     comp.name = 'xCH4', extrap = TRUE)

# cumBg()
cum.prodcn <- cumBg(s3lcombo, temp = 25, pres = 1, 
                      id.name = 'id', time.name = 'time.d', 
                      data.struct = 'longcombo', dat.name = 'vol.ml', 
                      comp.name = 'xCH4', extrap = TRUE)

all_equal(cum.prodcn, cum.prodc, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# Plot longcombo results
ggplot.1 <- ggplot(cum.prodc, aes(time.d, cvCH4, colour = id)) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "ID")  + 
  theme_bw() 

ggplot.2 <- ggplot(cum.prodcn, aes(time.d, cvCH4, colour = id)) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time [d]", y = "cvCH4  [mL]", colour = "ID")  + 
  theme_bw() 

grid.arrange(ggplot.1, ggplot.2, ncol=1)


# Cumulative 'wide' structure data
DBFZcum.w.prod <- cumBgVol(feedVol, comp = 1, temp = 0, pres = 1,
                time.name = 'time.d',
                data.struct = 'wide',
                dat.name = '1',
                dry = TRUE,
                interval = FALSE)

DBFZcum.w.prodn <- cumBg(feedVol, comp = 1, temp = 0, pres = 1,
                           time.name = 'time.d',
                           data.struct = 'wide',
                           dat.name = '1',
                           dry = TRUE,
                           interval = FALSE)

all_equal(DBFZcum.w.prod, DBFZcum.w.prodn, convert = TRUE)

