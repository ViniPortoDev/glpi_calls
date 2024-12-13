import 'package:app_glpi_ios/app/shared/models/user.dart';

class Ticket {
  int id;
  int type;
  String category;
  int urgency;
  int impact;
  int status;
  int priority;
  String location;
  String name;
  String content;
  DateTime dateCreation;
  DateTime? closeDate;
  DateTime? solveDate;
  DateTime? timeToResolve;
  String userCreation;
  User? technician;
  List<dynamic>? links;
  String? entity;

  Ticket({
    required this.id,
    required this.type,
    required this.category,
    required this.urgency,
    required this.impact,
    required this.status,
    required this.priority,
    required this.location,
    required this.name,
    required this.content,
    required this.dateCreation,
    required this.closeDate,
    required this.solveDate,
    required this.userCreation,
    this.timeToResolve,
    this.links,
    this.technician,
    this.entity,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        id: json['id'],
        type: json['type'],
        category: json['itilcategories_id'] == 0
            ? 'Sem categoria'
            : json['itilcategories_id'],
        urgency: json['urgency'],
        impact: json['impact'],
        status: json['status'],
        priority: json['priority'],
        location: json['locations_id'] == 0
            ? 'Sem localização'
            : json['locations_id'],
        name: json['name'],
        content: json['content'],
        dateCreation: DateTime.parse(json['date_creation']),
        closeDate: json['closedate'] != null
            ? DateTime.parse(json['closedate'])
            : null,
        solveDate: json['solvedate'] != null
            ? DateTime.parse(json['solvedate'])
            : null,
        userCreation: json['users_id_recipient'] == 0
            ? 'Sem usuário'
            : json['users_id_recipient'],
        links: json['links'],
        timeToResolve: json['time_to_resolve'] != null
            ? DateTime.parse(json['time_to_resolve'])
            : null,
        entity: json['entities_id']);
  }
}
