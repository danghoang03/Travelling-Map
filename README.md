# TravellingMap 🇻🇳

[![Tiếng Việt](https://img.shields.io/badge/lang-Tiếng%20Việt-red.svg)](./README_VI.md)
[![Swift 6.2](https://img.shields.io/badge/Swift-6.2-orange.svg)](https://swift.org)
[![iOS 26.0+](https://img.shields.io/badge/iOS-26.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-7.0+-blue.svg)](https://developer.apple.com/xcode/swiftui/)

**TravellingMap** is a iOS application built with **SwiftUI** that helps users discover travel destinations in Vietnam. The app features an interactive map, detailed location information, route planning, and offline data persistence.

## 🌟 Features

* **Interactive Map**: Browse travel destinations on a map using customized annotations.
* **Discover Locations**: View a list of famous tourist spots with search functionality (by name or city).
* **Smart Navigation**:
    * Calculate routes from your current location to a destination.
    * View estimated travel time and distance.
    * Visualize the route path directly on the map.
    * Deep link integration to open Apple Maps for turn-by-turn navigation.
* **Favorites System**: Mark locations as "Favorites" to save them for later.
* **Detailed Insights**: View images, descriptions, and Wikipedia links for each location.
* **Offline Capability**: Data is cached locally using **SwiftData**, ensuring the app works even without an internet connection (updates every 24 hours).

## 🎥 Demo

https://github.com/user-attachments/assets/8217b8e6-9330-4768-8819-fd507b2d8ece

## 🛠 Tech Stack

* **Language**: Swift 6+
* **UI Framework**: SwiftUI
* **Architecture**: MVVM (Model-View-ViewModel)
* **Data Persistence**: [SwiftData](https://developer.apple.com/xcode/swiftdata/) (Local database)
* **Networking**: URLSession (Async/Await)
* **Maps**: MapKit & CoreLocation
* **State Management**: Observation Framework (`@Observable`)
* **Dependencies**:
    * [Kingfisher](https://github.com/onevcat/Kingfisher) (Image caching and loading)

## 📂 Architecture

The project follows a clean MVVM architecture:

* **Models**: Defines data structures (`Location`, `LocationDTO`) and database schema.
* **Views**: SwiftUI views organized by feature (`LocationsView`, `LocationDetailView`, `RouteView`, etc.).
* **ViewModels**: Manages business logic and state (`LocationsViewModel`).
* **DataServices**: Handles API calls (`LocationsDataService`) and Location permissions (`LocationManager`).

## 🚀 Getting Started

### Prerequisites
* Xcode 15.0 or later.
* iOS 17.0 or later (due to usage of SwiftData and Observation macros).

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/danghoang03/Travelling-Map.git
    ```
2.  **Open the project**:
    Double-click `TravellingMap.xcodeproj`.
3.  **Resolve Dependencies**:
    Xcode should automatically fetch the Kingfisher package via Swift Package Manager. If not, go to `File > Packages > Resolve Package Versions`.
4.  **Run the App**:
    Select an iOS Simulator or a physical device and press `Cmd + R`.

> **Note**: To test the routing and user location features on the Simulator, ensure you simulate a location via `Features > Location`.

## 🧪 Testing

The project includes a comprehensive suite of Unit Tests to ensure code reliability and logic correctness.

* **Test Target**: `TravellingMapTests`
* **What is tested**:
    * **ViewModels** (`LocationsViewModelTests`): Verifies filtering logic, including search functionality (by name/city) and "Favorites" toggling.
    * **Data Models** (`LocationDTOTests`): Ensures JSON decoding handles valid/invalid data correctly and tests DTO-to-Model mapping.
    * **Data Persistence** (`DataServiceTests`): Tests the ability to save and retrieve locations using SwiftData.

### How to Run Tests
1.  Open the project in Xcode.
2.  Select the `TravellingMap` scheme.
3.  Press **Cmd + U** or navigate to **Product > Test** in the menu bar.
4.  Check the results in the Test Navigator (Cmd + 6).
