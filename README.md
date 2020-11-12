### Ứng dụng di động tổng hợp thông tin cứu nạn, cứu hộ theo [https://cuuhomientrung.info](https://cuuhomientrung.info):

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

## How to run
- Với android, để chạy đúng môi trường cần chọn main_prod hoặc main_staging

## How to build
### iOS
> flutter build ios --release
- Mở Xcode -> Archive ...

### android
> flutter build apk --flavor production  --split-per-abi
