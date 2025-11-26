//
//  LocationsViewModelTests.swift
//  TravellingMapTests
//
//  Created by Hoàng Minh Hải Đăng on 26/11/25.
//

import XCTest
import SwiftData
@testable import TravellingMap

@MainActor
class LocationsViewModelTests: XCTestCase {
    private var viewModel: LocationsViewModel!
    var container: ModelContainer!
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Location.self, configurations: config)
        
        viewModel = LocationsViewModel()
        viewModel.locations = [
            Location(id: "1", name: "Dinh Độc Lập", cityName: "TP.HCM", latitude: 0, longitude: 0, desc: "", imageURLs: [], link: "", isFavorite: true),
            Location(id: "2", name: "Hồ Gươm", cityName: "Hà Nội", latitude: 0, longitude: 0, desc: "", imageURLs: [], link: "", isFavorite: false),
            Location(id: "3", name: "Chợ Bến Thành", cityName: "TP.HCM", latitude: 0, longitude: 0, desc: "", imageURLs: [], link: "", isFavorite: false)
        ]
    }
    
    override func tearDown() {
        viewModel = nil
        container = nil
    }
    
    func testFilteredLocations_emptySearch_shouldReturnAll() {
        viewModel.searchText = ""
        viewModel.showFavoritesOnly = false
        
        let results = viewModel.filteredLocations
        
        XCTAssertEqual(results.count, 3)
    }
    
    func testFilteredLocations_showFavoriteOnly_shouldReturnOnlyFavorite() {
        viewModel.searchText = ""
        viewModel.showFavoritesOnly = true
        
        let results = viewModel.filteredLocations
        
        XCTAssertEqual(results.count, 1)
    }
    
    func testFilteredLocations_searchByName_shouldReturnMatches() {
        viewModel.searchText = "Dinh"
        
        let results = viewModel.filteredLocations
                
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Dinh Độc Lập")
    }
    
    func testFilterLocations_searchByCity_shouldReturnMatches() {
        viewModel.searchText = "TP.HCM"
        
        let results = viewModel.filteredLocations
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.cityName == "TP.HCM" })
    }
    
    func testFilteredLocations_searchAndFavorite_shouldCombineLogic() {
        viewModel.searchText = "Gươm"
        viewModel.showFavoritesOnly = true
        
        let results = viewModel.filteredLocations
        
        XCTAssertEqual(results.count, 0)
    }
}
