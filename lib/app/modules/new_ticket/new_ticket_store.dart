import 'dart:convert';
import 'dart:io';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/admin_token.dart';
import 'package:app_glpi_ios/app/shared/utils/custom_dio.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:app_glpi_ios/app/shared/utils/send_notification.dart';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';

import '../../shared/utils/firestore.dart';
part 'new_ticket_store.g.dart';

class NewTicketStore = NewTicketStoreBase with _$NewTicketStore;

abstract class NewTicketStoreBase with Store {
  User? user;
  @observable
  bool isLoading = false;
  List<Map<String, dynamic>> list = [];
  List<Map<String, dynamic>> categoriaList = [];
  List<Map<String, dynamic>> localizacaoList = [];
  List<Map<String, dynamic>> tipoList = [
    {
      'id': 1,
      'name': 'Incidente',
    },
    {
      'id': 2,
      'name': 'Requisição',
    }
  ];
  List<Map<String, dynamic>> urgencia = [
    {'id': 1, 'name': 'Muito Baixa'},
    {'id': 2, 'name': 'Baixa'},
    {'id': 3, 'name': 'Média'},
    {'id': 4, 'name': 'Alta'},
    {'id': 5, 'name': 'Muito Alta'},
  ];

  @observable
  int? categoriaSelecionada;
  @observable
  /* int? localizacaoSelecionada; */
  @observable
  int? tipoSelecionada = 1;
  @observable
  int? urgenciaSelecionada = 1;
  @observable
  File? selectedFile;

  @observable
  String statusMessage = '';

  @action
  Future<void> getDetail() async {
    isLoading = true;
    statusMessage = 'Atualizando dados...';
    categoriaList.clear();
    try {
      var categorias = await getTicketDetail('ITILCategory');
      //print(categorias);
      for (var item in categorias) {
        if (item['completename'] == 'TI' ||
            item['completename'] == 'ENGENHARIA') {
        } else {
          categoriaList.add({'id': item['id'], 'name': item['completename']});
        }
      }
      categoriaList.sort((a, b) => a['name'].compareTo(b['name']));
      categoriaSelecionada = categoriaList[0]['id'];
      /* var localizacoes = await getTicketDetail('Location');

      for (var item in localizacoes) {
        localizacaoList.add({'id': item['id'], 'name': item['completename']});
      } */
      /*  localizacaoSelecionada = localizacaoList[0]['id']; */
      /* var tipo = await getTicketDetail('RequestType', adminToken);
      for (var item in tipo) {
        
        tipoList.add({'id': item['id'], 'name': item['name']});
      }
      tipoSelecionada = tipoList[0]['id']; */
    } on DioException catch (e) {
      logger.e(e);
      isLoading = false;
      //return Left(LoginFailure('Erro ao fazer login'));
    }
    isLoading = false;
  }

  @action
  Future<Either<String, bool>> createNewTicket(
      String title, String content, File? file, int entityId) async {
    isLoading = true;
    statusMessage = 'Criando ticket...';
    if (user!.sessionToken!.isEmpty) {
      user!.sessionToken = await getUserToken();
    }

    var data = {
      'input': {
        'name': title,
        'content': content,
        'urgency': urgenciaSelecionada,
        'type': tipoSelecionada,
        'itilcategories_id': categoriaSelecionada,
        'entities_id': entityId,
        //'locations_id': localizacaoSelecionada,
      }
    };
    try {
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      statusMessage = 'Criando ticket...';
      var response = await dio.post('/ticket', data: data);
      if (response.statusCode == 201) {
        //print(response.data);
        statusMessage = 'Ticket criado com sucesso';
        int ticketId = response.data['id'];
        var observers = await getTicketObservers(ticketId);
        db.collection("tickets").doc(response.data['id'].toString()).set({
          "author": user!.id,
          "observers": observers,
          "lastUpdate": DateTime.now(),
        });
        statusMessage = 'Enviando notificação...';
        List externalId = await getAdmins();
        externalId.addAll(observers);
        if (externalId.isNotEmpty) {
          String notificationTitle = 'Novo chamado aberto';
          String notificationContent =
              'Um novo chamado foi aberto por ${user!.name}';
          await sendPushNotification(
              notificationTitle, notificationContent, externalId, 'New Ticket');
        }
        if (file != null) {
          //print(await file.length());
          statusMessage = 'Enviando anexo...';
          var ticketId = response.data['id'];
          var formData = FormData.fromMap({
            'uploadManifest': jsonEncode({
              'input': {
                'name': 'Uploading a document',
                '_filename': [file.path.split('/').last],
              }
            }),
            'filename': await MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last),
          });

          dio.options.headers['Session-Token'] = user!.sessionToken;
          dio.options.headers['Content-Type'] = 'multipart/form-data';
          var responseFile = await dio.post(
            '/Document/',
            data: formData,
          );
          if (responseFile.statusCode == 201) {
            statusMessage = 'Anexo enviado com sucesso';
            var documentId = responseFile.data['id'];
            var uploadManifest = {
              'input': {
                'items_id': ticketId,
                'itemtype': 'Ticket',
                'id': documentId,
              }
            };
            dio.options.headers['Session-Token'] = user!.sessionToken;
            dio.options.headers['Content-Type'] = 'application/json';
            var responseUpload = await dio.post(
              '/Ticket/$ticketId/Document',
              data: uploadManifest,
            );
            if (responseUpload.statusCode == 201) {
              statusMessage = 'Anexo vinculado com sucesso';
              isLoading = false;
              return const Right(true);
            } else {
              isLoading = false;
              return const Left('Erro ao criar ticket');
            }
          } else {
            isLoading = false;
            return const Left('Erro ao criar ticket');
          }
        }
        isLoading = false;
        return const Right(true);
      } else {
        isLoading = false;
        return const Left('Erro ao criar ticket');
      }
    } on DioException catch (e) {
      logger.e(e);
      isLoading = false;
      return const Left('Erro ao criar ticket');
    }
  }

  @action
  Future<dynamic> getTicketDetail(
    String url,
  ) async {
    var token = await getAdminToken();
    var queryParameters = {
      'expand_dropdowns': 'true',
      'range': '0-1000',
    };
    if (url.contains('Document')) {
      queryParameters['alt'] = 'media';
    }
    try {
      dio.options.headers['Session-Token'] = token;
      dio.options.headers['Content-Type'] = 'application/json';
      //print(token);
      var response = await dio.get('/$url', queryParameters: queryParameters);
      if (response.statusCode == 200 || response.statusCode == 206) {
        //print(response.data);

        killAdminSession(token);
        return response.data;
      } else {
        killAdminSession(token);
        return false;
      }
    } on DioException catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<String> getUserToken() async {
    try {
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

  Future<List> getAdmins() async {
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

  Future<List<String>> getTicketObservers(int ticketId) async {
    try {
      List<String> observers = [];
      dio.options.headers['Session-Token'] = user!.sessionToken;
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.get('/Ticket/$ticketId/Ticket_User');
      if (response.statusCode == 200) {
        response.data.forEach((element) {
          if (element['type'] == 3) {
            observers.add(element['users_id'].toString());
          }
        });
        logger.i(response.data);
        return observers;
      } else {
        logger.e('Erro ao buscar observadores');
        return [];
      }
    } on DioException catch (e) {
      logger.e(e);
      return [];
    }
  }
}
