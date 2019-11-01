# Amazon-Stock-Price-Analysis-Prediction
Time Series Analysis on Amazon Stock Price with R.

# Abstract
This project focuses on using univariate time series forecasting methods for the stock market index, Amazon Stock Price, which is the notation we will use in this project) emphasizing on Box-Jenkins AutoRegressive Integrated Moving Average (ARIMA) modeling. We went about the time series analysis was through using R and R studio to both predict and visualize our predictions. Along with the interactivity of plotly through the ggplot2 package we were able to create stunning visuals that help in understanding which time series forecasting method is most appropriate for your own time series analysis.

# Methodology
For our time series analysis, we chose to focus on the Box-Jenkins methodology which incorporates a series of steps to ensure we produce the best model to forecasting. We used the years 2008 to 2017, withholding 2018 and 2019 so that we can compare the forecast.

But before we outline the steps we would like to outline some necessary assumptions for univariate time series analysis:

1. The Box-Jenkins Model assumes weakly stationarity process.
2. The residuals are white noise (independently and identically distributed random variables) and homoscedastic.

# ARIMA Model
For this project we will be using the Autoregressive Integrated Moving Average model and its variations to forecast the Amazon Stock Price. For each component we have a corresponding variable for which we model if there is sign of these components. Here we roughly outline the parts that make an ARIMA(p,d,q) model
1. Autoregressive [AR(p)] - a stochastic process where future values are dependent on past values signifying that past values have a linear effect on the future values.
2. Integration [I(d)] - when differencing is done to make a process stationary, we include the difference value(i.e. if we took the first difference it would be I(d=1))
3. Moving Average [MA(q)] - a prcoess where the current value is linearly regressed on current and past white noise terms (residuals).

Next we outline the steps to ensure we fit the appropriate ARIMA(p,d,q) model!

# Stationary process and Seasonality
The first step is checking to see if the time series object is stationary, this can be done in various methods which can also be explained as exploratory analysis since we are in essence "getting a feel" for our data. Here we include some of the processes:

1. Plot the time series object: sometimes simply plotting the time series object can tell you if a process is stationary or not. As well as telling you if there are strong seasonal patterns!

2. Plot Decomposed time series object: decomposing allows us to view a time series object in components (four components see website for more information). Further discussion can be seen in the project, but when we decompose our time series objects we get a glimpse of its seasonal and trend components independently.

3. Seasonal Plot: The name speaks for itself but this plot is a great way to check for seasonal components which is something common when dealing with yearly, quarterly and monthly data.

These plots will help us in our Box-Jenkins Model estimation, as well as doing transformations such as differencing (and taking the log if necessary) of our time series objects to take into consideration non-stationarity and heteroskedasticity respectively.

# Autocorrelation and Partial Autocorrelation Plots
These plots play a crucial role in time series analysis, because we can estimate our ARIMA(p,d,q) model based on the behaviour of these plots or justify the need to do an appropriate transformation.

We won't go into too much detail since we outlined the process in the project, but through the use of our ACF and PACF plots for our original time series we were able to make the deduction to take the first difference of our time series. Once we did that we saw that the ACF and PACF plot showed characteristics of a MA(1) model, but since we took the first difference it becomes a mixed model; ARIMA(0, 1, 1)

From here we do residual diagnostics to see if our model displays residuals that are white noise.

# Residual Diagnostics
We visually inspect the residual diagnostics of our model to ensure our residuals are white noise; we employ the tsdisplay to give us the standardized residuals, ACF plot of the residuals and the Ljung-Box statistics which are all explained more indepth in the project.

We also included a histogram of the residuals to show that they display a fairly normally distribution which ensure we haven't violated our assumptions.

# Forecast
Once we have our model, we forecast the year 2015 and see how it compares to the actual values!

We won't go into detail here but we outlined several other forecasting methods to use as comparisons. The other forecasting methods we included are:

Box-Cox Transformation Forecast
Mean Forecast
Naive Forecast
Seasonal Naive Forecast
Exponential Smoothing Forecast

# Conclusion

Still in Process...
