library(tidyverse)
library(ggplot2)
library(ggalluvial)
library(mi)
library(GGally)
library(parcoords)
library(choroplethr)

df_fbi_ht <- readr::read_csv("datasets/HT_2013_2019.csv")
fbiHT_df <- as.data.frame(df_fbi_ht)
x <- missing_data.frame(fbiHT_df)
image(x)

colSums(is.na(df_fbi_ht))

summary(df_fbi_ht)

theme_dotplot <- theme_bw(14) +
  theme(axis.text.y = element_text(size = rel(.75)),
        axis.ticks.y = element_blank(),
        axis.title.x = element_text(size = rel(.75)),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(size = 0.5),
        panel.grid.minor.x = element_blank())

df_fbi_ht_by_states <- df_fbi_ht %>%
  group_by(STATE_NAME) %>%
  summarise(Total = n())

ggplot(df_fbi_ht_by_states, aes(x = Total, y = reorder(STATE_NAME, Total))) +
  geom_point(color = "blue") +
  #scale_x_continuous(limits = c(35, 95), breaks = seq(40, 90, 10)) +
  theme_dotplot +
  xlab("Total registered cases") +
  ylab("State") +
  ggtitle("Registered Human Trafficking cases by State (2013-19)")

df_fbi_ht_states_year <- df_fbi_ht %>%
  group_by(STATE_NAME, DATA_YEAR) %>%
  summarise(Total = n())

df_temp <- df_fbi_ht_by_states %>% filter(Total>=100)
df_temp <- df_temp[, "STATE_NAME"]

#is_lodes_form(df_fbi_ht_states_year %>% filter(STATE_NAME %in% df_temp$STATE_NAME))

ggplot(df_fbi_ht_states_year %>% 
         filter(STATE_NAME %in% df_temp$STATE_NAME), 
       aes(alluvium = STATE_NAME, x = DATA_YEAR, stratum = Total)) +
  geom_alluvium(color="blue", aes(fill = STATE_NAME)) + 
  geom_stratum() +
  geom_text(stat="stratum", aes(label = after_stat(stratum))) +
  scale_x_continuous(limits = c(2013, 2019), breaks = seq(2013, 2019, 1)) 

ggplot(df_fbi_ht_states_year %>% 
         filter(STATE_NAME %in% df_temp$STATE_NAME),
       aes(x=DATA_YEAR, y=Total, color=STATE_NAME))+
  geom_line(size=1)+
  scale_x_continuous(limits = c(2013, 2019), breaks = seq(2013, 2019, 1))

state_choropleth(df_fbi_ht_by_states %>% 
                   as.data.frame() %>% 
                   transmute(region = tolower(`STATE_NAME`), value = Total),
                 title = "",
                 legend = "")

View(df_fbi_ht_temp)

NY_info <- data.frame("New York", 0)      
names(NY_info) <- c("STATE_NAME", "Total")  
df_fbi_ht_temp <- rbind(df_fbi_ht_temp, NY_info)

new_info <- data.frame( c("New York", "District of Columbia", "Pennsylvania", "California", "Alabama","Iowa"),  
                        c(0, 0, 0, 0, 0, 0))  

names(new_info) <- c("STATE_NAME", "Total")

df_fbi_ht_temp <- rbind(df_fbi_ht_temp, new_info)

state_choropleth(df_fbi_ht_temp %>% 
                   as.data.frame() %>% 
                   transmute(region = tolower(`STATE_NAME`), value = Total),
                 title = "Human Trafficking Cases (2013-19)",
                 legend = "Total Cases")
       
