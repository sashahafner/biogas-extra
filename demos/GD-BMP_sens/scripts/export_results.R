# Export tables

write.csv(cbg.gdt, '../output/cbg_gdt.csv', row.names = FALSE)
write.csv(cbg.gdtc, '../output/cbg_gdtc.csv', row.names = FALSE)
write.csv(cbg.gdi, '../output/cbg_gdi.csv', row.names = FALSE)
write.csv(cbg.gdv, '../output/cbg_gdv.csv', row.names = FALSE)

write.csv(BMP, '../output/BMP.csv', row.names = FALSE)
write.csv(BMPo, '../output/BMPo.csv', row.names = FALSE)
write.csv(yld, '../output/yld.csv', row.names = FALSE)
write.csv(yldo, '../output/yldo.csv', row.names = FALSE)

write.csv(detect.limits, '../output/detect_lim.csv', row.names = FALSE)

write.csv(leaks, '../output/leaks.csv', row.names = FALSE)
write.csv(leaks.tot, '../output/leaks_tot.csv', row.names = FALSE)
