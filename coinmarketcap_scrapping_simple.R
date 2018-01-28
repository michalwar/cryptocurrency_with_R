library(XML)
library(RCurl)
library(rlist)
# Sys.getenv("JAVA_HOME")
Sys.setenv(JAVA_HOME="c:/Program Files/Java/jdk1.8.0_144/jre/") # Java just in case - some problems with xlsx
library(xlsx)

# set url
theurl <- 
  getURL("https://coinmarketcap.com/currencies/bitcoin/historical-data/?start=20130428&end=21000101",
         .opts = list(ssl.verifypeer = FALSE) )

# read html source
tables <- readHTMLTable(theurl, stringsAsFactors = FALSE)

# clean the list object
tables <- list.clean(tables, fun = is.null, recursive = FALSE)

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
table$Date <- as.Date(table$Date, format = "%b %d, %Y")

# verify the structure of the data.frame
# str(table)

# save the table
write.xlsx(table, 
           file = "bitcoin.xlsx", 
sheetName = "qoute")
