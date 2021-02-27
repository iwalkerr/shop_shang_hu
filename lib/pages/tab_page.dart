import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shop_shang_hu/dao/CustomerDao.dart';
import 'package:shop_shang_hu/pages/pending/pending_page.dart';
import 'package:shop_shang_hu/utils/StringUtils.dart';

import 'delivery/delivery_page.dart';
import 'home/home_page.dart';

class TabPage extends StatefulWidget {
  final int currentIndex;

  TabPage({this.currentIndex = 0});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex;

  final List<Widget> _tabs = [
    HomePage(),
    DeliveryPage(),
    PendingPage(),
  ];

  List<BottomNavigationBarItem> _bottomTabs = [];

  PageController _pageController;

  Timer timer;
  int count = 0;

  @override
  void initState() {
    _currentIndex = widget.currentIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getCount();
    });
    _getBottomTabs();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _getBottomTabs() {
    _bottomTabs = [
      BottomNavigationBarItem(
        icon: Image.asset("images/理货.png", width: 30, height: 20),
        activeIcon: Image.asset("images/理货1.png", width: 30, height: 20),
        label: "理货",
      ),
      BottomNavigationBarItem(
        icon: Image.asset("images/派送.png", width: 30, height: 20),
        activeIcon: Image.asset("images/派送1.png", width: 30, height: 20),
        label: "派送",
      ),
      BottomNavigationBarItem(
        icon: Container(
          child: Stack(
            overflow: Overflow.visible,
            children: [countWidget, Image.asset("images/待处理.png", width: 30, height: 20)],
          ),
        ),
        activeIcon: Stack(
          overflow: Overflow.visible,
          children: [countWidget, Image.asset("images/待处理1.png", width: 30, height: 20)],
        ),
        label: "待处理",
      ),
    ];
  }

  getCount() {
    CustomerDao.platformNumberCount(context).then((value) {
      if (StringUtils.isNotEmpty(value)) {
        count = value;
      } else {
        count = 0;
      }
      _getBottomTabs();
      setState(() {});
    });
  }

  get countWidget {
    return Positioned(
      top: -10,
      right: -10,
      child: count > 0
          ? Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 20,
              height: 20,
              child: Text(
                "$count",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false); // 全局配置页面模版

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _tabs,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
        items: _bottomTabs,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
