#ui.R

library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(
    title=""
  ),
  dashboardSidebar(
    img(id="logo", src="NBA-logo.jpg")
  ),
  dashboardBody(
    tags$head(
      tags$link(
        rel="stylesheet",
        type="text/css",
        href="style.css"
      )
    ),
  h1("NBA stat scraper/Fantasy Basketball analyzer"),
  tags$hr(),
  actionButton(inputId="scrapeNBA", label="Scrape NBA stats"),
  actionButton(inputId="scrapeFantasy", label="Scrape Fantasy stats")
  
  )
)


