import 'package:chat_gpt/core/bloc_observer.dart';
import 'package:chat_gpt/core/resources/colors_manger.dart';
import 'package:chat_gpt/core/resources/strings_manager.dart';
import 'package:chat_gpt/features/splash_screen/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/injiction_container.dart' as di;
import 'features/chat_gpt/presintation/cubit/chat_gpt_cubit/chat_gpt_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => di.sl<ChatGptCubit>()..getmodels(),
            ),
          ],
          child: MaterialApp(
            title: StringsManager.chatGPT,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: scaffoldBackgroundColor,
                appBarTheme: AppBarTheme(
                  color: cardColor,
                )),
            home: const SplashView(),
          ),
        );
      },
    );
  }
}
