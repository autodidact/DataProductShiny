
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(lubridate)
library(RCurl)

shinyServer(function(input, output) {

  data <- NULL;
  unit <- 100;
  Sys.setlocale(category = "LC_ALL", locale = "en_US.UTF-8");
  
  loadCSV <- function() {
    if (!is.null(data)) return (data)
    
    #message("loading data")
    #url <- getURL("https://raw.githubusercontent.com/autodidact/DataProductShiny/master/data/bse30.csv",encoding="UTF-8")
    ldata <- read.csv("data/bse30date.csv")
                
    ldata$Date <- as.Date(ldata$Date)
    data <<- ldata
    return (data)
  }
  
  calculateDates <- function(start, end, interval) {   
    if (interval == "monthly") {
      plus <- "month"
    }
    else if (interval == "biannually") {
      plus <- "6 months"
    }
    else {
      plus <- "year"
    }
    seq(start, end, by=plus)
  }
  
  df <- reactive({
    data <- loadCSV()
    
    interval <- input$interval
    start <- input$date
    
    end <- tail(data$Date, n=1)
    print(str(data))
    print(end)
    
    dates <- calculateDates(start, end, interval)
    total <- length(dates)
    
    stock_index <- numeric(total)
    
    num <- 1
    for (d in seq_along(data$Date)) {
      row <- data[d, ]
      if (dates[num] < row$Date) {
        stock_index[num] <- data[d-1, ]$Close
        num <- num + 1
        if (num > total) break
      }
    }
    
    data.frame(date=dates, index=stock_index)
  })
  
  output$distPlot <- renderPlot({
    mydf <- df()
    plot(mydf$date, mydf$index, type="b", ylab="Stock Index", xlab="Date")
  })
  
  output$totalInvestment <- renderText({
    mydf <- df()
    ti <- length(mydf$date) * unit
    paste("Your total investments till date: ", ti)
  })
  
  output$currentValue <- renderText({
    mydf <- df()
    current_index <- tail(loadCSV()$Close, n=1)
    
    cv<- sum(sapply(mydf$index, function(index) {
      unit*(current_index - index)/index
    }))
    paste("Current value of your holdings: ", cv)
  })

})
