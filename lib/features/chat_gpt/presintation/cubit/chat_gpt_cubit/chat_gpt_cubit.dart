import 'package:chat_gpt/core/strings/failures.dart';
import 'package:chat_gpt/features/chat_gpt/domain/usecases/get_models_usecase.dart';
import 'package:chat_gpt/features/chat_gpt/domain/usecases/send_message_gpt_usecase.dart';
import 'package:chat_gpt/features/chat_gpt/domain/usecases/send_message_usecase.dart';
import 'package:chat_gpt/features/chat_gpt/presintation/cubit/chat_gpt_cubit/chat_gpt_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entites/chat_entite.dart';
import '../../../domain/entites/models_entite.dart';

class ChatGptCubit extends Cubit<ChatGptStates> {
  final GetModelUsecase getModelUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final SendMessageGptUsecase sendMessageGptUsecase;
  ChatGptCubit({
    required this.getModelUsecase,
    required this.sendMessageUsecase,
    required this.sendMessageGptUsecase,
  }) : super(ChatGptInitialStates());
  static ChatGptCubit getChatGptCubit(context) => BlocProvider.of(context);

  List<Models> modelsList = [];
  Future getmodels() async {
    emit(GetModelsLoadingStates());
    Either<Failure, List<Models>> response = await getModelUsecase.call();
    emit(
      response.fold(
          (failure) => GetModelsErrorStates(msg: _mapFailureToMessage(failure)),
          (models) {
        modelsList.addAll(models);
        return GetModelsSuccessStates(models: models);
      }),
    );
  }

  List<Chat> chatList = [];
  Future sendMessage({required String message, required String modelId}) async {
    emit(SendMessageLoadingStates());
    Either<Failure, List<Chat>> response =
        await sendMessageUsecase.call(message: message, modelId: modelId);
    emit(response.fold(
        (failure) => SendMessageErrorStates(msg: _mapFailureToMessage(failure)),
        (chats) {
      chatList.addAll(chats);
      return SendMessageSuccessStates(chats: chats);
    }));
  }

  Future sendMessageGpt(
      {required String message, required String modelId}) async {
    emit(SendMessageGptLoadingStates());
    Either<Failure, List<Chat>> response =
        await sendMessageGptUsecase.call(message: message, modelId: modelId);
    emit(response.fold(
        (failure) =>
            SendMessageGptErrorStates(msg: _mapFailureToMessage(failure)),
        (chats) {
      chatList.addAll(chats);
      return SendMessageGptSuccessStates(chats: chats);
    }));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;

      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }

//models Functions
  String currentModel = "gpt-3.5-turbo-0301";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    SetCurrentModelStates();
  }

  List<Models> get getModelsList {
    return modelsList;
  }

  Future<List<Models>> getAllModels() async {
    return modelsList;
  }

//Chats Functions
  List<Chat> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(Chat(message: msg, chatIndex: 0));
    AdduserMessageStates();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      await sendMessageGpt(message: msg, modelId: chosenModelId);
    } else {
      await sendMessage(message: msg, modelId: chosenModelId);
    }
  }
}
