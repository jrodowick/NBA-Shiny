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

league_choice <- list(
  'Points Per Game',
  'Field Goals Made',
  'Field Goals Attempted'
  
)

shot_choice <- list(
  '2 point %',
  '3 point %',
  'FG %'
)


dashboardPage(
  dashboardHeader(
    title="Stats Dashboard"
  ),
  dashboardSidebar(
    img(id="logo", src="NBA-logo.jpg"),
    actionButton(inputId="scrapeNBA", label="Scrape NBA stats", class="text-center")
    #actionButton(inputId="scrapeFantasy", label="Scrape Fantasy stats")
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
               h3('Looking at what determines a players minutes in game',
                  class='text-center'),
               column(width=4,
                      h4('Minutes Played vs Shot Make %'),
                      selectInput(inputId='shotType',
                                  label='',
                                  choices = shot_choice ),
                      plotOutput('fg-min')
               ),
               column(width=4,
                      h4('Minutes Played vs Assists and Turnovers per game'),
                      selectInput(inputId='ASTTO',
                                  label='',
                                  choices = c('Assists','Turnovers','Ast/To Ratio')),
                      plotOutput('AstTur-min')
               ),
               column(width=4,
                      h4('Minutes Played vs Steal and Blocks per game'),
                      selectInput(inputId='STLBLK',
                                  label='',
                                  choices = c('Steals','Blocks','Rebounds')),
                      plotOutput('StlBlk-min')
               )
             ),
             fluidRow(
               column(
                 h4('Minutes Played vs Player Efficency Rating',
                    class='text-center'),
                 width=4,
                 plotOutput('per-min')
               ),
               column(
                 h4('Minutes played vs Games started',
                    class='text-center'),
                 width=8,
                 plotOutput('games-started')
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
            ),
            fluidRow(
              column(
                h3('Team Points / Made Shots / Shot attempts',
                   class='text-center'),
                width=10,
                plotOutput('box')
              ),
              column(
                id='columnSelect',
                width=2,
                selectInput(inputId='columnChoice',
                            label='Select X axis',
                            choices = league_choice)
              )
            ),
            fluidRow(
              column(
                width=6,
                id='leagueData',
                DT::dataTableOutput('league-table')
                
              )
            )
                   
          )
        )
        
        
      )
    )
  )
)



