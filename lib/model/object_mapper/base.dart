import 'package:chmt/model/model.dart';

class BaseResponse {
  int count;
  String next, previous;
  List results;

  BaseResponse({this.results});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    results = json['results'];
  }

  List<HouseHold> get houseHolds =>
      results.map((e) => HouseHold.fromJson(e)).toList();

  List<Province> get provinceList =>
      results.map((e) => Province.fromJson(e)).toList();

  List<District> get districtList =>
      results.map((e) => District.fromJson(e)).toList();

  List<Commune> get communeList =>
      results.map((e) => Commune.fromJson(e)).toList();

  List<Rescuer> get rescuerList =>
      results.map((e) => Rescuer.fromJson(e)).toList();
}
