rm(list=ls())

# 從網頁抓json
if(!require(jsonlite)) {
  install.packages("jsonlite")
  library(jsonlite)
}

#製圖用的
if(!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

#****************************************************************************************
#                                 Main在第 137 行
#****************************************************************************************

#*******************讀取資料****************************
read_data <- function() {
  address <- "http://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json"
  temp <- fromJSON(address)
  #as.data.frame 把資料轉成data.frame的型態
  data_deal <- as.data.frame(temp)
  return(data_deal)
}

deal_file<-function(data) {
  data <- subset(data,select=c(XML_Head.Infos.Info.Name:XML_Head.Infos.Info.Picdescribe1) )
  #移除zone欄(幾乎都空白)
  data <- subset(data, select = -XML_Head.Infos.Info.Zone)
  return(data)
}
#********************************************************

#**************************** 1 . **********************************
find_place_sight<-function() {
  
    cat("輸入一縣/市：(例如：垃圾苗栗縣)");cat("\n");
    cat("備註：(若台中市需要打_臺_字)");cat("\n");
    name <- readline()
    place<-subset(data,XML_Head.Infos.Info.Region==name,select=c(XML_Head.Infos.Info.Name:XML_Head.Infos.Info.Picdescribe1) )
    return(place) 
    
}

select_country<-function(sel){
  cat("輸入一鄉鎮：(例如：苑裡鎮)");cat("\n");
  selection <- sel[["XML_Head.Infos.Info.Town"]]
  
  #清除掉一個向量中重複的東西
  selection <- selection[!duplicated(selection)]
  print(selection)
  name <- readline()
  
  country<-subset(sel,XML_Head.Infos.Info.Town==name,select=c(XML_Head.Infos.Info.Name:XML_Head.Infos.Info.Picdescribe1) )
  
  repeat{
    x_name <- ""
    cat("輸入一個地點來獲取詳情：");cat("\n");
    cat("輸入0來跳出");cat("\n");
    print(country[["XML_Head.Infos.Info.Name"]])
    x_name<- readline()
    if ( x_name == "0" ){
      break;
    }
    else {
      detail <- subset(country,XML_Head.Infos.Info.Name == x_name,select=c(XML_Head.Infos.Info.Name:XML_Head.Infos.Info.Picdescribe1))
      cat("\n");print(detail);cat("\n\n");
    }
  }
  selection<-c()
}

#*******************************************************************

#*************************** 2 . ************************************************

city_sel<-function() {
  count <- 1
  Fname <- ""
  Sname <- ""
    city_list <- data[["XML_Head.Infos.Info.Region"]]
    city_list <- city_list[!duplicated(city_list)]
    print(city_list)
    cat(" 輸入要比較的縣/市名字：(兩個) ");cat("\n");
    cat(" 輸入Q將會返回                 ");cat("\n");
    Fname <- readline()
    Sname <- readline()
    compare_sight(Fname,Sname) ;
}

compare_sight <- function(Fname,Sname) {
  Fname1 <-Fname
  Sname1 <-Sname
  first_name<-subset(data,XML_Head.Infos.Info.Region==Fname1,select=c(XML_Head.Infos.Info.Name:XML_Head.Infos.Info.Picdescribe1) )
  second_name<-subset(data,XML_Head.Infos.Info.Region==Sname1,select=c(XML_Head.Infos.Info.Name:XML_Head.Infos.Info.Picdescribe1) )
  
  if ( length(first_name[["XML_Head.Infos.Info.Name"]]) > length(second_name[["XML_Head.Infos.Info.Name"]]) ) {
    cat(Fname," 景點量大於 ",Sname);cat("\n");
    cat("景點量為：",length(first_name[["XML_Head.Infos.Info.Name"]]));cat("\n");
    cat("圖在結束此程式後執行pic來呼叫...");cat("\n");
    pic<<-ggplot(data=first_name) +   
      geom_point(aes(x=XML_Head.Infos.Info.Town,  
                     y=XML_Head.Infos.Info.Name,
                     main="Sights of country",
                     color=XML_Head.Infos.Info.Town) 
      ) + 
      labs(title="City of Sights",
           x="Country",
           y="Name of sight") +
      
      theme_bw() ;
  }
  else if ( length(first_name[["XML_Head.Infos.Info.Name"]]) < length(second_name[["XML_Head.Infos.Info.Name"]]) ) {
    cat(Sname," 景點量大於 ",Fname);cat("\n");
    cat("景點量為：",length(second_name[["XML_Head.Infos.Info.Name"]]));cat("\n");
    cat("圖在結束此程式後執行pic來呼叫...");cat("\n");
    pic<<-ggplot(data=second_name) +   
      geom_point(aes(x=XML_Head.Infos.Info.Town,  
                     y=XML_Head.Infos.Info.Name,
                     main="Sights of country",
                     color=XML_Head.Infos.Info.Town) 
      ) + 
      labs(title="City of Sights",
           x="Country",
           y="Name of sight") +
      
      theme_bw() ;
  }
  
}

#**********************************************************************************

# *********************************** Main ******************************************

#從網頁上讀取json
data <- read_data()
#處理資料使用不到的部分刪除掉
data<- deal_file(data)

repeat {
  x <- ""
  sel<- c()
  cat("\n");
  cat("*1.輸入縣市、鄉鎮來取得景點相關資訊：  *") ;cat("\n");
  cat("*2.輸入兩個來比較：                    *") ;cat("\n");
  cat("*0.DS期末考大爆炸(離開)                *") ;cat("\n");
  x <-readline()
  
  if ( x == "1") {
    sel<-find_place_sight();
    select_country(sel);
  }
  else if ( x == "2") {
    city_sel();
  }
  else if ( x == "0" || x =="88" ){
    cat("\n");cat("謝謝您使用本服務");cat("\n");
    break ;
  }
  else {
    cat("\n");cat("輸入指令有誤，請重新輸入一次。");cat("\n");
  }
  
}

#技術上的不足於是圖另外印
pic

# ************************************************************************************
