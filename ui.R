
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Bombay Stock Exchange Historical Returns"),
  h3("Introduction"),
  p("Bombay Stock Exchange is the oldest stock exchanges in India. 
    BSE 30 is a market-weighted stock market index calculated from 30 well established
    companies on this exchange. This index is said to be reflect the pulse of the
    indian stock market and investor confidence in the indian economy."),
  p("I have been interested in financial investing for a while. The idea behind this
    application is to investigate the historical trends and whether indian stock
    market is a good long term bet based on historical data."),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h3("Howto"),
      p("Please select a date for starting your investment period. Also select
        and investment interval. We will purchase 100 units of currency every
        interval from the start date till the current data."),
      dateInput("date",
                "Starting Date", 
                value = "1980-01-01", 
                min = "1980-01-01", 
                max = "2014-01-01",
                format = "yyyy-mm-dd", 
                startview = "year",
      ),
      selectInput("interval",
                  "Investment Interval", 
                  c("monthly" = "monthly",
                    "biannually" = "biannually",
                    "yearly" = "yearly"), 
                  selected = "yearly"
      )
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      textOutput("totalInvestment"),
      textOutput("currentValue")
    )
  )
))
