
import 'package:shop_shang_hu/utils/HttpUtil.dart';

class PlatformDao{

  static Future<dynamic> query(var context) async {
    return HttpUtil.doGet(context, "/platform/list", null);
  }

  static Future<dynamic> addOrder(var context, String customerId, String platformId, String remark) async {
    return HttpUtil.doPost(context, "/order", {"user_id": customerId, "platform_id": platformId, "remark": remark});
  }

  static Future<dynamic> buyQuery(var context) async {
    return HttpUtil.doGet(context, "/platform/list", null);
  }
}