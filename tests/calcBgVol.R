# For testing the biogas functions while writing help files
# S. Hafner and Nanna Løjborg

# Load data and functions
# This command may be different for different users
setwd('../../biogas/')

options(width = 70)

files <- list.files('R', full.names = TRUE)
for(i in files) source(i)

files <- list.files('data', full.names = TRUE)
for(j in files) load(j)

# Required packages
library(ggplot2)
library(gridExtra)
library(dplyr)


data("s3lcombo")
s3lcombo

# Calculate cumulative production and rates from s3lcombo
# With default data structure comp argument is not needed
# Necessary to extrapolate because first observations are missing xCH4
cbg <- calcBgVol(s3lcombo, 
                 temp = 25, pres = 1,
                 id.name = 'id', time.name = 'time.d', 
                 vol.name = 'vol.ml', comp.name = 'xCH4', 
                 extrap = TRUE)
head(cbg)

# Note composition argument is set as comp when data structure is longcombo to avoid errors regarding missing composition data frame 

# Plot results
\dontrun{
  # Not run just because it is a bit slow
  ggplot(cbg, aes(time.d, cvCH4, colour = id)) + 
         geom_point() + geom_line(aes(group = id)) +
         labs(x = "Time (d)", y = "Cumulative methane production  (mL)", colour = "Bottle ID")  + 
         theme_bw() 

  plot(ggplot)
}


# Wide data structure, from AMPTS II in this case
data("feedVol")
head(feedVol)

# By default biogas is assumed to be saturated with water vapor
# Composition is set to a single value. 
# Data are cumulative
args(calcBgVol)
cbg <- calcBgVol(feedVol, comp = 1, temp = 0, pres = 1,
                 interval = FALSE, data.struct = 'wide',
                 id.name = "id", time.name = 'time.d', vol.name = '1', 
                 dry = TRUE)

head(cbg)


# Calculate cumulative production and rates from vol and comp
# Biogas volume and composition can be in separate data frames
data("vol")
data("comp")

head(vol)
head(comp)

# extrap = TRUE is needed to get CH4 results here because first xCH4 values are missing
cbg <- calcBgVol(vol, comp = comp, temp = 20, pres = 1, 
                 data.struct = "long",
                 id.name = "id", time.name = "days", comp.name = "xCH4", 
                 vol.name = "vol", extrap = TRUE)

head(cbg)

# Note warnings and related NAs in results
# Set extrap = TRUE to extrapolate xCH4 to earliest times

# Calculate cumulative production and rates from vol and comp
cum.prod <- calcBgVol(vol, comp = comp, temp = 20, pres = 1, id.name = "id", time.name = "days", 
		  comp.name = "xCH4", vol.name = "vol", extrap = TRUE)
head(cum.prod)

# In this case, we can use default values for some column names, so this call is identical
cum.prod <- calcBgVol(vol, comp = comp, temp = 20, pres = 1, time.name = "days", extrap = TRUE)

# Plot results
\dontrun{
# Not run just because it is a bit slow
library(ggplot2)
qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", 
      ylab = "Cumulative methane production (mL)",color = id, geom = "line")
}

# Omit added time zero rows
cum.prod <- calcBgVol(vol, comp = comp, temp = 20, pres = 1, time.name = "days", extrap = TRUE, 
		  showt0 = FALSE)
head(cum.prod)

\dontrun{
# Not run just because it is a bit slow
qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", 
      ylab = "Cumulative methane production (mL)", color = id, geom = "line")
}

# Previous is different from never adding them in the first place (rates not calculated for first 
# observations here)
cum.prod <- calcBgVol(vol, comp = comp, temp = 20, pres = 1, time.name = "days", extrap = TRUE, 
		  addt0 = FALSE)
head(cum.prod)

\dontrun{
# Not run just because it is a bit slow
qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", 
      ylab = "Cumulative methane production (mL)", color = id, geom = "line")
}

# Can use POSIX objects for time (but calcBg cannot add t0 rows here)
class(vol$date.time)
class(comp$date.time)
cum.prod <- calcBgVol(vol, comp = comp, temp = 20, pres = 1, time.name = "date.time", extrap = TRUE)
head(cum.prod)

\dontrun{
# Not run just because it is a bit slow
qplot(x = date.time, y = cvCH4, data = cum.prod, xlab = "Time (d)", 
      ylab = "Cumulative methane production (mL)", color = id, geom = "line")
}

# Can leave out composition data, and then CH4 is not included in results
cum.prod <- calcBgVol(vol, temp = 20, pres = 1, time.name = "days")
head(cum.prod)

# Leave out pres or temp, and results are not standardised
cum.prod <- calcBgVol(vol, time.name = "days")
head(cum.prod)

# Example with input data frames with different column names
data("vol2")
data("comp2")

head(vol2)
head(comp2)

cum.prod <- calcBgVol(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  vol.name = "meas.vol", comp.name = "CH4.conc")
head(cum.prod)
tail(cum.prod)

# Note warnings and related NAs in results
warnings()

# Set extrap = TRUE to avoid
cum.prod <- calcBgVol(vol2, comp = comp2, temp = 20, pres = 1, 
                  id.name = "bottle", time.name = "days", 
		  vol.name = "meas.vol", comp.name = "CH4.conc", 
                  extrap = TRUE)
head(cum.prod)

\dontrun{
# Not run just because it is a bit slow
qplot(x = days, y = cvCH4, data = cum.prod, xlab = "Time (d)", 
      ylab = "Cumulative methane production (mL)", 
      color = bottle, geom = "line")
}


# Example with wide structured input data frame (AMPTS II)
data("feedVol")

# By default biogas is assumed to be saturated with water vapor
# Composition is set to a single value. 
# Data are cumulative
cum.prod <- calcBgVol(feedVol, comp = 1, temp = 0, pres = 1,
                     interval = FALSE,
                     data.struct = 'wide',
                     id.name = "id", time.name = 'time.d', 
                     vol.name = '1', comp.name = "xCH4",
                     dry = TRUE)
head(cum.prod)

# Can leave out composition data, and then CH4 is not included in results
cum.prod <- calcBgVol(feedVol, temp = 0, pres = 1,
                     interval = FALSE,
                     data.struct = 'wide',
                     time.name = 'time.d', 
                     vol.name = '1',
                     dry = TRUE)
head(cum.prod)

# Leave out pres or temp, and results are not standardised
cum.prod <- calcBgVol(feedVol, comp = 1,
                     interval = FALSE,
                     data.struct = 'wide',
                     time.name = 'time.d', 
                     vol.name = '1',
                     dry = TRUE)
head(cum.prod)

# Plot results
\dontrun{
  # Not run just because it is a bit slow
  library(ggplot2)
  ggplot <- ggplot(cum.prod, aes(time.d, cvCH4, colour = id)) + 
    geom_point() +
    geom_line(aes(group = id)) +
    labs(x = "Time (d)", y = "Cumulative methane production  (mL)", colour = "Bottle id")  + 
    theme_bw() 
  
  plot(ggplot)
}


# Example with longcombo structured data


#---------------------

cbg <- calcBgVol(feedVol, comp = 1, temp = 0, pres = 1,
                 interval = FALSE, data.struct = 'wide',
                 id.name = "id", time.name = 'time.d', vol.name = '1', 
                 dry = TRUE)

cum.prod <- calcBgVol(feedVol, temp = 0, pres = 1,
                     interval = FALSE,
                     data.struct = 'wide',
                     time.name = 'time.d', 
                     vol.name = '1',
                     dry = TRUE)

undebug(calcBgVol)
debug(cumBgDataPrep)

cum.prod.w <- calcBgVol(feedVol, comp = 1, temp = 0, pres = 1,
                        interval = FALSE,
                        data.struct = "wide",
                        time.name = "time.d", vol.name = "1",
                        dry = TRUE
                       )
traceback()

#---------------


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


# Compare results from cumBgVol() and cumBgVol()
# long data structure 
# cumBgVol()
cum.prodl <- cumBgVol(vol2, comp = comp2, temp = 20, pres = 1,
                     data.struct = 'long',
                     id.name = "bottle", time.name = "days", 
                     dat.name = "meas.vol", comp.name = "CH4.conc", 
                     extrap = TRUE)

# cumBgVol()
cum.prodln <- cumBgVol(vol2, comp = comp2, temp = 20, pres = 1, 
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

# cumBgVol()
cum.prodcn <- cumBgVol(s3lcombo, temp = 25, pres = 1, 
                      id.name = 'id', time.name = 'time.d', 
                      data.struct = 'longcombo', dat.name = 'vol.ml', 
                      comp.name = 'xCH4', extrap = TRUE)

all_equal(cum.prodcn, cum.prodc, ignore_col_order = FALSE,
          ignore_row_order = FALSE, convert = FALSE)

# Plot longcombo results
ggplot.1 <- ggplot(cum.prodc, aes(time.d, cvCH4, colour = id)) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time (d)", y = "cvCH4  (mL)", colour = "ID")  + 
  theme_bw() 

ggplot.2 <- ggplot(cum.prodcn, aes(time.d, cvCH4, colour = id)) + 
  geom_point() +
  geom_line(aes(group = id)) +
  labs(x = "Time (d)", y = "cvCH4  (mL)", colour = "ID")  + 
  theme_bw() 

grid.arrange(ggplot.1, ggplot.2, ncol=1)


# Cumulative 'wide' structure data
DBFZcum.w.prod <- cumBgVol(feedVol, comp = 1, temp = 0, pres = 1,
                time.name = 'time.d',
                data.struct = 'wide',
                dat.name = '1',
                dry = TRUE,
                interval = FALSE)

DBFZcum.w.prodn <- cumBgVol(feedVol, comp = 1, temp = 0, pres = 1,
                           time.name = 'time.d',
                           data.struct = 'wide',
                           dat.name = '1',
                           dry = TRUE,
                           interval = FALSE)

all_equal(DBFZcum.w.prod, DBFZcum.w.prodn, convert = TRUE)

