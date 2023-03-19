import 'package:chat_gpt/features/chat_gpt/domain/repository/chat_gpt_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entites/chat_entite.dart';

class SendMessageGptUsecase {
  ChatGptRepository chatGptRepository;
  SendMessageGptUsecase({required this.chatGptRepository});

  Future<Either<Failure, List<Chat>>> call(
      {required String message, required String modelId}) async {
    return await chatGptRepository.sendMessageGpt(
        message: message, modelId: modelId);
  }
}
