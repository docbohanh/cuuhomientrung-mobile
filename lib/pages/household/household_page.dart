import 'dart:async';

import 'package:chmt/helper/search_box.dart';
import 'package:chmt/helper/tab_header.dart';
import 'package:chmt/model/model.dart';
import 'package:chmt/pages/household/collapse.dart';
import 'package:chmt/utils/utility.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import 'house_hold_item.dart';
import 'household_vm.dart';

enum Address { province, district, commune }

extension Location on Address {
  String get location {
    switch (this) {
      case Address.province:
        return r'tỉnh';
      case Address.district:
        return r'huyện';
      case Address.commune:
        return r'xã';
      default:
        return '';
    }
  }
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HouseHoldPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HouseHoldPage();
}

class _HouseHoldPage extends State<HouseHoldPage>
    with TickerProviderStateMixin {
  Animation animationIn, animationOut;

  AnimationController _collapseAnimationController;

  bool get isExpanded =>
      _collapseAnimationController.status == AnimationStatus.completed;

  AnimationController animationController;
  ScrollController _scrollController = ScrollController();
  var searchEditingCtl = TextEditingController(text: '');

  var nameEditingCtl = TextEditingController(text: '');
  var phoneEditingCtl = TextEditingController(text: '');
  var locationEditingCtl = TextEditingController(text: '');

  final viewModel = HouseHoldViewModel();

  final List<int> allStatus = [0, 1, 2, 3, 4, 5, 6, 7, 8];

  @override
  void initState() {
    _collapseAnimationController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: Duration(milliseconds: 300),
    );
    animationIn = CurvedAnimation(
      parent: _collapseAnimationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    animationOut = CurvedAnimation(
      parent: _collapseAnimationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    _initAnimation();

    super.initState();

    viewModel.getHouseHoldList();

    viewModel.refreshStream.listen((e) => _reload());
    viewModel.houseHoldStream.listen((e) {
      setState(() {
        houseHoldCount = e.length.toString();
        if (isExpanded) {
          _toggleExpanded();
        }
      });
    });
  }

  void _toggleExpanded() {
    if (isExpanded) {
      _collapseAnimationController.reverse();
    } else {
      _collapseAnimationController.forward();
    }
  }

  void _reload() {
    viewModel.reset();
    _refresh();
  }

  void _refresh() {
    _scrollController
        .animateTo(0.0,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 300))
        .then((value) {
      animationController.reverse();
      viewModel.getHouseHoldList();
    });
  }

  void _initAnimation() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  // void _querySubmitted(String query) {
  //   List<HouseHold> result = List<HouseHold>();
  //
  //   if (query.isEmpty) {
  //     result = viewModel.houseHoldList;
  //   } else {
  //     result = viewModel.houseHoldList.where((e) {
  //       return e.searchText.contains(removeDiacritics(query).toLowerCase());
  //     }).toList();
  //   }
  //
  //   viewModel.houseHoldChanged(result);
  // }

  void showMessage({String text = r'Đang cập nhật'}) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),
      ),
    ));
  }

  void _updateHouseHoldStatus(HouseHold item) async {
    final status = await statusChange(allStatus);

    bool allowUpdateStatus = false;

    void update() {
      var newItem = item;
      newItem.status = status;
      newItem.setUpdateTime(DateTime.now());

      logger.info(newItem.toJson());

      Utility.showLoading(context, r'Đang thực hiện');
      viewModel.repo.updateHouseHold(item: newItem).then((value) {
        Navigator.pop(context);
        showMessage(text: r'Cập nhật trạng thái thành công');
        setState(() => item.status = status);
      }).catchError((e) {
        logger.info(e);
        Navigator.pop(context);
        showMessage(text: r'Đã xảy ra lỗi. Vui lòng thử lại');
      });
    }

    void notPermission() {
      if (allowUpdateStatus) {
        update();
      } else {
        showMessage(text: r'Not permission');
      }
    }

    if (status != null) {
      Utility.showConfirmDialog(
        context,
        message: r'Bạn có chắc muốn cập nhật trạng thái không?',
        onPressedOK: notPermission,
      );
    }
  }

  void _deleteHouseHold(HouseHold item) async {
    void delete() {
      logger.info(item.toJson());

      showMessage(text: r'Vui lòng thực hiện chức năng này trên web');

      // Utility.showLoading(context, r'Đang thực hiện');
      // viewModel.repo.updateHouseHold(item: item).then((value) {
      //   Navigator.pop(context);
      //   showMessage(text: r'Đã xóa');
      //   List<HouseHold> list = viewModel.houseHoldList;
      //   list.removeWhere((e) => e.id == item.id);
      //   viewModel.houseHoldChanged(list);
      // }).catchError((e) {
      //   logger.info(e);
      //   Navigator.pop(context);
      //   showMessage(text: r'Đã xảy ra lỗi. Vui lòng thử lại');
      // });
    }

    Utility.showConfirmDialog(
      context,
      message: r'Bạn có chắc muốn xóa trường hợp này không?',
      onPressedOK: delete,
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () => Utility.hideKeyboardOf(context),
          child: Column(
            children: <Widget>[
              Expanded(
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return SizedBox();
                          },
                          childCount: 1,
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: ContestTabHeader(
                            height: 50,
                            child: Container(
                              color: Color(0xFFFEFEFE),
                              child: SearchBox(
                                cursorColor: Color(0xFF01477f),
                                textColor: Color(0xFF01477f),
                                controller: searchEditingCtl,
                                onChanged: (q) {},
                                onSubmitted: (q) =>
                                    viewModel.searchHouseHoldList(query: q),
                              ),
                            )),
                      ),
                    ];
                  },
                  body: StreamBuilder<List<HouseHold>>(
                    stream: viewModel.houseHoldStream,
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData) {
                        return Utility.centerLoadingIndicator();
                      }

                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        padding: EdgeInsets.only(top: 4, bottom: 80),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var count = snapshot.data.length;
                          var animation = Tween(begin: 0.2, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          animationController.forward();
                          var hh = snapshot.data[index];
                          var address = viewModel.getLandmark(hh);

                          return HouseHoldItemView(
                            callback: () {},
                            phoneCallback: () => Utility.launchURL(
                              context,
                              url: hh.phoneCall,
                              errorMessage: r'Số điện thoại không hợp lệ',
                            ),
                            statusCallback: () => _updateHouseHoldStatus(hh),
                            deleteCallback: () => _deleteHouseHold(hh),
                            item: hh,
                            address: address,
                            animation: animation,
                            animationController: animationController,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: () => _toggleExpanded(),
            child: Container(
              width: 42,
              height: 49,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                  ),
                ],
                color: Colors.blue,
              ),
              child: Center(
                child: Icon(Icons.filter_alt_outlined, color: Colors.white),
              ),
            ),
          ),
          top: 0,
          left: 0,
        ),
        Positioned(
          child: CollapseAnimation(
            animation: isExpanded ? animationOut : animationIn,
            child: Container(
              child: _filterBar(),
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterBar() {
    return GFButtonBar(
      alignment: WrapAlignment.start,
      children: [
        GFButton(
          padding: EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => _refresh(),
          child: Text(
            r"LỌC",
            style: GoogleFonts.merriweather(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          color: Color(0xFF0b457c),
          size: GFSize.SMALL,
        ),
        GFButton(
          padding: EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => _selectAddress(Address.province),
          child: StreamBuilder<Province>(
            stream: viewModel.selectedProvinceStream,
            builder: (ctx, snapshot) {
              var text = r"Tỉnh";
              if (snapshot.hasData) text = snapshot.data.name;
              return Text('$text ');
            },
          ),
          icon: Icon(
            Icons.location_on,
            size: 16,
            color: Colors.white,
          ),
          color: Colors.blue,
          size: GFSize.SMALL,
        ),
        GFButton(
          padding: EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => _selectAddress(Address.district),
          child: StreamBuilder<District>(
            stream: viewModel.selectedDistrictStream,
            builder: (ctx, snapshot) {
              var text = r"Huyện";
              if (snapshot.hasData) text = snapshot.data.name;
              return Text('$text ');
            },
          ),
          icon: Icon(
            Icons.location_on,
            size: 16,
            color: Colors.white,
          ),
          color: Colors.blue,
          size: GFSize.SMALL,
        ),
        GFButton(
          padding: EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => _selectAddress(Address.commune),
          child: StreamBuilder<Commune>(
            stream: viewModel.selectedCommuneStream,
            builder: (ctx, snapshot) {
              var text = r"Xã";
              if (snapshot.hasData) text = snapshot.data.name;
              return Text('$text ');
            },
          ),
          icon: Icon(
            Icons.location_on,
            size: 16,
            color: Colors.white,
          ),
          color: Colors.blue,
          size: GFSize.SMALL,
        ),
        GFButton(
          padding: EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => _selectStatus(),
          child: StreamBuilder<int>(
            stream: viewModel.statusStream,
            builder: (ctx, snapshot) {
              var text = r"Trạng thái cứu hộ";
              if (snapshot.hasData) text = snapshot.data.statusString;
              return Text('$text ');
            },
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          color: Colors.blue,
          size: GFSize.SMALL,
        ),
        GFButton(
          padding: EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => _toggleExpanded(),
          child: Text('Ẩn'),
          color: Color(0xFF0b457c),
          size: GFSize.SMALL,
        ),
      ],
    );
  }

  void _selectAddress(Address type) async {
    var list = List<AddressItem>();
    switch (type) {
      case Address.province:
        list = viewModel.provinceList;
        break;
      case Address.district:
        list = viewModel.districtList;
        break;
      case Address.commune:
        list = viewModel.communeList;
        break;
      default:
        break;
    }

    if (list.isEmpty) return;

    final address = await showDialog<AddressItem>(
        context: context,
        builder: (ctx) {
          var textColor = Color(0xFF01477f);

          final query = BehaviorSubject<String>();
          var textField = TextField(
            cursorColor: Color(0xFF01477f),
            textAlign: TextAlign.center,
            decoration:
                InputDecoration(hintText: r'Chọn ' + '${type.location}'),
            onChanged: query.sink.add,
          );

          return StreamBuilder<String>(
            stream: query.stream,
            builder: (ctx, snapshot) {
              var address = list;
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                var q = removeDiacritics(snapshot.data.toLowerCase());
                address = address
                    .where((e) =>
                        removeDiacritics(e.name).toLowerCase().contains(q))
                    .toList();
              }

              return SimpleDialog(
                title: textField,
                children: address.map((d) {
                  return Column(
                    children: <Widget>[
                      Divider(height: 0.7),
                      Container(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, d);
                              query.close();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Center(
                                child: Text(
                                  '${d.name}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(height: 0.7),
                    ],
                  );
                }).toList(),
              );
            },
          );
        });

    if (address != null) {
      switch (type) {
        case Address.province:
          viewModel.selectedProvinceChanged(address);
          break;
        case Address.district:
          viewModel.selectedDistrictChanged(address);
          break;
        case Address.commune:
          viewModel.selectedCommuneChanged(address);
          break;
        default:
          break;
      }
      _refresh();
    }
  }

  Future<int> statusChange(List<int> list) async {
    return await showDialog<int>(
        context: context,
        builder: (ctx) {
          var textColor = Color(0xFF01477f);

          return SimpleDialog(
            title: Text(
              r'Chọn trạng thái',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
              ),
            ),
            children: list.map((d) {
              return Column(
                children: <Widget>[
                  Divider(height: 0.7),
                  Container(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context, d),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                          child: Center(
                            child: Text(
                              '${d.statusString}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 0.7),
                ],
              );
            }).toList(),
          );
        });
  }

  void _selectStatus() async {
    var status = await statusChange([-1] + allStatus);

    if (status != null) {
      if (status == -1) status = null;
      viewModel.statusChanged(status);
      _refresh();
    }
  }

  var houseHoldCount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            houseHoldCount.isNotEmpty
                ? '$houseHoldCount ' + r'trường hợp'
                : r'Cứu hộ miền Trung',
            style: GoogleFonts.openSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Tooltip(
            message: r'Nạp lại',
            child: IconButton(
              icon: Icon(Icons.replay),
              onPressed: () {
                Utility.hideKeyboardOf(context);
                searchEditingCtl.clear();
                _reload();
              },
            ),
          )
        ],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nameEditingCtl.clear();
          phoneEditingCtl.clear();
          locationEditingCtl.clear();

          showDialog<String>(
            context: context,
            builder: (ctx) {
              var textColor = Color(0xFF0b457c);

              return SimpleDialog(
                title: Text(
                  r'Tìm kiếm nâng cao',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,),
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Container(
                        child: Column(
                          children: [
                            SearchBox(
                              showPrefixIcon: false,
                              cursorColor: Color(0xFF01477f),
                              textColor: Color(0xFF01477f),
                              controller: nameEditingCtl,
                              onChanged: (q) {},
                              onSubmitted: (q) {},
                              hintText: 'Hộ dân',
                            ),
                            SearchBox(
                              showPrefixIcon: false,
                              cursorColor: Color(0xFF01477f),
                              textColor: Color(0xFF01477f),
                              controller: phoneEditingCtl,
                              onChanged: (q) {},
                              onSubmitted: (q) {},
                              hintText: r'Số điện thoại',
                            ),
                            SearchBox(
                              showPrefixIcon: false,
                              cursorColor: Color(0xFF01477f),
                              textColor: Color(0xFF01477f),
                              controller: locationEditingCtl,
                              onChanged: (q) {},
                              onSubmitted: (q) {},
                              hintText: 'Địa chỉ',
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 130,
                        child: Center(
                          child: RaisedButton(
                            color: textColor,
                            onPressed: () {
                              Navigator.pop(context);
                              viewModel.advanceSearchHouseHoldList(
                                name: nameEditingCtl.text,
                                phone: phoneEditingCtl.text,
                                location: locationEditingCtl.text
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                Text(r'Tìm kiếm',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          );
        },
        tooltip: r'Tìm kiếm nâng cao',
        child: Icon(Icons.flip),
      ),
    );
  }
}
