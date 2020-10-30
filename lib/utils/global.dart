import 'package:chmt/model/model.dart';

class AppGlobal {
  AppGlobal._();

  static final shared = AppGlobal._();

  static const baseUrl = r'https://cuuhomientrung.info/';

  List<Province> provinceList = [];
  List<District> districtList = [];
  List<Commune> communeList = [];
}