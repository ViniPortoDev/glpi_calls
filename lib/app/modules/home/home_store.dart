import 'dart:developer';

import 'package:app_glpi_ios/app/shared/models/ticket.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:flutter_modular/flutter_modular.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/user.dart';
import '../../shared/utils/custom_dio.dart';
part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  @observable
  List ticketIds = [];
  @observable
  User? user;
  @observable
  int qtdTickets = 0;
  @observable
  bool isLoading = false;
  List<Map<String, dynamic>> dropdownProfiles = [];
  Map<String, dynamic>? selectedProfile;
  List<Map<String, dynamic>> dropdownEntities = [];
  Map<String, dynamic>? selectedEntity;
  @observable
  ObservableList<Map<int, List<Ticket>>> ticketMap =
      ObservableList<Map<int, List<Ticket>>>.of([]);

  late SharedPreferences storage;

  @observable
  String statusMessage = '';

  String locationMessage = "";

  Position? position;

  late LocationPermission permission;

  @action
  Future<void> getTicketsByUser() {
    switch (user!.type) {
      case 1: //Self-Service
        return getTickets2();
      case 6: //Tecnico
        return getIds();
      case 2: // Observador
        return getTickets2();
      case 3: // Administrador
        return getIds();
      case 4: // Super Administrador
        return getIds();
      case 10: // Administrador Engenharia
        return getIds();
      case 11: //Tecnico Engenharia
        return getIds();
      default:
        return getIds();
    }
  }

  Map<String, dynamic> searchParameterByUser(int userType, int userId) {
    switch (userType) {
      case 1: //Self-Service
        return {
          "criteria[0][field]": 4,
          "criteria[0][searchtype]": 'equals',
          "criteria[0][value]": userId,
          "criteria[1][link]": "AND",
          "criteria[1][criteria][0][field]": 12,
          "criteria[1][criteria][0][searchtype]": "equals",
          "criteria[1][criteria][0][value]": 1,
          "criteria[1][criteria][1][link]": "OR",
          "criteria[1][criteria][1][field]": 12,
          "criteria[1][criteria][1][searchtype]": "equals",
          "criteria[1][criteria][1][value]": 2,
          "criteria[1][criteria][2][link]": "OR",
          "criteria[1][criteria][2][field]": 12,
          "criteria[1][criteria][2][searchtype]": "equals",
          "criteria[1][criteria][2][value]": 3,
          "criteria[1][criteria][3][link]": "OR",
          "criteria[1][criteria][3][field]": 12,
          "criteria[1][criteria][3][searchtype]": "equals",
          "criteria[1][criteria][3][value]": 4,
          "criteria[1][criteria][4][link]": "OR",
          "criteria[1][criteria][4][field]": 12,
          "criteria[1][criteria][4][searchtype]": "equals",
          "criteria[1][criteria][4][value]": 5,
          "criteria[1][criteria][5][link]": "OR",
          "criteria[1][criteria][5][field]": 12,
          "criteria[1][criteria][5][searchtype]": "equals",
          "criteria[1][criteria][5][value]": 6,
          "sort": "15",
          "order": "DESC",
        };
      case 6: //Tecnico
        return {
          "is_deleted": 0,
          "criteria[0][field]": 5,
          "criteria[0][searchtype]": "equals",
          "criteria[0][value]": userId,
          "criteria[1][link]": "AND",
          "criteria[1][criteria][0][field]": 12,
          "criteria[1][criteria][0][searchtype]": "equals",
          "criteria[1][criteria][0][value]": 2,
          "criteria[1][criteria][1][link]": "OR",
          "criteria[1][criteria][1][field]": 12,
          "criteria[1][criteria][1][searchtype]": "equals",
          "criteria[1][criteria][1][value]": 5,
          "criteria[1][criteria][2][link]": "OR",
          "criteria[1][criteria][2][field]": 12,
          "criteria[1][criteria][2][searchtype]": "equals",
          "criteria[1][criteria][2][value]": 6,
          /* "criteria[2][link]": "OR",
          "criteria[2][criteria][0][field]": 12,
          "criteria[2][criteria][0][searchtype]": "equals",
          "criteria[2][criteria][0][value]": 6,
          "criteria[2][criteria][1][link]": "AND",
          "criteria[2][criteria][1][field]": 5,
          "criteria[2][criteria][1][searchtype]": "equals",
          "criteria[2][criteria][1][value]": userId,
          "criteria[3][link]": "OR",
          "criteria[3][field]": 12,
          "criteria[3][searchtype]": "equals",
          "criteria[3][value]": 1, */
          "range": "0-100",
          "sort": "15",
          "order": "DESC",
        };

      case 10: // Administrador ENGENHARIA
        return {
          'is_deleted': 0,
          'criteria[0][field]': 7,
          'criteria[0][searchtype]': 'contains',
          'criteria[0][value]': 'ENGENHARIA >',
          "criteria[1][link]": "AND",
          "criteria[1][criteria][0][field]": 12,
          "criteria[1][criteria][0][searchtype]": "equals",
          "criteria[1][criteria][0][value]": 1,
          "criteria[1][criteria][1][link]": "OR",
          "criteria[1][criteria][1][field]": 12,
          "criteria[1][criteria][1][searchtype]": "equals",
          "criteria[1][criteria][1][value]": 2,
          "criteria[1][criteria][2][link]": "OR",
          "criteria[1][criteria][2][field]": 12,
          "criteria[1][criteria][2][searchtype]": "equals",
          "criteria[1][criteria][2][value]": 3,
          "criteria[1][criteria][3][link]": "OR",
          "criteria[1][criteria][3][field]": 12,
          "criteria[1][criteria][3][searchtype]": "equals",
          "criteria[1][criteria][3][value]": 4,
          "range": "0-1000",
        };
      case 3: // Administrador
        return {
          'is_deleted': 0,
          'criteria[0][field]': 7,
          'criteria[0][searchtype]': 'contains',
          'criteria[0][value]': 'TI >',
          "criteria[1][link]": "AND",
          "criteria[1][criteria][0][field]": 12,
          "criteria[1][criteria][0][searchtype]": "equals",
          "criteria[1][criteria][0][value]": 1,
          "criteria[1][criteria][1][link]": "OR",
          "criteria[1][criteria][1][field]": 12,
          "criteria[1][criteria][1][searchtype]": "equals",
          "criteria[1][criteria][1][value]": 2,
          "criteria[1][criteria][2][link]": "OR",
          "criteria[1][criteria][2][field]": 12,
          "criteria[1][criteria][2][searchtype]": "equals",
          "criteria[1][criteria][2][value]": 3,
          "criteria[1][criteria][3][link]": "OR",
          "criteria[1][criteria][3][field]": 12,
          "criteria[1][criteria][3][searchtype]": "equals",
          "criteria[1][criteria][3][value]": 4,
          "range": "0-1000",
        };
      case 4: // Super Administrador
        return {
          'is_deleted': 0,
          'criteria[0][field]': 7,
          'criteria[0][searchtype]': 'contains',
          'criteria[0][value]': 'TI >',
          "criteria[1][link]": "AND",
          "criteria[1][criteria][0][field]": 12,
          "criteria[1][criteria][0][searchtype]": "equals",
          "criteria[1][criteria][0][value]": 1,
          "criteria[1][criteria][1][link]": "OR",
          "criteria[1][criteria][1][field]": 12,
          "criteria[1][criteria][1][searchtype]": "equals",
          "criteria[1][criteria][1][value]": 2,
          "criteria[1][criteria][2][link]": "OR",
          "criteria[1][criteria][2][field]": 12,
          "criteria[1][criteria][2][searchtype]": "equals",
          "criteria[1][criteria][2][value]": 3,
          "criteria[1][criteria][3][link]": "OR",
          "criteria[1][criteria][3][field]": 12,
          "criteria[1][criteria][3][searchtype]": "equals",
          "criteria[1][criteria][3][value]": 4,
          "range": "0-1000",
        };
      case 9: // Gerente
        return {
          'is_deleted': 0,
          'criteria[0][field]': 66,
          'criteria[0][searchtype]': 'equals',
          'criteria[0][value]': userId,
          "criteria[1][link]": "AND",
          "criteria[1][criteria][0][field]": 12,
          "criteria[1][criteria][0][searchtype]": "equals",
          "criteria[1][criteria][0][value]": 1,
          "criteria[1][criteria][1][link]": "OR",
          "criteria[1][criteria][1][field]": 12,
          "criteria[1][criteria][1][searchtype]": "equals",
          "criteria[1][criteria][1][value]": 2,
          "criteria[1][criteria][2][link]": "OR",
          "criteria[1][criteria][2][field]": 12,
          "criteria[1][criteria][2][searchtype]": "equals",
          "criteria[1][criteria][2][value]": 3,
          "criteria[1][criteria][3][link]": "OR",
          "criteria[1][criteria][3][field]": 12,
          "criteria[1][criteria][3][searchtype]": "equals",
          "criteria[1][criteria][3][value]": 4,
          "criteria[1][criteria][4][link]": "OR",
          "criteria[1][criteria][4][field]": 12,
          "criteria[1][criteria][4][searchtype]": "equals",
          "criteria[1][criteria][4][value]": 5,
          "criteria[1][criteria][5][link]": "OR",
          "criteria[1][criteria][5][field]": 12,
          "criteria[1][criteria][5][searchtype]": "equals",
          "criteria[1][criteria][5][value]": 6,
          "sort": "15",
          "order": "DESC",
        };
      case 11: //Tecnico Engenharia
        return {
          "is_deleted": 0,
          "criteria[0][field]": 5,
          "criteria[0][searchtype]": "equals",
          "criteria[0][value]": userId,
          "criteria[1][link]": "AND",
          "criteria[1][criteria][0][field]": 12,
          "criteria[1][criteria][0][searchtype]": "equals",
          "criteria[1][criteria][0][value]": 2,
          "criteria[1][criteria][1][link]": "OR",
          "criteria[1][criteria][1][field]": 12,
          "criteria[1][criteria][1][searchtype]": "equals",
          "criteria[1][criteria][1][value]": 5,
          "criteria[1][criteria][2][link]": "OR",
          "criteria[1][criteria][2][field]": 12,
          "criteria[1][criteria][2][searchtype]": "equals",
          "criteria[1][criteria][2][value]": 6,
          /* "criteria[2][link]": "OR",
          "criteria[2][criteria][0][field]": 12,
          "criteria[2][criteria][0][searchtype]": "equals",
          "criteria[2][criteria][0][value]": 6,
          "criteria[2][criteria][1][link]": "AND",
          "criteria[2][criteria][1][field]": 5,
          "criteria[2][criteria][1][searchtype]": "equals",
          "criteria[2][criteria][1][value]": userId,
          "criteria[3][link]": "OR",
          "criteria[3][field]": 12,
          "criteria[3][searchtype]": "equals",
          "criteria[3][value]": 1, */
          "range": "0-100",
          "sort": "15",
          "order": "DESC",
        };
      default:
        return {};
    }
  }

  @action
  Future<void> getIds() async {
    isLoading = true;
    statusMessage = 'Buscando tickets...';
    try {
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var params = searchParameterByUser(user!.type, user!.id!);
      var response = await dio.get('/search/Ticket', queryParameters: params);
      if (response.statusCode == 200 || response.statusCode == 206) {
        if (response.data['totalcount'] == 0) {
          isLoading = false;
          return;
        }
        qtdTickets = response.data['totalcount'];
        logger.i(response.data['totalcount']);
        List dataTicketList = response.data['data'];
        ticketIds.clear();
        for (var i = 0; i < dataTicketList.length; i++) {
          ticketIds.add(dataTicketList[i]['2']);
        }

        if (ticketIds.isNotEmpty) {
          await getTickets();
        }
      } else {
        isLoading = false;
        await storage.remove('user');
        OneSignal.logout();
        Modular.to.pushReplacementNamed('/login');
      }
    } catch (e) {
      isLoading = false;
      await storage.remove('user');
      OneSignal.logout();
      Modular.to.pushReplacementNamed('/login');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> getTickets() async {
    /* isLoading = true; */
    //print(sessionToken);
    statusMessage = 'Buscando tickets...';
    var itens = [];
    for (int i = 0; i < ticketIds.length; i++) {
      itens.add({
        'itemtype': 'Ticket',
        'items_id': ticketIds[i],
      });
    }

    try {
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.get('/getMultipleItems', queryParameters: {
        'expand_dropdowns': 'true',
        'with_documents': 'true',
        'add_keys_name': [
          'name',
          'content',
          'date_creation',
          'users_id',
          'documents_id',
          'users_id_recipient',
        ],
        'items': itens,
      });
      //print(response.data);
      if (response.statusCode == 200) {
        List dataTicketList = response.data;
        //ticketList.clear();
        ticketMap.clear();
        statusMessage = 'Preparando tickets...';
        await Future.forEach(dataTicketList, (element) async {
          Ticket ticket = Ticket.fromJson(element as Map<String, dynamic>);
          statusMessage = 'Processando ticket ${ticket.id}...';
          var techInfo = await getTechInfo(ticket.id);
          if (techInfo.isNotEmpty) {
            User tech = User.fromJson2(techInfo);
            ticket.technician = tech;
          }
          if (ticketMap.isEmpty) {
            ticketMap.add({
              ticket.status: [ticket]
            });
          } else {
            bool hasStatus = false;
            for (int i = 0; i < ticketMap.length; i++) {
              if (ticketMap[i].containsKey(ticket.status)) {
                if (ticket.status == 6) {
                  if (ticketMap[i][ticket.status]!.length < 5) {
                    ticketMap[i][ticket.status]!.add(ticket);
                  }
                } else {
                  ticketMap[i][ticket.status]!.add(ticket);
                }
                hasStatus = true;
              }
            }
            if (!hasStatus) {
              ticketMap.add({
                ticket.status: [ticket]
              });
            }
          }
        });
        ticketMap.sort((a, b) => a.keys.first.compareTo(b.keys.first));
        for (int i = 0; i < ticketMap.length; i++) {
          ticketMap[i]
              .values
              .first
              .sort((a, b) => a.dateCreation.compareTo(b.dateCreation) * -1);
        }
      }
    } catch (e) {
      await storage.remove('user');
      OneSignal.logout();
      Modular.to.pushReplacementNamed('/login');
    }
  }

  @action
  Future<void> getTickets2() async {
    isLoading = true;
    statusMessage = 'Buscando tickets...';
    //print(sessionToken);
    try {
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.get('/Ticket', queryParameters: {
        'expand_dropdowns': 'true',
        'with_documents': 'true',
        'range': '0-1000',
        'sort': 'date_creation',
        'order': 'DESC',
        'add_keys_name': [
          'name',
          'content',
          'date_creation',
          'users_id',
          'documents_id',
          'users_id_recipient',
          'entities_id'
        ],
      });
      //print(response.data);
      if (response.statusCode == 200) {
        List dataTicketList = response.data;
        //ticketList.clear();
        qtdTickets = dataTicketList.length;
        ticketMap.clear();
        await Future.forEach(dataTicketList, (elementData) async {
          statusMessage = 'Preparando ticket...';
          Ticket ticket = Ticket.fromJson(elementData as Map<String, dynamic>);
          statusMessage = 'Processando ticket ${ticket.id}...';
          if (ticket.entity!.contains(selectedEntity!['name'])) {
            var techInfo = await getTechInfo(ticket.id);
            if (techInfo.isNotEmpty) {
              User tech = User.fromJson2(techInfo);
              ticket.technician = tech;
            }
            if (ticketMap.isEmpty) {
              ticketMap.add({
                ticket.status: [ticket]
              });
            } else {
              bool hasStatus = false;
              for (int i = 0; i < ticketMap.length; i++) {
                if (ticketMap[i].containsKey(ticket.status)) {
                  if (ticket.status == 6) {
                    if (ticketMap[i][ticket.status]!.length < 5) {
                      ticketMap[i][ticket.status]!.add(ticket);
                    }
                  } else {
                    ticketMap[i][ticket.status]!.add(ticket);
                  }
                  hasStatus = true;
                }
              }

              if (!hasStatus) {
                ticketMap.add({
                  ticket.status: [ticket]
                });
              }
            }
          }
          //ticketList.add(ticket);
          //String status = getStatusDesc(ticket.status);
        });
        ticketMap.sort((a, b) => a.keys.first.compareTo(b.keys.first));
        for (int i = 0; i < ticketMap.length; i++) {
          ticketMap[i]
              .values
              .first
              .sort((a, b) => a.dateCreation.compareTo(b.dateCreation) * -1);
        }
      }
      isLoading = false;
    } on DioException catch (e) {
      logger.e(e);
      isLoading = false;
      await storage.remove('user');
      OneSignal.logout();
      Modular.to.pushReplacementNamed('/login');
      //return Left(CredentialsFailure());
    }
  }

  Future<void> logout() async {
    try {
      await storage.remove('user');
      await OneSignal.logout();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<Map<String, dynamic>> getTechInfo(int ticketId) async {
    try {
      var techData =
          await db.collection('tickets').doc(ticketId.toString()).get();
      if (!techData.exists) {
        return {};
      }
      var techId = techData.data()!['technician'];
      if (techId == null) {
        return {};
      }
      var tech = await db.collection('users').doc(techId.toString()).get();
      return tech.data()!;
    } catch (e) {
      return {};
    }
  }

  void prepareDropdownItems() {
    dropdownProfiles.clear();
    dropdownEntities.clear();
    for (var i = 0; i < user!.profiles!.length; i++) {
      dropdownProfiles.add({
        'id': user!.profiles![i].id,
        'name': user!.profiles![i].name,
      });
    }
    for (int i = 0; i < user!.profiles!.first.entities.length; i++) {
      dropdownEntities.add({
        'id': user!.profiles!.first.entities[i].id,
        'name': user!.profiles!.first.entities[i].name,
      });
    }
    selectedProfile = dropdownProfiles.first;
    selectedEntity = dropdownEntities.first;
  }

  void changeProfile(int profileId) {
    for (int i = 0; i < user!.profiles!.length; i++) {
      if (user!.profiles![i].id == profileId) {
        dropdownEntities.clear();
        for (int j = 0; j < user!.profiles![i].entities.length; j++) {
          dropdownEntities.add({
            'id': user!.profiles![i].entities[j].id,
            'name': user!.profiles![i].entities[j].name,
          });
        }
        selectedEntity = dropdownEntities.first;
      }
    }
  }

  @action
  Future<bool> setFirestoreUser(User user) async {
    try {
      //print(user.toJson());

      var userData = user.toJson();
      var userDoc = await db.collection('users').doc(user.id.toString()).get();
      if (userDoc.exists) {
        await db.collection('users').doc(user.id.toString()).update(
          {
            'sessionToken': user.sessionToken,
            'profiles': user.profiles!.map((x) => x.toJson()).toList(),
            'latitude': user.latitude,
            'longitude': user.longitude,
          },
        );
      } else {
        await db.collection('users').doc(user.id.toString()).set(userData);
      }
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    try {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationMessage = "Permissão de localização negada.";
          return;
        }
        if (permission == LocationPermission.deniedForever) {
          locationMessage =
              "Permissões de localização negadas permanentemente.";
          return;
        }

        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 10),
            distanceFilter: 10,
          ),
        );
        locationMessage =
            "Latitude: ${position!.latitude}, Longitude: ${position!.longitude}";
        user!.latitude = position!.latitude;
        user!.longitude = position!.longitude;

        setFirestoreUser(user!);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> instantiateSharedPreferences() async{
    storage = await SharedPreferences.getInstance();
  }
}
