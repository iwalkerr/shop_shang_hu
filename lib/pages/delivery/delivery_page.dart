import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_shang_hu/dao/CustomerDao.dart';
import 'package:shop_shang_hu/dao/PlatformDao.dart';
import 'package:shop_shang_hu/ent/Platformm.dart';
import 'package:shop_shang_hu/utils/StringUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryPage extends StatefulWidget {
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  List house;

  TextEditingController search = TextEditingController();

  // 二级导航数据
  List _subHeaderList = [
    {"id": 1, "title": '栋数  ', "fileds": "floor_", "asc": true},
    {"id": 2, "title": '按单量  ', "fileds": "count_", "asc": true}
  ];
  int _selectHeaderId = 1;

  int all = 0;

  var sort;
  bool rsh = false;
  bool showPlatform = false;
  String pingTai = "全部平台";

  List<Platformm> platformList = List();
  List<Platformm> selectPlatform;

  bool showSearch = false;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    sort = _subHeaderList[0];
    PlatformDao.buyQuery(context).then((value) {
      if (StringUtils.isNotEmpty(value)) {
        value.toList().forEach((val) {
          platformList.add(Platformm(val["platform_name"], val["platform_id"]));
        });
        setState(() {});
      }
    });
    getHouse();
    super.initState();
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showSearch
                  ? Container()
                  : Container(
//                width: 200.w,
                      child: Text('共 $all 个客户'),
                    ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showSearch = true;
                    FocusScope.of(context).requestFocus(focusNode);
                    queryList = List();
                  });
                },
                child: Row(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment.center,
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 160),
                      width: showSearch ? 610.w : 0,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 28.w),
                        // height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28.h),
                          border: Border.all(color: Colors.blue),
                        ),
                        constraints: BoxConstraints(maxHeight: 60.h),
                        // constraints: BoxConstraints(maxHeight: 30),
                        child: TextField(
                            focusNode: focusNode,
                            autofocus: false,
                            maxLines: 1,
                            controller: search,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            //   LengthLimitingTextInputFormatter(4),
                            // ],
                            keyboardType: TextInputType.phone,
                            textAlignVertical: TextAlignVertical.center,
                            // style: TextStyle(fontSize: 32.sp),
                            decoration: InputDecoration(
                              isDense: true,
                              // contentPadding: EdgeInsets.all(0),
                              contentPadding: EdgeInsets.only(left: 26.w, right: 26.w),
                              hintText: 'Enter a nickname',
                              border: InputBorder.none,
                              // border: OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                            onChanged: (val) {
                              // if (StringUtils.isNotEmpty(val) && val.length >= 4) {
                              if (StringUtils.isNotEmpty(val)) {
                                query(val);
                              }
                            }),
                      ),
                    ),
                    showSearch
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                showSearch = !showSearch;
                              });
                              if (showSearch) {
                                FocusScope.of(context).requestFocus(focusNode);
                              } else {
                                search.text = "";
                                focusNode.unfocus();
                              }
                            },
                            child: Container(
                              child: Text(
                                "取消",
                                style: TextStyle(fontSize: 32.sp),
                              ),
                            ),
                          )
                        : Icon(Icons.search)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  _subheader(),
                  platformList != null && platformList.length > 0
                      ? Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: () {
                                if (showPlatform) {
                                  closeP();
                                  setState(() {});
                                } else {
                                  setState(() {
                                    showPlatform = true;
                                  });
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 80.h,
                                    padding: EdgeInsets.only(right: 48.w),
                                    alignment: Alignment.centerRight,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 300.w,
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            pingTai,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.blue, fontSize: 32.sp),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        showPlatform
                                            ? Image.asset(
                                                'images/up.png',
                                                width: 16.w,
                                              )
                                            : Image.asset(
                                                'images/down.png',
                                                width: 16.w,
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        )
                      : Expanded(
                          flex: 1,
                          child: Container(
                            height: 80.h,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
              house != null && house.length > 0
                  ? Expanded(
                      flex: 1,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          house = List();
                          getHouse();
                        },
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return _data(house[index]);
                          },
                          itemCount: house.length,
                        ),
                      ),
                    )
                  : house == null
                      ? Container(
                          alignment: Alignment.center,
                          child: Text("加载中..."),
                        )
                      : Expanded(
                          flex: 1,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              house = List();
                              getHouse();
                            },
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 800.h,
                                  alignment: Alignment.center,
                                  child: Text("没有数据"),
                                );
                              },
                              itemCount: 1,
                            ),
                          ),
                        )
            ],
          ),
          showPlatform
              ? Positioned(
                  top: 80.h,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 12.h, left: 12.h, top: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: Colors.black12, width: 0.5.h)),
                        ),
                        child: Wrap(
                          children: platformList.map((Platformm val) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  val.select = !val.select;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: val.select ? Color(0x192196F3) : Colors.white,
                                        border: Border.all(color: val.select ? Color(0x002196F3) : Color(0x10000000), width: 1.5.w),
                                        borderRadius: BorderRadius.circular(4.w),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                      child: Text(
                                        val.name,
                                        style: TextStyle(
                                          color: val.select ? Colors.blue : Colors.black,
                                        ),
                                      ),
                                    ),
                                    val.select
                                        ? Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Image.asset(
                                              'images/select_d.png',
                                              width: 26.w,
                                            ),
                                          )
                                        : Container(
                                            width: 0,
                                            height: 0,
                                          )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  selectPlatform = List();
                                  showPlatform = false;
                                  platformList.forEach((element) => element.select = false);
                                  getHouse();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 24.h),
                                  padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 6.h, bottom: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.w),
                                  ),
                                  child: Text(
                                    "重置",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  selectPlatform = List();
                                  showPlatform = false;
                                  platformList.forEach((e) {
                                    if (e.select) {
                                      selectPlatform.add(e);
                                    }
                                  });
                                  getHouse();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 24.h),
                                  padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 6.h, bottom: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4.w),
                                  ),
                                  child: Text(
                                    "完成",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            closeP();
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          showSearch
              ? Positioned(
                  top: 0.h,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showSearch = false;
                        search.text = "";
                        focusNode.unfocus();
                      });
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.w), boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0.0, 1.w), blurRadius: 3.0, spreadRadius: 1.0)]),
                              child: Column(
                                children: queryList.map((e) => getItem(e)).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  List queryList = List();

  query(number) {
    CustomerDao.queryo(context, number).then((value) async {
      if (StringUtils.isNotEmpty(value) && value.toString().toLowerCase() != "操作成功") {
        queryList = value.toList();
      } else {
        queryList = List();
      }
      setState(() {});
    });
  }

  Widget getItem(item) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: queryList.indexWhere((element) => item == element) == queryList.length - 1
            ? BoxDecoration()
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.blue)),
              ),
        width: 640.w,
        margin: EdgeInsets.only(left: 30.w, right: 30.w),
        padding: EdgeInsets.only(top: 50.h, bottom: 50.h, left: 20.w, right: 20.w),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: 30.w,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        '楼栋号 :',
                        style: TextStyle(fontSize: 32.sp),
                      ),
                      Text(
                        ' ${item["door"] ?? ""} ',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 32.sp, color: Colors.orange),
                      )
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          '昵   称 : ',
                          style: TextStyle(fontSize: 32.sp),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              ' ${item["nickname"] ?? ""}',
                              style: TextStyle(fontSize: 32.sp),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          '电   话 : ${item["phone"] ?? ""}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 32.sp),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              String url = 'tel:${item["phone"]}';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw '不能进行访问，异常';
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              height: 50.h,
                              // color: Colors.red,
                              child: Image.asset("images/拨打电话.png"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    '备   注 : ${item["remark"] ?? ""}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 32.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getHouse() {
    if (!rsh) {
      rsh = true;
      all = 0;
      String platform = "0";
      if (selectPlatform != null && selectPlatform.length > 0) {
        List<int> ids = List();
        List<String> names = List();
        selectPlatform.forEach((e) => ids.add(e.platformId));
        selectPlatform.forEach((e) => names.add(e.name));
        platform = ids.join(",");
        pingTai = names.join("|");
      } else {
        pingTai = "全部平台";
      }
      CustomerDao.orderList(context, sort["fileds"] + (sort["asc"] ? "asc" : "desc"), platform).then((value) {
        if (StringUtils.isNotEmpty(value)) {
          all = value["toal"] ?? 0;
        } else {
          all = 0;
        }
        if (StringUtils.isNotEmpty(value) && StringUtils.isNotEmpty(value["info_list"])) {
          house = value["info_list"].toList();
//          house.add(value["other"]);
          house.removeWhere((element) => element["count"] == 0);
        } else {
          house = List();
        }
      }).whenComplete(() {
        rsh = false;
        setState(() {});
      });
    }
  }

  Widget _data(data) {
    return GestureDetector(
      onTap: () {
        data["platformId"] = "0";
        if (selectPlatform != null && selectPlatform.length > 0) {
          List<int> ids = List();
          selectPlatform.forEach((e) => ids.add(e.platformId));
          data["platformId"] = ids.join(",");
        }
        Navigator.pushNamed(context, '/subContent', arguments: data).then((value) {
          getHouse();
        });
      },
      child: Container(
        color: Colors.transparent,
        height: 100.h,
        margin: EdgeInsets.only(left: 20.w, right: 20.w),
//        decoration: house.indexWhere((element) => data == element) == house.length - 1
//          ? BoxDecoration()
//          : BoxDecoration(
//          border: Border(bottom: BorderSide(color: Color(0x15000000))),
//        ),
        child: Row(
          children: [
            Container(
              width: 180.w,
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 48.w),
              child: Text(
                "${data["floor_number"] == -1 ? "其他小区" : (data["floor_number"] == -2 ? "暂无门牌" : (data["floor_number"]?.toString() ?? "") + '栋')}",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 490.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 48.w),
                    alignment: Alignment.center,
                    width: 180.w,
                    child: Text("${data["count"] ?? ""}"),
                  ),
                  Image.asset(
                    'images/jiantou.png',
                    width: 16.w,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showIcon(value) {
    if (_selectHeaderId == value["id"]) {
      if (value["asc"]) {
        return Image.asset(
          'images/up.png',
          width: 18.w,
        );
      } else {
        return Image.asset(
          'images/down.png',
          width: 18.w,
        );
      }
    }
    return SizedBox(
      width: 18.w,
    );
  }

  // 筛选浮动导航栏
  Widget _subheader() {
    return Container(
//      width: 480.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: _subHeaderList.map((value) {
          return InkWell(
            child: Container(
              color: Colors.white,
              width: 180.w,
//              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${value["title"]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: (_selectHeaderId == value["id"] ? Colors.blue : Colors.black54), fontSize: 32.sp),
                  ),
                  _showIcon(value),
                ],
              ),
            ),
            onTap: () {
              closeP();
              _selectHeaderId = value["id"];
              value["asc"] = !value["asc"];
              sort = value;
              house = List();
              getHouse();
            },
          );
        }).toList(),
      ),
    );
  }

  closeP() {
    showPlatform = false;
    if (selectPlatform != null && selectPlatform.length > 0) {
      platformList.forEach((e) => e.select = selectPlatform.indexWhere((ee) => e.platformId == ee.platformId) > -1);
    } else {
      platformList.forEach((e) => e.select = false);
    }
  }
}
