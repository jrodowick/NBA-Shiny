#server.R
library(ggplot2)
library(stringr)

function(input,output) {
  league_df <- read.csv('/home/jrodowick/NBA-Shiny/leagueInfo.csv')
  
  output$team <- renderText({
    input$teamChoice
  })
  output$`win-shot` <- renderPlot({
    if(input$shotChoice == 'Field Goal %')
    {
      ggplot(data = league_df, mapping = aes(x=as.double(FGPERC), y=as.double(PCT))) +
        geom_point() +
        geom_smooth(method = "lm", se = FALSE) +
        #ggtitle('Win % vs Points Per Game') +
        labs(x='FG %',y='Win Percentage')
    }
    else if(input$shotChoice == '3 Point %')
    {
      ggplot(data = league_df, mapping = aes(x=as.double(THRPPERC), y=as.double(PCT))) +
        geom_point() +
        geom_smooth(method = "lm", se = FALSE) +
        #ggtitle('Win % vs Points Per Game') +
        labs(x='3P Shot %',y='Win Percentage')
    }
    else if(input$shotChoice == 'Free Throw %')
    {
      ggplot(data = league_df, mapping = aes(x=as.double(FTPERC), y=as.double(PCT))) +
        geom_point() +
        geom_smooth(method = "lm", se = FALSE) +
        #ggtitle('Win % vs Points Per Game') +
        labs(x='Free Throw %',y='Win Percentage')
    }
    
  })
  output$`fg-min` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    ggplot() +
      geom_point(data = team_df, mapping = aes(x=as.double(TWOPPERC),y=as.double(MIN), color='2P %')) +
      geom_smooth(method = "lm", se=FALSE) +
      geom_point(data = team_df, mapping = aes(x=as.double(THRPPERC),y=as.double(MIN), color='3P %')) +
      geom_smooth(method = "lm", se=FALSE) +
      geom_point(data = team_df, mapping = aes(x=as.double(FGPERC),y=as.double(MIN), color='FG %')) +
      geom_smooth(method = "lm", se=FALSE) +
      
      labs(x='Field Goal %',y='Minutes Played')
  })
  output$`team-table` <- DT::renderDataTable({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
  })
  output$`AstTur-min` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    ggplot() +
      geom_point(data = team_df, mapping = aes(x=as.double(TPG),y=as.double(MIN),color='Turnovers')) +
      geom_smooth(method = "lm", se=FALSE) +
      geom_point(data = team_df, mapping = aes(x=as.double(APG),y=as.double(MIN),color='Assists')) +
      geom_smooth(method = "lm", se=FALSE) +
      labs(x='Assists/Turnovers',y='Minutes Played')
  })
  output$`StlBlk-min` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    ggplot() +
      geom_point(data = team_df, mapping = aes(x=as.double(SPG),y=as.double(MIN),color='Steals')) +
      geom_smooth(method = "lm", se=FALSE) +
      geom_point(data = team_df, mapping = aes(x=as.double(BPG),y=as.double(MIN),color='Blocks')) +
      geom_smooth(method = "lm", se=FALSE) +
      labs(x='Steals and Blocks',y='Minutes Played')
  })
  output$`per-min` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    ggplot(data=team_df, mapping = aes(x=PER,y=MIN)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE)
  })
  output$`win-ppg` <- renderPlot({
    ggplot(data = league_df, mapping = aes(x=as.integer(PPG), y=as.double(PCT))) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      #ggtitle('Win % vs Points Per Game') +
      labs(x='Points Per Game',y='Win Percentage')
  })
  output$`win-oppg` <- renderPlot({
    ggplot(data = league_df, mapping = aes(x=as.integer(OppPPG), y=as.double(PCT))) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      #ggtitle('Win % vs Opponents Points Per Game') +
      labs(x='Opponents Points Per Game',y='Win Percentage')
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
