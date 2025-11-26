//
//  Location.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//
// MARK: - Location Model
/// `Location` is the main model representing a travel destination.
/// This class serves as a SwiftData Model and conforms to `Equatable` protocol.
/// Each location contains coordinates, description, images, and favorite status.

import Foundation
import MapKit
import SwiftData

@Model
class Location: Equatable {
    // MARK: - Properties
    
    /// Unique identifier for location (generated from name + cityName)
    @Attribute(.unique) var id: String
    
    /// Location name
    var name: String
    
    /// City name
    var cityName: String
    
    /// Latitude coordinate
    var latitude: Double
    
    /// Longitude coordinate
    var longitude: Double
    
    /// Detailed description of the location
    var desc: String
    
    /// Array of image URLs for the location
    var imageURLs: [String]
    
    /// Wikipedia link for the location
    var link: String
    
    /// User's favorite status
    var isFavorite: Bool = false
    
    // MARK: - Computed Properties
       
    /// Converts latitude/longitude to CLLocationCoordinate2D for MapKit usage
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Initializer
        
    /// Initializes a new location
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - name: Location name
    ///   - cityName: City name
    ///   - latitude: Latitude coordinate
    ///   - longitude: Longitude coordinate
    ///   - desc: Description
    ///   - imageURLs: Array of image URLs
    ///   - link: Wikipedia link
    ///   - isFavorite: Favorite status
    init(id: String, name: String, cityName: String, latitude: Double, longitude: Double, desc: String, imageURLs: [String], link: String, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.desc = desc
        self.imageURLs = imageURLs
        self.link = link
        self.isFavorite = isFavorite
    }
    
    // MARK: - Equatable Protocol
        
    /// Compares two Locations based on their ID
    /// - Parameters:
    ///   - lhs: Left-hand side Location
    ///   - rhs: Right-hand side Location
    /// - Returns: `true` if same ID, `false` otherwise
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
