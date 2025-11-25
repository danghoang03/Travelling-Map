//
//  LocationDetailView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 20/11/25.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @Bindable var location: Location
    @Environment(LocationsViewModel.self) var vm
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
        .overlay(favoriteButton, alignment: .topTrailing)
    }
}

extension LocationDetailView {
    private var imageSection: some View {
        TabView {
            ForEach(location.imageURLs, id: \.self) { imageURL in
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                    .containerRelativeFrame(.horizontal)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.desc)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let url = URL(string: location.link) {
                Link("Read more on Wikipedia", destination: url)
                    .font(.headline)
            }
        }
    }
    
    private var mapLayer: some View {
        let position = MapCameraPosition.region(MKCoordinateRegion(
            center: location.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        return Map(position: .constant(position)) {
            Annotation(location.name, coordinate: location.coordinates) {
                LocationMapAnnotationView(locationId: location.id, isSelected: true)
                    .shadow(radius: 10)
            }
        }
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
    }
    
    private var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
        }
        .padding()
    }
    
    private var favoriteButton: some View {
        Button {
            withAnimation(.snappy) {
                location.isFavorite.toggle()
            }
        } label: {
            Image(systemName: location.isFavorite ? "heart.fill" : "heart")
                .font(.title2)
                .padding(16)
                .foregroundColor(location.isFavorite ? .red : .primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
        }
        .padding()
    }
}

#Preview {
    let location = Location(
        id: "Dinh Độc LậpTP.HCM",
        name: "Dinh Độc Lập",
        cityName: "TP.HCM",
        latitude: 10.77717336,
        longitude: 106.69533428208155,
        desc: "Dinh Độc Lập là một tòa dinh thự tại Thành phố Hồ Chí Minh, từng là nơi ở và làm việc của Tổng thống Việt Nam Cộng hòa trước Sự kiện 30 tháng 4 năm 1975. Hiện nay, Dinh Độc Lập đã được Chính phủ Việt Nam xếp hạng là di tích quốc gia đặc biệt. Cơ quan quản lý di tích văn hoá Dinh Độc Lập có tên là Hội trường Thống Nhất thuộc Văn phòng Chính phủ.",
        imageURLs: [
            "https://images.unsplash.com/photo-1592114714621-ccc6cacad26b?q=80&w=500&h=500",
            "https://images.unsplash.com/photo-1592114716576-0e4a1c6ba02d?q=80&w=500&h=500"
        ],
        link: "https://vi.wikipedia.org/wiki/Dinh_%C4%90%E1%BB%99c_L%E1%BA%ADp",
        isFavorite: true
    )
    return LocationDetailView(location: location)
        .environment(LocationsViewModel())
}
