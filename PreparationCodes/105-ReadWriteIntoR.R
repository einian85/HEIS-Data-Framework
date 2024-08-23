# 105-ReadWriteIntoR
# Read and Save All Tables into R Format
#
# Copyright © 2015: Majid Einian
# Licence: GPL-3
# 
rm(list=ls())

starttime <- proc.time()
cat("\n\n================ ReadWriteIntoR =====================================\n")

library(yaml)
Settings <- yaml.load_file("Settings-Basic.yaml")

file.copy(from = Settings$HEISDF.Path.D80LinkSource, 
          to = Settings$HEISDF.Path.D80LinkDest, overwrite = TRUE)

library(RODBC)
library(data.table)
library(arrow)
library(readr)


for(year in (Settings$StartYear:Settings$EndYear)){
  cat(paste0("\n------------------------------\nYear:",year,"\n"))
  
  l <- dir(path=Settings$HEISDF.Path.Access, 
           pattern=glob2rx(paste0(year,".*")),ignore.case = TRUE)
  if(year==80){
    cns<-odbcConnectAccess2007(Settings$D80LinkDest)
  }else{
    cns<-odbcConnectAccess2007(paste0(Settings$HEISDF.Path.Access, l))
  }
  tbls <- data.table(sqlTables(cns))[TABLE_TYPE %in% c("TABLE","SYNONYM"),
                                     ]$TABLE_NAME
  print(tbls)
  Tables <- vector(mode = "list")#, length = length(tbls))
  
  dir.create(paste0(Settings$HEISDF.Path.RawParquet,year),showWarnings = FALSE)
  
  for (tbl in tbls) {
    D <- data.table(sqlFetch(cns,tbl,stringsAsFactors=FALSE))
    write_parquet(D,paste0(Settings$HEISDF.Path.RawParquet,
                           year,"/",toupper(tbl),".parquet"))
    Tables[[tbl]] <- D
  }
  names(Tables) <- toupper(names(Tables))
  #  Tables[[paste0("RU",year,"Weights")]] <- AllWeights[(Year==year),]
  close(cns)
  
  write_rds(Tables,file = paste0(Settings$HEISDF.Path.RawRDS,"Raw-",year,".rds"))
  #save(Tables,file=paste0(Settings$HEISRawPath,"Y",year,"Raw.rda"))
}

endtime <- proc.time()

cat("\n\n============================\nIt took",(endtime-starttime)[3],"seconds")
