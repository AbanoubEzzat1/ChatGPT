import 'dart:developer';
import 'package:chat_gpt/core/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/resources/assets_manger.dart';
import '../../../../core/resources/colors_manger.dart';
import '../../../../core/widgets/wedgits_manager.dart';
import '../cubit/chat_gpt_cubit/chat_gpt_cubit.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController _textEditingController;
  late ScrollController _listScrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            buildChatList(),
            if (_isTyping)
              SpinKitThreeBounce(
                color: whiteColor,
                size: 18.w,
              ),
            SizedBox(height: 5.h),
            buildTextField(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Image.asset(AssetsManager.openaiLogo),
      ),
      title: Text(StringsManager.chatGPT),
      actions: [
        IconButton(
          onPressed: () async {
            await WedgitsManger.showModalSheet(context: context);
          },
          icon: Icon(Icons.more_vert_rounded, color: whiteColor),
        ),
      ],
    );
  }

  Widget buildChatList() {
    return Flexible(
      child: ListView.builder(
        controller: _listScrollController,
        itemCount: BlocProvider.of<ChatGptCubit>(context).getChatList.length,
        itemBuilder: (context, index) {
          return ChatWidget(
            msg: BlocProvider.of<ChatGptCubit>(context)
                .getChatList[index]
                .message,
            chatIndex: BlocProvider.of<ChatGptCubit>(context)
                .getChatList[index]
                .chatIndex,
          );
        },
      ),
    );
  }

  Widget buildTextField() {
    return Container(
      color: cardColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                style: TextStyle(color: whiteColor),
                controller: _textEditingController,
                onSubmitted: (value) async {
                  await sendMessageFCT(
                    modelsProvider: BlocProvider.of<ChatGptCubit>(context),
                  );
                },
                decoration: InputDecoration.collapsed(
                    hintText: StringsManager.howCanIHelpYou,
                    hintStyle: TextStyle(color: gryColor)),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await sendMessageFCT(
                    modelsProvider: BlocProvider.of<ChatGptCubit>(context),
                  );
                },
                icon: Icon(
                  Icons.send,
                  color: whiteColor,
                ))
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent + 40.h,
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ChatGptCubit modelsProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: StringsManager.youCantSendMultipleMessages,
          ),
          backgroundColor: redColor,
        ),
      );
    } else if (_textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: StringsManager.pleaseTypeMessage,
          ),
          backgroundColor: redColor,
        ),
      );
    }
    try {
      String msg = _textEditingController.text;
      setState(() {
        _isTyping = true;
        modelsProvider.addUserMessage(msg: msg);
        _textEditingController.clear();
        _focusNode.unfocus();
      });
      await modelsProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsProvider.getCurrentModel,
      );
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: redColor,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
