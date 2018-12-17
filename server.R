#server.R
library(ggplot2)
library(stringr)

function(input,output) {
  output$team <- renderText({
    input$teamChoice
  })
  output$table <- renderTable({
    df <- read.csv(str_c(input$teamChoice,'.csv'))
  })
  observeEvent(input$scrapeNBA, {
    showModal(modalDialog(
      title = h2('Web scrape initiated'),
      h3('Scraping ESPN.com/NBA ...\n'),
      h3('Updating .csv files')
    ))
    source('scrapeNBA.R')
  })
}