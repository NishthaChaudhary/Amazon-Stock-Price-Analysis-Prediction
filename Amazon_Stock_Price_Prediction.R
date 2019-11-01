library(ggplot2) 
library(fpp2) 
library(forecast)
library(fma)
library(expsmooth)    
library(quantmod) #install.packages("quantmod") 




Sys.Date()
#sp500 <- new.env()
getSymbols("AMZN",from = as.Date("2008-01-04"), to = as.Date("2019-10-01"))
#AMZN <- sp500$AMZN
amzn<-data.frame(to.monthly(AMZN))

amzn_close = round(amzn$AMZN.Close,2)
#to.monthly(gspc_close,indexAt='yearmon')
amzn_close <- ts(data=amzn_close,start=c(2010, 1), freq=12)


#Time plot to observe the trend, seasonality or cyclic pattern
autoplot(amzn_close) + xlab("Year") + ylab("Closing Price of sp500")+
  ggtitle("Timeseries plot of Amazon closing price")

#The Amazon stock price shows a strong increasing trend with seasonality. However, there is no evidence of 
#cyclic behaviour

#Let's plot the seasonal plot to plot the data against the individual "seasons"
#in which the data is observed.

ggseasonplot(amzn_close, year.labels = TRUE, year.labels.left = TRUE) + ylab("Closing price") + 
  xlab(" Dates across year") + ggtitle("Seasonal Plot: Amazon Stock Prices")

#We observe sudden increase in the stock price from 2017 to 2018.


#Seasonal Subseries Plots
ggsubseriesplot(amzn_close) + ylab("$ million") + ggtitle("Seasonal subseries plot: Amazon Stock Price")

##This plot emphasises the seasonal patterns. The horizontal lines indicates the mean for each month
#Here, we can easily see the seasonal pattern.

#Let's explore the relationship more..
qplot(amzn$AMZN.Close,amzn$AMZN.Open, data=amzn)


#Scatterplot Matrix
library(GGally)
ggpairs(amzn[,1:5])
#We can see that the variables are highly correlated.. VOlume is not highly correlated.


#Let's plot the Lagged scatterplot
gglagplot(amzn_close)
#Here the color indicate the month of the variable on the vertical axis.

###Lets take quarterly data
amzn_q<-data.frame(to.quarterly(AMZN))
amzn_close_q = round(amzn_q$AMZN.Close,2)
amzn_quart<-ts(data=amzn_close_q,start=c(1997, 2), freq=4)
gglagplot(amzn_quart)
##We observe the seasonality is not that strong

#ACF
ggAcf(amzn_close)
#Here we see a strongly increasing trend in the data and all lags are significant and highly correlated..

#Decomposition
fit<-stl(amzn_close,s.window = 5)
plot(fit)

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




















