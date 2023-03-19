import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_gpt/features/chat_gpt/data/models/chat_model.dart';
import 'package:chat_gpt/features/chat_gpt/data/models/models_model.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/resources/api_constants.dart';

abstract class ChatGptRemoteDataSource {
  Future<List<ModelsModel>> getModels();
  Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId});
  Future<List<ChatModel>> sendMessageGpt(
      {required String message, required String modelId});
}

class ChatGptRemoteDataSourceImpl implements ChatGptRemoteDataSource {
  final http.Client client;
  ChatGptRemoteDataSourceImpl({required this.client});
  @override
  Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
      }
      return List.generate(
          temp.length, (index) => ModelsModel.fromJson(temp[index]));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            message: jsonResponse["choices"][index]["text"],
            chatIndex: 0,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> sendMessageGpt(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            message: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
