# Explore Yannick's Data

catch<-read.csv("../data/Catch_PelDem_by_FGroup_AreaV4.csv")
#check names
names(catch)

# subset LME 42 and FCounty == AUS and Sector == Industrial & FGroup == Large pelagics
catch<-catch[catch$LMEnbr==42,]
#catch<-catch[catch$Fcountry=="AUS",]
#catch<-catch[catch$Sector=="Industrial",]
#catch<-catch[catch$FGroup=="pelagic>=90cm",]
catch
# When I subset for one FGroup & AUS only I expected this subset would produce one single time series - what are the extra points for? # WHY ARE THERE NOT  AN EQUAL NUMBER OF CELLS IN EACH ROW? HOW WAS THIS AGGREGATED? ALSO WHY DIFFERENT FAOnbrs (not FAO areas??) What does X stand for ??

t <- ggplot(catch, aes(x=Year, y=Reported,color=as.factor(X))) + geom_point()
t

### the data are not clear enough to me - I need the total catch only in this LME per FG - are this grid cells?? How were the cells allocated to LMEs - there seems to be a mapping issue? YR could you put the code that allocates your country data to spatial grid cells and then re-aggregates to these LMEs on github please so we can understand and repeat the methods.

# I assume it  is OK to sum all rows by LME here.

catch_sum<-aggregate(catch$Reported,list(catch$Year,catch$FGroup),sum)
names(catch_sum)<-c("Year","FGroup","Reported")

catch_sum_IUUs<-aggregate(catch$IUUs,list(catch$Year,catch$FGroup),sum)
names(catch_sum_IUUs)<-c("Year","FGroup","IUUs")

catch_sum$catch<-catch_sum_IUUs$IUUs + catch_sum$Reported

# stacked area chart

# Library
library(viridis)
library(hrbrthemes)
# Plot
ggplot(catch_sum, aes(x=Year, y=catch, fill=as.factor(FGroup))) + 
  geom_area() +
  scale_fill_viridis(discrete = T) +
  theme_ipsum()



effort<-read.csv("../data/Effort_PelDem_by_FGroup_AreaV4.csv")
#check names
names(effort)
# subset LME 42 and FCounty == AUS and Sector == Industrial & FGroup == Large pelagics
effort<-effort[effort$LMEnbr==42,]
effort<-effort[effort$Fcountry=="AUS",]
#effort<-effort[effort$Sector=="Industrial",]
#effort<-effort[effort$FGroup=="pelagic>=90cm",]
effort


effort_sum<-aggregate(effort$NomEffReported,list(effort$Year,effort$Sector,effort$FGroup),sum)
names(effort_sum)<-c("Year","Sector", "FGroup","NomEffReported")

effort_sum_IUUs<-aggregate(effort$NomEffIUU,list(effort$Year,effort$Sector,effort$FGroup),sum)
names(effort_sum_IUUs)<-c("Year","Sector","FGroup","NomEffIUU")

effort_sum$effort<-effort_sum_IUUs$NomEffIUU + effort_sum$NomEffReported

# Plot
ggplot(effort_sum, aes(x=Year, y=effort, fill=FGroup)) + 
  geom_area() +
  scale_fill_viridis(discrete = T) 

#   scale_y_continuous(trans='log10')
#   theme_ipsum()

# the data look a little weird to me... why so many values close to  zero?
