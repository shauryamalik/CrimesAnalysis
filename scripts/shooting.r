# install.packages("bookdown")
# install.packages("mi")

library(naniar)
library("ggplot2")
# library("GGally")
library("dplyr")
library("tidyr")
library("lubridate")
library("ggpubr")
library("data.table")
# df_nyc_earnings<- readr::read_csv("https://datausa.io/api/data?measure=Household%20Income%20by%20Race,Household%20Income%20by%20Race%20Moe&Geography=16000US3651000:parents,16000US3651000,16000US3651000:similar")

## Shootings in 2020

df_shooting_ytd <- readr::read_csv("datasets/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")
df_shooting_old <- readr::read_csv("https://data.cityofnewyork.us/resource/833y-fsy8.csv")
# colnames(df_shooting_ytd)
colnames(df_shooting_old)<- toupper(colnames(df_shooting_old))
colnames(df_shooting_ytd)<- toupper(colnames(df_shooting_ytd))

df_shooting_total<-bind_rows(df_shooting_ytd, df_shooting_old)
?scales::label_number

#processing data
df_shooting_total$OCCUR_DATE <-as.Date(df_shooting_total$OCCUR_DATE, format = "%m/%d/%Y")
# extract year and month from date - #TODO: hour and dayofweek
# 1 means Monday, 7 means Sunday (default)
df_shooting_total<-df_shooting_total %>%
  mutate(year = year(OCCUR_DATE), month = month(OCCUR_DATE,label = TRUE), day = wday(OCCUR_DATE,label = TRUE),
         murder = ifelse(STATISTICAL_MURDER_FLAG==TRUE, 1, 0))

gg_miss_var(df_shooting_total)

miss_var_summary(df_shooting_total)
# LOCATION_DESC              1220     62.8
# PERP_AGE_GROUP             1154     59.4
# PERP_SEX                   1154     59.4
# PERP_RACE                  1154     59.4

## dropping the missing columns, as they relate to the perpetrator's details and are not required in the current analysis

#### Total Shootings
df_shoot_grouped <- df_shooting_total %>%
  select(OCCUR_DATE, murder, VIC_AGE_GROUP, VIC_SEX, VIC_RACE) %>%
  group_by(OCCUR_DATE, murder, VIC_SEX, VIC_AGE_GROUP, VIC_RACE) %>%
  summarize(occurances = n())

df_shoot_grouped2 <- df_shooting_total %>%
  select(year, month, murder, VIC_AGE_GROUP, VIC_SEX, VIC_RACE) %>%
  group_by(year, month, murder, VIC_SEX, VIC_AGE_GROUP, VIC_RACE) %>%
  summarize(occurances = n())

df_shoot_grouped2$date<-as.Date(paste(df_shoot_grouped2$year, df_shoot_grouped2$month,"1",sep="-"), format = "%Y-%b-%d")

temp_df<- df_shoot_grouped2 %>% 
  filter(year>=2019) %>%
  group_by(date, month) %>%
  summarize(total_shots= sum(occurances))#%>%
  # mutate(monthly_change = (total_shots/shift(total_shots, n=1, fill = NA, type="lag") -1)*100)

temp_df$monthly_change<- ((temp_df$total_shots/shift(temp_df$total_shots, n=1, fill=NA, type="lag"))-1)*100

ggplot(temp_df, aes(x= date)) + 
  geom_bar(aes(y = monthly_change/100, fill = factor(month)), stat="identity") +
  geom_text(aes( label = scales::percent(monthly_change/100),
                 y= monthly_change/100 ), stat= "identity",angle = 90) +
  labs(y = "Percent change", fill="month number") +
  scale_y_continuous(labels = scales::percent)

ggplot(temp_df, aes(x= date)) + 
  geom_bar(aes(y = total_shots, fill = factor(month)), stat="identity") +
  # geom_text(aes( label = scales::percent(..prop..),
  #                y= ..prop.. ), stat= "count", vjust = -.5) +
  labs(y = "Percent change", fill="month number") +
  scale_y_continuous(labels = scales::label_percent(decimal.mark = "."))

?scales::percent_format

ggbarplot(temp_df,
       x="date",
       y="month")

ggline(temp_df,
       x="date",
       y="total_shots")

ggplot(df_total_shoot, aes(x=OCCUR_DATE, y=occurances, fill=VIC_SEX))+
  geom_bar(stat = "identity",position = "dodge") +
  facet_grid(VIC_RACE~., scales = "free", space="free_x") 

####################################### By Age group #########
df_shoot_grouped_BORO$BORO <- as.factor(df_shoot_grouped_BORO$BORO)
theme_heat <- theme_classic() +
  theme(axis.line = element_blank(),
        axis.ticks = element_blank())

temp_df<- df_shoot_grouped_BORO %>% 
  filter(year>=2019) %>%
  group_by(date,BORO, VIC_AGE_GROUP) %>%
  summarize(total_shots= sum(occurances)) %>%
  ungroup()

ggplot(temp_df, aes(x = date, y = VIC_AGE_GROUP)) +
  geom_tile(aes(fill = total_shots), color = "black") +
  theme_heat + ggtitle("Does age matter?!",
                       subtitle = "Number of Shootings in each borough for each age group by month") + scale_fill_gradient(low = "#cccccc", high = "#880808") +
  facet_grid(BORO~.) +
  labs(y = "Borough", x="Date", fill="Number of shootings", caption = "Source: NYC-open-Data::Shooting Incident Data") +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
  theme(plot.caption = element_text(color = "grey68"))

# -----------------------------------------------

temp_df<- df_shoot_grouped_BORO %>% 
  filter(year>=2019, VIC_SEX!="U") %>%
  group_by(date,BORO, VIC_SEX) %>%
  summarize(total_shots= sum(occurances)) %>%
  ungroup()

# ggline(temp_df, x="date",y="total_shots",color="BORO",  legend = "right", facet.by = "VIC_SEX") + ggtitle("Females Effected across NYC",
#                                                                                     subtitle = "Number of Female Shootings in each borough by month") + scale_fill_gradient(low = "#cccccc", high = "#880808") +
#   labs(y = "Number of shootings", x="Date", color="Borough", caption = "Source: NYC-open-Data::Shooting Incident Data") 

ggplot(temp_df, aes(x = date, color = BORO, y = total_shots)) +
  geom_line() +
  ggtitle("Females Effected across NYC",
                       subtitle = "Number of Female Shootings in each borough by month") + scale_fill_gradient(low = "#cccccc", high = "#880808") +
  labs(y = "Number of shootings", x="Date", color="Borough", caption = "Source: NYC-open-Data::Shooting Incident Data") +
  theme_pubr(legend="right") + facet_grid(VIC_SEX~., scales = "free", space="free_x") 

  # theme(plot.title = element_text(face = "bold")) +
  # theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
  # theme(plot.caption = element_text(color = "grey68"))

ggplot(temp_df, aes(x = date, y = BORO)) +
  geom_tile(aes(fill = total_shots), color = "black") +
  theme_heat + ggtitle("Females Effected across NYC",
                       subtitle = "Number of Female Shootings in each borough by month") + scale_fill_gradient(low = "#cccccc", high = "#880808") +
  labs(y = "Borough", x="Date", fill="Number of shootings", caption = "Source: NYC-open-Data::Shooting Incident Data") +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
  theme(plot.caption = element_text(color = "grey68"))


temp_df<- df_shoot_grouped_BORO %>% 
  filter(year>=2019, VIC_SEX=="M") %>%
  group_by(date,BORO, VIC_SEX) %>%
  summarize(total_shots= sum(occurances)) %>%
  ungroup()

ggplot(temp_df, aes(x = date, y = BORO)) +
  geom_tile(aes(fill = total_shots), color = "black") +
  theme_heat + ggtitle("Males Effected across NYC",
                       subtitle = "Number of Male Shootings in each borough by month") + scale_fill_gradient(low = "#cccccc", high = "#880808") +
  labs(y = "Borough", x="Date", fill="Number of shootings", caption = "Source: NYC-open-Data::Shooting Incident Data") +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
  theme(plot.caption = element_text(color = "grey68"))




####################################### number of deaths trend  #########

df_shoot_grouped2 <- df_shooting_total %>%
  select(year, month, murder, VIC_AGE_GROUP, VIC_SEX, VIC_RACE) %>%
  group_by(year, month, murder, VIC_SEX, VIC_AGE_GROUP, VIC_RACE) %>%
  summarize(occurances = n())

df_shoot_grouped2$date<-as.Date(paste(df_shoot_grouped2$year, df_shoot_grouped2$month,"1",sep="-"), format = "%Y-%b-%d")
temp_df<- df_shoot_grouped2 %>% 
  filter(year>=2019, murder==1) %>%
  group_by(date, month) %>%
  summarize(total_shots= sum(occurances))#%>%
# mutate(monthly_change = (total_shots/shift(total_shots, n=1, fill = NA, type="lag") -1)*100)

temp_df$monthly_change<- ((temp_df$total_shots/shift(temp_df$total_shots, n=1, fill=NA, type="lag"))-1)*100

ggplot(temp_df, aes(x= date)) + 
  geom_bar(aes(y = monthly_change/100, fill = factor(month)), stat="identity") +
  geom_text(aes( label = scales::percent(monthly_change/100),
                 y= monthly_change/100 ), stat= "identity",angle = 90) +
  labs(y = "Percent change", fill="month number") +
  scale_y_continuous(labels = scales::percent)
# - Number of deaths per month etc did not show any trend

#######################################  location trend#########
library(RColorBrewer)


unique(df_shooting_total$BORO)

df_shoot_grouped_BORO <- df_shooting_total %>%
  select(year, month, BORO, murder, VIC_AGE_GROUP, VIC_SEX, VIC_RACE) %>%
  group_by(year, month, murder, BORO, VIC_SEX, VIC_AGE_GROUP, VIC_RACE) %>%
  summarize(occurances = n())

df_shoot_grouped_BORO$date<-as.Date(paste(df_shoot_grouped_BORO$year, df_shoot_grouped_BORO$month,"1",sep="-"), format = "%Y-%b-%d")

temp_df<- df_shoot_grouped_BORO %>% 
  filter(year>=2019) %>%
  group_by(date,BORO) %>%
  summarize(total_shots= sum(occurances)) %>%
  ungroup()

temp_df$BORO <- as.factor(temp_df$BORO)

theme_heat <- theme_classic() +
  theme(axis.line = element_blank(),
        axis.ticks = element_blank())

ggplot(temp_df, aes(x = date, y = BORO)) +
  geom_tile(aes(fill = total_shots), color = "black") +
  theme_heat + ggtitle("Where to stay?!",
                       subtitle = "Number of Shootings in each borough by month") + scale_fill_gradient(low = "#cccccc", high = "#880808") 
  labs(y = "Borough", x="Date", fill="Number of shootings", caption = "Source: NYC-open-Data::Shooting Incident Data") +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
  theme(plot.caption = element_text(color = "grey68"))

# temp_df$monthly_change<- ((temp_df$total_shots/shift(temp_df$total_shots, n=1, fill=NA, type="lag"))-1)

df_shoot_grouped_BORO$BORO <- as.factor(df_shoot_grouped_BORO$BORO)

temp_df<- df_shoot_grouped_BORO %>% 
  filter(year>=2019) %>%
  group_by(BORO,date) %>%
  summarize(total_shots= sum(occurances)) %>%
  mutate(monthly_change = (total_shots/shift(total_shots, n=1, fill = NA, type="lag") -1)/10)

temp_df$month<- lubridate::month(temp_df$date,label = TRUE)

ggplot(temp_df, aes(x= date)) + 
  geom_bar(aes(y = monthly_change, fill = factor(month)), stat="identity") +
  # geom_text(aes( label = scales::percent(monthly_change),
                 # y= monthly_change ), stat= "identity",angle = 90) +
  facet_grid(BORO~.) +
  scale_y_continuous(labels = scales::percent)+
  ggtitle("Where to visit?!",
          subtitle = "Percentage change in number of Shootings in borough by month") +
  labs(y = "Percentage Change", x="Date", fill="Month", caption = "Source: NYC-open-Data::Shooting Incident Data") +
  theme(plot.title = element_text(face = "bold")) +
  theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
  theme(plot.caption = element_text(color = "grey68"))

###############################
