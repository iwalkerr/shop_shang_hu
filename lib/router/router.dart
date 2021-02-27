

import 'package:shop_shang_hu/pages/delivery/subdelivery_page.dart';
import 'package:shop_shang_hu/pages/home/adduser_page.dart';
import 'package:shop_shang_hu/pages/tab_page.dart';

final routes = {
  "/": (context, {arguments}) => TabPage(currentIndex: arguments),
  "/adduser": (context) => AddUserPage(),
  "/subContent": (context, {arguments}) => SubDeliveryPage(arguments),
};
