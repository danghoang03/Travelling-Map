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
            mapLayer
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                .padding()
                Spacer()  
                locationPreview
                
            }
        }
        .sheet(item: Bindable(vm).sheetLocation, onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
    }
}

extension LocationsView {
    private var headerTitle: String {
        let name = vm.mapLocation?.name ?? ""
        let cityName = vm.mapLocation?.cityName ?? ""
        return name + ", " + cityName
    }
    private var header: some View {
        VStack {
            Button(action: vm.toggleLocationsList) {
                Text(headerTitle)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundStyle(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                    }
            }
            .buttonStyle(.plain)
            if vm.showLocationsList {
                LocationsListView()
                    .padding()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        let selectedId = vm.mapLocation?.id
        return Map(position: Bindable(vm).position) {
            ForEach(vm.locations) { location in
                Annotation(location.name, coordinate: location.coordinates) {
                    LocationMapAnnotationView(locationId: location.id, isSelected: location.id == selectedId)
                        .equatable()
                        .onTapGesture {
                            vm.showNextLocation(location: location)
                        }
                }
            }
        }
    }
    
    private var locationPreview: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}

    

#Preview {
    LocationsView()
        .environment(LocationsViewModel())
}
