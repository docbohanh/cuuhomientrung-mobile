import 'package:chmt/model/model.dart';
import 'package:chmt/model/object_mapper/province.dart';
import 'package:chmt/pages/splash/loadapp_vm.dart';
import 'package:chmt/utils/global.dart';
import 'package:chmt/utils/utility.dart';
import 'package:rxdart/rxdart.dart';

class HouseHoldViewModel extends LoadAppViewModel {
  final _houseHold = BehaviorSubject<List<HouseHold>>();
  final _refresh = BehaviorSubject<bool>();

  final _selectedProvince = BehaviorSubject<Province>();
  final _selectedDistrict = BehaviorSubject<District>();
  final _selectedCommune = BehaviorSubject<Commune>();

  final _status = BehaviorSubject<int>();

  Stream<int> get statusStream => _status.stream;

  Function(int) get statusChanged => _status.sink.add;

  int get status => _status.value;

  Stream<List<HouseHold>> get houseHoldStream => _houseHold.stream;

  Stream<bool> get refreshStream => _refresh.stream;

  Function(bool) get refreshChanged => _refresh.sink.add;

  Function(List<HouseHold>) get houseHoldChanged => _houseHold.sink.add;

  List<HouseHold> get houseHoldList => _houseHold.value;

  List<District> get districtList {
    if (selectedProvince == null) {
      return [];
    } else {
      return allDistrict
          .where((e) => e.parentID == selectedProvince.id)
          .toList();
    }
  }

  List<Commune> get communeList {
    if (selectedDistrict == null) {
      return [];
    } else {
      return allCommune
          .where((e) => e.parentID == selectedDistrict.id)
          .toList();
    }
  }

  Stream<Commune> get selectedCommuneStream => _selectedCommune.stream;

  Function(Commune) get selectedCommuneChanged => _selectedCommune.sink.add;

  Commune get selectedCommune => _selectedCommune.value;

  Stream<District> get selectedDistrictStream => _selectedDistrict.stream;

  Function(District) get selectedDistrictChanged => _selectedDistrict.sink.add;

  District get selectedDistrict => _selectedDistrict.value;

  Stream<Province> get selectedProvinceStream => _selectedProvince.stream;

  Function(Province) get selectedProvinceChanged => _selectedProvince.sink.add;

  Province get selectedProvince => _selectedProvince.value;

  HouseHoldViewModel() {
    init();

    selectedProvinceStream.listen((event) {
      selectedDistrictChanged(null);
      selectedCommuneChanged(null);
      statusChanged(null);
    });

    selectedDistrictStream.listen((event) {
      selectedCommuneChanged(null);
    });

    // statusChanged(1); /// Lọc mặc định theo hộ cần ứng cứu gấp
  }

  @override
  void init() {
    provinceChanged(AppGlobal.shared.provinceList);
    districtChanged(AppGlobal.shared.districtList);
    communeChanged(AppGlobal.shared.communeList);
  }

  void reset() {
    selectedProvinceChanged(null);
    selectedDistrictChanged(null);
    selectedCommuneChanged(null);
    statusChanged(null);
  }

  void getHouseHoldList() {
    Map<String, dynamic> params = {
      r'tinh': selectedProvince != null ? selectedProvince.id : null,
      r'huyen': selectedDistrict != null ? selectedDistrict.id : null,
      r'xa': selectedCommune != null ? selectedCommune.id : null,
      r'status': status != null ? status : null,
      'limit': 100000,
      'offset': 0
    };

    params.removeWhere((key, value) => value == null);

    repo.getHouseHoldList(params: params).then((value) {
      List<HouseHold> list = value.houseHolds.where((e) => e.isValid).toList();
      list.sort((a, b) => b.updateTime.compareTo(a.updateTime));

      if (selectedProvince != null) {
        list = list.where((e) => e.province == selectedProvince.id).toList();
      }

      if (selectedDistrict != null) {
        list = list.where((e) => e.district == selectedDistrict.id).toList();
      }

      if (selectedCommune != null) {
        list = list.where((e) => e.commune == selectedCommune.id).toList();
      }

      if (status != null) {
        list = list.where((e) => e.status == status).toList();
      }

      houseHoldChanged(list);
    }).catchError((e) {
      logger.info(e);
      houseHoldChanged([]);
    });
  }

  void searchHouseHoldList({String query = ''}) {
    Map<String, dynamic> params = {
      r'search': query,
      'limit': 100000,
      'offset': 0
    };

    params.removeWhere((key, value) => value == null);

    repo.getHouseHoldList(params: params).then((value) => _processList(value)).catchError((e) {
      logger.info(e);
      houseHoldChanged([]);
    });
  }

  void advanceSearchHouseHoldList({String name = '', String phone = '', String location = ''}) {
    Map<String, dynamic> params = {
      'name': name,
      'phone': phone,
      'location': location,
      'limit': 100000,
      'offset': 0
    };

    params.removeWhere((key, value) => value == null);

    repo.getHouseHoldList(params: params).then((value) => _processList(value)).catchError((e) {
      logger.info(e);
      houseHoldChanged([]);
    });
  }
  
  void _processList(BaseResponse value) {
    List<HouseHold> list = value.houseHolds.where((e) => e.isValid).toList();
    list.sort((a, b) => b.updateTime.compareTo(a.updateTime));
    houseHoldChanged(list);
  }

  @override
  void dispose() {
    super.dispose();
    _houseHold.close();
    _refresh.close();
    _selectedProvince.close();
    _selectedDistrict.close();
    _selectedCommune.close();
    _status.close();
  }
}
