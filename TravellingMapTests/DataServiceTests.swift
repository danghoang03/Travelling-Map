//
//  DataServiceTests.swift
//  TravellingMapTests
//
//  Created by Hoàng Minh Hải Đăng on 26/11/25.
//

import XCTest
import SwiftData
@testable import TravellingMap

@MainActor
class DataServiceTests: XCTestCase {
    
    func testSaveLocation_shouldPersistToContainer() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Location.self, configurations: config)
        let context = container.mainContext
        
        let location = Location(
            id: "TestID",
            name: "Test Name",
            cityName: "Test City",
            latitude: 0,
            longitude: 0,
            desc: "Desc",
            imageURLs: [],
            link: "",
            isFavorite: false
        )
        
        context.insert(location)
        
        let descriptor = FetchDescriptor<Location>()
        let fetchedLocations = try context.fetch(descriptor)
        
        XCTAssertEqual(fetchedLocations.count, 1)
        XCTAssertEqual(fetchedLocations.first?.id, "TestID")
    }
}
