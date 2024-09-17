start our journey to make Githup Trending App 
# Project Name

## Overview

GitHupTrendingApp is an iOS application designed to [briefly describe the functionality of the project, e.g., "manage user favorites and provide real-time updates based on internet connectivity."] This app implements a seamless user experience by ensuring data is fetched only when the device is connected to the internet. Additionally, it offers offline support by caching user preferences and favorites.

## Features

- **Real-Time Internet Connection Monitoring**: The app monitors the network status and alerts the user when there is no internet connection.
- **Offline Favorites**: Users can add and manage their favorite repositories, which are stored locally for offline use.
- **Automatic Retry**: When the internet is restored, the app will automatically refresh the data and dismiss the offline view.
- **Search Functionality**: Filter through a list of repositories with a search bar that provides real-time filtering.
- **Error Handling**: Clear user experience with visual feedback when there is no internet or an error occurs.
  
## How to Use

1. Clone this repository.
2. Open the project in Xcode.
3. Run the app on your simulator or device.

## Installation

To install the app, follow these steps:

1. Clone the repository: git clone https://github.com/AhmadMaher1992/GitHupTrendingApp.git
2. Open the `.xcodeproj` or `.xcworkspace` file in Xcode.
3. Install Pods then Run the app on a simulator or a physical device.

## Usage

Once the app is running:

1. Navigate through the list of trending repositories.
2. Use the search bar to filter repositories.
3. Add repositories to your favorites list for offline access.
4. If the internet connection is lost, you will be notified, and upon reconnection, the app will refresh the data.

## Technologies Used

- **Swift**
- **Combine Framework** for data binding.
- **Network Framework** for monitoring network status.
- **UIKit** for building the user interface.
- **ArchitecturePAttern(MVVM-MVC)** use mvvm in the main screen that need more functionality and mvc in screen that has little logic
- **DESING(StoryBoard-Nibs)** mix between nibs and storyboard to show my skills  
## Contribution

Feel free to fork this project, create a new branch, and submit a pull request if you'd like to contribute. All contributions are welcome!

