//
//  LocationsListView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//

import SwiftUI

struct LocationsListView: View {
    @Environment(LocationsViewModel.self) var vm
    @Binding var displayPreview: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.locations) { location in
                    Button {
                        displayPreview = true
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
        .frame(height: 250)
        .background(Color.clear)
    }
}

extension LocationsListView {
    private func listRowView(location: Location) -> some View {
        HStack {
            if let imageURL = location.imageURLs.first {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
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
}

#Preview {
    LocationsListView(displayPreview: .constant(true))
        .environment(LocationsViewModel())
}
