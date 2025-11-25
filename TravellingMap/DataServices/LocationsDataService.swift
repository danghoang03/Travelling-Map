//
//  LocationsDataService.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 21/11/25.
//

import Foundation
import MapKit
import SwiftData

@MainActor
class LocationsDataService {
    static let shared = LocationsDataService()
    
    private let refreshInterval: TimeInterval = 86400
    
    private init() {}
    
    private func shouldFetchData() -> Bool {
        let lastFetchDate = UserDefaults.standard.object(forKey: "lastFetchDate") as? Date ?? Date.distantPast
        return Date().timeIntervalSince(lastFetchDate) > refreshInterval
    }
    
    func fetchAndSaveData(context: ModelContext) async {
        guard shouldFetchData() else { return }
        do {
            guard let url = URL(string: "https://gist.githubusercontent.com/danghoang03/c499b00fb63cbf76cf32ac94dcc85d24/raw/5c62ec40311419ee5a14b92047c6d07369085596/LocationsData.json") else {
                print("URL Error")
                return
            }
            
            let (data,_) = try await URLSession.shared.data(from: url)
            let locationsDTO = try JSONDecoder().decode([LocationDTO].self, from: data)
            
            let receivedIDs = locationsDTO.map { $0.name + $0.cityName }
            
            let favoriteDescriptor = FetchDescriptor<Location>(predicate: #Predicate { $0.isFavorite })
            let existingFavorites = try? context.fetch(favoriteDescriptor)
            let favoriteIDs = Set(existingFavorites?.map { $0.id } ?? [])
            
            try? context.delete(model: Location.self, where: #Predicate { location in
                !receivedIDs.contains(location.id)
            })
            
            for locationDTO in locationsDTO {
                let locationModel = locationDTO.toModel()
                if favoriteIDs.contains(locationModel.id) {
                    locationModel.isFavorite = true
                }
                context.insert(locationModel)
            }
            try context.save()
            UserDefaults.standard.set(Date(), forKey: "lastFetchDate")
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func forceRefresh() {
        UserDefaults.standard.removeObject(forKey: "lastFetchDate")
    }
}
