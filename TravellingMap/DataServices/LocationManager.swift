//
//  LocationManager.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 23/11/25.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
}
