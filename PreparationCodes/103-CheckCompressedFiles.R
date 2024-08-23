# 103-CheckCompressedFiles.R


rm(list=ls())

starttime <- proc.time()
cat("\n\n================ CheckCompressedFiles =====================================\n")


library(yaml)
library(readxl)

Settings <- yaml.load_file("Settings-Basic.yaml")

compressed_file_names_df <- fread("Metadata/CompressedFileNames.csv")

present_compressed_file_list <- list.files(Settings$HEISDF.Path.Compressed)

needed_compressed_files_list <- setdiff(compressed_file_names_df$CompressedFileName,present_compressed_file_list)


path_to_buy <- "https://ssis.sci.org.ir/%D8%AF%D8%A7%D8%AF%D9%87%D9%87%D8%A7%DB%8C-%D8%AE%D8%A7%D9%85"
if(length(needed_compressed_files_list)>0){
  cat("Add following years to basket and download from ",path_to_buy)
  cat("\n",needed_compressed_files_list)
}else{
  cat("All files in the range specified in Setting.yaml file are present, no need to download.")
}


endtime <- proc.time()

cat("\n\n============================\nIt took",(endtime-starttime)[3],"seconds")
