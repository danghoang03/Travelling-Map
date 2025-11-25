//
//  LocationsListView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//

import SwiftUI
import Kingfisher

struct LocationsListView: View {
    @Environment(LocationsViewModel.self) var vm
    @Binding var showBottomPanel: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            locationList
        }
    }
}

extension LocationsListView {
    private func listRowView(location: Location) -> some View {
        HStack {
            if let imageURL = location.imageURLs.first, let url = URL(string: imageURL) {
                    KFImage(url)
                        .placeholder {
                        ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(location.cityName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
    }
    
    private var searchBar: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Nhập tên địa điểm...", text: Bindable(vm).searchText)
                    .textFieldStyle(.plain)
                
                if !vm.searchText.isEmpty {
                    Button(action: { vm.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Toggle(isOn: Bindable(vm).showFavoritesOnly) {
                Label("Địa điểm yêu thích", systemImage: "heart.fill")
                        .foregroundColor(.red)
                }
                .toggleStyle(SwitchToggleStyle(tint: .red))
                .padding(.horizontal, 4)
        }
    }
    
    private var locationList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.filteredLocations) { location in
                    Button {
                        if vm.route != nil { vm.clearRoute() }
                        showBottomPanel = true
                        vm.showNextLocation(location: location)
                    } label: {
                        listRowView(location: location)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    Divider()
                        .padding(.leading, 60)
                }
            }
        }
        .frame(height: 300)
        .background(Color.clear)
    }
}

#Preview {
    LocationsListView(showBottomPanel: .constant(true))
        .environment(LocationsViewModel())
}
