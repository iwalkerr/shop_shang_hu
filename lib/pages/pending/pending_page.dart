import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_shang_hu/dao/CustomerDao.dart';
import 'package:shop_shang_hu/utils/StringUtils.dart';
import 'package:shop_shang_hu/utils/Toast.dart';
import 'package:shop_shang_hu/widget/input_button.dart';
import 'package:shop_shang_hu/widget/pop_route.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingPage extends StatefulWidget {
  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  List orders;

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() {
    CustomerDao.platformPending(context).then((value) {
      if (StringUtils.isNotEmpty(value)) {
        orders = value.toList();
        orders.forEach((element) => element["select"] = false);
        orders.forEach((element) => element["beizhu"] = StringUtils.isNotEmpty(element["order_remark"]));
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
        elevation: 0,
        title: Text('待处理${orders?.length ?? 0}位客户'),
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
              : RefreshIndicator(
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
    );
  }

  Widget _data(value) {
    return Stack(
      children: [
        InkWell(
          onLongPress: () {
            orders.forEach((element) => element["select"] = false);
            setState(() {
              value["select"] = true;
            });
          },
          child: Container(
              decoration: orders.indexWhere((element) => value == element) == orders.length - 1
                  ? BoxDecoration()
                  : BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0x15000000))),
                    ),
              margin: EdgeInsets.only(left: 28.w, right: 28.w),
//              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: Container(
                margin: EdgeInsets.only(bottom: 16.h),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Flex(
                        direction: Axis.vertical,
                        children: getsss(value),
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        alignment: Alignment.center,
                        height: 90.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF9100),
                        ),
                        child: Container(
                          child: Text(
                            '${value["door"] ?? ""}',
                            style: TextStyle(color: Colors.white, fontSize: 36.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        value["select"]
            ? Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      value["select"] = false;
                    });
                  },
                  child: Container(
//                    padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                    alignment: Alignment.center,
                    color: Colors.black38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              value["select"] = false;
                              value["beizhu"] = true;
                            });
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
                                      value["beizhu"] = StringUtils.isNotEmpty(value["order_remark"]);
                                    });
                                  },
                                  onEditingCompleteText: (text) {
                                    CustomerDao.orderRemark(context, value["ids"]?.toString(), text).then((result) {
                                      if (result == "操作成功") {
                                        setState(() {
                                          value["order_remark"] = text;
                                          value["beizhu"] = StringUtils.isNotEmpty(value["order_remark"]);
                                        });
                                        Toast.toast(context, msg: result, showTime: 1000, textSize: 13.0, position: 'center');
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 120.w,
                            height: 120.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60.w),
                            ),
                            child: Text("备注"),
                          ),
                        ),
                        SizedBox(
                          width: 60.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomerDao.orderDone(context, value["ids"]?.toString(), "all").then((result) {
                              if (result == "操作成功") {
                                getOrders();
                                Toast.toast(context, msg: result, showTime: 1000, textSize: 13.0, position: 'center');
                              }
                            });
                          },
                          child: Container(
                            width: 120.w,
                            height: 120.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60.w),
                            ),
                            child: Text("已处理"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  getsss(valuee) {
    List<Widget> re = List();
    valuee["user_list"].toList().forEach((v) {
      re.add(Flex(
        direction: Axis.vertical,
        children: [
          Container(
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
                              onTap: () {
//                        CustomerDao.orderDone(context, platform["order_id"]?.toString(), "one").then((result) {
//                          setState(() {
//                            platform["deal"] = platform["deal"] == 1 ? 0 : 1;
//                          });
//                        });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                margin: EdgeInsets.only(right: 8.w, bottom: 8.w),
                                decoration: BoxDecoration(
                                  color: platform["deal"] == 1 ? Colors.blue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(3.w),
                                  border: Border.all(width: 1, color: Color(0xFFEFEFEF)),
                                ),
                                child: Text(platform["platform_name"], style: TextStyle(fontSize: 28.sp)),
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8.h),
            alignment: Alignment.centerLeft,
//                          margin: EdgeInsets.only(top: 10.h),
            child: Text(
              v["create_time"] ?? "",
              style: TextStyle(),
            ),
          ),
          StringUtils.isNotEmpty(v["user_remark"])
              ? Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
//              color: Colors.black12,
//              borderRadius: BorderRadius.circular(4.w),
//              border: Border.all(width: 1, color: Color(0xFFEFEFEF)),
                      ),
                  padding: EdgeInsets.only(
                    top: 8.h,
                  ),
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
                          child: StringUtils.isNotEmpty(v["user_remark"])
                              ? Text(
                                  v["user_remark"],
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
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
}
