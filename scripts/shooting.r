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
  mutate(year = year(OCCUR_DATE), month = month(OCCUR_DATE,label = TRUE), day = wday(OCCUR_DATE,label = TRUE))

gg_miss_var(df_shooting_total)

miss_var_summary(df_shooting_total)
# LOCATION_DESC              1220     62.8
# PERP_AGE_GROUP             1154     59.4
# PERP_SEX                   1154     59.4
# PERP_RACE                  1154     59.4

## dropping the missing columns, as they relate to the perpetrator's details and are not required in the current analysis

#### Total Shootings
df_shoot_grouped <- df_shooting_total %>%
  select(OCCUR_DATE, STATISTICAL_MURDER_FLAG, VIC_AGE_GROUP, VIC_SEX, VIC_RACE) %>%
  group_by(OCCUR_DATE, STATISTICAL_MURDER_FLAG, VIC_SEX, VIC_AGE_GROUP, VIC_RACE) %>%
  summarize(occurances = n())

df_shoot_grouped2 <- df_shooting_total %>%
  select(year, month, STATISTICAL_MURDER_FLAG, VIC_AGE_GROUP, VIC_SEX, VIC_RACE) %>%
  group_by(year, month, STATISTICAL_MURDER_FLAG, VIC_SEX, VIC_AGE_GROUP, VIC_RACE) %>%
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
  

