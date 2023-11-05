# Technical Task

Create an iOS app that displays ‘Next to Go’ races using our API.
A user should always see 5 races, and they should be sorted by time ascending. Race should disappear
from the list after 1 min past the start time, if you are looking for inspiration look at
https://www.neds.com.au/next-to-go

## Requirements
1. As a user, I should be able to see a time ordered list of races ordered by advertised start ascending
2. As a user, I should not see races that are one minute past the advertised start
3. As a user, I should be able to filter my list of races by the following categories: Horse, Harness &amp;
Greyhound racing
4. As a user, I can deselect all filters to show the next 5 from of all racing categories
5. As a user I should see the meeting name, race number and advertised start as a countdown for
each race.
6. As a user, I should always see 5 races and data should automatically refresh

## Technical Requirements
- Use SwiftUI or UIKit
- Has some level of testing. Full coverage is not necessary, but there should be at least some testing
for key files.
- Documentation
- Use scalable layouts so your app can respond to font scale changes
- (Optional) Use of custom Decodable
- (Optional) Use of SF Symbols for any icons
- (Optional) add accessibility labels such that you can navigate via voiceover

Categories are defined by IDs and are the following:
- Greyhound racing: category_id: 9daef0d7-bf3c-4f50-921d-8e818c60fe61
- Harness racing: category_id: 161d9be2-e909-4326-8c2c-35ed71fb460b
- Horse racing: category_id: 4a2788f8-e825-4d36-9894-efd4baf1cfae
GET https://api.neds.com.au/rest/v1/racing/?method=nextraces&amp;count=10
Content-type: application/json

# Solution:

## XCode 15 / iOS 17

## Architecture: 
Clean Code Architecture and MVVM. The App is divided into three distinct layers (Data, Domain and Presentation). Each outer layer has dependency on the inner layer's abstraction. The idea is to make the code modular and testable. For unit tests, previews and UI tests we have mock implementation of abctraction passed with dependency injection.

Presentation layer consists of Views and ViewModels. Views are plain SwiftUI views and viewModels are state of views which has view related logic like data formatting, handling user interaction etc. 
Domain layer consists of main business logic like fetching the data from data layer, validating the data, scheculing next api call, running timer etc.
Data layer is responsible for fetching and parsing data. In this project there is no requirement for offline caching hance it is ignored.


## Data refresh logic:
The requirement is to make sure 5 valid races are always visible to UI and data should be automatically refreshed on expiry. To funfill this requirement I have modelled following algorithm in domain layer.
1. Fetch 50 races
2. Filter (if category filter applied) and sort out 5 races and publish to Async stream
3. Get the oldest race's expiry time and schedule a timer to run logic again after delay.
4. Check if we still have 5 valid races with existing data. If yes, rerun step 2 otherwise rerun step 1.

This solution makes sure the API call is made only when it is absolutely necessary otherwise it just plays around the existing data and displays in the UI. The downside of this solution is, if there is change in the data in the backend, app wont be notified. User can get away with this problem with pull to refresh.

## Limitations / TODOs:
1. Beautify UI: The UI is very simple with all native UI components. 
2. Accessibility: The app has decent scalling and voiceover support.
3. Unit / UI tests: I have written few unit tests just to demonstrate my testing skills but it is not anywhere near 100% tested.

## Screenshots / Demo

<img src="/Screenshots/Simulator%20Screenshot%20-%20iPhone%20Xs%20-%202023-11-05%20at%2013.06.01.png" width="400">

<img src="/Screenshots/Simulator%20Screenshot%20-%20iPhone%20Xs%20-%202023-11-05%20at%2013.05.37.png" width="400">

<img src="https://raw.githubusercontent.com/dipeshdhakal/TechTask/main/Screenshots/Screenshot%202023-11-05%20at%207.17.53%20pm.png" width="700">

<img src="/Screenshots/Screenshot%202023-11-05%20at%207.19.09%20pm.png" width="700">

<img src="/Screenshots/Simulator%20Screen%20Recording%20-%20iPhone%20Xs%20-%202023-11-05%20at%2013.04.16.mp4" width="400">

https://github.com/dipeshdhakal/TechTask/assets/7351244/68251379-b1dd-4ae0-a0af-448cd1226bd2



