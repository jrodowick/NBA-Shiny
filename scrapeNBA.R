library(xml2)
library(httr)
library(dplyr)
library(rvest)
library(stringr)

teams <- list(
  atl <- c("Atlanta Hawks",'atl'),
  bos <- c("Boston Celtics",'bos'),
  bkn <- c("Brooklyn Nets", 'bkn'),
  cha <- c("Charlotte Hornets",'cha'),
  chi <- c("Chicago Bulls",'chi'),
  cle <- c("Cleveland Cavaliers",'cle'),
  dal <- c("Dallas Mavericks",'dal'),
  den <- c("Denver Nuggets",'den'),
  det <- c("Detroit Pistons",'det'),
  gs <- c("Golden State Warriors",'gs'),
  hou <- c("Houston Rockets",'hou'),
  int <- c("Indiana Pacers",'ind'),
  lac <- c("Los Angeles Clippers",'lac'),
  lal <- c("Los Angeles Lakers",'lal'),
  mem <- c("Memphis Grizzlies",'mem'),
  mia <- c("Miami Heat",'mia'),
  mil <- c("Milwaukee Bucks",'mil'),
  min <- c("Minnesota Timberwolves",'min'),
  no <- c("New Orleans Pelicans", 'no'),
  ny <- c("New York Knicks",'ny'),
  okc <- c("Oklahoma City Thunder",'okc'),
  orl <- c("Orlando Magic",'orl'),
  phi <- c("Philadelphia 76ers",'phi'),
  pho <- c("Phoenix Suns",'pho'),
  por <- c("Portland Trail Blazers",'por'),
  sac <- c("Sacramento Kings",'sac'),
  sa <- c("San Antonio Spurs",'sa'),
  tor <- c("Toronto Raptors",'tor'),
  utah <- c("Utah Jazz",'utah'),
  was <- c("Washington Wizards",'was')
)

team_prepend <- 'http://www.espn.com/nba/team/stats/_/name/'

o_url <- 'http://www.espn.com/nba/statistics/team/_/stat/offense-per-game'
d_url <- 'http://www.espn.com/nba/statistics/team/_/stat/defense-per-game'

league_url <- 'http://www.espn.com/nba/standings/_/group/league'

###  Scrape League wins and losses ###
scrapeLeague <- function(league_url,o_url,d_url) {
  
  teams_offense <- read_html(o_url)
  teams_defense <- read_html(d_url)
  
  o_tables <- html_nodes(teams_offense, "table")
  d_tables <- html_nodes(teams_defense, "table")
  
  o_col_names <- o_tables %>%
    xml_child(1) %>%
    xml_find_all("td") %>%
    xml_text()
  
  offense_stats <- o_tables %>%
    xml_find_all(".//tr[@class != 'colhead']") %>%
    xml_find_all("td") %>%
    xml_text()
  
  d_col_names <- d_tables %>%
    xml_child(1) %>%
    xml_find_all("td") %>%
    xml_text()
  
  defense_stats <- d_tables %>%
    xml_find_all(".//tr[@class != 'colhead']") %>%
    xml_find_all("td") %>%
    xml_text()
  
  
  team_off_df <- data.frame(matrix(offense_stats, nrow = 30, ncol = 14, byrow = TRUE), stringsAsFactors = FALSE)
  team_def_df <- data.frame(matrix(defense_stats, nrow = 30, ncol = 14, byrow = TRUE), stringsAsFactors = FALSE)
  
  col_names <- c('TEAM','PTS',	'FGM',	'FGA',	'FGPERC',	'THRPM',	'THRPA','THRPPERC',	'FTM',	'FTA',	'FTPERC',	'PPS',	'AFG')
  
  team_off_df <- team_off_df[,-1]
  team_def_df <- team_def_df[,-1]
  
  colnames(team_off_df) <- col_names
  colnames(team_def_df) <- col_names
  
  
  
  
  #write.csv(team_off_df, '/home/jrodowick/NBA-Shiny/teamOffense.csv')
  write.csv(team_def_df, '/home/jrodowick/NBA-Shiny/teamDefense.csv')
  
#########################################################################################
  
  league <- read_html(league_url)
  league_table <- html_nodes(league,"table")
  
  team_names <- league_table[2] %>%
    xml_find_all(".//tr[@class != 'stathead']") %>%
    xml_find_all("td") %>%
    xml_find_all("div") %>%
    xml_find_all("span") %>%
    xml_text()
  
  
  i <- 1
  new_teams <- array()
  
  for(e in seq(3,90,by=3)) {
    new_teams[i] <- team_names[e]
    i <- i+1
  }
  
  e <- 1
  for(team in new_teams) {
    if(team == 'Los Angeles Lakers')
    {
      team <- 'LA Lakers'
    }
    else if(team == 'LA Clippers')
    {
      team <- 'LA Clippers'
    }
    else if(team == 'Oklahoma City Thunder')
    {
      team <- 'Oklahoma City'
    }
    else if(team == 'New York Knicks')
    {
      team <- 'New York'
    }
    else if(team == 'Golden State Warriors')
    {
      team <- 'Golden State'
    }
    else if(team == 'New Orleans Pelicans')
    {
      team <- 'New Orleans'
    }
    else if(team == 'San Antonio Spurs')
    {
      team <- 'San Antonio'
    }
    else 
    {
      team <- strsplit(team,' ')[[1]][1]
    }
    new_teams[e] <- team
    e <- e + 1
  }
  print(new_teams)
  
  league_stats <- league_table[3] %>%
    xml_find_all(".//tr[@class != 'stathead']") %>%
    xml_find_all("td") %>%
    xml_text()
  
  cols <- c('TEAM','Wins','Loss','PCT','GB','Home','Away','DIV','CONF','PPG','OppPPG','DIFF','STRK','L10')
  
  league_df <- data.frame(matrix(league_stats, nrow = 30, ncol = 13, byrow = TRUE), stringsAsFactors = FALSE)
  
  league_df <- cbind(new_teams,league_df)
  
  colnames(league_df) <- cols
  
  final_df <- left_join(team_off_df, league_df)
  
  write.csv(final_df, str_c('/home/jrodowick/NBA-Shiny/leagueInfo.csv'),append = FALSE)
  
  
}

#### Scrape Each teams players ###
scrapePlayers <-function(prepend, append, filename) {
  team_url <- str_c(prepend, append)
  team <- read_html(team_url)
  team_table <- html_nodes(team, "table")
  
  game_stats <- team_table[1] %>%
    xml_find_all(".//tr[@class != 'stathead']") %>%
    xml_find_all("td") %>%
    xml_text()
  
  team_col_name <- team_table[1] %>%
    xml_child(2) %>%
    xml_find_all("td") %>%
    xml_text()
  
  
  shooting_stats <- team_table[2] %>%
    xml_find_all(".//tr[@class != 'stathead']") %>%
    xml_find_all("td") %>%
    xml_text()
  
  shooting_col_name <- team_table[2] %>%
    xml_child(2) %>%
    xml_find_all("td") %>%
    xml_text()
  
  game_df <- data.frame(matrix(game_stats, nrow = 15, ncol = 15, byrow = TRUE), stringsAsFactors = FALSE)
  shooting_df <- data.frame(matrix(shooting_stats, nrow = 15, ncol = 15, byrow = TRUE), stringsAsFactors = FALSE)
  
  colnames(game_df) <- team_col_name
  colnames(shooting_df) <- shooting_col_name
  
  team_df <- left_join(game_df,shooting_df)
  team_df <- team_df[-1,]
  
  cols <- c('PLAYER',	'GP',	'GS',	'MIN', 'PPG',	'OFFR',	'DEFR',	'RPG',	'APG',	'SPG',	'BPG',	'TPG',	'FPG',	'ATO',	'PER',	'FGM',	'FGA',	'FGPERC',	'THRPM',	'THRPA',	'THRPPERC',	'FTM',	'FTA',	'FTPERC',	'TWOPM', 'TWOPA', 'TWOPPERC', 'PPS', 'AFGPERC')
  colnames(team_df) <- cols
  
  write.csv(team_df, str_c('/home/jrodowick/NBA-Shiny/team_csv_files/',filename),append = FALSE)
}


## Call all functions ##
for(i in teams) {
  scrapePlayers(team_prepend, i[2], str_c(i[1],'.csv'))
}

scrapeLeague(league_url,o_url,d_url)
