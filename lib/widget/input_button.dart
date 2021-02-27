import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputButtomWidget extends StatelessWidget {
  final int minLines; // 行数
  final int maxLength; // 最大长度
  final String text;
  final String hitText;
  final ValueChanged onEditingCompleteText;
  final closed;
  final TextEditingController controller = TextEditingController();

  InputButtomWidget({this.minLines, this.maxLength, this.hitText, this.onEditingCompleteText, this.text, this.closed});

  @override
  @override
  Widget build(BuildContext context) {
    controller.text = text;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () {
                closed();
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            // height: 80,
            color: Color(0xFFF4F4F4),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Container(
              // height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLengthEnforced: true,
                maxLength: maxLength,
                controller: controller,
                autofocus: true,
                style: TextStyle(fontSize: 16),
                //设置键盘按钮为发送
                textInputAction: TextInputAction.done,
                onSubmitted: (text) {
                  //点击发送调用
                  onEditingCompleteText(controller.text);
                  Navigator.pop(context);
                },
                decoration: InputDecoration(
                  hintText: hitText, //'请输入...',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                minLines: minLines,
                maxLines: 20,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16.h),
            color: Color(0xFFF4F4F4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h, bottom: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: Text("取消", style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(width: 40.w,),
                InkWell(
                  onTap: (){
                    onEditingCompleteText(controller.text);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h, bottom: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    child: Text("确定", style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(width: 40.w,),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
