import 'package:chat_gpt/core/resources/colors_manger.dart';
import 'package:chat_gpt/core/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/chat_gpt/presintation/widgets/drop_down.dart';
import '../../features/chat_gpt/presintation/widgets/text_widget.dart';

class WedgitsManger {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.w),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: TextWidget(
                    label: StringsManager.chosenModel,
                    fontSize: 14.sp,
                  ),
                ),
                const Flexible(flex: 2, child: ModelsDrowDownWidget()),
              ],
            ),
          );
        });
  }
}
