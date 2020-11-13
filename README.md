### Ứng dụng di động tổng hợp thông tin cứu nạn, cứu hộ theo [https://cuuhomientrung.info](https://cuuhomientrung.info)
---
## Feature
- [x] Xem danh sách các hộ cần ứng cứu
- [x] Xem danh sách các đội cứu hộ
- [x] Tìm kiếm theo từ khóa
- [x] Lọc theo địa chỉ
- [x] Reload danh sách
- [x] Bấm vào số số phone được cung cấp để thực hiện cuộc gọi
- [x] Lọc theo các trạng thái cứu hộ


## TODO
- [ ] <s>Cập nhật trạng thái</s>
- [ ] <s>Thêm sửa xóa các đối tượng</s>

Testing
- Google Play Store: [CHMT](https://play.google.com/store/apps/details?id=info.cuuhomientrung.chmt)
- iOS Beta Testflight: [https://testflight.apple.com/join/jMgpk8E3](https://testflight.apple.com/join/jMgpk8E3)

<p align="center">
  <img src="https://user-images.githubusercontent.com/5656118/98765030-b8e42180-240f-11eb-99d3-4894d73fc548.png" width="300" >
  <img src="https://user-images.githubusercontent.com/5656118/98765068-cef1e200-240f-11eb-9e21-681a478ec996.png" width="300" >
</p>

## How to use

- Tạo các file .env như hình dưới, xem thêm [flutter_config](https://pub.dev/packages/flutter_config)
<img src="https://user-images.githubusercontent.com/5656118/99026667-13ab8380-259e-11eb-8aeb-97aa0adb36b0.png" width="300" >

- Nội dung file .env.production:

```
API_URL=https://cuuhomientrung.info/api/
TOKEN=your_token
APP_NAME=CHMT
```

- Để có token vui lòng liên hệ team trên [slack](https://cuuhomientrung.slack.com/), hoặc pm huuthanhla@gmail.com.

- Với iOS, để run staging thì bạn phải tạo thêm schema staging:
<img src="https://user-images.githubusercontent.com/5656118/99027398-b57fa000-259f-11eb-90e9-931cfc308afa.png" width="300" >

- Với Android, bạn chọn file main để chạy tương ứng:
<img src="https://user-images.githubusercontent.com/5656118/99027445-d8aa4f80-259f-11eb-8e80-6eca6791eea0.png" width="300" >

```
[✓] Flutter (Channel stable, 1.22.0, on Mac OS X 10.15.7 19H2, locale en)
    • Flutter version 1.22.0 at /Users/admin/flutter
    • Framework revision d408d302e2 (6 weeks ago), 2020-09-29 11:49:17 -0700
    • Engine revision 5babba6c4d
    • Dart version 2.10.0
```

## How to build

### iOS
> flutter build ios --release
- Mở Xcode -> Archive ...

### android
> flutter build apk --flavor production  --split-per-abi
