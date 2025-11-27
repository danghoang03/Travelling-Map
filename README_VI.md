# TravellingMap 🇻🇳

[![English](https://img.shields.io/badge/lang-English-blue.svg)](./README.md)
[![Swift 6.2](https://img.shields.io/badge/Swift-6.2-orange.svg)](https://swift.org)
[![iOS 26.0+](https://img.shields.io/badge/iOS-26.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-7.0+-blue.svg)](https://developer.apple.com/xcode/swiftui/)

**TravellingMap** là ứng dụng iOS được xây dựng bằng **SwiftUI**, giúp người dùng khám phá các địa điểm du lịch nổi tiếng tại Việt Nam. Ứng dụng cung cấp bản đồ tương tác, thông tin chi tiết về địa điểm, tính năng chỉ đường và khả năng lưu trữ dữ liệu offline.

## 🌟 Tính năng chính

* **Bản đồ tương tác**: Khám phá các điểm đến du lịch trên giao diện bản đồ trực quan với các biểu tượng tùy chỉnh.
* **Danh sách địa điểm**: Xem danh sách các điểm du lịch, hỗ trợ tìm kiếm nhanh theo tên hoặc thành phố.
* **Dẫn đường thông minh**:
    * Tính toán lộ trình từ vị trí của bạn đến điểm đến.
    * Hiển thị khoảng cách và thời gian di chuyển dự kiến.
    * Vẽ đường đi (polyline) trực tiếp trên bản đồ ứng dụng.
    * Hỗ trợ mở Apple Maps để điều hướng chi tiết.
* **Yêu thích**: Đánh dấu các địa điểm bạn quan tâm vào danh sách "Yêu thích".
* **Thông tin chi tiết**: Xem hình ảnh, mô tả và liên kết đến Wikipedia cho từng địa điểm.
* **Hoạt động Offline**: Dữ liệu được lưu trữ cục bộ bằng **SwiftData**, đảm bảo ứng dụng hoạt động mượt mà ngay cả khi không có mạng (tự động cập nhật dữ liệu mới mỗi 24 giờ).

## 🎥 Demo

https://github.com/user-attachments/assets/8217b8e6-9330-4768-8819-fd507b2d8ece

## 🛠 Công nghệ sử dụng

* **Ngôn ngữ**: Swift 6+
* **Giao diện**: SwiftUI
* **Kiến trúc**: MVVM (Model-View-ViewModel)
* **Lưu trữ dữ liệu**: [SwiftData](https://developer.apple.com/xcode/swiftdata/) (Cơ sở dữ liệu nội bộ)
* **Networking**: URLSession (Sử dụng Concurrency Async/Await)
* **Bản đồ**: MapKit & CoreLocation
* **Quản lý trạng thái**: Observation Framework (`@Observable`)
* **Thư viện bên thứ 3**:
    * [Kingfisher](https://github.com/onevcat/Kingfisher) (Tải và cache hình ảnh)

## 📂 Kiến trúc

Dự án tuân theo mô hình kiến trúc MVVM:

* **Models**: Định nghĩa dữ liệu (`Location`, `LocationDTO`) và mô hình cơ sở dữ liệu.
* **Views**: Các màn hình SwiftUI (`LocationsView`, `LocationDetailView`, `RouteView`, v.v.).
* **ViewModels**: Xử lý logic nghiệp vụ và trạng thái (`LocationsViewModel`).
* **DataServices**: Xử lý gọi API (`LocationsDataService`) và quản lý quyền vị trí (`LocationManager`).

## 🚀 Cài đặt và Chạy ứng dụng

### Yêu cầu
* Xcode 15.0 trở lên.
* iOS 17.0 trở lên (do sử dụng SwiftData và Observation macro).

### Hướng dẫn cài đặt

1.  **Clone dự án về máy**:
    ```bash
    git clone https://github.com/danghoang03/Travelling-Map.git
    ```
2.  **Mở dự án**:
    Nhấp đúp vào file `TravellingMap.xcodeproj`.
3.  **Cài đặt thư viện**:
    Xcode sẽ tự động tải thư viện Kingfisher qua Swift Package Manager. Nếu không, vào menu `File > Packages > Resolve Package Versions`.
4.  **Chạy ứng dụng**:
    Chọn thiết bị giả lập (Simulator) hoặc thiết bị thật và nhấn `Cmd + R`.

> **Lưu ý**: Để kiểm tra tính năng chỉ đường và định vị trên Simulator, bạn cần giả lập vị trí thông qua menu `Features > Location` của Simulator.

## 🧪 Kiểm thử (Testing)

Dự án đi kèm với bộ Unit Test đầy đủ để đảm bảo tính ổn định và chính xác của các chức năng quan trọng.

* **Target kiểm thử**: `TravellingMapTests`
* **Phạm vi kiểm thử**:
    * **ViewModels** (`LocationsViewModelTests`): Kiểm tra logic lọc dữ liệu, bao gồm tìm kiếm (theo tên/thành phố) và bộ lọc "Yêu thích".
    * **Models** (`LocationDTOTests`): Đảm bảo việc giải mã JSON hoạt động đúng với dữ liệu hợp lệ/không hợp lệ và chuyển đổi đúng từ DTO sang Model.
    * **Lưu trữ dữ liệu** (`DataServiceTests`): Kiểm tra khả năng lưu và truy xuất dữ liệu địa điểm bằng SwiftData.

### Cách chạy kiểm thử
1.  Mở dự án trong Xcode.
2.  Chọn scheme `TravellingMap`.
3.  Nhấn tổ hợp phím **Cmd + U** hoặc chọn menu **Product > Test**.
4.  Xem kết quả chi tiết trong tab Test Navigator (Cmd + 6).
