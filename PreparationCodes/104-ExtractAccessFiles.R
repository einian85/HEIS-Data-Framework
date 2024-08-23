
#
# Copyright © 2015: Majid Einian
# Licence: GPL-3

rm(list=ls())

starttime <- proc.time()
cat("\n\n================ ExtractAccessFiles =====================================\n")


library(yaml)
library(readxl)
library(yaml)
library(tools)
library(data.table)

Settings <- yaml.load_file("Settings-Basic.yaml")

compressed_file_names_df <- fread("Metadata/CompressedFileNames.csv")

existing_years <- file_path_sans_ext(list.files(Settings$HEISDF.Path.Access))
needed_years <- Settings$startyear:Settings$endyear
years_to_extract <- setdiff(needed_years,existing_years)

files_to_extract <- compressed_file_names_df[
  compressed_file_names_df$Year %in% years_to_extract,]$CompressedFileName

cmdline <- paste0(normalizePath("Tools/7z/7z.exe")," e -y ")      # Use 7-zip binary


cwd <- getwd()
dir.create("temp")
setwd("temp")

for(year in years_to_extract){
  filename <- compressed_file_names_df[
    compressed_file_names_df$Year ==year,]$CompressedFileName
  file.copy(from = paste0(Settings$HEISDF.Path.Compressed,filename),to = ".")
  shell(paste0(cmdline,filename))
  l <- dir(pattern=glob2rx("*.mdb"),ignore.case = TRUE)
  if(length(l)>0){
    file.rename(from = l,to = paste0(year,".mdb"))
    file.copy(from = paste0(year,".mdb"),
              to = paste0(Settings$HEISDF.Path.Access,year,".mdb"))
  }
  l <- dir(pattern=glob2rx("*.accdb"),ignore.case = TRUE)
  if(length(l)>0){
    file.rename(from = l,to = paste0(year,".accdb"))
    file.copy(from = paste0(year,".accdb"),
              to = paste0(Settings$HEISDF.Path.Access,year,".accdb"))
  }
  unlink("*.*")
}
setwd(cwd)
unlink("temp",recursive = TRUE,force = TRUE)

existing_file_list <- file_path_sans_ext(list.files(Settings$HEISDF.Path.Access))
years <- Settings$startyear:Settings$endyear
years_had_error <- setdiff(years,existing_file_list)
if (length(years_had_error)>0 ){
  cat("\n------------------\nFollowing years had errors; you have to provide")
  cat(" the *.mdb files manually for these years:\n")
  cat(years_had_error)
}


endtime <- proc.time()

cat("\n\n============================\nIt took",(endtime-starttime)[3],"seconds")
