#ui.R

library(shiny)
library(shinydashboard)
library(stringr)
library(DT)

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

shots <- list(
  "Field Goal %",
  "3 Point %",
  "Free Throw %"
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
        
        tabsetPanel(
          tabPanel(h5('By Team'),
             selectInput(inputId="teamChoice",
                         label=h3("Select Team"),
                         choices = teams),
             fluidRow(
               h2(textOutput('team'))
             ),
             fluidRow(
               h3('What factors into minutes played',
                  class='text-center'),
               column(width=4,
                      h4('Minutes Played vs Shot Make %',
                         class='text-center'),
                      plotOutput('fg-min')
               ),
               column(width=4,
                      h4('Minutes Played vs Assists and Turnovers per game',
                         class='text-center'),
                      plotOutput('AstTur-min')
               ),
               column(width=4,
                      h4('Minutes Played vs Steal and Blocks per game',
                         class='text-center'),
                      plotOutput('StlBlk-min')
               )
             ),
             fluidRow(
               column(
                 h4('Minutes Played vs Player Efficency Rating',
                    class='text-center'),
                 width=4,
                 plotOutput('per-min')
               )
             ),
             fluidRow(
               column(
                 id="teamData",
                 width=6,
                 #tableOutput('team-table')
                 DT::dataTableOutput('team-table')
               )
             )
          ),
          tabPanel(h5('Entire League'),
            fluidRow(
              h3("Looking at what determines win percentage", class="text-center"),
              column(
                h3('Win % vs Points Per Game',
                   class='text-center'
                ),
                id="win-ppg",
                width=4,
                plotOutput('win-ppg')
              ),
              column(
                h3('Win % vs Opponents Points Per Game',
                   class='text-center'
                ),
                id="win-oppg",
                width=4,
                plotOutput('win-oppg')
              ),
              column(
                width=4,
                selectInput(inputId="shotChoice",
                            label = 'Select shot',
                            choices=shots),
                plotOutput('win-shot')
                
              )
            )
                   
          )
        )
        
        
      ),
        
      tabPanel(
        h4("Fantasy Basketball Analysis")
      )
    )
  )
)



