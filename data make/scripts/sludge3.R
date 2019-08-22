# Makes rda files for sludge3 data set
# S. Hafner
# 16 Dec 2016

s3voll <- read.csv('../original/sludge3_vol_long.csv', skip = 1)[,-2]

s3compl <- read.csv('../original/sludge3_comp_long.csv', skip = 1)[,-2]

s3volw <- read.csv('../original/sludge3_vol_wide.csv', skip = 1)[,-1]

s3compw <- read.csv('../original/sludge3_comp_wide.csv', skip = 1)[,-1]

s3lcombo <- read.csv('../original/sludge3_longcombo.csv', skip = 1)[,-2]

# Create rda files

save(s3voll, file = '../output rda/s3voll.rda')
save(s3compl, file = '../output rda/s3compl.rda')
save(s3volw, file = '../output rda/s3volw.rda')
save(s3compw, file = '../output rda/s3compw.rda')
save(s3lcombo, file = '../output rda/s3lcombo.rda')


