//
//  LocationsDataService.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 21/11/25.
//

import Foundation
import MapKit

class LocationsDataService {
    static let shared = LocationsDataService()
    
    private init() {}
    
    func fetchLocations() async throws -> [Location] {
        guard let url = URL(string: "https://gist.githubusercontent.com/danghoang03/c499b00fb63cbf76cf32ac94dcc85d24/raw/5c62ec40311419ee5a14b92047c6d07369085596/LocationsData.json") else {
            throw URLError(.badURL)
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        let locations = try JSONDecoder().decode([Location].self, from: data)
        return locations
    }
}
