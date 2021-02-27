import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_shang_hu/dao/CustomerDao.dart';
import 'package:shop_shang_hu/dao/PlatformDao.dart';
import 'package:shop_shang_hu/router/CustomRoute.dart';
import 'package:shop_shang_hu/utils/Shared.dart';
import 'package:shop_shang_hu/utils/StringUtils.dart';
import 'package:shop_shang_hu/utils/Toast.dart';
import 'package:shop_shang_hu/widget/input_button.dart';
import 'package:shop_shang_hu/widget/pop_route.dart';
import 'package:shop_shang_hu/widget/verification_box/verification_box.dart';

import 'adduser_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> animation; // 组件动画
  Animation<Offset> textAni; // 文字动画
  bool isShow = false; // 是否展示查询数据

  // 备注
  String remark = ''; //我是一只小肥吖,成天就为找妈妈

  List queryList = List();
  List platformList = List();

  @override
  void initState() {
    super.initState();

    // 设置动画控制器
    controller = AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    // 设置偏移量
    animation = Tween(begin: Offset(0, 0.4), end: Offset(0, 0)).animate(controller);
    textAni = Tween(begin: Offset.zero, end: Offset(-0.2, 0)).animate(controller);

    // 监听动画
    controller.addListener(() {
      setState(() {});
    });
    Shared.init().then((s) {
      PlatformDao.query(context).then((value) {
        if (StringUtils.isNotEmpty(value)) {
          platformList = value.toList();
          setState(() {});
        }
        platformId = Shared.get("platform") ?? platformList[0]["platform_id"];
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 顶部
    final double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            height: double.infinity,
            margin: EdgeInsets.only(top: topPadding),
            child: SlideTransition(
              position: animation,
              child: _mobileWidget(),
            ),
          ),
          isShow
              ? Positioned(
                  top: topPadding + 250.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    height: (1334 - 250).h,
                    child: queryList != null && queryList.length > 0
                        ? SingleChildScrollView(
                            child: _contentWidget(),
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 120.h),
                            alignment: Alignment.topCenter,
                            child: Text(
                              "没有客户信息",
                              style: TextStyle(fontSize: 40.sp),
                            ),
                          ),
                  ),
                )
              : Positioned(child: Text('')),
          isShow
              ? Positioned(
                  bottom: 180.h,
                  right: -60.w,
                  child: InkWell(
                    onTap: () {
                      childKey.currentState.close();
                      Navigator.push(context, CustomRouteRight(AddUserPage(item: null))).then((value) {
                        if (StringUtils.isNotEmpty(value)) {
                          childKey.currentState.change(value.toString().substring(value.toString().length - 4, value.toString().length));
                          query(value.toString().substring(value.toString().length - 4, value.toString().length));
                        }
                      });

//                      Navigator.pushNamed(context, '/adduser');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(60.w),
                      ),
                      child: Text(
                        '新增',
                        style: TextStyle(fontSize: 36.sp, color: Colors.white),
                      ),
                    ),
                  ),
                )
              : Positioned(child: Text('')),
        ],
      ),
    );
  }

  // 详细内容
  Widget _contentWidget() {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(top: 20.h),
          child: Column(
            children: queryList.map((e) => getItem(e)).toList(),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 40.w, top: 30.h, bottom: 20.h),
          child: Text(
            '购买平台',
            style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 20.w,
          runSpacing: 20.h,
          children: _tagItem(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 40.w, top: 30.h),
          child: Text(
            '备注',
            style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PopRoute(
                child: InputButtomWidget(
                  minLines: 2,
                  maxLength: 50,
                  text: remark,
                  hitText: '请输入备注',
                  closed: () {
                    setState(() {});
                  },
                  onEditingCompleteText: (text) {
                    setState(() {
                      remark = text;
                    });
                  },
                ),
              ),
            );
          },
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
            alignment: Alignment.centerLeft,
            child: remark == ''
                ? Text(
                    '可填写缺货等信息',
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 32.sp,
                    ),
                  )
                : Text(
                    remark,
                    style: TextStyle(
                      fontSize: 32.sp,
                    ),
                  ),
          ),
        ),
        GestureDetector(
          onTap: () {
            PlatformDao.addOrder(context, customerId.toString(), platformId.toString(), remark).then((value) {
              remark = "";
              Toast.toast(context, msg: value, showTime: 1000, textSize: 13.0, position: 'center');
              setState(() {
                queryList.clear();
                isShow = false;
                controller.reverse();
              });
              childKey.currentState.editParent();
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 50.h),
            alignment: Alignment.center,
            width: 300.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(26.w),
            ),
            child: Text(
              '确认',
              style: TextStyle(fontSize: 40.sp, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 180.h),
      ],
    );
  }

  var platformId = 1; // 默认选择第一个
  // 购买平台
  List<Widget> _tagItem() {
    return List.generate(platformList.length, (index) {
      return InkWell(
        onTap: () {
          setState(() {
            platformId = platformList[index]["platform_id"];
            Shared.setInt("platform", platformId);
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          decoration: BoxDecoration(
            color: platformId == platformList[index]["platform_id"] ? Color(0xFF3C8FFF) : Colors.white,
            borderRadius: BorderRadius.circular(15.w),
          ),
          child: Text(
            platformList[index]["platform_name"] ?? "",
            style: TextStyle(
              color: platformId == platformList[index]["platform_id"] ? Colors.white : Colors.black,
              fontSize: 30.sp,
            ),
          ),
        ),
      );
    });
  }

  // 手机后四位组件
  Widget _mobileWidget() {
    return Container(
      height: 250.h,
      color: Colors.blue,
      child: Column(
        children: [
          Container(
            height: 60.h,
            margin: EdgeInsets.only(top: 30.h),
            child: SlideTransition(
              position: textAni,
              child: Text(
                '请输入客户手机号码后4位:',
                style: TextStyle(
                  fontSize: 38.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: 100.h,
            margin: EdgeInsets.fromLTRB(0, 20.h, 0, 30.h),
            child: VerificationBox(
              key: childKey,
              itemWidget: 100.h,
              textStyle: TextStyle(color: Colors.black, fontSize: 52.sp, fontWeight: FontWeight.bold),
              borderColor: Colors.white,
              count: 4,
              autoFocus: false,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.w),
              ),
              onSubmitted: (text) async {
                await controller.forward();
                // 显示组件
                setState(() {
                  isShow = true;
                });
                query(text);
              },
            ),
          ),
        ],
      ),
    );
  }

  int customerId = 0;

  Widget getItem(item) {
    return InkWell(
      onTap: () {
        queryList.forEach((element) {
          element["select"] = false;
        });
        item["select"] = true;
        customerId = item["user_id"];
        setState(() {});
      },
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
            queryList.length > 1
                ? item["select"]
                    ? Container(
                        alignment: Alignment.center,
                        height: 30.h,
                        width: 30.h,
                        child: Image.asset('images/select.png', height: 30.h, width: 30.h, fit: BoxFit.fill),
                      )
                    : Container(
                        width: 30.h,
                        height: 30.h,
//              margin: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.w, color: Colors.black54),
                          borderRadius: BorderRadius.circular(18.w),
                          color: Colors.white,
                        ),
                      )
                : Container(),
            SizedBox(
              width: 30.w,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '楼栋号: ${item["door"] ?? ""}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 32.sp),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          '昵称: ',
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
                  Text(
                    '电话: ${item["phone"] ?? ""}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 32.sp),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, CustomRouteRight(AddUserPage(item: item))).then((value) {
                  if (StringUtils.isNotEmpty(value)) {
                    childKey.currentState.change(value.toString().substring(value.toString().length - 4, value.toString().length));
                    query(value.toString().substring(value.toString().length - 4, value.toString().length));
                  }
                });
              },
              child: Container(
//                color: Colors.green,
                width: 100.w,
                height: 100.h,
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  query(number) {
    CustomerDao.query(context, number).then((value) async {
      if (StringUtils.isNotEmpty(value)) {
        queryList = value.toList();
        queryList?.forEach((element) {
          element["select"] = false;
        });
        if (queryList.length == 1) {
          queryList[0]["select"] = true;
          customerId = queryList[0]["user_id"];
        }
      } else {
        queryList = List();
        customerId = 0;
      }
      setState(() {});
    });
  }
}
