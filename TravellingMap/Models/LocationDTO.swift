//
//  LocationDTO.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 22/11/25.
//

import Foundation

struct LocationDTO: Codable {
    let name: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let description: String
    let imageURLs: [String]
    let link: String
    
    func toModel() -> Location {
        let id: String = name + cityName
        return Location(
            id: id,
            name: name,
            cityName: cityName,
            latitude: latitude,
            longitude: longitude,
            desc: description,
            imageURLs: imageURLs,
            link: link,
            isFavorite: false
        )
    }
}
