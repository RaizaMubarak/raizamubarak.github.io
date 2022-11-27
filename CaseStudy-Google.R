install.packages("tidyverse")
library(tidyverse)
library(readr)
trip_data_1<-read_csv("202111-divvy-tripdata.csv")

trip_data_1<-mutate(trip_data_1,ride_length = ended_at - started_at)

trip_data_2<-read_csv("202112-divvy-tripdata.csv")
trip_data_2<-mutate(trip_data_2,ride_length = ended_at - started_at)

trip_data_3<-read_csv("202201-divvy-tripdata.csv")
trip_data_3<-mutate(trip_data_3,ride_length = ended_at - started_at)

trip_data_4<-read_csv("202202-divvy-tripdata.csv")
trip_data_4<-mutate(trip_data_4,ride_length = ended_at - started_at)

trip_data_5<-read_csv("202203-divvy-tripdata.csv")
trip_data_5<-mutate(trip_data_5,ride_length = ended_at - started_at)

trip_data_6<-read_csv("202204-divvy-tripdata.csv")
trip_data_6<-mutate(trip_data_6,ride_length = ended_at - started_at)

trip_data_7<-read_csv("202205-divvy-tripdata.csv")
trip_data_7<-mutate(trip_data_7,ride_length = ended_at - started_at)

trip_data_8<-read_csv("202206-divvy-tripdata.csv")
trip_data_8<-mutate(trip_data_8,ride_length = ended_at - started_at)

trip_data_9<-read_csv("202207-divvy-tripdata.csv")
trip_data_9<-mutate(trip_data_9,ride_length = ended_at - started_at)

trip_data_10<-read_csv("202208-divvy-tripdata.csv")
trip_data_10<-mutate(trip_data_10,ride_length = ended_at - started_at)

trip_data_11<-read_csv("202209-divvy-tripdata.csv")
trip_data_11<-mutate(trip_data_11,ride_length = ended_at - started_at)

trip_data_12<-read_csv("202210-divvy-tripdata.csv")
trip_data_12<-mutate(trip_data_12,ride_length = ended_at - started_at)

library(hms)
library(lubridate)
trip_data_1$ride_length_new <- hms::hms(seconds_to_period(trip_data_1$ride_length))
trip_data_2$ride_length_new <- hms::hms(seconds_to_period(trip_data_2$ride_length))
trip_data_3$ride_length_new <- hms::hms(seconds_to_period(trip_data_3$ride_length))
trip_data_4$ride_length_new <- hms::hms(seconds_to_period(trip_data_4$ride_length))
trip_data_5$ride_length_new <- hms::hms(seconds_to_period(trip_data_5$ride_length))
trip_data_6$ride_length_new <- hms::hms(seconds_to_period(trip_data_6$ride_length))
trip_data_7$ride_length_new <- hms::hms(seconds_to_period(trip_data_7$ride_length))
trip_data_8$ride_length_new <- hms::hms(seconds_to_period(trip_data_8$ride_length))
trip_data_9$ride_length_new <- hms::hms(seconds_to_period(trip_data_9$ride_length))
trip_data_10$ride_length_new <- hms::hms(seconds_to_period(trip_data_10$ride_length))
trip_data_11$ride_length_new <- hms::hms(seconds_to_period(trip_data_11$ride_length))
trip_data_12$ride_length_new <- hms::hms(seconds_to_period(trip_data_12$ride_length))

trip_data_1$weekday <- wday(trip_data_1$started_at)
trip_data_2$weekday <- wday(trip_data_2$started_at)
trip_data_3$weekday <- wday(trip_data_3$started_at)
trip_data_4$weekday <- wday(trip_data_4$started_at)
trip_data_5$weekday <- wday(trip_data_5$started_at)
trip_data_6$weekday <- wday(trip_data_6$started_at)
trip_data_7$weekday <- wday(trip_data_7$started_at)
trip_data_8$weekday <- wday(trip_data_8$started_at)
trip_data_9$weekday <- wday(trip_data_9$started_at)
trip_data_10$weekday <- wday(trip_data_10$started_at)
trip_data_11$weekday <- wday(trip_data_11$started_at)
trip_data_12$weekday <- wday(trip_data_12$started_at)

trip_data_new<-rbind(trip_data_1, trip_data_2, 
                     trip_data_3, trip_data_4, 
                     trip_data_5,trip_data_6,
                     trip_data_6, trip_data_7, 
                     trip_data_8, trip_data_9,
                     trip_data_10, trip_data_11,
                     trip_data_12)

trip_data_new$started_day <- with(trip_data_new, 
                            ifelse(weekday == 1, "Sun",
                            ifelse(weekday == 2, "Mon",
                            ifelse(weekday == 3, "Tue", 
                            ifelse(weekday == 4,"Wed", 
                            ifelse(weekday == 5, "Thur",
                            ifelse(weekday == 6, "Fri",
                                             "Sat")))))))
## creating a table with only needed columns
temp_table<- trip_data_new %>%
              select(ride_id, started_at, ended_at,
                     member_casual,ride_length, ride_length_new, started_day)




## finding out what type of riders have used for more ride length
temp_table[temp_table$ride_length > 300000, ] %>% 
  select(member_casual, ride_length) %>% arrange(-ride_length)

temp_table[temp_table$ride_length > 300000 &
           temp_table$member_casual == "casual", ] %>% 
  select(member_casual, ride_length) %>% arrange(-ride_length)


## graph-1 to find the maximum ride_length by each type
 max_values<-temp_table %>% group_by(member_casual) %>%
  summarize(max_ride_length = max(ride_length_new)) 
## Plotting graph 1
 library(ggplot2)
 ggplot(max_values, aes(x = member_casual, y = max_ride_length, fill =c( "red","green"))) + geom_col() + labs(title = "Maximum Ride Length by each Type of Users", x = "Type of User", colour = "User Type") + theme(legend.position = "none")
 
 
 ## exporting the file for graph 1
 install.packages("writexl")
library(writexl)
 write_xlsx(max_values,"/Users/mac/Desktop/Stuttgart/Google Capstone\\max values.xlsx")
 
 #finding the trend in ride length throughout the week by each type of member
 # to use n() function load dplyr
 library(dplyr)
analysis_2<-temp_table %>% group_by(started_day, member_casual) %>% summarize(no_of_times =n()) 
 
## Extract relevant information from data_analysis_2
day<-c(unique(analysis_2$started_day))
casual<-c(subset(analysis_2, member_casual == "casual", select = no_of_times))
member<-c(subset(analysis_2, member_casual == "member", select = no_of_times))

day_trend<- data.frame(day, casual, member)
day_trend<-day_trend %>% rename(casual= no_of_times, member = no_of_times.1)

##Plot graph no 2 for day trend

Day_trend_long <- day_trend %>% pivot_longer(cols = -day,names_to = "Type") %>% 
  mutate(scaled_value=ifelse(Type=="casual",value,value))
head(Day_trend_long)

ggplot(Day_trend_long,aes(x=day, y = scaled_value,fill= Type)) + 
  geom_col(position= position_dodge(0.7),width = 0.7) + 
  labs(y="Number of times rides occurred", x ="day") 







#export analysis 2 table
write_xlsx(analysis_2,"/Users/mac/Desktop/Stuttgart/Google Capstone\\analysis_2.xlsx")

## finding the month in the date
library(lubridate)
temp_table$month<- format(as.Date(temp_table$started_at, format="%Y-%m-%d-%h-%m-%s"),"%m")

##calculating the trend in ride length based on month,
month_trend<-temp_table %>% group_by(month,member_casual) %>% summarise(sum_of_ride_length = sum(ride_length))

month_trend$month <- as.numeric(month_trend$month)


##month in names
month_trend$month_name <- with(month_trend, 
                            ifelse(month == 01, "January",
                            ifelse(month == 02, "February",
                            ifelse(month == 03, "March", 
                            ifelse(month == 04,"April", 
                            ifelse(month == 05, "May",
                            ifelse(month == 06, "June",
                            ifelse(month == 07, "July",
                            ifelse(month == 08, "August",
                            ifelse(month == 09, "September",
                            ifelse(month == 10, "October",
                            ifelse(month == 11, "November",
                             "December"))))))))))))

## month_trend_extension(create a table- casual)
month<-c(unique(month_trend$month))
sum_ride_length<-c(subset(month_trend, member_casual == "casual", select = sum_of_ride_length))
casual<-data.frame(month, sum_ride_length)

## ## month_trend_extension(create a table- member)
month<-c(unique(month_trend$month_name))
sum_ride_length<-c(subset(month_trend, member_casual == "member", select = sum_of_ride_length))
member<-data.frame(month, sum_ride_length)

##Create a final table for month trend
month<-c(unique(month_trend$month))
sum_ride_length_member<-c(subset(month_trend, member_casual == "member", select = sum_of_ride_length))
sum_ride_length_casual<-c(subset(month_trend, member_casual == "casual", select = sum_of_ride_length))
month_trend_final<-data.frame(month, sum_ride_length_casual, sum_ride_length_member)

plot(month, sum_ride_length_casual, type = "b", frame = FALSE, pch = 19, 
     col = "red", xlab = "month", ylab = "sum ride length")

install.packages("reshape")
library(reshape)
newData<- melt(list(casual = casual, member = member))
cols<-c("red", "blue")


##ggplot(newData, aes(month, value, colour = L1)) + geom_line() + scale_colour_manual(values = cols)
##casual$sum_of_ride_length<-as.numeric(casual$sum_of_ride_length)
##member$sum_of_ride_length<-as.numeric(member$sum_of_ride_length)

ggplot(data = casual) + geom_point(mapping = aes(x = month, y = sum_ride_length)) 

## Exporting month_trend
write_xlsx(month_trend,"/Users/mac/Desktop/Stuttgart/Google Capstone\\month trend.xlsx")

install.packages("rmarkdown")
library(rmarkdown)
