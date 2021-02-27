import 'package:flutter/material.dart';

import 'router/router.dart';

// flutter build apk --target-platform android-arm --split-per-abi

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
      // supportedLocales: [const Locale('zh', 'CH')],
    );
  }
}

// 固定写法
// ignore: missing_return, top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];

  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      return MaterialPageRoute(
        builder: (context) => pageContentBuilder(context, arguments: settings.arguments),
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
    }
  }
};
