// ignore_for_file: unused_catch_clause

import 'dart:developer';
import 'dart:io';
import 'package:app_glpi_ios/app/shared/models/document.dart';
import 'package:app_glpi_ios/app/shared/models/ticket.dart';
import 'package:app_glpi_ios/app/shared/utils/admin_token.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:app_glpi_ios/app/shared/utils/send_notification.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:open_file/open_file.dart' as of;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../shared/models/user.dart';
import '../../shared/utils/custom_dio.dart';
part 'ticket_store.g.dart';

class TicketStore = TicketStoreBase with _$TicketStore;

abstract class TicketStoreBase with Store {
  User? user;
  @observable
  List techList = [];
  @observable
  int selectedTechnician = 0;
  @observable
  bool isLoading = false;
  @observable
  bool isSolucionarLoading = false;
  @observable
  bool isAtribuirLoading = false;
  @observable
  bool isLoadingDetails = false;
  @observable
  bool isTileLoading = false;
  @observable
  Ticket? ticket;
  @observable
  ObservableList<Document> documentList = ObservableList<Document>();
  @observable
  ObservableList<dynamic> ticketDetails = ObservableList<dynamic>();
  List<String> excludeEntities = [
    'User',
    'RequestType',
    'Entity',
    'ITILCategory',
    'Location',
    'SLA'
  ];
  @observable
  bool showDateFields = false;
  @observable
  String loadingMessage = '';

  @observable
  bool dialogLoading = false;

  @action
  Future<void> getTicketDetails() async {
    isLoadingDetails = true;
    ticketDetails.clear();
    var links = ticket!.links;
    for (var item in links!) {
      if (!excludeEntities.contains(item['rel'])) {
        var details = await getDetails(item['href']);
        if (details.length > 0 && details != []) {
          ticketDetails
              .add({'rel': item['rel'], 'url': item['href'], 'data': details});
        }
      }
    }
    isLoadingDetails = false;
    //return Future.value();
  }

  @action
  Future<bool> getTicketDetail(int index, String url) async {
    isTileLoading = true;
    var resourcetype = url.split('api/');
    //String resource = resourcetype[5] + '/' + resourcetype[6];
    String resource = resourcetype[1];
    var adminToken = await getAdminToken();
    var queryParameters = {
      'expand_dropdowns': 'true',
    };
    try {
      dio.options.headers['Session-Token'] = adminToken;
      dio.options.headers['Content-Type'] = 'application/json';
      //print(adminToken);
      var response =
          await dio.get('/$resource', queryParameters: queryParameters);
      if (response.statusCode == 200) {
        //print(response.data);
        if (response.data == []) {
          ticket!.links!.removeAt(index);
        } else {
          ticket!.links![index]['data'] = response.data;
        }
        isTileLoading = false;
      } else {
        isTileLoading = false;
      }
      killAdminSession(adminToken);
    } on DioException catch (e) {
      logger.e(e);
      isTileLoading = false;
      //return Left(LoginFailure('Erro ao fazer login'));
    }
    //print('index: $index');
    //print('url: $url');

    return true;
  }

  @action
  Future<dynamic> getDetails(String url) async {
    var adminToken = await getAdminToken();
    var resourcetype = url.split('api/');
    //String resource = resourcetype[5] + '/' + resourcetype[6];
    String resource = resourcetype[1];

    var queryParameters = {
      'expand_dropdowns': 'true',
      'range': '0-1000',
    };
    /* if (resource.contains('Document')) {
      queryParameters['alt'] = 'media';
    } */

    try {
      dio.options.headers['Session-Token'] = adminToken;
      dio.options.headers['Content-Type'] = 'application/json';
      //print(adminToken);
      var response =
          await dio.get('/$resource', queryParameters: queryParameters);
      killAdminSession(adminToken);
      if (response.statusCode == 200) {
        //print(response.data);
        return response.data;
      } else {
        return [];
      }
    } on DioException catch (e) {
      logger.e(e);
      return [];
      //return Left(LoginFailure('Erro ao fazer login'));
    }
  }

  Future<void> downloadDocument(int id, String name) async {
    //print('download document');
    try {
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Accept'] = 'application/octet-stream';
      //dio.options.headers['Content-Type'] = 'application/octet-stream';
      dio.options.responseType = ResponseType.bytes;
      dio.get('/Document/$id').then((value) async {
        //print(value.data);
        dio.options.responseType = ResponseType.json;
        //save file to local storage
        var file = value.data;
        Directory? directory;

        if (Platform.isAndroid) {
          // Para Android, pega o diretório de armazenamento externo (onde está a pasta Downloads)
          directory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          // Para iOS, pega a pasta de documentos (não há acesso direto à pasta Downloads)
          directory = await getApplicationDocumentsDirectory();
        }
        if (directory != null) {
          var storagePermission = await Permission.storage.status;
          if (!storagePermission.isGranted) {
            await Permission.storage.request();
          }
          File('${directory.path}/$name').writeAsBytesSync(file);
          of.OpenFile.open('${directory.path}/$name');
        } else {
          logger.e('Diretorio não encontrado');
        }
      });
    } on DioException catch (e) {
      logger.e(e);
      isLoading = false;
    } on Exception catch (e) {
      logger.e(e);
      isLoading = false;
    }
  }

  Future<String> getUserToken() async {
    try {
      dio.options.headers['Session-Token'] = null;
      dio.options.headers['Authorization'] = user!.userBasicAuth;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.post('/initSession');
      if (response.statusCode == 200) {
        dio.options.headers['Authorization'] = null;
        logger
            .i('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        logger.i(response.data['session_token']);
        return response.data['session_token'];
      } else {
        return '';
      }
    } on DioException catch (e) {
      logger.e(e);

      return '';
    }
  }

  Future<void> getDocumentList(dynamic data) async {
    var adminToken = await getAdminToken();
    documentList.clear();

    ///sessionToken = await getUserToken();
    for (var doc in data) {
      var links = doc['links'];
      for (var item in links) {
        if (item['rel'] == 'Document') {
          var resourcetype = item['href'].split('api/');
          //String resource = resourcetype[5] + '/' + resourcetype[6];
          String resource = resourcetype[1];

          var queryParameters = {
            'expand_dropdowns': 'true',
          };
          /* if (resource.contains('Document')) {
      queryParameters['alt'] = 'media';
    } */

          try {
            dio.options.headers['Session-Token'] = adminToken;
            dio.options.headers['Content-Type'] = 'application/json';
            var response =
                await dio.get('/$resource', queryParameters: queryParameters);
            if (response.statusCode == 200) {
              //print(response.data);
              var document = Document.fromJson(response.data);
              documentList.add(document);

              //ticket!.links![index]['data'] = response.data;
            }
          } on DioException catch (e) {
            logger.e(e);
            //return Left(LoginFailure('Erro ao fazer login'));
          }
        }
      }
    }
    killAdminSession(adminToken);
  }

  @action
  Future<bool> validacaoTicketWithComment(
    int ticketId,
    String comment,
  ) async {
    isLoading = true;
    logger.i('ValidacaoTicketWithComment');
    try {
      var parametrs = {
        'input': {
          'items_id': ticketId,
          'itemtype': 'Ticket',
          'content': comment,
        }
      };
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.post('/ITILSolution/', data: parametrs);
      if (response.statusCode == 201) {
        await sendValidationNotification(ticketId);
        isLoading = false;
        return true;
      } else {
        isLoading = false;
        return false;
      }
    } on DioException catch (e) {
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> addFollowup(
    int ticketId,
    String comment,
  ) async {
    dialogLoading = true;
    logger.i('addFollowup');

    try {
      var parametrs = {
        'input': {
          'itemtype': 'Ticket',
          'items_id': ticketId,
          'content': comment,
        }
      };
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.post('/ITILFollowup/', data: parametrs);
      if (response.statusCode == 201) {
        await sendMessageNotification(ticketId, comment);
        dialogLoading = false;
        return true;
      } else {
        dialogLoading = false;
        return false;
      }
    } on DioException catch (e) {
      // Trate os erros aqui, se necessário
      // print(e);
      dialogLoading = false;
      return false;
    }
  }

  @action
  Future<bool> respondSolution(
    int solutionId,
    int ticketId,
    bool approved,
  ) async {
    logger.i('respondSolution');
    var adminToken = await getAdminToken();
    try {
      isSolucionarLoading = true;

      var parametrs = {
        'input': {
          'id': solutionId,
          'items_id': ticketId,
          'comment': approved ? 'Solução aceita' : 'Solução rejeitada',
          'status': approved ? 3 : 4,
          'date_approval':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'users_id_approval': user!.id,
        }
      };
      dio.options.headers['Session-Token'] = adminToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.patch('/ITILSolution', data: parametrs);
      killAdminSession(adminToken);
      if (response.statusCode == 200) {
        if (approved) {
          await closeTicket(ticketId);
        } else {
          await backTicket(ticketId);
        }

        await sendApprovalNotification(ticketId, approved);
        isSolucionarLoading = false;

        return true;
      } else {
        isSolucionarLoading = false;
        return false;
      }
    } on DioException catch (e) {
      isSolucionarLoading = false;
      return false;
    }
  }

  @action
  Future<bool> editTicketTask(int ticketId, int taskId, bool done) async {
    isLoading = true;
    logger.i('editTicketTask');
    try {
      var parametrs = {
        'input': {
          'id': taskId,
          'state': done ? 2 : 1,
        }
      };
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      Response response =
          await dio.put('/Ticket/$ticketId/TicketTask', data: parametrs);
      if (response.statusCode == 200) {
        isLoading = false;
        return true;
      } else {
        isLoading = false;
        return false;
      }
    } on DioException catch (e) {
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> creatTask(
    int ticketId,
    String comment,
    String dateInicio,
    String dateFinal,
  ) async {
    isLoading = true;
    logger.i('creatTask');
    try {
      var parametrs = {
        'input': {
          'description': comment,
          'begin': dateInicio,
          'end': dateFinal,
        }
      };
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio
          .post('/Ticket/${ticketId.toString()}/TicketTask/', data: parametrs);
      if (response.statusCode == 201) {
        isLoading = false;
        return true;
      } else {
        isLoading = false;
        return false;
      }
    } on DioException catch (e) {
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> closeTicket(int ticketId) async {
    isLoading = true;
    logger.i('closeTicket');
    var adminToken = await getAdminToken();
    try {
      var parametrs = {
        'input': {
          'id': ticketId,
          'status': 6,
          'solvedate': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        }
      };
      dio.options.headers['Session-Token'] = adminToken;
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.put('/Ticket/$ticketId', data: parametrs);
      killAdminSession(adminToken);
      if (response.statusCode == 200) {
        isLoading = false;
        return true;
      } else {
        isLoading = false;
        return false;
      }
    } on DioException catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  @action
  Future<bool> backTicket(int ticketId) async {
    isLoading = true;
    logger.i('backTicket');
    var adminToken = await getAdminToken();
    try {
      var parametrs = {
        'input': {
          'id': ticketId,
          'status': 2,
          'solvedate': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        }
      };
      dio.options.headers['Session-Token'] = adminToken;
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.put('/Ticket/$ticketId', data: parametrs);
      killAdminSession(adminToken);
      if (response.statusCode == 200) {
        isLoading = false;
        return true;
      } else {
        isLoading = false;
        return false;
      }
    } on DioException catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  @action
  Future<bool> getAllTechnicians({
    bool isAtribuir = false,
    bool isEscalar = false,
    bool isEngenharia = false,
    bool isAdm = false,
  }) async {
    isLoading = true;
    try {
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.get('/search/User', queryParameters: {
        'range': '0-1000',
        'expand_dropdowns': 'true',
        'criteria[0][criteria][0][field]': '20',
        'criteria[0][criteria][0][searchtype]': 'equals',
        'criteria[0][criteria][0][value]': 6,
        'criteria[0][criteria][1][link]': 'OR',
        'criteria[0][criteria][1][field]': '20',
        'criteria[0][criteria][1][searchtype]': 'equals',
        'criteria[0][criteria][1][value]': 3,
        'criteria[0][criteria][2][link]': 'OR',
        'criteria[0][criteria][2][field]': '20',
        'criteria[0][criteria][2][searchtype]': 'equals',
        'criteria[0][criteria][2][value]': 4,
        'criteria[0][criteria][3][link]': 'OR',
        'criteria[0][criteria][3][field]': '20',
        'criteria[0][criteria][3][searchtype]': 'equals',
        'criteria[0][criteria][3][value]': 10,
        'criteria[0][criteria][4][link]': 'OR',
        'criteria[0][criteria][4][field]': '20',
        'criteria[0][criteria][4][searchtype]': 'equals',
        'criteria[0][criteria][4][value]': 11,
        'criteria[1][link]': 'AND',
        'criteria[1][field]': '8',
        'criteria[1][searchtype]': 'equals',
        'criteria[1][value]': 1,
        'forcedisplay[0]': '1',
        'forcedisplay[5]': '2',
        'forcedisplay[1]': '8',
        'forcedisplay[2]': '20',
        'forcedisplay[3]': '21',
        'forcedisplay[4]': '79',
      });
      if (response.statusCode == 200) {
        if (response.data.length == 0) {
          isLoading = false;
          return true;
        }
        techList.clear();
        response.data['data'].forEach((usuario) {
          var userType = usuario['20'];
          log('${usuario['1'].toString()} : ${userType.toString()}');

          // Função auxiliar para verificar o tipo de usuário
          bool hasUserType(dynamic userType, List<String> validTypes) {
            if (userType is String) {
              return validTypes.contains(userType);
            } else if (userType is List) {
              return userType.any((type) => validTypes.contains(type));
            }
            return false;
          }

          // Atribuir tecnico
          if (isAtribuir) {
            if (isEngenharia) {
              if (isAdm &&
                  hasUserType(
                      userType, ["Técnico-Engenharia", "Admin-Engenharia"])) {
                techList.add(usuario);
              }
            } else {
              if (isAdm &&
                  hasUserType(
                      userType, ["Technician", "Admin", "Super-Admin"])) {
                techList.add(usuario);
              }
            }
          }

          // Escalar tecnico
          if (isEscalar) {
            if (isEngenharia) {
              if (hasUserType(userType, ["Admin-Engenharia"])) {
                techList.add(usuario);
              }
            } else {
              if (hasUserType(userType, ["Admin", "Super-Admin"])) {
                techList.add(usuario);
              }
            }
          }
        });

        if (techList.isNotEmpty) {
          selectedTechnician = techList[0]['2'];
        }
        isLoading = false;
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      logger.e(e);
      return false;
      //return Left(LoginFailure('Erro ao fazer login'));
    }
  }

  @action
  Future<bool> assignTech(int ticketId, int techId) async {
    logger.i('assignTech');
    try {
      isAtribuirLoading = true;
      var adminToken = await getAdminToken();

      var parametrs = {
        'input': {
          'tickets_id': ticketId,
          'users_id': techId,
          'type': '2',
        }
      };
      dio.options.headers['Session-Token'] = adminToken;
      dio.options.headers['Content-Type'] = 'application/json';
      Response response =
          await dio.post('/Ticket/$ticketId/Ticket_User', data: parametrs);
      killAdminSession(adminToken);
      if (response.statusCode == 201) {
        await sendNotificationsTechnician(ticketId, techId);
        registerTechnicianFirestore(ticketId, techId);

        isAtribuirLoading = false;
        return true;
      } else {
        isAtribuirLoading = false;
        return false;
      }
    } on DioException catch (e) {
      isAtribuirLoading = false;
      return false;
    }
  }

  Future<bool> registerTechnicianFirestore(ticketId, techId) async {
    try {
      var ticketData =
          await db.collection('tickets').doc(ticketId.toString()).get();
      if (ticketData.exists) {
        await db.collection('tickets').doc(ticketId.toString()).update(
            {"technician": techId, "lastUpdate": DateTime.now().toString()});
        return true;
      } else {
        await db.collection('tickets').doc(ticketId.toString()).set(
            {"technician": techId, "lastUpdate": DateTime.now().toString()});
      }
      return false;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> sendNotificationsTechnician(ticketId, techId) async {
    try {
      var authorDoc =
          await db.collection('tickets').doc(ticketId.toString()).get();
      var author = authorDoc.data()!['author'];
      var observers = authorDoc.data()!['observers'];
      await sendPushNotification(
          'Você tem um novo chamado',
          'Um novo chamado foi atribuido a você',
          [techId.toString()],
          'Technician');
      await sendPushNotification(
          'Há uma atualização no chamado #${ticketId.toString()}',
          'Um tecnico foi atribuido ao seu chamado',
          [author.toString()],
          'Technician');
      if (observers != null) {
        await sendPushNotification(
            'Há uma atualização no chamado #${ticketId.toString()}',
            'Um tecnico foi atribuido ao chamado',
            observers,
            'Technician');
      }

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<void> sendMessageNotification(ticketId, message) async {
    var receivers = <String>[];
    var ticketStatus = ticket!.status;
    var userId = user!.id;
    var ticketData =
        await db.collection('tickets').doc(ticketId.toString()).get();
    if (!ticketData.exists) {
      return;
    }
    var author = ticketData.data()!['author'];
    try {
      if (ticketStatus == 1 && userId != author) {
        receivers.add(author.toString());
      }
      if (ticketStatus != 1) {
        var technician = ticketData.data()!['technician'];
        if (userId != author && userId != technician) {
          receivers.add(author.toString());
          receivers.add(technician.toString());
        } else {
          if (userId == author) {
            receivers.add(technician.toString());
          }
          if (userId == technician) {
            receivers.add(author.toString());
          }
        }
      }
      await sendPushNotification(
          'Nova mensagem no chamado #${ticketId.toString()}',
          '${user!.name} $message',
          receivers,
          'Message');
    } catch (e) {
      logger.e('Houve um erro ao enviar notificações');
      logger.e(e);
    }
  }

  Future<void> sendValidationNotification(ticketId) async {
    var ticketData =
        await db.collection('tickets').doc(ticketId.toString()).get();
    if (!ticketData.exists) {
      return;
    }
    var author = ticketData.data()!['author'];
    var observers = ticketData.data()!['observers'];
    try {
      await sendPushNotification(
          'Há uma solução pendente no chamado #${ticketId.toString()}',
          'O seu chamado foi solucionado e está aguardando sua aprovação',
          [author.toString()],
          'Validation');
      if (user!.type != 6 && ticket!.status > 1) {
        var technician = ticketData.data()!['technician'];
        await sendPushNotification(
            'Chamado Solucionado #${ticketId.toString()}',
            'Uma solução foi adicionada a um dos seus chamados.',
            [technician.toString()],
            'Validation');
      }
      if (observers != null) {
        await sendPushNotification(
            'Há uma solução pendente no chamado #${ticketId.toString()}',
            'O chamado foi solucionado e está aguardando aprovação',
            observers,
            'Validation');
      }
    } catch (e) {
      logger.e('Houve um erro ao enviar notificações');
      logger.e(e);
    }
  }

  Future<void> sendApprovalNotification(ticketId, approved) async {
    var ticketData =
        await db.collection('tickets').doc(ticketId.toString()).get();
    if (!ticketData.exists) {
      return;
    }
    var technician = ticketData.data()!['technician'];
    var observers = ticketData.data()!['observers'];
    var admins = await getAdmins();
    var receivers = [];
    if (observers != null && observers.isNotEmpty) {
      receivers.addAll(observers);
    }
    if (admins.isNotEmpty) receivers.addAll(admins);
    try {
      if (approved) {
        await sendPushNotification(
            'Solução aprovada #${ticketId.toString()}',
            'A solução do seu chamado foi aprovada e o chamado foi fechado',
            [technician.toString()],
            'Validation');
        await sendPushNotification(
            'O Chamado #${ticketId.toString()} foi resolvido',
            'A solução foi aprovada. O chamado foi fechado',
            receivers,
            'Validation');
      } else {
        await sendPushNotification(
            'Solução reprovada #${ticketId.toString()}',
            'A solução foi reprovada. O chamado aguarda uma nova solução',
            [technician.toString()],
            'Validation');
      }
    } catch (e) {
      logger.e('Houve um erro ao enviar notificações');
      logger.e(e);
    }
  }

  Future<List<String>> getAdmins() async {
    final externalId = <String>[];
    final usersfp = db.collection('users');
    final query =
        await usersfp.where('glpiactiveprofile', whereIn: [3, 4]).get();
    if (query.docs.isEmpty) {
      return [];
    }
    for (var item in query.docs) {
      externalId.add(item['glpiID'].toString());
    }
    return externalId;
  }

  @action
  Future<bool> changeTechnician(int ticketId, int techId) async {
    isAtribuirLoading = true;
    logger.i('changeTechnician');
    try {
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get('/Ticket/$ticketId/Ticket_user/');
      if (response.statusCode == 200) {
        int? ticketUser;
        response.data.forEach((element) {
          if (element['type'] == 2) {
            ticketUser = element['id'];
          }
        });
        if (ticketUser == null) {
          isAtribuirLoading = false;
          return false;
        }
        var parametrs = {
          'input': {
            'id': ticketUser,
            'tickets_id': ticketId,
            'users_id': techId,
            'type': '2',
          }
        };
        var adminToken = await getAdminToken();
        dio.options.headers['Session-Token'] = adminToken;
        dio.options.headers['Content-Type'] = 'application/json';
        Response responseEdit =
            await dio.put('/Ticket/$ticketId/Ticket_user', data: parametrs);
        killAdminSession(adminToken);
        if (responseEdit.statusCode == 200) {
          await sendNotificationsTechnician(ticketId, techId);
          registerTechnicianFirestore(ticketId, techId);
          isAtribuirLoading = false;
          return true;
        } else {
          isAtribuirLoading = false;
          return false;
        }
      }
      return false;
    } on DioException catch (e) {
      isAtribuirLoading = false;
      rethrow;
    }
  }
}
