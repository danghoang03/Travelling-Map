//
//  TravellingMapApp.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//

import SwiftUI
import SwiftData

@main
struct TravellingMapApp: App {
    @State private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environment(vm)
        }
        .modelContainer(for: Location.self)
    }
}
