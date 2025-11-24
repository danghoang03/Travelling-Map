//
//  LocationsViewModel.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//

import Foundation
import Observation
import SwiftUI
import MapKit

@Observable
class LocationsViewModel {
    // All loaded locations
    var locations: [Location] = []
    
    // Current location on map
    var mapLocation: Location? = nil {
        didSet {
            updatePosition(location: mapLocation)
        }
    }
    
    // Current region on map
    var position: MapCameraPosition = .userLocation(fallback: .automatic)
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    // Show list of locations
    var showLocationsList: Bool = false
    
    // Show location detail sheet
    var sheetLocation: Location? = nil
    
    let locationManager = LocationManager.shared
    
    var showLocationDeniedAlert: Bool = false
    
    var route: MKRoute? = nil
    var routeDestination: Location? = nil
    
    init() {
        locationManager.requestLocationPermission()
    }
    
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
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            self.mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed() {
        // Get the current index
        guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else {
            print("Could not find current index in locations array!")
            return
        }
        
        // Check if the nextIndex is valid
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            // nextIndex is not valid
            // Restart from 0
            guard let firstLocation = locations.first else {
                return
            }
            showNextLocation(location: firstLocation)
            return
        }
        
        //nextIndex is valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
    
    func centerOnUserLocation() {
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestLocationPermission()
            return
        }
        
        if status == .denied || status == .restricted {
            showLocationDeniedAlert = true
            return
        }
        
        withAnimation(.easeInOut) {
            self.mapLocation = nil
            self.position = .userLocation(fallback: .automatic)
        }
    }
    
    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.mapLocation = nil
            self.position = .userLocation(fallback: .automatic)
        }
    }
    
    func calculateRoute(to location: Location) {
        guard let userLocation = locationManager.manager.location?.coordinate else {
            print("Can't get user location")
            return
        }
        
        let request = MKDirections.Request()
        let sourceLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destinationLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        request.source = MKMapItem(location: sourceLocation, address: nil)
        request.destination = MKMapItem(location: destinationLocation, address: nil)
        request.transportType = .automobile
        
        Task {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                await MainActor.run {
                    if let route = response.routes.first {
                        self.route = route
                        self.routeDestination = location
                        
                        let rect = route.polyline.boundingMapRect
                        let paddedRect = rect.insetBy(dx: -rect.width * 0.3, dy: -rect.height * 0.3)
                        self.position = .rect(paddedRect)
                    }
                }
            } catch {
                print("Error getting directions: \(error.localizedDescription)")
            }
        }
    }
    
    func openNavigationApp() {
        guard let location = routeDestination else { return }
            
        let destCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let mapItem = MKMapItem(location: destCLLocation, address: nil)
        mapItem.name = location.name
            
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func clearRoute() {
        self.route = nil
        self.routeDestination = nil
        updatePosition(location: mapLocation)
    }
}
