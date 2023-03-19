import 'package:chat_gpt/core/resources/colors_manger.dart';
import 'package:chat_gpt/features/chat_gpt/presintation/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/assets_manger.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final Color likeColor = thumbUpColor;
  final Color disLikeColor = redColor;

  bool thumbDownPreesed = true;
  bool thumbUpPreesed = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: widget.chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30.h,
                  width: 30.w,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: widget.chatIndex == 0
                      ? TextWidget(label: widget.msg)
                      : DefaultTextStyle(
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                          child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              repeatForever: false,
                              displayFullTextOnTap: true,
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText(
                                  widget.msg.trim(),
                                ),
                              ]),
                        ),
                ),
                widget.chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.thumb_up,
                              color: thumbUpPreesed ? whiteColor : likeColor,
                            ),
                            onTap: () {
                              setState(() {
                                thumbUpPreesed = !thumbUpPreesed;
                              });
                            },
                          ),
                          SizedBox(width: 5.w),
                          InkWell(
                            onTap: (() {
                              setState(() {
                                thumbDownPreesed = !thumbDownPreesed;
                              });
                            }),
                            child: Icon(
                              Icons.thumb_down,
                              color:
                                  thumbDownPreesed ? whiteColor : disLikeColor,
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
