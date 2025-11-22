//
//  LocationPreviewView.swift
//  TravellingMap
//
//  Created by Hoàng Minh Hải Đăng on 20/11/25.
//

import SwiftUI

struct LocationPreviewView: View {
    @Environment(LocationsViewModel.self) var vm
    let location: Location
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 16) {
                imageSection
                titleSection
            }
            
            VStack(spacing: 8) {
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension LocationPreviewView {
    private var imageSection: some View {
        ZStack {
            if let imageURL = location.imageURLs.first {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.title2.bold())
            Text(location.cityName)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var learnMoreButton: some View {
        Button {
            vm.sheetLocation = location
        } label: {
            Text("Learn More")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var nextButton: some View {
        Button {
            vm.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
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
        link: "https://vi.wikipedia.org/wiki/Dinh_%C4%90%E1%BB%99c_L%E1%BA%ADp"
    )
    LocationPreviewView(location: location)
        .padding()
        .environment(LocationsViewModel())
}
