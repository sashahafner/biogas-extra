# BMP calculation

BMP <- summBg(cbg.list, setup, id.name = "id",
               time.name = 'time.d', descrip.name = 'descrip',
               inoc.name = "I", inoc.m.name = "m.inoc", norm.name = "m.sub.vs",
               when = 'end', extrap = TRUE, set.name = 'method')

# o for "obs" = one value for each bottle
BMPo <- summBg(cbg.list, setup, id.name = "id",
                time.name = 'time.d', descrip.name = 'descrip',
                inoc.name = "I", inoc.m.name = "m.inoc", norm.name = "m.sub.vs",
                when = 'end', extrap = TRUE, set.name = 'method', show.obs = TRUE)

# yld for yield
yld <- summBg(cbg.list, setup, id.name = "id",
               time.name = 'time.d', descrip.name = 'descrip',
               inoc.name = "I", inoc.m.name = "m.inoc", norm.name = "m.sub.vs",
               when = 'meas', extrap = TRUE, set.name = 'method')

yldo <- summBg(cbg.list, setup, id.name = "id",
               time.name = 'time.d', descrip.name = 'descrip',
               inoc.name = "I", inoc.m.name = "m.inoc", norm.name = "m.sub.vs",
               when = 'meas', extrap = TRUE, set.name = 'method', show.obs = TRUE)
