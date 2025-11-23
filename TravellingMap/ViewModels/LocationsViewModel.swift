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
            } else if let userLocation = locationManager.currentLocation {
                self.position = .region(MKCoordinateRegion(
                    center: userLocation.coordinate,
                    span: mapSpan
                ))
            } else {
                self.position = .userLocation(fallback: .automatic)
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
        }
    }
    
    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.mapLocation = nil
        }
    }
}
