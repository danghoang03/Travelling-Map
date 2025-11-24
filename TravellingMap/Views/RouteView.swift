//
//  RouteView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 24/11/25.
//

import SwiftUI
import MapKit

struct RouteView: View {
    @Environment(LocationsViewModel.self) var vm
    let route: MKRoute
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Đường đi dự kiến")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: 16) {
                        Label(distanceString, systemImage: "car.fill")
                            .font(.headline)
                        Label(timeString, systemImage: "clock")
                            .font(.headline)
                    }
                }
                Spacer()
                clearRouteButton
            }
            openInMapsButton
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 15).fill(.ultraThinMaterial))
    }
}

extension RouteView {
    private var distanceString: String {
        let km = route.distance / 1000
        return String(format: "%.1f km", km)
    }
    
    private var timeString: String {
        let minutes = Int(route.expectedTravelTime / 60)
        return "\(minutes) phút"
    }
    
    private var clearRouteButton: some View {
        Button {
            withAnimation {
                vm.clearRoute()
            }
        } label: {
            Image(systemName: "xmark")
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
    
    private var openInMapsButton: some View {
        Button {
            vm.openNavigationApp()
        } label: {
            Text("Bắt đầu đi")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    RouteView(route: MKRoute())
        .environment(LocationsViewModel())
        .padding()
}
