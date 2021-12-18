#  WeatherApp Demo

## Introduction

I applied MVVM design pattern, so each controller has its own view model also, I took the advantages of combine. For the second part, I used my city as a fixed data stored in _Resources_ called **FixedWeather.json**.

### Main

Token which is authenticated for me from open weather and base url are stored in _Secrets.plist_. I implemented _APIManager_ in Utils to organize the all functions for communication with the cloud as a singleton object. So, I am able to communicate with the cloud in anywhere app. Communication is provided by request and response models declared in _Models_ group as struct type, I used here _struct_ since the persistent storage did not initialize, so struct type was enough for just this operation.

I chose to use the segmented control in order to select the page type at the navigation bar, also settings tab was added for defining the query parameters for the forecasts. The default values of the query parameters was determined in _AppSettings.plist_. If the app is launched for the first time, then the file is being read from the bundle and saving into **UserDefaults**.

### Second part

I control the page type using UISegmentedControl, also table view has its own refresher in both type. **FileAccessManager** is responsible for the reading the content of files from both bundle and documents directory. Users can also set the parameters in the _Settings_ tab.
