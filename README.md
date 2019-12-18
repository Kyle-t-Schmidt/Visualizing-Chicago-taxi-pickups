# Visualizing-Chicago-taxi-pickups

## Introduction
The Chicago Taxi Trips data is a publicly available dataset with information on taxi trips from 2013 to present day. The data includes information on the location of pickups, dropoffs fares and other information. I wanted to create a fun and usefull interactive data visualiztion using R shiny. In this project I demostrate:
* Use of SQL (Google Bigquery) to manipulate and extract data from a database
* R programming language
* data visualization

The full data set can be found here: https://console.cloud.google.com/marketplace/details/city-of-chicago-public-data/chicago-taxi-trips

## Program Purpose
The R Shiny app is an interactive map of Chicago taxi pickups on the busiest week of 2018 for Chicago taxis. With the app you are able to filter days and hours of the day to see where pcikups are happening and how many pickups are at each location.

## Using the program
To launch the app you first need to download the Taxi.csv file and the app.R and store them in the same location. Open the app.R file with R studio and click the launch app button. You may need to first set your working directory to the filepath where the Taxi.csv and app.R files are stored.

Alternatively, you can download the data by going to https://console.cloud.google.com/marketplace/details/city-of-chicago-public-data/chicago-taxi-trips and using the queries in queries.txt.

Once the app has launched use the selectors on the left to select the days and hours of the day. You may zoom in on the map and hover the cursor over pickup locations to see the exact number of pickups at that location in the selected timeframe.
