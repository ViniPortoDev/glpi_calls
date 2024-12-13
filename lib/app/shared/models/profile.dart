import 'package:app_glpi_ios/app/shared/models/entity.dart';

class Profile {
  int id;
  String name;
  List<Entity> entities;

  Profile({
    required this.id,
    required this.name,
    required this.entities,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'entities': entities.map((x) => x.toJson()).toList(),
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json, int id) {
    if (json['entities'].runtimeType == List) {
      return Profile(
        id: id,
        name: json['name'],
        entities:
            List<Entity>.from(json['entities'].map((x) => Entity.fromJson(x))),
      );
    } else {
      return Profile(
          id: id,
          name: json['name'],
          entities: List<Entity>.from(
            json['entities'].values.map((x) => Entity.fromJson(x)),
          ));
    }
  }
}
