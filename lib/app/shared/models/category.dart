class Category {
  int? id;
  int entitiesId;
  String name;
  String completename;
  String comment;
  String level;
  int user;
  DateTime dateMod;
  DateTime dateCreation;
  List links;



Category({
    this.id,
    required this.entitiesId,
    required this.name,
    required this.completename,
    required this.comment,
    required this.level,
    required this.user,
    required this.dateMod,
    required this.dateCreation,
    required this.links,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      entitiesId: json['entities_id'],
      name: json['name'],
      completename: json['completename'],
      comment: json['comment'],
      level: json['level'],
      user: json['user'],
      dateMod: json['date_mod'],
      dateCreation: json['date_creation'],
      links: json['links'],
    );
  }







}
