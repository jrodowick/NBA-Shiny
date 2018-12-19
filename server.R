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
    
    if(input$shotType == '2 point %')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(TWOPPERC),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='2 point %',y='Minutes Played')
    }
    else if(input$shotType == '3 point %')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(THRPPERC),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='3 point %',y='Minutes Played')
    }
    else if(input$shotType == 'FG %')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(FGPERC),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='FG %',y='Minutes Played')
    }
  })
  output$`team-table` <- DT::renderDataTable({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
  })
  output$`league-table` <- DT::renderDataTable({
    #team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    DT::datatable(league_df, options = list(orderClasses = TRUE))
  })
  output$`AstTur-min` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    
    if(input$ASTTO == 'Assists')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(APG),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Assists',y='Minutes Played')
    }
    else if(input$ASTTO == 'Turnovers')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(TPG),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Turnovers',y='Minutes Played')
    }
    else if(input$ASTTO == 'Ast/To Ratio')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(ATO),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Assists/Turnoers',y='Minutes Played')
    }
  })
  output$`StlBlk-min` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    
    
    if(input$STLBLK == 'Steals')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(SPG),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Steals',y='Minutes Played')
    }
    else if(input$STLBLK == 'Blocks')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(BPG),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Blocks',y='Minutes Played')
    }
    else if(input$STLBLK == 'Rebounds')
    {
      ggplot(data = team_df, mapping = aes(x=as.double(RPG),y=as.double(MIN))) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Rebounds',y='Minutes Played')
    }
  })
  output$`per-min` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    ggplot(data=team_df, mapping = aes(x=PER,y=MIN)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      labs(x='Player Efficiency Rating',y='Minutes Played')
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
  output$`box` <- renderPlot({
    if(input$columnChoice == 'Points Per Game')
    {
      ggplot(data = league_df, mapping = aes(x=as.integer(PTS),fill=TEAM)) +
        geom_bar() +
        labs(x='Points Per Game',y='Number of teams')
    }
    else if(input$columnChoice == 'Field Goals Made')
    {
      ggplot(data = league_df, mapping = aes(x=as.integer(FGM),fill=TEAM)) +
        geom_bar() +
        labs(x='Field Goals Made',y='Number of teams')
    }
    else if(input$columnChoice == 'Field Goals Attempted')
    {
      ggplot(data = league_df, mapping = aes(x=as.integer(FGA),fill=TEAM)) +
        geom_bar() +
        labs(x='Field Goals Attempted',y='Number of teams')
    }
  })
  output$`games-started` <- renderPlot({
    team_df <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$teamChoice,'.csv'))
    
    ggplot(team_df, mapping = aes(x=GS,y=MIN)) +
      geom_point(data=team_df,mapping = aes(color=PLAYER)) +
      geom_smooth(method = "lm",se=FALSE)
  })
  
  output$`team-one` <- renderPlot({
    team_1 <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$`team-1`,'.csv'))
    if(input$Xaxis == 'Points Per Game')
    {
      ggplot(data = team_1, mapping = aes(x=PPG,y=MIN)) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Points Per Game',y='Minutes Played')
    }
    else if(input$Xaxis == 'Field Goal %')
    {
      ggplot(data = team_1, mapping = aes(x=FGPERC,y=MIN)) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Field Goal %',y='Minutes Played')
    }
  })
  output$`team-two` <- renderPlot({
    team_2 <- read.csv(str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',input$`team-2`,'.csv'))
    if(input$Xaxis == 'Points Per Game')
    {
      ggplot(data = team_2, mapping = aes(x=PPG,y=MIN)) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Points Per Game',y='Minutes Played')
    }
    else if(input$Xaxis == 'Field Goal %')
    {
      ggplot(data = team_2, mapping = aes(x=FGPERC,y=MIN)) +
        geom_point() +
        geom_smooth(method = "lm", se=FALSE) +
        labs(x='Field Goal %',y='Minutes Played')
    }
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
