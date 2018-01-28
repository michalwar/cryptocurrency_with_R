
loadCryptoData <- function(name){
  
  library(XML)
  library(RCurl)
  library(rlist)
  
# set url
theurl <- 
    getURL(paste0("https://coinmarketcap.com/currencies/",
                  name,
                  "/historical-data/?start=20130428&end=21000101"),
           .opts = list(ssl.verifypeer = FALSE)
           )

# read html source
tables <- readHTMLTable(theurl, 
                        stringsAsFactors = FALSE)
  
# clean the list object
tables <- list.clean(tables, 
                     fun = is.null, 
                     recursive = FALSE)

    # unlist the list
    table <- tables[[1]]
    
    # convert characters to numericals
    table$Open      <- as.numeric(gsub(",", "", table$Open))
    table$High      <- as.numeric(gsub(",", "", table$High))
    table$Low       <- as.numeric(gsub(",", "", table$Low))
    table$Close     <- as.numeric(gsub(",", "", table$Close))
    table$Volume    <- as.numeric(gsub(",", "", table$Volume))
    table$MarketCap <- as.numeric(gsub(",", "", table[, "Market Cap"]))
    table[, "Market Cap"] <- NULL

    # set locale to English
    Sys.setlocale("LC_TIME", "C")
    
    # convert the date from chr into Date
    table$Date <- as.Date(table$Date, 
                          format = "%b %d, %Y") # b - means use 3 first letters of the month

return(table)

}

btc <- loadCryptoData("bitcoin")
    head(btc)

eth <- loadCryptoData("ethereum")
    head(eth)


# Simple - Results wizualization 
library(ggplot2)
  
    ggplot() + 
      geom_line(data = btc, 
                aes(x = btc$Date,
                    y = btc$Close))


# Advanced - Results wizualization
library(dygraphs)
library(xts)

    btc.xts <-xts(btc, 
                  order.by = btc$Date)
    
    dygraph(btc.xts[,"Close"]) %>% 
              dyRangeSelector(height = 50)





