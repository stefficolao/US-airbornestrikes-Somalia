## Visualizing Scraped Airwars Data for Somalia by DPH Claim Assessment
## Steffi Colao | Michael Everett

## Create new column headings for cleaning xlsx file converted from PDF appendix
new.cols <- c('ID', 'Location','Date', 'Claimed.by.AFRICOM', 'Claimed.1', 'Claimed.2',
              'Target.Description', 'Target.1', 'Target.2','DPH.Claim','Link')

## Load and clean xlsx file converted from PDF appendix
somalia.appendix <- '/Users/atlas/Documents/OUT_3/Steffi_Somalia/out_files/somalia_data.csv' %>%
    read_csv() %>%
    mutate(
        Claimed.by.AFRICOM = `Claimed by AFRICOM?`,
        Target.Description = `Description of target`,
        DPH.Claim = `DPH claim?`,
        Link = URL
    ) %>%
    select(ID, Location, Date, Claimed.by.AFRICOM, Target.Description, DPH.Claim, Link)

## Create aggregate summaries of AFRICOM / US strikes by DPH Claim variable
somalia.agg.us <- somalia.appendix %>%
    subset(!is.na(ID)) %>%
    group_by(DPH.Claim) %>%
    summarise(`Total Cases` = n()) %>%
    mutate(Claimed.by = 'United States')
somalia.agg.afcom <- somalia.appendix %>%
    subset(!is.na(ID)) %>%
    subset(Claimed.by.AFRICOM == 'Yes') %>%
    group_by(DPH.Claim) %>%
    summarise(`Total Cases` = n()) %>%
    mutate(Claimed.by = 'AFRICOM')

somalia.agg.case <- somalia.agg.us %>%
    rbind(somalia.agg.afcom)

## Factorize variables in aggregate summary files for visualization
somalia.agg.factor = somalia.agg.case %>% 
    group_by(Claimed.by) %>% 
    arrange(`Total Cases`) %>% 
    mutate(
        Claimed.by = Claimed.by %>% factor(c("United States", "AFRICOM")),
        DPH.Claim  = factor(DPH.Claim, levels = c('No', 'Maybe', 'Yes'))
    )

## Create color dataframe for DPH Claim visualizing
fill_values <- c("No" = "#00847C",
                 "Yes" = "#FB8C00", 
                 "Maybe" = "#FFAE88")

## Create bar plot
somalia.bar.plot <- somalia.agg.factor %>% 
    ggplot(aes(x= Claimed.by, y= `Total Cases`, fill= DPH.Claim)) +
    geom_bar(data=somalia.agg.factor %>% filter(Claimed.by == "United States"), width=0.35, position = 'stack',  stat = "identity") +
    geom_bar(data=somalia.agg.factor %>% filter(Claimed.by == "AFRICOM"), width=0.35, position = 'stack',  stat = "identity") +
    scale_x_discrete(labels = c("AFRICOM", "United States")) +
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

## Show bar plot
somalia.bar.plot

## Save barplots
file.location = '/DPHClaim_StrikeCount_barplot.svg' 

ggsave(filename = file.location,
       somalia.bar.plot, 
       width = 12, height = 8
)




