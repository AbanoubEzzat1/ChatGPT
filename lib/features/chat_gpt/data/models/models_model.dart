import 'package:chat_gpt/features/chat_gpt/domain/entites/models_entite.dart';

class ModelsModel extends Models {
  const ModelsModel({
    required String id,
    required int created,
    required String root,
  }) : super(id: id, created: created, root: root);

  factory ModelsModel.fromJson(Map<String, dynamic> json) {
    return ModelsModel(
        id: json['id'], created: json['created'], root: json['root']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created': created,
      'root': root,
    };
  }
}
