import 'package:chat_gpt/core/resources/colors_manger.dart';
import 'package:chat_gpt/features/chat_gpt/domain/entites/models_entite.dart';
import 'package:chat_gpt/features/chat_gpt/presintation/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../cubit/chat_gpt_cubit/chat_gpt_cubit.dart';

class ModelsDrowDownWidget extends StatefulWidget {
  const ModelsDrowDownWidget({super.key});

  @override
  State<ModelsDrowDownWidget> createState() => _ModelsDrowDownWidgetState();
}

class _ModelsDrowDownWidgetState extends State<ModelsDrowDownWidget> {
  String? currentModel;

  bool isFirstLoading = true;
  @override
  Widget build(BuildContext context) {
    currentModel = BlocProvider.of<ChatGptCubit>(context).getCurrentModel;
    return FutureBuilder<List<Models>>(
      future: BlocProvider.of<ChatGptCubit>(context).getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            isFirstLoading == true) {
          isFirstLoading = false;
          return FittedBox(
            child: SpinKitFadingCircle(
              color: Colors.lightBlue,
              size: 30.w,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(label: snapshot.error.toString()),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
                child: DropdownButton(
                  dropdownColor: scaffoldBackgroundColor,
                  iconEnabledColor: Colors.white,
                  items: List<DropdownMenuItem<String>>.generate(
                    snapshot.data!.length,
                    (index) => DropdownMenuItem(
                      value: snapshot.data![index].id,
                      child: TextWidget(
                        label: snapshot.data![index].id,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  value: currentModel,
                  onChanged: (value) {
                    setState(
                      () {
                        currentModel = value.toString();
                      },
                    );
                    BlocProvider.of<ChatGptCubit>(context).setCurrentModel(
                      value.toString(),
                    );
                  },
                ),
              );
      },
    );
  }
}
