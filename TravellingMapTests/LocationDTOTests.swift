//
//  LocationDTOTests.swift
//  TravellingMapTests
//
//  Created by Hoàng Minh Hải Đăng on 26/11/25.
//

import XCTest
@testable import TravellingMap

@MainActor
class LocationDTOTests: XCTestCase {
    private let validJSON = """
    {
        "name": "Dinh Độc Lập",
        "cityName": "TP.HCM",
        "latitude": 10.77717336,
        "longitude": 106.69533428208155,
        "description": "Dinh Độc Lập là một tòa dinh thự tại Thành phố Hồ Chí Minh, từng là nơi ở và làm việc của Tổng thống Việt Nam Cộng hòa trước Sự kiện 30 tháng 4 năm 1975. Hiện nay, Dinh Độc Lập đã được Chính phủ Việt Nam xếp hạng là di tích quốc gia đặc biệt. Cơ quan quản lý di tích văn hoá Dinh Độc Lập có tên là Hội trường Thống Nhất thuộc Văn phòng Chính phủ.",
        "imageURLs": [
            "https://images.unsplash.com/photo-1592114714621-ccc6cacad26b?q=80&w=500&h=500",
            "https://images.unsplash.com/photo-1592114716576-0e4a1c6ba02d?q=80&w=500&h=500"
        ],
        "link": "https://vi.wikipedia.org/wiki/Dinh_%C4%90%E1%BB%99c_L%E1%BA%ADp"
    }
    """.data(using: .utf8)!
    
    func testDecodingJSON() {
        do {
            let locationDTO = try JSONDecoder().decode(LocationDTO.self, from: validJSON)
            
            XCTAssertEqual(locationDTO.name, "Dinh Độc Lập")
            XCTAssertEqual(locationDTO.cityName, "TP.HCM")
            XCTAssertEqual(locationDTO.latitude, 10.77717336, accuracy: 0.000001)
            XCTAssertEqual(locationDTO.longitude, 106.69533428208155, accuracy: 0.000001)
            XCTAssertEqual(locationDTO.description, "Dinh Độc Lập là một tòa dinh thự tại Thành phố Hồ Chí Minh, từng là nơi ở và làm việc của Tổng thống Việt Nam Cộng hòa trước Sự kiện 30 tháng 4 năm 1975. Hiện nay, Dinh Độc Lập đã được Chính phủ Việt Nam xếp hạng là di tích quốc gia đặc biệt. Cơ quan quản lý di tích văn hoá Dinh Độc Lập có tên là Hội trường Thống Nhất thuộc Văn phòng Chính phủ.")
            XCTAssertEqual(locationDTO.imageURLs.count, 2)
            XCTAssertEqual(locationDTO.link, "https://vi.wikipedia.org/wiki/Dinh_%C4%90%E1%BB%99c_L%E1%BA%ADp")
        } catch {
            XCTFail("Can't decode JSON: \(error)")
        }
    }
    
    func testDecodingMissingRequiredField() {
        let invalidJSON = """
            {
                "name": "Test",
                "cityName": "Test City"
            }
        """.data(using: .utf8)!
            
            XCTAssertThrowsError(try JSONDecoder().decode(LocationDTO.self, from: invalidJSON))
    }
    
    func testToModelConversion() {
        let locationDTO = LocationDTO(
            name: "Test Location",
            cityName: "Test City",
            latitude: 10.0,
            longitude: 106.0,
            description: "Test Description",
            imageURLs: ["http://test.com/img1.jpg"],
            link: "https://example.com"
        )
            
        let location = locationDTO.toModel()
            
        XCTAssertEqual(location.id, "Test LocationTest City")
        XCTAssertEqual(location.name, locationDTO.name)
        XCTAssertEqual(location.cityName, locationDTO.cityName)
        XCTAssertEqual(location.latitude, locationDTO.latitude)
        XCTAssertEqual(location.longitude, locationDTO.longitude)
        XCTAssertEqual(location.desc, locationDTO.description)
        XCTAssertEqual(location.imageURLs.count, 1)
        XCTAssertEqual(location.imageURLs.first, "http://test.com/img1.jpg")
        XCTAssertFalse(location.isFavorite)
    }
}
