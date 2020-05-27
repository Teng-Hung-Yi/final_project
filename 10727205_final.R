rm(list=ls())

hardware_path <- "c:/"
setwd(hardware_path)
dir.create("metro_data")
path <- "metro_data"

#  http://web.metro.taipei/RidershipPerStation/202004_cht.ods

download_data_file <- function( x ) {
   
  dest<- paste0( hardware_path,path,'/',x,"_cht.ods")
  filename_Fhalf <- paste0("https://web.metro.taipei/RidershipPerStation/",x )
  filename<- paste0( filename_Fhalf,"_cht.ods")
  filename
  
  download.file(filename,destfile = dest, mode = "wb" )
  
}

download_data_file(202004)

