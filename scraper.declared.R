## Steffi Airstrike Civilian Casualty Scraper

# Set Environment
library(tidyverse)
library(rvest)

# Set Dataframe of All Available Page Links
aw.link <- 'https://airwars.org/civilian-casualties/?type_of_strike=airstrike&country=somalia&belligerent=us-forces&strike_status=declared-strike'

aw.urls <- aw.link %>% #grabbing web links for the incident profiles from homepage  
  read_html() %>%
  html_nodes("a") %>% #pulling all of the links from the HTML, all of the nodes
  html_attr('href') %>% #and anything with an href attribute, which designates a link 
  as.data.frame() %>% #subset to only get links to incident profiles  
  plyr::rename(c('.' = 'Link')) %>% #descriptive column name to links 
  subset(str_detect(Link, 'civilian-casualties') &!str_detect(Link, 'page') & !str_detect(Link, 'country')) 
aw.urls

home.link <- data.frame(Links = 'https://airwars.org/civilian-casualties/?type_of_strike=airstrike&country=somalia&belligerent=us-forces&strike_status=declared-strike') #this link as only object in the column
core.links <- data.frame(Links = str_c('https://airwars.org/civilian-casualties/page/', 1:45, '/?country=somalia&belligerent=us-forces&strike_status=declared-strike')) #create the URLs for the 45 pages 

run.links <- home.link %>% 
  plyr::rbind.fill(., core.links) #homepage and then 1-45 links as the column rows  

# Pull all incident profile links from pages 1-45 and put into dataframe
pull_links <- function(core.links) {
  run.length <- core.links %>% #set length of the function 
    row.names() %>%
    length()
  for (k in 1:run.length) {
    page.urls <- core.links[k,'Links'] %>%
      read_html() %>%
      html_nodes("a") %>%
      html_attr('href') %>%
      as.data.frame() %>%
      plyr::rename(c('.' = 'Links')) %>%
      subset(str_detect(Links, 'civilian-casualties') &!str_detect(Links, 'page') & !str_detect(Links, 'country') & str_detect(Links, 'airwars')) #detect the incident profiles only 
    assign(str_c("urls_", k), value = page.urls, envir = .GlobalEnv) #exporting each page's weblinks to object for list of weblinks
    print(str_c(core.links[k,'Links'], "_Pulled")) #print the link archived after pulling data 
  }
  out.links <- eval(parse(text = paste("plyr::rbind.fill(", paste0("urls_", 1:run.length, sep = "", collapse = ","),
                                       ")"))) #pastes all the outputs into one dataframe 
  eval(parse(text = paste("remove(", paste0("urls_", 1:100, sep = "", collapse = ","),
                          ")")))
  return(out.links) #all of the "_Pulled" appended weblinks 
} 

id.links <- run.links %>% 
  pull_links()

# Pull all profile info
pull_info <- function(urls) {
  run.length <- urls %>% #run length for function 
    row.names() %>%
    length
  for (z in 1:run.length) { #pulling each incident profile link and reading the html 
    page.html <- urls[z,'Links'] %>%
      read_html()
    url <- urls[z,'Links'] #pulls the URLs
    all.parts <- page.html %>% #taking the incident profile html--the info we wanted is in this one section, selects the metablock and turns it into text 
      html_nodes('.meta-block') %>%
      html_text() %>%
      str_replace_all('\\r|\\n|\\t', '') %>% #removing aesthetic html 
      as.data.frame() %>%
      plyr::rename(c('.' = 'Item')) #turning metablock into a dataframe to pull subsets from 
    id <- all.parts %>%
      subset(str_detect(Item, 'Code')) %>% #pull the code 
      mutate(Item = str_replace_all(Item, '.*Code', '')) %>% #remove everything before code (extraneous)
      as.character()
    location <- all.parts %>%
      subset(str_detect(Item, 'Location')) %>%
      mutate(Item = str_replace_all(Item, '.*Location', '')) %>%
      as.character()
    date <- all.parts %>%
      subset(str_detect(Item, 'date')) %>%
      mutate(Item = str_replace_all(Item, '.*date', '')) %>%
      as.character()
    geoloc <- all.parts %>%
      subset(str_detect(Item, 'Geolocation') & str_detect(Item, 'map')) %>%
      mutate(Item = str_replace_all(Item, 'Note.*', '')) %>%
      mutate(Item = str_replace_all(Item, '.*ion', '')) %>%
      as.character()
    out.info <- data.frame(ID = id, #put output in a dataframe 
                           Location = location,
                           Date = date,
                           Coordinates = geoloc,
                           URL = url)
    assign(str_c("info_", z), value = out.info, envir = .GlobalEnv)
    print(str_c(urls[z,'Links'], "_Pulled")) #noting the incident profiles that were already pulled and archived 
  }
  out.info <- eval(parse(text = paste("plyr::rbind.fill(", paste0("info_", 1:run.length, sep = "", collapse = ","),
                                      ")")))
  eval(parse(text = paste("remove(", paste0("info_", 1:run.length, sep = "", collapse = ","),
                          ")")))
  return(out.info)
}

steffi.info <- id.links %>%
  pull_info()
# Output summary info into csv 
write_csv(steffi.info, str_c(Sys.Date(), "_civilian_casualty_summary.csv"))




install.packages(devtools)
library(utils)


