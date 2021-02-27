import 'dart:convert';

import 'package:http/http.dart' as http;

import 'HttpLoading.dart';
import 'StringUtils.dart';
import 'Toast.dart';

class HttpUtil {

  static String APPADDR = "http://47.108.29.138:8000/api/v1";

  static String APPPATH = "http://47.108.29.138:8000/api/v1/warden";

  static Future<dynamic> doPost(var context, path, body, {bool showLoading = true, bool put = false}) async {
    if(showLoading){
      HttpLoading.loading(context);
    }

    http.Response response ;
    if(put){
      response = await http.put(APPPATH + path, body: body, encoding: Utf8Codec()).timeout(Duration(seconds: 6), onTimeout:(){
        Toast.toast(context, msg: "请求超时", showTime: 1000, textSize: 13.0, position: 'center');
        return Future.value(null);
      });
    }else{
      response = await http.post(APPPATH + path, body: body, encoding: Utf8Codec()).timeout(Duration(seconds: 6), onTimeout:(){
        Toast.toast(context, msg: "请求超时", showTime: 1000, textSize: 13.0, position: 'center');
        return Future.value(null);
      });
    }

    if(response == null){
      if(showLoading){
        HttpLoading.remove();
      }
      return Future.error(0);
    }
    if(showLoading){
      HttpLoading.remove();
    }

    if (response.statusCode == 200 || response.statusCode == 307) {
      return success(context, response);
    } else {
      Toast.toast(context, msg: "请求错误", showTime: 1000, textSize: 13.0, position: 'center');
      return Future.error(0);
    }
  }

  static Future<dynamic> doGet(var context, path, body, {bool showLoading = true}) async{
    if(showLoading){
      HttpLoading.loading(context);
    }
    String param = "";
    if(body != null){
      param = "?";
      body.forEach((key, value){
        param += (key + "=" + value + "&");
      });
    }
    http.Response response = await http.get(APPPATH + path + param).timeout(Duration(seconds: 6), onTimeout:(){
      Toast.toast(context, msg: "请求超时", showTime: 1000, textSize: 13.0, position: 'center');
      return Future.value(null);
    });
    if(response == null){
      if(showLoading){
        HttpLoading.remove();
      }
      return Future.error(0);
    }
    if(showLoading){
      HttpLoading.remove();
    }

    if (response.statusCode == 200 || response.statusCode == 307) {
      return success(context, response);
    } else {
      Toast.toast(context, msg: "请求错误", showTime: 1000, textSize: 13.0, position: 'center');
      return Future.error(0);
    }
  }

  static Future<dynamic> success(context, response){
    try{
      final Map<String, dynamic> responseData = json.decode(response.body);
      // 0 成功 500 错误 403 无权限 -1 失败
      if (responseData != null){
        if(responseData["code"] == 200) {
          if(StringUtils.isNotEmpty(responseData["data"])){
            return Future.value(responseData["data"]);
          }else{
            if(responseData["msg"] == "ok" || responseData["msg"] == "OK"){
              responseData["msg"] = "操作成功";
            }
            return Future.value(responseData["msg"]);
          }
        } else if(responseData["code"] == 500 || responseData["code"] == -1){
          Toast.toast(context, msg: "${responseData['msg']}", showTime: 1000, textSize: 13.0, position: 'center');
          return Future.error(0);
        }else if(responseData["code"] == 403){
          Toast.toast(context, msg: "无权限", showTime: 1000, textSize: 13.0, position: 'center');
          return Future.error(0);
        }else if(responseData["code"] == 4017){

//          Toast.toast(context, msg: responseData['msg'], showTime: 1000, textSize: 13.0, position: 'center');
          return Future.value(null);
        }else{
          Toast.toast(context, msg: responseData["msg"], showTime: 1000, textSize: 13.0, position: 'center');
          return Future.error(0);
        }
      }else {
        Toast.toast(context, msg: "${responseData['msg']}", showTime: 1000, textSize: 13.0, position: 'center');
        return Future.error(0);
      }
    }catch(e){
      print(e);
      return Future.error(0);
    }
  }

}
