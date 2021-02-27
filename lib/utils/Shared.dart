import 'package:shared_preferences/shared_preferences.dart';

class Shared{

  static SharedPreferences prefs;

  static Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return Future.value(true);
  }

  static get(key){
    return prefs.get(key);
  }

  static remove(key){
    return prefs.remove(key);
  }

  static setString(key, value){
    prefs.setString(key, value);
  }

  static setInt(key, value){
    prefs.setInt(key, value);
  }
}