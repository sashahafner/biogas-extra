# Reads in data

fp <- '../data/UQ2_GD.xlsx'
setup <- as.data.frame(read_xlsx(fp, sheet = 1, skip = 1))
biogas  <- as.data.frame(read_xlsx(fp, sheet = 2, skip = 1))
water  <- as.data.frame(read_xlsx(fp, sheet = 3, skip = 1))

