# 102-InstallRequiredPackagees
#
# Copyright © 2016: Majid Einian
# Licence: GPL-3

rm(list=ls())

starttime <- proc.time()
cat("\n\n================ Install Required Packages =====================================\n")




pkglist <- c("yaml","RODBC","readxl","data.table","ggplot2","tools","arrow")

for(pkg in pkglist){
  if((eval(parse(text = paste0("require(",pkg,")")))==FALSE))
    install.packages(pkg)
}



endtime <- proc.time()

cat("\n\n============================\nIt took",(endtime-starttime)[3],"seconds")
