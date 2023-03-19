import 'package:chat_gpt/core/network/network_info.dart';
import 'package:chat_gpt/features/chat_gpt/data/data_sources/remote_data_source/chat_gpt_remote_data_source.dart';
import 'package:chat_gpt/features/chat_gpt/data/repository/chat_gpt_repository_impl.dart';
import 'package:chat_gpt/features/chat_gpt/domain/usecases/get_models_usecase.dart';
import 'package:chat_gpt/features/chat_gpt/domain/usecases/send_message_gpt_usecase.dart';
import 'package:chat_gpt/features/chat_gpt/domain/usecases/send_message_usecase.dart';
import 'package:chat_gpt/features/chat_gpt/presintation/cubit/chat_gpt_cubit/chat_gpt_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:http/http.dart' as http;

import '../features/chat_gpt/domain/repository/chat_gpt_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //-- FeaturePosts

  // bloc
  sl.registerFactory(() => ChatGptCubit(
      getModelUsecase: sl(),
      sendMessageUsecase: sl(),
      sendMessageGptUsecase: sl()));

  //  UseCases
  sl.registerLazySingleton(() => GetModelUsecase(chatGptRepository: sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(chatGptRepository: sl()));
  sl.registerLazySingleton(
      () => SendMessageGptUsecase(chatGptRepository: sl()));

  // Repository
  sl.registerLazySingleton<ChatGptRepository>(() =>
      ChatGptRepositoryImpl(chatGptRemoteDataSource: sl(), networkInfo: sl()));

  // Datasources
  sl.registerLazySingleton<ChatGptRemoteDataSource>(
      () => ChatGptRemoteDataSourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
