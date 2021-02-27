import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_shang_hu/dao/CustomerDao.dart';
import 'package:shop_shang_hu/pages/home/adduser_page.dart';
import 'package:shop_shang_hu/router/CustomRoute.dart';
import 'package:shop_shang_hu/utils/StringUtils.dart';
import 'package:shop_shang_hu/utils/Toast.dart';
import 'package:shop_shang_hu/widget/input_button.dart';
import 'package:shop_shang_hu/widget/pop_route.dart';
import 'package:url_launcher/url_launcher.dart';

class SubDeliveryPage extends StatefulWidget {
  final data;

  SubDeliveryPage(this.data);

  @override
  _SubDeliveryPageState createState() => _SubDeliveryPageState();
}

class _SubDeliveryPageState extends State<SubDeliveryPage> {
  List orders;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() {
    CustomerDao.platformNumber(context, widget.data["floor_number"].toString(), widget.data["platformId"].toString()).then((value) {
      if (StringUtils.isNotEmpty(value) && value.toString() != "操作成功") {
        orders = value.toList();
        orders.forEach((element) {
          element["beizhu"] = StringUtils.isNotEmpty(element["order_remark"]);
        });
      } else {
        orders = List();
      }
      setState(() {});
      // print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              size: 60.w,
            ),
          ),
          width: 80.w,
        ),
        elevation: 0,
        title: Text('${widget.data["floor_number"] == -1 ? "其他小区" : (widget.data["floor_number"]?.toString() ?? "") + '栋'}'),
      ),
      body: orders != null && orders.length > 0
          ? RefreshIndicator(
              onRefresh: () async {
                getOrders();
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _data(orders[index]);
                },
                itemCount: orders.length,
              ),
            )
          : orders == null
              ? Container(
                  alignment: Alignment.center,
                  child: Text("加载中..."),
                )
              : Expanded(
                  flex: 1,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getOrders();
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
                ),
    );
  }

  Widget _data(value) {
    return GestureDetector(
      onTap: () {
        showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return dialog(value);
          },
        ).then((val) {
          // print(val);
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
        ),
        padding: EdgeInsets.only(bottom: 12.h, top: 12.h),
        decoration: orders.indexWhere((element) => value == element) == orders.length - 1
            ? BoxDecoration()
            : BoxDecoration(
//          color: Colors.deepOrange,
                border: Border(bottom: BorderSide(color: Color(0x10000000))),
              ),
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Flex(
                direction: Axis.vertical,
                children: getsss(value),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12.h, right: 12.w),
              child: ClipOval(
                child: Container(
                  alignment: Alignment.center,
                  height: 90.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Container(
                    child: Text(
                      '${value["door"] ?? ""}',
                      style: TextStyle(color: Colors.white, fontSize: 36.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getsss(valuee) {
    List<Widget> re = List();
    valuee["user_list"].toList().forEach((v) {
//      v["platforms"].add(v["platforms"][0]);
//      v["platforms"].add(v["platforms"][0]);
//      v["platforms"].add(v["platforms"][0]);
//      v["platforms"].add(v["platforms"][0]);
//      v["platforms"].add(v["platforms"][0]);
//      v["platforms"].add(v["platforms"][0]);
      re.add(Flex(
        direction: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.only(top: 6.h),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 200.w,
                  ),
                  child: Text(
                    "${v["nickname"] ?? ""}",
                    style: TextStyle(color: Color(0xFF666666), fontSize: 28.sp),
                  ),
                ),
                Text(
                  " /  ${v["phone"] ?? ""}",
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF666666), fontSize: 28.sp),
                ),
                SizedBox(width: 0.w),
                InkWell(
                  onTap: () async {
                    String url = 'tel:' + v["phone"];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw '不能进行访问，异常';
                    }
                  },
                  child: Container(
                    width: 100.w,
                    height: 60.h,
                    padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                    child: Image.asset('images/拨打电话.png'),
                  ),
                ),
                SizedBox(width: 25.w),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0.h),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Text(
                  '${v["count"]} 单   ',
                  style: TextStyle(color: Colors.blue, fontSize: 28.sp),
                ),
                Expanded(
                  flex: 1,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: (v["platforms"] ?? "")
                        .toList()
                        .map<Widget>((platform) => GestureDetector(
                              onLongPress: () {
                                CustomerDao.orderDone(context, platform["order_id"]?.toString(), "one").then((result) {
                                  setState(() {
                                    platform["deal"] = platform["deal"] == 1 ? 0 : 1;
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                margin: EdgeInsets.only(right: 8.w, bottom: 8.w),
                                decoration: BoxDecoration(
                                  color: platform["deal"] == 1 ? Colors.transparent : Colors.blue,
                                  borderRadius: BorderRadius.circular(10.w),
                                  border: Border.all(width: 1, color: Color(0xFFEFEFEF)),
                                ),
                                child: Text(platform["platform_name"],
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      color: platform["deal"] == 1 ? Colors.black : Colors.white,
                                    )),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    var item = {};
                    item["phone"] = v["phone"] ?? "";
                    item["door"] = valuee["door"] ?? "";
                    item["nickname"] = v["nickname"] ?? "";
                    item["floor_type"] = widget.data["floor_number"] == -1 ? 2 : 1;
                    item["remark"] = v["user_remark"] ?? "";
                    item["user_id"] = v["user_id"];
                    Navigator.push(context, CustomRouteRight(AddUserPage(item: item))).then((value) {
                      getOrders();
                    });
                  },
                  child: Container(
//                    color: Colors.green,
                    width: 60.w,
//                    height: 50.h,
                    child: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
          StringUtils.isNotEmpty(v["user_remark"])
              ? Container(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        "备注：",
                        style: TextStyle(color: Colors.blue),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            v["user_remark"],
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ));
    });
    re.add(valuee["beizhu"]
        ? Container(
            padding: EdgeInsets.only(top: 8.h),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Text(
                  "备注：",
                  style: TextStyle(color: Colors.red),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: StringUtils.isNotEmpty(valuee["order_remark"])
                        ? Text(
                            valuee["order_remark"],
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
          )
        : Container());

    return re;
  }

  dialog(value) {
    return SimpleDialog(
      children: [
        SimpleDialogOption(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              '已完成',
              style: TextStyle(fontSize: 32.sp),
            ),
          ),
          onPressed: () {
            CustomerDao.orderDone(context, value["ids"]?.toString(), "all").then((result) {
              Toast.toast(context, msg: result, showTime: 1000, textSize: 13.0, position: 'center');
              Navigator.of(context).pop();
              getOrders();
            });
          },
        ),
        Divider(),
        SimpleDialogOption(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              '备注',
              style: TextStyle(fontSize: 32.sp),
            ),
          ),
          onPressed: () {
            setState(() {
              value["beizhu"] = true;
            });
            Navigator.of(context).pop();
            Navigator.push(
              context,
              PopRoute(
                child: InputButtomWidget(
                  minLines: 2,
                  maxLength: 50,
                  text: value["order_remark"],
                  hitText: '请输入备注',
                  closed: () {
                    setState(() {
                      value["beizhu"] = (StringUtils.isNotEmpty(value["order_remark"]));
                    });
                  },
                  onEditingCompleteText: (text) {
                    CustomerDao.orderRemark(context, value["ids"]?.toString(), text).then((result) {
                      value["beizhu"] = (StringUtils.isNotEmpty(text));
                      if (result?.toString() == "操作成功") {
                        setState(() {
                          value["order_remark"] = text;
                        });
                        Toast.toast(context, msg: result, showTime: 1000, textSize: 13.0, position: 'center');
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
        Divider(),
        SimpleDialogOption(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              '添加到待处理',
              style: TextStyle(fontSize: 32.sp),
            ),
          ),
          onPressed: () {
            CustomerDao.orderDone(context, value["ids"], "remove").then((result) {
              if (result == "操作成功") {
                Navigator.of(context).pop();
                getOrders();
                Toast.toast(context, msg: result, showTime: 1000, textSize: 13.0, position: 'center');
              }
            });
          },
        ),
      ],
    );
  }
}
