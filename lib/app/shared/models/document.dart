class Document {
  int id;
  String name;
  String filename;
  String filepath;
  String mime;
  DateTime dateMod;
  DateTime dateCreation;
  String userCreation;

  Document({
    required this.id,
    required this.name,
    required this.filename,
    required this.filepath,
    required this.mime,
    required this.dateMod,
    required this.dateCreation,
    required this.userCreation,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      filename: json['filename'],
      filepath: json['filepath'],
      mime: json['mime'],
      dateMod: DateTime.parse(json['date_mod']),
      dateCreation: DateTime.parse(json['date_creation']),
      userCreation: json['users_id'],
    );
  }
}
