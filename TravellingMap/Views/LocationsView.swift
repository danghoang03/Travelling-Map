//
//  LocationsView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on  19/11/25.
//

import SwiftUI
import MapKit
import SwiftData

struct LocationsView: View {
    @Environment(LocationsViewModel.self) var vm
    @Environment(\.modelContext) var context
    @Query(sort: \Location.cityName) var locations: [Location]
    @State var showBottomPanel: Bool = false
    
    var body: some View {
        ZStack {
            mapLayer
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                .padding()
                Spacer()
                userLocationButton
                if showBottomPanel {
                    bottomPanel
                }
                
            }
        }
        .sheet(item: Bindable(vm).sheetLocation, onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
        .alert("Cần quyền truy cập vị trí", isPresented: Bindable(vm).showLocationDeniedAlert) {
            Button("Hủy", role: .cancel) { }
            Button("Mở Cài đặt") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        } message: {
            Text("Vui lòng cấp quyền truy cập vị trí trong Cài đặt để ứng dụng có thể hiển thị vị trí của bạn trên bản đồ.")
        }
        .task {
            await LocationsDataService.shared.fetchAndSaveData(context: context)
        }
        .onChange(of: vm.locationManager.authorizationStatus) { oldValue, newValue in
            vm.checkLocationAuthorization()
        }
        .onChange(of: locations, initial: true) { oldValue, newValue in
            vm.locations = newValue
        }
        .onChange(of: vm.mapLocation) { _, newValue in
            withAnimation(.easeInOut) {
                showBottomPanel = newValue != nil
            }
        }
        .onChange(of: showBottomPanel) { _, newValue in
            if !newValue && vm.mapLocation != nil {
                vm.mapLocation = nil
            }
        }
    }
}

extension LocationsView {
    private var headerTitle: String {
        if let location = vm.mapLocation {
            return location.name + ", " + location.cityName
        }
        let status = vm.locationManager.authorizationStatus
        if status == .denied || status == .restricted {
            return "Điểm đến du lịch"
        }
        return "Vị trí của bạn"
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
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if vm.showLocationsList {
                LocationsListView(showBottomPanel: $showBottomPanel)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.5), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        let selectedId = vm.mapLocation?.id
        return Map(position: Bindable(vm).position) {
            UserAnnotation()
            ForEach(vm.locations) { location in
                Annotation(location.name, coordinate: location.coordinates) {
                    LocationMapAnnotationView(locationId: location.id, isSelected: location.id == selectedId)
                        .equatable()
                        .onTapGesture {
                            if vm.route != nil { vm.clearRoute() }
                            showBottomPanel = true
                            vm.showNextLocation(location: location)
                        }
                }
            }
            if let route = vm.route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 6)
            }
        }
    }
    
    private var bottomPanel: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    if let route = vm.route, vm.routeDestination == location {
                        RouteView(route: route)
                            .shadow(color: Color.black.opacity(0.3), radius: 20)
                            .padding()
                            .transition(.move(edge: .bottom))
                    } else {
                        LocationPreviewView(showBottomPanel: $showBottomPanel,location: location)
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
    
    private var userLocationButton: some View {
        HStack {
            Spacer()
            Button(action: {
                if vm.route != nil { vm.clearRoute() }
                vm.centerOnUserLocation()
            }) {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .padding(10)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.trailing, 20)
        }
    }
}

    

#Preview {
    LocationsView()
        .environment(LocationsViewModel())
}
