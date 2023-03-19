import 'package:chat_gpt/features/chat_gpt/domain/repository/chat_gpt_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entites/models_entite.dart';

class GetModelUsecase {
  ChatGptRepository chatGptRepository;
  GetModelUsecase({required this.chatGptRepository});
  Future<Either<Failure, List<Models>>> call() async {
    return await chatGptRepository.getModels();
  }
}
