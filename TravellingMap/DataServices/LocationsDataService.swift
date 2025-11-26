//
//  LocationsDataService.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 21/11/25.
//
// MARK: - Data Service Layer
/// `LocationsDataService` handles remote data fetching and local persistence.
/// Implements caching strategy with 24-hour refresh interval.
/// Uses SwiftData for local storage and URLSession for networking.

import Foundation
import MapKit
import SwiftData

@MainActor
class LocationsDataService {
    // MARK: - Singleton Instance
        
    /// Shared singleton instance
    static let shared = LocationsDataService()
    
    // MARK: - Properties
        
    /// Cache refresh interval (24 hours in seconds)
    private let refreshInterval: TimeInterval = 86400
    
    // MARK: - Private Initializer
        
    /// Private initializer for singleton pattern
    private init() {}
    
    // MARK: - Cache Management
        
    /// Determines if data should be fetched based on last fetch time
    /// - Returns: `true` if cache is stale, `false` otherwise
    private func shouldFetchData() -> Bool {
        let lastFetchDate = UserDefaults.standard.object(forKey: "lastFetchDate") as? Date ?? Date.distantPast
        return Date().timeIntervalSince(lastFetchDate) > refreshInterval
    }
    
    // MARK: - Data Operations
        
    /// Fetches data from remote API and saves to SwiftData
    /// - Parameter context: SwiftData ModelContext for persistence
    /// - Throws: `URLError` for network issues or invalid responses
    func fetchAndSaveData(context: ModelContext) async throws {
        // Check cache validity
        guard shouldFetchData() else { return }
        
        // API endpoint URL
        guard let url = URL(string: "https://gist.githubusercontent.com/danghoang03/c499b00fb63cbf76cf32ac94dcc85d24/raw/5c62ec40311419ee5a14b92047c6d07369085596/LocationsData.json") else {
            throw URLError(.badURL)
        }
         
        // Fetch data from network
        let (data,response) = try await URLSession.shared.data(from: url)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode JSON to DTOs
        let locationsDTO = try JSONDecoder().decode([LocationDTO].self, from: data)
        
        // Prepare IDs from fetched data
        let receivedIDs = locationsDTO.map { $0.name + $0.cityName }
        
        // Fetch existing favorites to preserve their state
        let favoriteDescriptor = FetchDescriptor<Location>(predicate: #Predicate { $0.isFavorite })
        let existingFavorites = try? context.fetch(favoriteDescriptor)
        let favoriteIDs = Set(existingFavorites?.map { $0.id } ?? [])
        
        // Delete locations not in fetched data
        try? context.delete(model: Location.self, where: #Predicate { location in
            !receivedIDs.contains(location.id)
        })
        
        // Insert or update locations
        for locationDTO in locationsDTO {
            let locationModel = locationDTO.toModel()
            
            // Preserve favorite status if previously marked
            if favoriteIDs.contains(locationModel.id) {
                locationModel.isFavorite = true
            }
            
            context.insert(locationModel)
        }
        
        // Save changes and update cache timestamp
        try context.save()
        UserDefaults.standard.set(Date(), forKey: "lastFetchDate")
    }
    
    /// Forces refresh by clearing cache timestamp
    func forceRefresh() {
        UserDefaults.standard.removeObject(forKey: "lastFetchDate")
    }
}
