//
//  LocationMapAnnotationView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 20/11/25.
//

import SwiftUI

struct LocationMapAnnotationView: View, Equatable {
    let accentColor = Color.accentColor
    let locationId: String
    let isSelected: Bool
    @State private var scale: CGFloat = 0.7
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(accentColor)
                .cornerRadius(36)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(accentColor)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
        .scaleEffect(scale)
        .onAppear {
            scale = isSelected ? 1.0 : 0.7
        }
        .onChange(of: isSelected) { oldValue, newValue in
            withAnimation(.default) {
                scale = newValue ? 1.0 : 0.7
            }
        }
    }
    
    static func == (lhs: LocationMapAnnotationView, rhs: LocationMapAnnotationView) -> Bool {
        lhs.locationId == rhs.locationId && lhs.isSelected == rhs.isSelected
    }
}

#Preview {
    LocationMapAnnotationView(locationId: "Preview", isSelected: true)
}
