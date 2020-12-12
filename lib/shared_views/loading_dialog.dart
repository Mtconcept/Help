

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'loading_anim.dart';

void loadDialog({String title, bool dismiss}){

  Get.generalDialog(
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 100.h,
                    child: Center(
                      child: Column(
                        children: [
                          LoadingAnim(),

                          SizedBox(
                            height: 10.h,
                          ),

                          Text(title, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                          ),)
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
      );
    },
    barrierDismissible: dismiss,
    barrierLabel: "Hello",
    transitionDuration: const Duration(milliseconds: 200),
  );
}