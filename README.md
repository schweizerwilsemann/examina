# Examina — Quản lý chi tiêu

App Flutter tiếng Việt, triển khai 4 yêu cầu trong ảnh đề bài. Android, iOS và Windows; giao diện gồm danh sách chi tiêu, chỉnh sửa khoản chi và hộp thoại chọn tiền tệ.

## Chạy dự án

Dự án đã có Flutter **3.47.9 / Dart 3.13.7** tại `.tools/flutter`. SDK này tách biệt với Flutter cũ của máy; VS Code đã được cấu hình trỏ vào SDK của dự án.

```powershell
.\.tools\flutter\bin\flutter.bat pub get
.\.tools\flutter\bin\dart.bat run build_runner build
.\.tools\flutter\bin\flutter.bat run
```

Chạy trên Windows:

```powershell
.\.tools\flutter\bin\flutter.bat run -d windows
```

Nếu chuyển source sang máy khác, cài Flutter stable 3.47 trở lên (Dart 3.13 trở lên), rồi dùng `flutter` và `dart` như bình thường. `.tools/` không đưa vào Git. iOS cần macOS và Xcode để build.

## Chức năng

- Đọc danh sách từ SQLite, sắp xếp ngày chi tiêu mới nhất trước.
- Tạo đúng 5 khoản chi mẫu trong ảnh khi database được tạo lần đầu; không ghi đè dữ liệu khi mở lại app.
- Bấm bút chì để sửa tên, số tiền, danh mục và ngày chi tiêu. Lưu cập nhật SQLite và danh sách; Hủy/quay lại bỏ bản nháp.
- Kiểm tra tên trống, số tiền không hợp lệ, quá 2 chữ số thập phân hoặc vượt giới hạn. Chặn thao tác lưu lặp trong lúc đang ghi.
- Cài đặt VND/USD được lưu bằng `SharedPreferencesAsync` và đọc lại khi khởi động.
- Có trạng thái tải, lỗi, thử lại và hỗ trợ màn hình nhỏ/bàn phím.

**Quy ước tiền tệ:** đề không cung cấp tỷ giá, nên cài đặt VND/USD chỉ đổi đơn vị và định dạng hiển thị, không quy đổi giá trị. Ví dụ `150,000 VND` thành `150,000.00 USD`. Số tiền lưu dạng số nguyên bằng 100 lần giá trị nhập để tránh sai số số thực; chấp nhận dấu phẩy hoặc chấm cho phần thập phân, không nhập dấu phân cách hàng nghìn.

## Kiến trúc MVVM

```text
lib/
  main.dart                         # ProviderScope
  app.dart                          # Theme, ngôn ngữ Việt
  core/app_theme.dart
  models/                           # Expense, ExpenseCategory, Currency
  data/
    local/app_database.dart         # Schema, seed SQLite
    repositories/                   # Truy cập dữ liệu và cài đặt
    providers.dart                  # Dependency injection bằng @Riverpod
  viewmodels/                       # AsyncNotifier sinh bằng Riverpod Generator
  views/                            # Danh sách, form sửa, dialog cài đặt
    widgets/
```

Luồng: View → ViewModel → Repository → SQLite/SharedPreferences. Các file `.g.dart` được sinh bằng `riverpod_generator`, đã có sẵn trong source. Khi sửa provider, chạy lại `dart run build_runner build` hoặc dùng `watch`.

SQLite có bảng `expenses(id, title, amount_minor, category, spent_on)`. Ngày lưu theo `yyyy-MM-dd`, giao diện hiển thị `dd/MM/yyyy`. Trên Android/iOS dùng `sqflite`; Windows dùng `sqflite_common_ffi`, database ở thư mục application support.

## Package đã kiểm tra ngày 02/11/2026

| Package | Phiên bản |
| --- | --- |
| flutter_riverpod | 3.4.3 |
| riverpod_annotation | 4.0.7 |
| riverpod_generator | 4.0.9 |
| sqflite | 2.4.5 |
| sqflite_common_ffi | 2.4.5 |
| shared_preferences | 2.5.6 |
| path_provider | 2.1.6 |
| path | 1.9.1 |
| intl | 0.20.3 |
| flutter_lints | 6.0.0 |
| build_runner | 2.16.2 |

Các dependency trực tiếp dùng bản stable mới nhất từ pub.dev tại thời điểm kiểm tra, ngoại trừ **build_runner**: bản mới nhất `2.17.1` yêu cầu `build >=5.0.0`, nhưng Riverpod Generator `4.0.9` yêu cầu `build <5.0.0`. Vì thế dùng bản tương thích mới nhất `2.16.2`, không dùng dependency override ép phiên bản. Các dependency gián tiếp được Pub chọn theo ràng buộc của SDK/package. `pubspec.lock` giữ chính xác bộ phiên bản đã tải và kiểm tra.

Nguồn: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod), [riverpod_generator](https://pub.dev/packages/riverpod_generator), [sqflite](https://pub.dev/packages/sqflite), [shared_preferences](https://pub.dev/packages/shared_preferences), [build_runner](https://pub.dev/packages/build_runner).

## Kiểm tra và build

```powershell
.\.tools\flutter\bin\dart.bat analyze
.\.tools\flutter\bin\flutter.bat test
.\.tools\flutter\bin\flutter.bat build apk --debug
```

11 bài kiểm thử bao gồm database SQLite thật đóng/mở lại, sắp xếp và lưu các trường; ViewModel lưu tiền tệ qua lần tạo container mới, xử lý lỗi ghi và cập nhật danh sách; thao tác sửa/hủy, kiểm tra dữ liệu nhập, chọn ngày/danh mục, cài đặt tiền tệ, thử lại lỗi đọc và màn hình 320px khi mở bàn phím.

APK debug nằm ở `build/app/outputs/flutter-apk/app-debug.apk`. Bản debug dùng để cài thử; ký phát hành bằng keystore riêng trước khi đưa lên cửa hàng.

Tạo ảnh xem trước từ widget thật và dữ liệu mẫu (script dùng Segoe UI nếu có trên Windows):

```powershell
.\.tools\flutter\bin\flutter.bat test tool/capture_preview.dart
```

Ảnh xuất vào `docs/screenshots/`.
