import 'package:chat_gpt/core/error/failures.dart';
import 'package:chat_gpt/features/chat_gpt/domain/entites/chat_entite.dart';
import 'package:chat_gpt/features/chat_gpt/domain/entites/models_entite.dart';
import 'package:dartz/dartz.dart';

abstract class ChatGptRepository {
  Future<Either<Failure, List<Models>>> getModels();
  Future<Either<Failure, List<Chat>>> sendMessage(
      {required String message, required String modelId});
  Future<Either<Failure, List<Chat>>> sendMessageGpt(
      {required String message, required String modelId});
}
