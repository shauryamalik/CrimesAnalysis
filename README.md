## CRIME ANALYSIS

*Shaurya Malik, Rahul Agarwal, Keertan Krishnan*

### About

*Topic: Analyzing crimes: types, risks groups/victim demographics, perpetrator profiles and possible psychological, legal aspects and handling of different types of crimes.*

Our motivation for choosing this topic stems from several recent events including racial hate crimes, police brutality concerns, crimes influenced by political polarization etc. across the world. Thus we intend to analyze the trend of crimes over time, possible seasonalities and other influential factors.

Some questions which we expect to address include:

- What roles do location, demographics, literacy and other external factors play on the frequency and type/severity of crimes?
- What are the factors leading to a certain type of crime? This includes a wide group of crimes such as social, financial, cyber, hate influenced, those influenced by political opinions, intellectual property, drug abuse, human trafficking, sexual crimes, domestic abuse and assault, insider trading etc.
  - Further analyzing events that may have caused an increase of such crimes
- Were complaints filed for these crimes and how did the authorities deal with said crimes? Were accusations wrong?
- How policy change has affected crime rates?
  - Does increasing punishment type, degree and duration reduce crime?
- Has COVID-19 affected the crime rates/types/frequency and how so?

Tentative data-sets and their original sources are as below, however this list is not exhaustive and our analysis may not be limited to only New York trends:

- NYPD Hate Crimes Data: https://data.cityofnewyork.us/Public-Safety/NYPD-Hate-Crimes/bqiq-cu78
- NYPD Shooting Incident Data: https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Year-To-Date-/5ucz-vwe8
- NYC Park Crime Data: https://data.cityofnewyork.us/Public-Safety/NYC-Park-Crime-Data/ezds-sqp6
- Citywide Crime Stats https://data.cityofnewyork.us/Public-Safety/Citywide-Crime-Statistics/c5dk-m6ea
- NYPD Arrest Data: https://data.cityofnewyork.us/Public-Safety/NYPD-Arrest-Data-Year-to-Date-/uip8-fykc
- Criminal Justice Statistics: https://www.criminaljustice.ny.gov/crimnet/ojsa/stats.htm
- FBI crime data: https://crime-data-explorer.fr.cloud.gov/

*Our final lists of datasets can be found in the 02-data.Rmd file.*

### Other references:

- https://www.unodc.org/documents/data-and-analysis/covid/Property_Crime_Brief_2020.pdf
- https://covid19.counciloncj.org/2021/01/31/impact-report-covid-19-and-crime-3/
- https://www.nap.edu/read/18613/chapter/5#71

### Link between data and questions:

These datasets span a large class of crimes which include information about demographics, along with information of types and severity, helping us gain insight into answers about these questions.

For instance, the answers to question 2 and 5 will require a more nuanced understanding of certain events (political, financial, COVID) and understanding of the influencing factors behind these crimes. This would require correlation of the type of the crime and the point/interval of time when these events (political/financial etc) took place.

Answers to question 3 can be found through matching the crime records data and the crime complaint data. Often, policy changes are influential in affecting the crimes. Using data of policy changes through the years, and the types/counts of crimes that took place over the years, we wish to find insights on crime trends.	

*This repo was initially generated from a bookdown template available here: https://github.com/jtr13/EDAVtemplate.*	



