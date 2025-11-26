//
//  LocationDTO.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 22/11/25.
//
// MARK: - Data Transfer Object
/// `LocationDTO` represents the JSON structure from remote API.
/// Conforms to `Codable` for JSON serialization/deserialization.
/// Contains mapping method to convert to domain model `Location`.

import Foundation

struct LocationDTO: Codable {
    // MARK: - Properties (matching JSON keys)
        
    /// Location name from API
    let name: String
    
    /// City name from API
    let cityName: String
    
    /// Latitude from API
    let latitude: Double
    
    /// Longitude from API
    let longitude: Double
    
    /// Description from API
    let description: String
        
    /// Image URLs from API
    let imageURLs: [String]
        
    /// Wikipedia link from API
    let link: String
    
    // MARK: - Model Conversion
        
    /// Converts DTO to domain model `Location`
    /// - Returns: `Location` instance with generated ID
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
            isFavorite: false // Default value, will be updated if needed
        )
    }
}
