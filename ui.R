#ui.R

library(shiny)
library(shinydashboard)

teams <- list(
  "Atlanta Hawks",
  "Boston Celtics",
  "Brooklyn Nets",
  "Charlotte Hornets",
  "Chicago Bulls",
  "Cleveland Cavaliers",
  "Dallas Mavericks",
  "Denver Nuggets",
  "Detroit Pistons",
  "Golden State Warriors",
  "Houston Rockets",
  "Indiana Pacers",
  "Los Angeles Clippers",
  "Los Angeles Lakers",
  "Memphis Grizzlies",
  "Miami Heat",
  "Milwaukee Bucks",
  "Minnesota Timberwolves",
  "New Orleans Pelicans",
  "New York Knicks",
  "Oklahoma City Thunder",
  "Orlando Magic",
  "Philadelphia 76ers",
  "Phoenix Suns",
  "Portland Trail Blazers",
  "Sacramento Kings",
  "San Antonio Spurs",
  "Toronto Raptors",
  "Utah Jazz",
  "Washington Wizards"
)


dashboardPage(
  dashboardHeader(
    title="Stats Dashboard"
  ),
  dashboardSidebar(
    img(id="logo", src="NBA-logo.jpg"),
    actionButton(inputId="scrapeNBA", label="Scrape NBA stats", class="text-center"),
    actionButton(inputId="scrapeFantasy", label="Scrape Fantasy stats")
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
    tabsetPanel(
      tabPanel(
        h4("NBA Stats/Graphs"),
        selectInput(inputId="teamChoice",
                    label="Select Team",
                    choices = teams)),
      tabPanel(
        h4("Fantasy Basketball Analysis")
      )
    )
  )
)


