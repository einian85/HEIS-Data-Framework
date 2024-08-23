# 101-BuildDirectoryStructure
# Builds the needed directory structure
#
# Copyright © 2016, 2022: Majid Einian
# Licence: GPL-3

rm(list=ls())

starttime <- proc.time()
cat("\n\n================ BuildDirectoryStructure=======================================\n")



library(yaml)
Settings <- yaml.load_file("Settings-Basic.yaml")

dir.create(Settings$HEISDF.Path,showWarnings = FALSE)
dir.create(Settings$HEISDF.Path.Compressed,showWarnings = FALSE)
dir.create(Settings$HEISDF.Path.Access,showWarnings = FALSE)
dir.create(Settings$HEISDF.Path.RawParquet,showWarnings = FALSE)
dir.create(Settings$HEISDF.Path.RawRDS,showWarnings = FALSE)
dir.create(Settings$HEISDF.Path.ProcessedParquet,showWarnings = FALSE)
dir.create(Settings$HEISDF.Path.ResultsParquet,showWarnings = FALSE)


endtime <- proc.time()

cat("\n\n============================\nIt took",(endtime-starttime)[3],"seconds")
