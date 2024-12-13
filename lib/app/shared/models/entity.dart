class Entity {
  int id;
  String name;
  String? completeName;

  Entity({
    required this.id,
    required this.name,
    this.completeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completeName': completeName,
    };
  }

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'],
      name: json['name'],
      completeName: json['completeName'] ?? '',
    );
  }
}
