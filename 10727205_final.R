rm(list=ls())

hardware_path <- "c:/"
setwd(hardware_path)
#在當前目錄位置創造一資料夾
dir.create("metro_data")
path <- "metro_data"

#  http://web.metro.taipei/RidershipPerStation/202004_cht.ods

download_data_file <- function( x ) {
   # 下載後放到前面建立的資料結內並命名
  dest<- paste0( hardware_path,path,'/',x,"_cht.ods")
   # 設定要下載的檔案的網址
  filename_Fhalf <- paste0("https://web.metro.taipei/RidershipPerStation/",x )
  filename<- paste0( filename_Fhalf,"_cht.ods")
  # 下載檔案
  download.file(filename,destfile = dest, mode = "wb" )
  
}
# 2020 04 為可更改數字 依照網頁擁有的檔案做更改
download_data_file(202004)

