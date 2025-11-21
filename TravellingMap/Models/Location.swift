//
//  Location.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable, Codable {
    let name: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let description: String
    let imageURLs: [String]
    let link: String
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var id: String {
        name + cityName
    }
    
    // Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
