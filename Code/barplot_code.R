## Visualizing Scraped Airwars Data for Somalia by DPH Claim Assessment
## Steffi Colao | Michael Everett

## Create new column headings for cleaning xlsx file converted from PDF appendix
new.cols <- c('ID', 'Location','Date', 'Claimed.by.AFRICOM', 'Claimed.1', 'Claimed.2',
              'Target.Description', 'Target.1', 'Target.2','DPH.Claim','Link')

## Load and clean xlsx file converted from PDF appendix
somalia.appendix <- '/somalia_data.csv' %>%
    read_csv() %>%
    mutate(
        Claimed.by.AFRICOM = `Claimed by AFRICOM?`,
        Target.Description = `Description of target`,
        DPH.Claim = `DPH claim?`,
        Link = URL,
        Date.Clean.Try = as.Date(Date,'%d-%b-%y'),
        Date.Fix.Month = ifelse(is.na(Date.Clean.Try),str_replace_all(Date, ' .*',''),NA),
        Date.Fix.Year = ifelse(is.na(Date.Clean.Try),str_replace_all(Date, '.*,',''),NA),
        Date.Fix.Day = ifelse(is.na(Date.Clean.Try),str_replace(Date, ',.*',''),NA),
        Date.Fix.Day = str_replace_all(Date.Fix.Day,'.* ',''),
        Date.Fix.Day = gsub("–", "x",  Date.Fix.Day),
        Date.Fix.Day = str_replace_all(Date.Fix.Day, 'x.*',''),
        Date.Clean.Fix = as.Date(str_c(Date.Fix.Year,'-',Date.Fix.Month,'-',Date.Fix.Day),format='%Y-%B-%d'),
        Date.Combined = coalesce(Date.Clean.Try,Date.Clean.Fix),
        Date.Combined.Year = lubridate::year(Date.Combined),
        Administration = case_when(
            Date.Combined<as.Date('2009-01-20',format = '%Y-%m-%d')~'George W. Bush',
            Date.Combined>=as.Date('2009-01-20',format = '%Y-%m-%d')&Date.Combined<as.Date('2017-01-20',format = '%Y-%m-%d')~'Barack Obama',
            Date.Combined>=as.Date('2017-01-20',format = '%Y-%m-%d')&Date.Combined<as.Date('2021-01-20',format = '%Y-%m-%d')~'Donald Trump',
            Date.Combined>=as.Date('2021-01-20',format = '%Y-%m-%d')~'Joe Biden'
        )
    ) %>%
    select(ID, Location, Administration, Date, Date.Clean.Try, Date.Fix.Month, Date.Fix.Year, 
           Date.Fix.Day,Date.Clean.Fix,Date.Combined,Date.Combined.Year,
           Claimed.by.AFRICOM, Target.Description, DPH.Claim, Link)

## Create aggregate summaries of AFRICOM vs. Likely U.S. airborne strikes by DPH Claim variable ---------------------------------------
somalia.agg.us <- somalia.appendix %>%
    #subset(!is.na(ID)) %>%
    group_by(DPH.Claim) %>%
    summarise(`Total Cases` = n()) %>%
    mutate(Claimed.by = 'United States')
somalia.agg.afcom <- somalia.appendix %>%
    #subset(!is.na(ID)) %>%
    subset(Claimed.by.AFRICOM == 'Yes') %>%
    group_by(DPH.Claim) %>%
    summarise(`Total Cases` = n()) %>%
    mutate(Claimed.by = 'AFRICOM')

somalia.agg.case <- somalia.agg.us %>%
    rbind(somalia.agg.afcom)

## Factorize variables in aggregate summary files for visualization of AFRICOM vs. Likely U.S. airborne strikes by DPH Claim variable
somalia.agg.factor = somalia.agg.case %>% 
    group_by(Claimed.by) %>% 
    arrange(`Total Cases`) %>% 
    mutate(
        Claimed.by = Claimed.by %>% factor(c("United States", "AFRICOM")),
        DPH.Claim  = factor(DPH.Claim, levels = c('No', 'Maybe', 'Yes'))
    )

## Create color dataframe for DPH Claim visualizing AFRICOM vs. Likely U.S. airborne strikes by DPH Claim variable
fill_values <- c("No" = "#00847C",
                 "Yes" = "#FB8C00", 
                 "Maybe" = "#FFAE88")

## Create bar plot of AFRICOM vs. Likely U.S. airborne strikes by DPH Claim variable
somalia.barplot.dphclaim <- somalia.agg.factor %>% 
    ggplot(aes(x= Claimed.by, y= `Total Cases`, fill= DPH.Claim)) +
    geom_bar(data=somalia.agg.factor %>% filter(Claimed.by == "United States"), width=0.35, position = 'stack',  stat = "identity") +
    geom_bar(data=somalia.agg.factor %>% filter(Claimed.by == "AFRICOM"), width=0.35, position = 'stack',  stat = "identity") +
    scale_x_discrete(labels = c("AFRICOM", "Likely U.S. Government")) +
    scale_fill_manual(
        values = fill_values, 
        breaks = c("No", "Maybe", "Yes"), 
        labels = c("No", 
                   "Maybe", 
                   "Yes")
    ) +
    theme(panel.background = element_blank()) +
    theme(axis.text.y=element_text(size=16),
          axis.text.x=element_text(size=16),
          legend.title = element_text(size=14),
          legend.text = element_text(size=12),
            axis.title=element_text(size=16))+
    labs(title = NULL,
         x= NULL,
         y= "Count (n)",
         fill = 'DPH Claim')

## Show bar plot of AFRICOM vs. Likely U.S. airborne strikes by DPH Claim variable
somalia.barplot.dphclaim

## Save barplots of AFRICOM vs. Likely U.S. airborne strikes by DPH Claim variable
file.location = '/DPHClaim_StrikeCount_barplot.svg' 

ggsave(filename = file.location,
       somalia.barplot.dphclaim, 
       width = 12, height = 8
)

## Create aggregate summaries by presidential administration --------------------------------------------------------------
somalia.agg.admin <- somalia.appendix %>%
    group_by(Administration,DPH.Claim) %>%
    summarise(`Total Cases` = n()) %>%
    mutate(DPH.Claim = factor(DPH.Claim, levels = c('No', 'Maybe', 'Yes')),
           Administration = factor(Administration, levels = c('George W. Bush', 'Barack Obama', 'Donald Trump', 'Joe Biden'))
           )

## Create color dataframe for DPH Claim by presidential administration
fill_values <- c("No" = "#00847C",
                 "Yes" = "#FB8C00", 
                 "Maybe" = "#FFAE88")

## Create bar plot of DPH Claim by presidential administration
somalia.barplot.administration <- somalia.agg.admin %>% 
    ggplot(aes(x= Administration, y= `Total Cases`, fill= DPH.Claim)) +
    geom_bar(stat = 'identity', width = 0.5) +
    scale_fill_manual(
        values = fill_values, 
        breaks = c("No", "Maybe", "Yes"), 
        labels = c("No", 
                   "Maybe", 
                   "Yes")
    ) +
    theme(panel.background = element_blank()) +
    theme(axis.text.y=element_text(size=16),
          axis.text.x=element_text(size=16),
          legend.title = element_text(size=14),
          legend.text = element_text(size=12),
          axis.title=element_text(size=16))+
    labs(title = NULL,
         x= NULL,
         y= "Count (n)",
         fill = 'DPH Claim')

## Show bar plot of DPH Claim by presidential administration
somalia.barplot.administration

## Save barplots DPH Claim by presidential administration
file.location = '/Administration_StrikeCount_barplot.svg' 

ggsave(filename = file.location,
       somalia.barplot.administration, 
       width = 12, height = 8
)


## Create aggregate summaries by year --------------------------------------------------------------
somalia.agg.year <- somalia.appendix %>%
    mutate(Year = Date.Combined.Year) %>%
    group_by(Year,DPH.Claim) %>%
    summarise(`Total Cases` = n()) %>%
    mutate(DPH.Claim = factor(DPH.Claim, levels = c('No', 'Maybe', 'Yes'))
    )

## Create color dataframe for DPH Claim by presidential administration
fill_values <- c("No" = "#00847C",
                 "Yes" = "#FB8C00", 
                 "Maybe" = "#FFAE88")

## Create bar plot of DPH Claim by presidential administration
somalia.barplot.year <- somalia.agg.year %>% 
    ggplot(aes(x= Year, y= `Total Cases`, fill= DPH.Claim)) +
    geom_bar(stat = 'identity', width = 0.5) +
    scale_fill_manual(
        values = fill_values, 
        breaks = c("No", "Maybe", "Yes"), 
        labels = c("No", 
                   "Maybe", 
                   "Yes")
    ) +
    theme(panel.background = element_blank()) +
    theme(axis.text.y=element_text(size=16),
          axis.text.x=element_text(size=16),
          legend.title = element_text(size=14),
          legend.text = element_text(size=12),
          axis.title=element_text(size=16))+
    labs(title = NULL,
         x= NULL,
         y= "Count (n)",
         fill = 'DPH Claim')

## Show bar plot of DPH Claim by presidential administration
somalia.barplot.year

## Save barplots DPH Claim by presidential administration
file.location = '/Annual_StrikeCount_barplot.svg' 

ggsave(filename = file.location,
       somalia.barplot.year, 
       width = 12, height = 8
)



