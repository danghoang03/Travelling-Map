//
//  LocationManager.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 23/11/25.
//
// MARK: - Location Service Manager
/// `LocationManager` handles CoreLocation services and authorization.
/// Singleton pattern ensures single instance throughout the app.
/// Conforms to `CLLocationManagerDelegate` for authorization callbacks.

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Singleton Instance
    
    /// Shared singleton instance
    static let shared = LocationManager()
    
    // MARK: - Properties
        
    /// CoreLocation manager instance
    let manager = CLLocationManager()
    
    /// Current authorization status (observed by SwiftUI)
    var authorizationStatus: CLAuthorizationStatus?
    
    // MARK: - Initialization
        
    /// Private initializer for singleton pattern
    /// Sets up delegate and desired accuracy
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Permission Handling
        
    /// Requests location permission (when-in-use authorization)
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
        
    /// Called when authorization status changes
    /// Updates the observed `authorizationStatus` property
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
}
