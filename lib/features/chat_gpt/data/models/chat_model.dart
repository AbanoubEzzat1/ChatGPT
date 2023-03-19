import 'package:chat_gpt/features/chat_gpt/domain/entites/chat_entite.dart';

class ChatModel extends Chat {
  const ChatModel({required String message, required int chatIndex})
      : super(message: message, chatIndex: chatIndex);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(message: json['message'], chatIndex: json['chatIndex']);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'chatIndex': chatIndex,
    };
  }
}
