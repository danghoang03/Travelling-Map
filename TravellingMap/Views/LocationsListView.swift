//
//  LocationsListView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 19/11/25.
//

import SwiftUI

struct LocationsListView: View {
    @Environment(LocationsViewModel.self) var vm
    
    var body: some View {
        List {
            ForEach(vm.locations) { location in
                listRowView(location: location)
                    .padding(.vertical, 4)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

extension LocationsListView {
    private func listRowView(location: Location) -> some View {
        HStack {
            if let image = location.imageNames.first {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                Text(location.cityName)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    LocationsListView()
        .environment(LocationsViewModel())
}
