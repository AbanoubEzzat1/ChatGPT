import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/chat_gpt/presintation/cubit/chat_gpt_cubit/chat_gpt_cubit.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: InkWell(
          onTap: () async {
            BlocProvider.of<ChatGptCubit>(context).getmodels();
          },
          child: Container(
            color: Colors.amber,
            width: 50,
            height: 50,
            child: const Text("data"),
          ),
        ));
  }
}
