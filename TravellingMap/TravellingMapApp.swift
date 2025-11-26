//
//  TravellingMapApp.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//
// MARK: - App Entry Point
/// Main app structure conforming to SwiftUI App protocol.
/// Sets up SwiftData container and provides ViewModel to environment.

import SwiftUI
import SwiftData

@main
struct TravellingMapApp: App {
    @State private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environment(vm) // Inject ViewModel to environment
        }
        .modelContainer(for: Location.self) // SwiftData container setup
    }
}
