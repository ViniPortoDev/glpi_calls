// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Location {
  int? id;
  String name;
  String completename;
  String comment;
  String level;
  String address;
  String postcode;
  String town;
  String state;
  String country;
  String building;
  String latitute;
  String longitude;
  DateTime dateMod;
  DateTime dateCreation;
  List links;

  Location({
    this.id,
    required this.name,
    required this.completename,
    required this.comment,
    required this.level,
    required this.address,
    required this.postcode,
    required this.town,
    required this.state,
    required this.country,
    required this.building,
    required this.latitute,
    required this.longitude,
    required this.dateMod,
    required this.dateCreation,
    required this.links,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'completename': completename,
      'comment': comment,
      'level': level,
      'address': address,
      'postcode': postcode,
      'town': town,
      'state': state,
      'country': country,
      'building': building,
      'latitute': latitute,
      'longitude': longitude,
      'dateMod': dateMod.millisecondsSinceEpoch,
      'dateCreation': dateCreation.millisecondsSinceEpoch,
      'links': links,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
        id: map['id'] != null ? map['id'] as int : null,
        name: map['name'] as String,
        completename: map['completename'] as String,
        comment: map['comment'] as String,
        level: map['level'] as String,
        address: map['address'] as String,
        postcode: map['postcode'] as String,
        town: map['town'] as String,
        state: map['state'] as String,
        country: map['country'] as String,
        building: map['building'] as String,
        latitute: map['latitute'] as String,
        longitude: map['longitude'] as String,
        dateMod: DateTime.fromMillisecondsSinceEpoch(map['dateMod'] as int),
        dateCreation:
            DateTime.fromMillisecondsSinceEpoch(map['dateCreation'] as int),
        links: List.from(
          (map['links'] as List),
        ));
  }
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      completename: json['completename'],
      comment: json['comment'] ?? '',
      level: json['level'].toString(),
      address: json['address'] ?? '',
      postcode: json['postcode'] ?? '',
      town: json['town'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      building: json['building'] ?? '',
      latitute: json['latitute'] ?? '',
      longitude: json['longitude'] ?? '',
      dateMod: json['date_mod'] != null ? DateTime.parse(json['date_mod']) : DateTime.now(),
      dateCreation: json['date_creation'] != null ? DateTime.parse(json['date_creation']) : DateTime.now(),
      links: json['links'] ?? [],
    );

  }

  String toJson() => json.encode(toMap());

}
