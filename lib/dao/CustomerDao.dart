import 'package:shop_shang_hu/utils/HttpUtil.dart';

class CustomerDao {
  static Future<dynamic> query(var context, String number) async {
    return HttpUtil.doGet(context, "/user", {"q": number});
  }

  static Future<dynamic> queryo(var context, String number) async {
    return HttpUtil.doGet(context, "/order", {"q": number});
  }

  static Future<dynamic> orderList(var context, String orderBy, String platformId) async {
    return HttpUtil.doGet(context, "/order/list", {"order_by": orderBy, "platform_ids": platformId});
  }

  static Future<dynamic> add(var context, String mobile, String houseNumber, String nickname, String isOther, String remark) async {
    return HttpUtil.doPost(context, "/user", {"phone": mobile, "door": houseNumber, "nickname": nickname, "floor_type": isOther, "remark": remark});
  }

  static Future<dynamic> edit(var context, String customerId, String mobile, String houseNumber, String nickname, String isOther, String remark) async {
    return HttpUtil.doPost(context, "/user", {"user_id": customerId, "phone": mobile, "door": houseNumber, "nickname": nickname, "floor_type": isOther, "remark": remark}, put: true);
  }

  /*
  /order/opt op="one" && orders= // op 操作类型 all、one、remove
// all完成这个订单
// one完成一个平台的
// remove移动到待完成
   */
  // 1完成，2待处理
  static Future<dynamic> orderDone(var context, String orderId, String opt) async {
    return HttpUtil.doPost(context, "/order/opt", {"orders": orderId, "op": opt});
  }

  static Future<dynamic> orderRemark(var context, String orderId, String remark) async {
    return HttpUtil.doPost(context, "/order/remark", {"orders": orderId, "remark": remark});
  }

  static Future<dynamic> platformNumber(var context, String houseId, String platformId) async {
    return HttpUtil.doGet(context, "/order/floor/" + houseId, {"q": platformId});
  }

  // 获取待处理订单
  static Future<dynamic> platformPending(var context) async {
    return HttpUtil.doGet(context, "/order/pending", null);
  }

  static Future<dynamic> platformNumberCount(var context) async {
    return HttpUtil.doGet(context, "/order/timing/count", {}, showLoading: false);
  }
}
