# Cleaning of data and organizing for analysis 

biogas$time

# Water samples 
water$id.orig <- water$id
water$id <- replace(water$id, water$id == 28, 'W1')
water$id <- replace(water$id, water$id == 29, 'W2')
water$id <- replace(water$id, water$id == 30, 'W3')

# Make id a factor instead of a character
biogas$id <- factor(biogas$id)
setup$id <- factor(setup$id)

# Add leading zeros
biogas$date <- sprintf('%08i', biogas$date)
biogas$time <- sprintf('%04i', biogas$time)   

# Make a date/time column
biogas$date.time <- dmy_hm(paste(biogas$date, biogas$time))
if (sum(is.na(biogas$date.time)) > 0) stop('Date/time problem date8771')

# Make a cummulative date.time column
biogas <- as.data.frame(mutate(group_by(biogas, id), start.time = min(date.time)))
biogas$time.d <- as.numeric(difftime(biogas$date.time, biogas$start.time, units = 'days'))

# Check times
# print(sort(unique(biogas$time.d)))

# Check if day and time.d is equal - as it is time.d is not needed in water data set to be comparable
all.equal(biogas$day, biogas$time.d)
