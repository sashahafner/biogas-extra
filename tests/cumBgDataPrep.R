# For testing the biogas functions while writing help files
# S. Hafner and Nanna Løjborg

# Load data and functions
# This command may be different for different users
setwd('../../biogas-GH/')

options(width = 70)

files <- list.files('biogas/R', full.names = TRUE)
for(i in files) source(i)

files <- list.files('biogas/data', full.names = TRUE)
for(j in files) load(j)


# cumBgDataPrep tests
cdpw <- cumBgDataPrep(s3volw, comp = s3compw, temp = 25, pres = 1,
                      time.name = 'time.d',
                      data.struct = 'wide',
                      dat.name = 'D', comp.name = 'D',
                      extrap = TRUE)

cdpc <- cumBgDataPrep(s3lcombo, temp = 25, pres = 1,
                      id.name = 'id', time.name = 'time.d',
                      dat.name = 'vol.ml', comp.name = 'xCH4',
                      extrap = TRUE)

cdpl <- cumBgDataPrep(s3lcombo, comp = s3compl, temp = 25, pres = 1,
                      id.name = 'id', time.name = 'time.d',
                      data.struct = 'long',
                      dat.name = 'vol.ml', comp.name = 'xCH4',
                      extrap = TRUE)

head(cdpw)
head(cdpc)
head(cdpl)
