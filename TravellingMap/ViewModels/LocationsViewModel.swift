//
//  LocationsViewModel.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//
// MARK: - Main ViewModel
/// `LocationsViewModel` is the primary ViewModel managing state and business logic.
/// Handles: map display, search, routing, and location list management.
/// Uses `@Observable` macro for SwiftUI state management.

import Foundation
import Observation
import SwiftUI
import MapKit
import SwiftData

@Observable
class LocationsViewModel {
    // MARK: - State Properties
        
    /// All locations loaded from SwiftData
    var locations: [Location] = []
    
    /// Currently selected location on the map
    /// Automatically updates camera position when changed
    /// Automatically updates showBottomPanel when changed: turn off bottomPanel (showBottomPanel = false) if mapLocation = nil
    var mapLocation: Location? = nil {
        didSet {
            updatePosition(location: mapLocation)
            let shouldShowPanel = mapLocation != nil
            if showBottomPanel != shouldShowPanel {
                showBottomPanel = shouldShowPanel
            }
        }
    }
    
    /// Current camera position on the map
    /// Can be: user location, region, or rect
    var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    /// Map zoom level (in degrees)
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    /// Shows the locations list (toggled from header)
    var showLocationsList: Bool = false
    
    /// Location selected for detail sheet display
    var sheetLocation: Location? = nil
    
    /// Manager for handling location services
    let locationManager = LocationManager.shared
    
    /// Shows alert when user denies location permission/
    var showLocationDeniedAlert: Bool = false
    
    /// Calculated route (if any)
    var route: MKRoute? = nil
    
    /// Destination for current route
    var routeDestination: Location? = nil
    
    /// Text from search bar
    var searchText = ""
    
    /// Filter to show only favorite locations
    var showFavoritesOnly: Bool = false
    
    /// Shows bottom panel (RouteView/LocationPreviewView)
    var showBottomPanel: Bool = false
    
    /// Error message for alert display
    var errorMessage: String = ""
    
    /// Shows error alert
    var showErrorAlert: Bool = false
    
    // MARK: - Computed Properties
    
    /// Locations filtered by search text and favorite status
    var filteredLocations: [Location] {
        var result = locations
        
        // Apply favorite filter if enabled
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        // Return all if search is empty
        guard !searchText.isEmpty else { return result }
        
        // Filter by name or city name
        return result.filter { location in
            location.name.localizedStandardContains(searchText) ||
            location.cityName.localizedStandardContains(searchText)
        }
    }
    
    // MARK: - Initialization
        
    /// Initializes ViewModel and requests location permission
    init() {
        locationManager.requestLocationPermission()
    }
    
    // MARK: - Data Operations
        
    /// Loads location data from API and saves to SwiftData
    /// - Parameter context: SwiftData ModelContext for persistence
    func loadLocationsData(context: ModelContext) async {
        do {
            try await LocationsDataService.shared.fetchAndSaveData(context: context)
        } catch {
            print("Error: \(error.localizedDescription)")
            
            // Update UI on main thread
            await MainActor.run {
                self.errorMessage = "Không thể tải dữ liệu: \(error.localizedDescription)"
                self.showErrorAlert = true
            }
        }
    }
    
    // MARK: - Map Positioning
        
    /// Updates camera position based on selected location
    /// - Parameter location: Location to focus on, nil for user location
    private func updatePosition(location: Location?) {
        withAnimation(.easeInOut) {
            if let location = location {
                self.position = .region(MKCoordinateRegion(
                    center: location.coordinates,
                    span: mapSpan
                ))
            }
        }
    }
    
    // MARK: - User Interface Actions
        
    /// Toggles the visibility of locations list
    /// Clears search text when hiding the list
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
            if !showLocationsList {
                searchText = ""
            }
        }
    }
    
    /// Displays the next location on the map
    /// - Parameter location: Location to display
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            self.mapLocation = location
            self.showLocationsList = false
        }
    }
    
    /// Centers map on user's current location
    /// Handles: not determined, denied, and authorized states
    func centerOnUserLocation() {
        let status = locationManager.authorizationStatus
        
        // Not determined - request permission
        if status == .notDetermined {
            locationManager.requestLocationPermission()
            return
        }
        
        // Denied or restricted - show alert
        if status == .denied || status == .restricted {
            showLocationDeniedAlert = true
            return
        }
        
        // Authorized - center on user
        withAnimation(.easeInOut) {
            self.mapLocation = nil
            self.position = .userLocation(fallback: .automatic)
        }
    }
    
    /// Checks location authorization and centers map if permitted
    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.mapLocation = nil
            self.position = .userLocation(fallback: .automatic)
        }
    }
    
    // MARK: - Routing & Navigation
        
    /// Calculates route from user's location to destination
    /// - Parameter location: Destination location
    func calculateRoute(to location: Location) {
        // Check if user location is available
        guard let userLocation = locationManager.manager.location?.coordinate else {
            return
        }
        
        // Create MKDirections request
        let request = MKDirections.Request()
        let sourceLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destinationLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        request.source = MKMapItem(location: sourceLocation, address: nil)
        request.destination = MKMapItem(location: destinationLocation, address: nil)
        request.transportType = .automobile
        
        // Calculate route asynchronously
        Task {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                
                // Update UI on main thread
                await MainActor.run {
                    if let route = response.routes.first {
                        self.route = route
                        self.routeDestination = location
                        
                        // Zoom map to show entire route
                        let rect = route.polyline.boundingMapRect
                        let paddedRect = rect.insetBy(dx: -rect.width * 0.3, dy: -rect.height * 0.3)
                        self.position = .rect(paddedRect)
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Không tìm thấy đường đi: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }
    }
    
    /// Opens Maps app with navigation to destination
    func openNavigationApp() {
        guard let location = routeDestination else { return }
            
        let destCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let mapItem = MKMapItem(location: destCLLocation, address: nil)
        mapItem.name = location.name
        
        // Launch with driving mode
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    /// Clears current route and resets map
    func clearRoute() {
        self.route = nil
        self.routeDestination = nil
        updatePosition(location: mapLocation)
    }
}
