# To create datasets
# S. Hafner and C. Rennuit
# Modified: 20 June 2015
# New data set added by CRE 15 June 2015
setwd('C:/Users/cre/Dropbox/biogas_package/make data sets/')
dat<-read.csv('data.csv')

# setwd('C:/Users/cre/Dropbox/biogas_package/biogas/data/')

dat$date.time<-as.POSIXct(dat$date.time)
dfsumm(dat)

# vol for normVol, interp, and high-level functions
vol<-dat[dat$id %in% paste0(2,'_',c(1:12)),c('id','date.time','days','vol')]
vol$id<-factor(vol$id,levels=paste0(2,'_',c(1:12)))
vol$days<-round(vol$days,2)
rownames(vol)<-1:nrow(vol)
unique(vol$id)
vol
save(vol,file='vol.rda')


# mass for mx2v and high-level functions
mass<-read.csv('mass.csv')
mass$date.time<-as.POSIXct(mass$date.time)
dfsumm(mass)
mass$id<-factor(mass$id,levels=paste0(2,'_',c(1:12)))
mass$days<-round(mass$days,2)
unique(mass$id)
save(mass,file='mass.rda')

# massw for gravimetric functions
mass$when<-ifelse(mass$days==0,'start','end')
library(reshape2)
massw<-dcast(mass,id ~ when,value.var='mass')
massw<-massw[,c(1,3,2)]
save(massw,file='massw.rda')

# setup for BMP

# get data from results batch 
ss<-read.csv('master.volbg.csv')

## get initial total masses 

# subset experiment 2 and columns to get initial compo
s<-subset(ss, experiment=='rs2' & data.type=='replicates'& bottle<= 12, select = c('experiment','bottle','date.time','cum.time.days','volWbg','m.itot','mcod.tot','mvs.tot')) 
# Make id column
s$id<-paste0('2','_',s$bottle)
s<-s[order(s$bottle),]
# rename columns so they have explicit short names
names(s)[names(s)%in%c('cum.time.days','volWbg')]<-c('days','vol')
# remove experiment and bottle columns not needed anymore (id column is enough)
s<-s[,-which(names(s)%in%c('experiment','bottle'))]
# get only info for composition data: gets rid of duplicate values repeted at each date
s<-unique(s[,c('id','m.itot',"mcod.tot",'mvs.tot')])
# rename m.itot <- m.tot
names(s)<-c('id','m.tot',"mcod.tot",'mvs.tot')

## get initial wet masses

s.m <- read.csv('SetupRs2.csv')

s.m <- subset(s.m,exp=='bmp') 
s.m <- s.m[, c('bottle','treat',paste0(unique(s.m$treat)))]# select columns with masses of each bmp substrate 
s.mm <- melt(s.m,id.vars = c('bottle','treat','inoc'),value.name = 'msub') # melt to get msub in one column
s.m <- s.mm[!s.mm$msub == 0 | (s.mm$treat == 'inoc' & s.mm$variable == 'dig'),] # select only relevant columns : we want mass of substrate for each
s.m[s.m$treat == 'inoc','msub']<-s.m[s.m$treat == 'inoc','inoc'] # msub inoc = minoc
s.m <- s.m[,c('bottle','treat','msub','inoc')] # get rid of variable column
names(s.m) <- c('bottle','treat','msub','minoc') # rename minoc

## get minitial vs masses

s.vs<-subset(ss, experiment=='rs2' & data.type=='replicates'& bottle<= 12)
s.vs <- s.vs[, c('bottle','treat', paste0(rep('mvs.',length(unique(s.vs$treat))),unique(s.vs$treat)))] # select columns with only mvs mass of each bmp substrate
s.vs<-unique(s.vs)# get only info for composition data: gets rid of duplicate values repeted at each date
s.vsm <- melt(s.vs,id.vars = c('bottle','treat','mvs.inoc'),value.name = 'mvs.sub') # melt to get msub in one column
s.vs <- s.vsm[!s.vsm$mvs.sub == 0 | (s.vsm$treat == 'inoc' & s.vsm$variable == 'mvs.dig'),] # select only releevant columns : we want mass of substrate for each
s.vs[s.vs$treat == 'inoc','mvs.sub']<-s.vs[s.vs$treat == 'inoc','mvs.inoc'] # msub inoc = mvs.inoc
s.vs <- s.vs[,c('bottle','treat','mvs.sub','mvs.inoc')] # get rid of variable column

## get initial cod masses

s.cod<-subset(ss, experiment=='rs2' & data.type=='replicates'& bottle<= 12)
s.cod <- s.cod[, c('bottle','treat', paste0(rep('mcod.',length(unique(s.cod$treat))),unique(s.cod$treat)))] # select only cod masses for bmp substrates
s.cod<-unique(s.cod)# get only info for composition data: gets rid of duplicate values repeted at each date
s.codm <- melt(s.cod,id.vars = c('bottle','treat','mcod.inoc'),value.name = 'mcod.sub') # melt to get msub in one column
s.cod <- s.codm[!s.codm$mcod.sub == 0 | (s.codm$treat == 'inoc' & s.codm$variable == 'mcod.dig'),] # select only releevant columns : we want mass of substrate for each
s.cod[s.cod$treat == 'inoc','mcod.sub']<-s.cod[s.cod$treat == 'inoc','mcod.inoc'] # mcod.sub inoc = mcod.inoc
s.cod <- s.cod[,c('bottle','treat','mcod.sub','mcod.inoc')] # get rid of variable column

## build setup

# merge the masses, mvs, and mcod 
s2 <- merge(s.m,s.vs)
s2 <- merge(s2,s.cod)

s2 <- s2[order(s2$bottle),]
s2$id <- paste0('2','_',s2$bottle)
s2$treat <- as.character(s2$treat)
s2[s2$treat == 'dig', 'treat'] <- 'A'
s2[s2$treat == 'sss', 'treat'] <- 'B'
names(s2)[names(s2)=='treat']<-'descrip'

# get rid of bottle column and rearrange so 'id' is first
s2 <- s2 [,-1]
s2 <- s2 [,c('id',names(s2)[names(s2)!='id'])]
setup<-s2

# add cOD initial values to setup data frame
setup<-merge(setup,s[,c('id','m.tot',"mvs.tot","mcod.tot")])
setup<-setup[order(setup$descrip),]

save(setup,file='setup.rda')

# Make cumulative volume data set to compare with mass2vol
# Charlotte 18/06/2015 need to create help file
v<-subset(vol,days<=125)
c<-subset(comp,days<=125)
cv<-cumBg(dat=v,time.name='days',comp=c,temp=35, pres=1, extrap=TRUE,check=FALSE)
cumvol<-summBg(vol = cv, vol.name = 'cvBg', setup = setup, when = 'end',show.obs=TRUE)
#cumvol<-summBg(vol=cv,setup=setup,when=122.89,show.obs=TRUE)
cumvol<-cumvol[,-ncol(cumvol)]
save(cumvol,file='cumvol.rda')


# Ali's data
setup2<-read.csv('ali_setup.csv')
head(setup2)
setup2[,3:4]<-signif(setup2[,3:4],4)
save(setup2,file='setup2.rda')

vol2<-read.csv('ali_vol.csv')
head(vol2)
dfsumm(vol2)
save(vol2,file='vol2.rda')

comp2<-read.csv('ali_xCH4.csv')
comp2$CH4.conc<-signif(comp2$CH4.conc,4)
dfsumm(comp2)
head(comp2)
save(comp2,file='comp2.rda')


# Does not seem to be appropriate because takes already interpolated data
# comp for interp and high-level functions
# uses values from the real data (used in the first version of the package)
load('oldcomp.rda')
oldcomp <- comp

comp<-dat[dat$id %in% paste0(2,'_',c(1:12)),c('id','date.time','days','xCH4')]
comp$date.time<-as.POSIXct(comp$date.time)
dfsumm(comp)
comp$id<-factor(comp$id,levels=paste0(2,'_',c(1:12)))
comp$days<-round(comp$days,2)
unique(comp$id)
comp <- subset(comp, date.time %in% oldcomp$date.time) 
save(comp,file='comp.rda')

