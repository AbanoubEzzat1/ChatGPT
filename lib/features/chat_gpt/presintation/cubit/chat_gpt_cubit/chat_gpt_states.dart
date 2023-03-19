import '../../../domain/entites/chat_entite.dart';
import '../../../domain/entites/models_entite.dart';

abstract class ChatGptStates {
  const ChatGptStates();
}

class ChatGptInitialStates extends ChatGptStates {}

// Get Models States
class GetModelsLoadingStates extends ChatGptStates {}

class GetModelsSuccessStates extends ChatGptStates {
  final List<Models> models;
  const GetModelsSuccessStates({required this.models});
}

class GetModelsErrorStates extends ChatGptStates {
  final String msg;

  const GetModelsErrorStates({required this.msg});
}

// Get Send Message States
class SendMessageLoadingStates extends ChatGptStates {}

class SendMessageSuccessStates extends ChatGptStates {
  final List<Chat> chats;
  SendMessageSuccessStates({required this.chats});
}

class SendMessageErrorStates extends ChatGptStates {
  final String msg;

  const SendMessageErrorStates({required this.msg});
}

// Get Send Message GPT States
class SendMessageGptLoadingStates extends ChatGptStates {}

class SendMessageGptSuccessStates extends ChatGptStates {
  final List<Chat> chats;
  SendMessageGptSuccessStates({required this.chats});
}

class SendMessageGptErrorStates extends ChatGptStates {
  final String msg;

  const SendMessageGptErrorStates({required this.msg});
}

// Models Functions
class SetCurrentModelStates extends ChatGptStates {}

// Chats Functions
class AdduserMessageStates extends ChatGptStates {}
