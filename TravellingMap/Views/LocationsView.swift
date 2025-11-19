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
        }
    }
}

#Preview {
    LocationsView()
        .environment(LocationsViewModel())
}
