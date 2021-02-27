import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_shang_hu/dao/CustomerDao.dart';
import 'package:shop_shang_hu/utils/Toast.dart';

class AddUserPage extends StatefulWidget {
  var item;

  AddUserPage({this.item});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final FocusNode focusNode = FocusNode();
  TextEditingController mobile = TextEditingController();
  TextEditingController houseNumber = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController remark = TextEditingController();

  int xiaoQu = 1;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      mobile.text = widget.item["phone"];
      houseNumber.text = widget.item["door"];
      nickname.text = widget.item["nickname"];
      xiaoQu = widget.item["floor_type"];
      remark.text = widget.item["remark"];
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
        centerTitle: true,
        title: Text(widget.item != null ? '编辑用户' : '新增用户'),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          // width: 500.w,
          padding: EdgeInsets.only(top: 100.h),
          child: Column(
            // mainAxisAlignment: MainAxisAlignmsent.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 520.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        '昵称:',
                        style: TextStyle(
                          fontSize: 36.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      width: 400.w,
                      child: TextField(
                        maxLines: 1,
                        controller: nickname,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: '请输入昵称',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.sp),
              Container(
                width: 520.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        '楼栋:',
                        style: TextStyle(
                          fontSize: 36.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      width: 400.w,
                      child: TextField(
                        controller: houseNumber,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: '例 : 1-1122',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.sp),
              Container(
                width: 520.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        '电话:',
                        style: TextStyle(
                          fontSize: 36.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      width: 400.w,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(0),
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        controller: mobile,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: '请输入电话',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.sp),
              Container(
                width: 520.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        '备注:',
                        style: TextStyle(
                          fontSize: 36.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      width: 400.w,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        controller: remark,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: '请输入备注',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 520.w,
                padding: EdgeInsets.only(top: 20.h, bottom: 24.h, left: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        '小区:',
                        style: TextStyle(
                          fontSize: 36.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 30.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          xiaoQu = 1;
                        });
                      },
                      child: Container(
                        height: 80.h,
                        width: 180.w,
                        child: Row(
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.w,
                              margin: EdgeInsets.only(right: 16.w),
                              decoration: BoxDecoration(
                                border: Border.all(width: 4.w, color: xiaoQu == 1 ? Colors.blue : Colors.black54),
                                borderRadius: BorderRadius.circular(18.w),
                                color: Colors.white,
                              ),
                              child: xiaoQu == 1
                                ? Container(
                                margin: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(14.w),
                                ),
                              )
                                : Container(),
                            ),
                            Text('本小区', softWrap: false, style: TextStyle(letterSpacing: 2.sp, color: xiaoQu == 1 ? Colors.blue : Colors.black, fontSize: 28.sp)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          xiaoQu = 2;
                        });
                      },
                      child: Container(
                        height: 80.h,
                        width: 180.w,
                        child: Row(
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.w,
                              margin: EdgeInsets.only(right: 16.w),
                              decoration: BoxDecoration(
                                border: Border.all(width: 4.w, color: xiaoQu == 2 ? Colors.blue : Colors.black54),
                                borderRadius: BorderRadius.circular(18.w),
                                color: Colors.white,
                              ),
                              child: xiaoQu == 2
                                ? Container(
                                margin: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(14.w),
                                ),
                              )
                                : Container(),
                            ),
                            Text('其他小区', softWrap: false, style: TextStyle(letterSpacing: 2.sp, color: xiaoQu == 2 ? Colors.blue : Colors.black, fontSize: 28.sp)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.h),
              GestureDetector(
                onTap: () {
                  if (!RegexUtil.isMobileExact(mobile.text)) {
                    Toast.toast(context, msg: "请输入正确手机号");
                    return;
                  }
                  if (widget.item != null) {
                    CustomerDao.edit(context, widget.item["user_id"].toString(), mobile.text, houseNumber.text, nickname.text, xiaoQu.toString(), remark.text).then((value) {
                      Toast.toast(context, msg: value, showTime: 1000, textSize: 13.0, position: 'center');
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.pop(context, mobile.text);
                    });
                  } else {
                    CustomerDao.add(context, mobile.text, houseNumber.text, nickname.text, xiaoQu.toString(), remark.text).then((value) {
                      Toast.toast(context, msg: value, showTime: 1000, textSize: 13.0, position: 'center');
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.pop(context, mobile.text);
                    });
                  }
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
            ],
          ),
        ),
      ),
    );
  }
}
