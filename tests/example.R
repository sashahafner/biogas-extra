# For testing the biogas functions while writing help files
# S. Hafner

# This command may be different for different users
setwd('../biogas-GH/')

files <- list.files('biogas/R', full.names = TRUE)
for(i in files) source(i)

files <- list.files('biogas/data', full.names = TRUE)
for(j in files) load(j)


