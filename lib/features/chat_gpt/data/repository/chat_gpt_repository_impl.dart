import 'package:chat_gpt/core/error/exceptions.dart';
import 'package:chat_gpt/core/network/network_info.dart';
import 'package:chat_gpt/features/chat_gpt/data/data_sources/remote_data_source/chat_gpt_remote_data_source.dart';
import 'package:chat_gpt/features/chat_gpt/domain/entites/models_entite.dart';
import 'package:chat_gpt/features/chat_gpt/domain/entites/chat_entite.dart';
import 'package:chat_gpt/core/error/failures.dart';
import 'package:chat_gpt/features/chat_gpt/domain/repository/chat_gpt_repository.dart';
import 'package:dartz/dartz.dart';

class ChatGptRepositoryImpl implements ChatGptRepository {
  final ChatGptRemoteDataSource chatGptRemoteDataSource;
  final NetworkInfo networkInfo;
  ChatGptRepositoryImpl({
    required this.chatGptRemoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Models>>> getModels() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteModels = await chatGptRemoteDataSource.getModels();

        return Right(remoteModels);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> sendMessage(
      {required String message, required String modelId}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteChats = await chatGptRemoteDataSource.sendMessage(
            message: message, modelId: modelId);

        return Right(remoteChats);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> sendMessageGpt(
      {required String message, required String modelId}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteChats = await chatGptRemoteDataSource.sendMessageGpt(
            message: message, modelId: modelId);

        return Right(remoteChats);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
