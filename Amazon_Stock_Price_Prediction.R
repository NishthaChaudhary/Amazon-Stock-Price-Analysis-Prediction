library(ggplot2) 
library(fpp2) 
library(forecast)
library(fma)
library(expsmooth)    
library(quantmod) #install.packages("quantmod") 
library(plotly)
install.packages("ggfortify")
library(ggfortify)
library(tseries)
library(gridExtra)
install.packages("docstring")
library(docstring)
library(readr)




Sys.Date()
#sp500 <- new.env()
getSymbols("AMZN",from = as.Date("2008-01-04"), to = as.Date("2019-10-01"))
#AMZN <- sp500$AMZN
amzn<-data.frame(to.monthly(AMZN))
View(amzn)

#Cleaning DATASET 
##Check for any missing data
sum(is.na(amzn))
summary(amzn)
#We can see that there is no missing/Null values in our dataset

##Exploratory Analysis
#Now we want to get a feel for our data to get an intuition about the models that may be 
#appropriate for our forecast. For this, we plot our data and diagnose for trend, seasonality, 
#heteroskedasticity, and stationarity.


##Creating Time-Series data object
#We are considering the closing value for stock price. Fetching this column and creating a monthly 
#time series..
amzn_close = round(amzn$AMZN.Close,2)

#to.monthly(gspc_close,indexAt='yearmon')
amzn_close <- ts(data=amzn_close,start=c(2008, 1), freq=12)

#Before we begin any analysis, we will be splitting the data to remove 2018 & 2019 to use as our test set.
amzn_close_train<-ts(data=amzn_close,start=c(2008, 1), end=c(2017,12), freq=12)
#Test set
amzn_close_test<-ts(data=amzn_close,start=c(2018, 1), end=c(2019,09), freq=12)

#Plotting our Time series
#Plotting the data is arguably the most critical step in the exploratory analysis phase 
#(We chose to emphasize on the time series object that has intervals from 2008 to 2017, 
#which we will explain later!). This enables us to make inferences about important components of 
#the time-series data, such as trend, seasonality, heteroskedasticity, and stationarity. 
#Here is a quick summary of each:

#Trend: we say that a dataset has a trend when it has either a long-term increase or decrease.
#Seasonality: we say that a dataset has seasonality when it has patterns that repeat over known, 
#fixed periods of time (e.g. monthly, quarterly, yearly).
#Heteroskedasticity: we say that a data is heteroskedastic when its variability is not constant 
#(i.e. its variance increases or decreases as a function of the explanatory variable).
#Stationarity: a stochastic process is called stationary if the mean and variance are constant 
#(i.e. their joint distribution does not change over time).


#Time plot to observe the trend, seasonality or cyclic pattern
autoplot(amzn_close_train) + xlab("Year") + ylab("Closing Price of Amazon")+
  ggtitle("Timeseries plot of Amazon closing price")

#The Amazon stock price shows a strong increasing trend with no significant seasonality. 
#However, there is no evidence of cyclic behaviour

#TEst for STationarity(Statistical tests)
Box.test(amzn_close_train, lag = 20, type = 'Ljung-Box')
#Now we will utilize the Augmented Dickey-Fuller Test for stationarity. The null hypothesis states 
#that large p-values indicate non-stationarity and smaller p values indicate stationarity 
adf.test(amzn_close_train)

#We can see our p-value for the ADF test is relatively high, so we'll do some further visual 
#inspection. But we know we will most likely have to difference our time series for stationarity.

#Decomposing Time Series
#Decomposition
fit<-stl(amzn_close_train,s.window = 5)
plot(fit)

#Trend is showing positive growth. There might be some seasonality in our dataset. 

#Let's plot the seasonal plot to plot the data against the individual "seasons"
#in which the data is observed.


ggseasonplot(amzn_close_train, year.labels = TRUE, year.labels.left = TRUE) + ylab("Closing price") + 
  xlab(" Dates across year") + ggtitle("Seasonal Plot: Amazon Stock Prices")

ggseasonplot(amzn_close_train, polar=TRUE) + ylab("Closing price") + 
  xlab(" Dates across year") + ggtitle("Seasonal Plot: Amazon Stock Prices")

#However upon inspection there is no indication of any seasonal patterns outside of the later years
#showing upward trend, thus another indication towards non-stationarity.

#We observe sudden increase in the stock price from the end of year 2015.

#Seasonal Subseries Plots
ggsubseriesplot(amzn_close_train) + ylab("$ million") + ggtitle("Seasonal subseries plot: Amazon Stock Price")

##This plot emphasises the seasonal patterns. The horizontal lines indicates the mean for each month
#Here, we can not see the seasonal pattern.

#Let's explore the relationship more..
qplot(amzn$AMZN.Close,amzn$AMZN.Open, data=amzn)
#They have a linear relationship
qplot(amzn$AMZN.Volume,amzn$AMZN.Close, data=amzn)
#here, the volume is high only when the closing price is low..

a<-to.monthly(AMZN)
#Let's plot both the time series..
autoplot(a[,c("AMZN.Close","AMZN.Volume")], facets=TRUE) +
  xlab("Years") + ylab("") +
  ggtitle("CLosing Price & Volume")
#Here, we can see an inverse relation between closing price ad volumne of the Stock.


#Scatterplot Matrix
library(GGally)
ggpairs(amzn[,1:5])
#We can see that the variables are highly correlated and the relationship is also linear.. VOlume is not highly correlated.

#Show the trend cycle component..No seasonality.Only Trend
plot(amzn_close, col="gray",
     main="Amazon stock price",
     ylab="Date", xlab="")
lines(fit$time.series[,2],col="red",ylab="T
      rend")


#See the variation in the seasonal component
monthplot(fit$time.series[,"seasonal"], main="", ylab="Seasonal")

#For the seasonally adjusted data---seasonality is removed
plot(amzn_close, col="grey",
     main="Amazon Stock Market",
     xlab="", ylab="Date")
lines(seasadj(fit),col="red",ylab="Seasonally adjusted")

#We observe non-seasonality in the dataset...

#Let's plot the Lagged scatterplot
gglagplot(amzn_close)
#Here the color indicate the month of the variable on the vertical axis.

#LAG PLOTS----

#ACF
ggAcf(amzn_close_train)
#Here we see a strongly increasing trend in the data and all lags are significant..
gglagplot(amzn_close_train)
#They are highly autorelation at initial lags but tend to decrease gradually.. r1 >r2>r3>r4>r5.....
#When data have a trend, the autocorrelations for small lags tend to be large and positive because 
#observations nearby in time are also nearby in size. So the ACF of trended time series tend to 
#have positive values that slowly decrease as the lags increase.
#We see no seasonality/cyclic behaviour in the correlogram...
##ACF stands for "autocorrelation function" and PACF stands for "partial autocorrelation function". 
##The ACF and PACF diagnosis is employed over a time-series to determine the order for which we are
##going to create our model using ARIMA modeling. Loosely speaking, a time-series is stationary 
##when its mean, variance, and autocorrelation remain constant over time.
##These functions help us understand the correlation component of different data points at different
#time lags. Lag refers to the time difference between one observation and a previous observation in 
#a dataset.

#When there is large autocorrelation within our lagged values, we see geometric decay in our plots, 
#which is a huge indicator that we will have to take the difference of our time series object.

#Transforming our data to adjust for non-stationary:
#From visual inspection of the time-series object and the other graphs used for exploratory purposes
#we decided it is appropriate to difference our time series object to account for the 
#non-stationarity and see how that fares!

#A way to make a time-series stationary is to find the difference across its consecutive values. 
#This helps stabilize the mean, thereby making the time-series object stationary.

amzn_diff_train<-diff(amzn_close_train)
amzn_diff_test<-diff(amzn_close_test)

#Plotting the transformed data
autoplot(amzn_diff_train) + xlab("Year") + ylab("Closing Price of Amazon")+
  ggtitle("Timeseries plot of Amazon closing price")

#This plot suggests that our working data is stationary. We want to confirm this running an 
#ACF and PACF diagnostics over this data to find our if we can proceed to estimating a model.

##Testing for Stationarity
Box.test(amzn_diff_train, lag = 20, type = 'Ljung-Box')

adf.test(amzn_diff_train)
#We see the p-values is smaller that printed p-value which makes us reject the null suggestion 
#stationarity 
#################################################################################################33
###################################TO BE CONTINUED############################################
#ACG plots
ggAcf(amzn_diff_train)
#Here we see a strongly increasing trend in the data and all lags are significant..
gglagplot(amzn_diff_train)

#convert into dataframe consisting of closing stock values and log of those values
amz<-data.frame(closing=amzn_close, lclosing=log(amzn_close))
save(amz, file="amazon.df.RData")
load("amazon.df.RData")

#stl() is used to breakdown the time series into seasonal, trend, and residual components
amz.stl<-stl(amz$closing,s.window = "periodic")
plot(amz.stl,main="Amazon stock decomposition")

#Forecasting using stl()
library(forecast)
#arima model is used. h=24 specifies 2 years with 95% confidence level
amz.f<-forecast(amz.stl, method ="arima", h=24, level=95)
plot(amz.f,ylab = "Stock Price", xlab = "year", sub="Forecast from Oct 2019 to Sep 2021")


meanf(amzn_close, h=5)

naive(amzn_close, h=5)


snaive(amzn_close, h=5)


library(ggplot2)
library(gridExtra)




















