library(xml2)
library(httr)
library(dplyr)

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


teams_offense_url <- "http://www.espn.com/nba/statistics/team/_/stat/offense-per-game"
team_prepend <- "http://www.espn.com/nba/team/stats/_/name/"

teams_offense <- read_html(teams_offense_url)

tables <- html_nodes(teams_offense, "table")

col_names <- tables %>%
  xml_child(1) %>%
  xml_find_all("td") %>%
  xml_text()

player_stats <- tables %>%
  xml_find_all(".//tr[@class != 'colhead']") %>%
  xml_find_all("td") %>%
  xml_text()


team_off_df <- data.frame(matrix(player_stats, nrow = 30, ncol = 14, byrow = TRUE), stringsAsFactors = FALSE)
colnames(team_off_df) <- col_names

team_off_df <- team_off_df %>%
  select(-c(RK))

write.csv(team_off_df, 'NBA-Shiny/teamOffense.csv')



scrapeTeam <-function(prepend, append, filename) {
  team_url <- str_c(prepend, append)
  team <- read_html(team_url)
  team_table <- html_nodes(team, "table")
  team_col_name <- team_table %>%
    xml_child(2) %>%
    xml_find_all("td") %>%
    xml_text()
  
  team_stats <- team_table %>%
    xml_find_all(".//tr[@class != 'stathead']") %>%
    xml_find_all("td") %>%
    xml_text()
  
  team_df <- data.frame(matrix(team_stats, nrow = 17, ncol = 15, byrow = TRUE), stringsAsFactors = FALSE)
  team_df <- team_df[-1,]
  colnames(team_df) <- team_col_name
  
  write.csv(team_df, str_c('NBA-Shiny/',filename))
}

for(i in teams) {
  scrapeTeam(team_prepend, i[2], str_c(i[1],'.csv'))
}
