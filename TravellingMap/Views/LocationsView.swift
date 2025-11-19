//
//  LocationsView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on  19/11/25.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    @Environment(LocationsViewModel.self) var vm
    
    var body: some View {
        ZStack {
            Map(position: Bindable(vm).position)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                .padding()
                    
                Spacer()
            }
        }
    }
}

extension LocationsView {
    private var header: some View {
        VStack {
            Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(.primary)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 15)
        .overlay(alignment: .leading) {
            Image(systemName: "arrow.down")
                .font(.headline)
                .foregroundStyle(.primary)
                .padding()
        }
    }
}

    

#Preview {
    LocationsView()
        .environment(LocationsViewModel())
}
