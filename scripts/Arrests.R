library(tidyverse)
library(ggplot2)
library(mi)
library(dplyr)
# library(naniar)

# gg_miss_var(df_arrest_ytd)

df_arrest_ytd$ARREST_DATE <-as.Date(df_arrest_ytd$ARREST_DATE, format = "%m/%d/%Y")

arrest_2020 <- df_arrest_ytd %>% 
  filter(ARREST_DATE >= "01/01/2021")

unique(df_arrest_ytd$OFNS_DESC)

df_arrest_by_offense_type <- df_arrest_ytd %>% 
                              filter(!is.na(OFNS_DESC))%>%
                              group_by(OFNS_DESC) %>%
                              summarise(Total = n())

theme_dotplot <- theme_bw(14) +
  theme(axis.text.y = element_text(size = rel(.75)),
        axis.ticks.y = element_blank(),
        axis.title.x = element_text(size = rel(.75)),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(size = 0.5),
        panel.grid.minor.x = element_blank())

ggplot(df_arrest_by_offense_type, aes(x = Total, y = reorder(OFNS_DESC, Total))) +
  geom_point(color = "blue") +
  theme_dotplot +
  xlab("Total arrests") +
  ylab("Type of crime") +
  ggtitle("Most common crimes (as per NYPD Arrests Data)")

df_arrest_by_offense_type_perpsex <- df_arrest_ytd %>% 
  filter(!is.na(OFNS_DESC))%>%
  group_by(OFNS_DESC, PERP_SEX) %>%
  summarise(Total = n())

ggplot(df_arrest_by_offense_type_perpsex, aes(x = Total, y = reorder(OFNS_DESC, Total), color=PERP_SEX)) +
  geom_point() +
  theme_dotplot +
  xlab("Total arrests") +
  ylab("Type of crime") +
  ggtitle("Most common crimes (as per NYPD Arrests Data)")

df_arrest_by_offense_type_boro <- df_arrest_ytd %>% 
  filter(!is.na(OFNS_DESC))%>%
  group_by(OFNS_DESC, ARREST_BORO) %>%
  summarise(Total = n())

ggplot(df_arrest_by_offense_type_boro, aes(x = Total, y = reorder(OFNS_DESC, Total), color=ARREST_BORO)) +
  geom_point() +
  theme_dotplot +
  xlab("Total arrests") +
  ylab("Type of crime") +
  ggtitle("Most common crimes (as per NYPD Arrests Data)")

df_arrest_ytd$ARREST_BORO[df_arrest_ytd$ARREST_BORO == "B"] <- "Bronx"
df_arrest_ytd$ARREST_BORO[df_arrest_ytd$ARREST_BORO == "S"] <- "Staten Island"
df_arrest_ytd$ARREST_BORO[df_arrest_ytd$ARREST_BORO == "K"] <- "Brooklyn"
df_arrest_ytd$ARREST_BORO[df_arrest_ytd$ARREST_BORO == "M"] <- "Manhattan"
df_arrest_ytd$ARREST_BORO[df_arrest_ytd$ARREST_BORO == "Q"] <- "Queens"

arrests_boro <- df_arrest_ytd %>% 
  filter(OFNS_DESC %in% "ASSAULT 3 & RELATED OFFENSES") %>%
  group_by(ARREST_BORO) %>%
  summarise(Total = n())

ggplot(arrests_boro, aes(x = fct_reorder(ARREST_BORO, Total), y = Total, fill=ARREST_BORO)) +
  geom_bar(stat = "identity") +
  ggtitle("Assault related offenses by Borough") +
  xlab("Boroughs") +
  ylab("Total arrests") +
  coord_flip()

arrests_boro_age <- df_arrest_ytd %>% 
  #filter(OFNS_DESC %in% "ASSAULT 3 & RELATED OFFENSES") %>%
  group_by(ARREST_BORO, AGE_GROUP) %>%
  summarise(Total = n())

ggplot(arrests_boro_age, aes(x = AGE_GROUP, y = Total, fill=AGE_GROUP)) +
  geom_bar(stat = "identity", position="dodge") +
  ggtitle("Assault related offenses by Borough") +
  xlab("Boroughs") +
  ylab("Total arrests") +
  facet_wrap(~ARREST_BORO)

arrests_race <- df_arrest_ytd %>% 
  group_by(PERP_RACE, ARREST_BORO) %>%
  summarise(Total = n())

ggplot(arrests_race, aes(x = fct_reorder(ARREST_BORO, Total), y = Total, fill=PERP_RACE)) +
  geom_bar(stat = "identity") +
  ggtitle("Race of Perpetrators") +
  xlab("Race") +
  ylab("Total arrests")

drugs_plot <- ggplot(df_arrest_ytd %>% 
                      filter(OFNS_DESC %in% "DANGEROUS DRUGS"), aes(x = Longitude, y = Latitude)) + 
  geom_point(aes(color = ARREST_BORO), size = 3, alpha = 0.5, position = "jitter") +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Sexual Crimes")

drugs_plot + theme_minimal()

sex_crimes <- ggplot(df_arrest_ytd %>% 
                      filter(OFNS_DESC %in% c("RAPE", "SEX CRIMES")), aes(x = Longitude, y = Latitude)) + 
  geom_point(aes(color = ARREST_BORO), size = 3, alpha = 0.5, position = "jitter") +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Sexual Crimes and Rape")

sex_crimes + theme_minimal()

arrests_sex_boro <- df_arrest_ytd %>% 
  filter(OFNS_DESC %in% c("RAPE", "SEX CRIMES")) %>% 
  group_by(Latitude, Longitude, ARREST_BORO) %>%
  summarise(Total = n())

sex_crimes2 <- ggplot(df_arrest_ytd %>% 
                       filter(OFNS_DESC %in% c("RAPE", "SEX CRIMES")), aes(x = Longitude, y = Latitude)) + 
  #geom_point(aes(color = ARREST_BORO), size = 3, alpha = 0.5, position = "jitter") +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("Sexual Crimes and Rape") + 
  stat_density2d(aes(fill = ..level..), alpha = .5,
                 geom = "polygon", data = df_arrest_ytd %>% 
                   filter(OFNS_DESC %in% c("RAPE", "SEX CRIMES")))+ 
  scale_fill_viridis_c() + 
  theme(legend.position = 'none')

sex_crimes2 + theme_minimal()







