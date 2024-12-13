import 'dart:convert';
import 'package:app_glpi_ios/app/shared/models/profile.dart';

class User {
  //tipos de usuários
  //1 - Self-service
  //2 - Observador
  //3 - Administrador
  //4 - Super administrador
  //5 - Hotline
  //6 - Tecnico
  //7 - Supervisor

  int? id;
  String name;
  String realName;
  String firstName;
  int type;
  String? userBasicAuth;
  String? sessionToken;
  List<Profile>? profiles;
  DateTime? passwordExpiresAt;
  String? profileImage;
  double? longitude;
  double? latitude;
  bool? isAprovadorContabil;
  //List<Entity>? entities;

  User({
    this.id,
    required this.name,
    required this.realName,
    required this.firstName,
    required this.type,
    this.longitude,
    this.latitude,
    this.isAprovadorContabil,
     this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['glpiID'],
      name: json['glpiname'],
      realName: json['glpirealname'] ?? '',
      firstName: json['glpifirstname'] ?? '',
      type: json['glpiactiveprofile']['id'],
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
      isAprovadorContabil: json['eAprovadorContabil'] ?? false,
      profileImage: json['profileImage'] ?? ''
    );
  }

  factory User.fromJson2(Map<String, dynamic> json) {
    User user = User(
      id: json['glpiID'],
      name: json['glpiname'],
      realName: json['glpirealname'] ?? '',
      firstName: json['glpifirstname'] ?? '',
      type: json['glpiactiveprofile'],
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
      isAprovadorContabil: json['eAprovadorContabil'] ?? false,
      profileImage: json['profileImage'] ?? ''
    );
    user.userBasicAuth = json['userBasicAuth'];
    user.sessionToken = json['sessionToken'];
    user.profiles = [];
    if (json['passwordExpiresAt'] != null && json['passwordExpiresAt'] != '') {
      user.passwordExpiresAt = DateTime.parse(json['passwordExpiresAt']);
    }
    if (json['profiles'] == null) {
      return user;
    }
    var profileString = json['profiles'];
    //check if profileString is a String or a List
    if (profileString.runtimeType == String) {
      profileString = jsonDecode(profileString);
    }
    profileString.forEach((element) {
      var profile = Profile.fromJson(element, element['id']);
      user.profiles!.add(profile);
    });
    return user;
  }

  factory User.fromFirebaseData(data) {
    User user = User(
      id: data['glpiID'],
      name: data['glpiname'],
      realName: data['glpirealname'] ?? '',
      firstName: data['glpifirstname'] ?? '',
      type: data['glpiactiveprofile'],
      latitude: data['latitude'] ?? 0,
      longitude: data['longitude'] ?? 0,
      isAprovadorContabil: data['eAprovadorContabil'] ?? false,
      profileImage: data['profileImage'] ?? ''
    );
    if (data['passwordExpiresAt'] != null) {
      user.passwordExpiresAt = DateTime.parse(data['passwordExpiresAt']);
    }
    if (data['profileImage'] != null) {
      user.profileImage = data['profileImage'];
    }
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'glpiID': id,
      'glpiname': name,
      'glpirealname': realName,
      'glpifirstname': firstName,
      'glpiactiveprofile': type,
      /* 'userBasicAuth': userBasicAuth, */
      'sessionToken': sessionToken,
      'profiles': profiles!.map((x) => x.toJson()).toList(),
      'passwordExpiresAt':
          passwordExpiresAt == null ? '' : passwordExpiresAt!.toIso8601String(),
      //'entities': entities.toString(),
      'profileImage': profileImage ?? '',
      'latitude': latitude,
      'longitude': longitude,
      'eAprovadorContabil': isAprovadorContabil,
    };
  }
}
