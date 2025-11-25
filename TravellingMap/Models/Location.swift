//
//  Location.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//

import Foundation
import MapKit
import SwiftData

@Model
class Location: Equatable {
    @Attribute(.unique) var id: String
    var name: String
    var cityName: String
    var latitude: Double
    var longitude: Double
    var desc: String
    var imageURLs: [String]
    var link: String
    var isFavorite: Bool = false
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
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
    
    // Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
