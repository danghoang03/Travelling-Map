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
    var locations: [Location]
    
    // Current location on map
    var mapLocation: Location {
        didSet {
            updatePosition(location: mapLocation)
        }
    }
    
    // Current region on map
    var position: MapCameraPosition = .region(MKCoordinateRegion())
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // Show list of locations
    var showLocationsList: Bool = false
    
    
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        updatePosition(location: locations.first!)
    }
    
    private func updatePosition(location: Location) {
        withAnimation(.easeInOut) {
            self.position = .region(MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan
            ))
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
}
