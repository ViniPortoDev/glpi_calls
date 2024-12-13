// ignore_for_file: unused_catch_clause

import 'dart:convert';
import 'dart:io';

import 'package:app_glpi_ios/app/shared/models/ticket.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:app_glpi_ios/app/shared/utils/send_notification.dart';
import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';

import '../../shared/utils/custom_dio.dart';

part 'upload_store.g.dart';

class UploadStore = UploadStoreBase with _$UploadStore;

abstract class UploadStoreBase with Store {
  @observable
  String sessionToken = '';
  @observable
  File? selectedFile;
  @observable
  bool isLoading = false;
  Ticket? ticket;
  User? user;

  @action
  Future<bool> uploadTicket(int ticketId, File? file) async {
    isLoading = true;
    //sessionToken = await getUserToken();

    try {
      if (file != null) {
        //print(await file.length());

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

        dio.options.headers['Session-Token'] = sessionToken;
        dio.options.headers['Content-Type'] = 'multipart/form-data';
        var responseFile = await dio.post(
          '/Document/',
          data: formData,
        );
        if (responseFile.statusCode == 201) {
          var documentId = responseFile.data['id'];
          var uploadManifest = {
            'input': {
              'items_id': ticketId,
              'itemtype': 'Ticket',
              'id': documentId,
            }
          };
          dio.options.headers['Session-Token'] = sessionToken;
          dio.options.headers['Content-Type'] = 'application/json';
          var responseUpload = await dio.post(
            '/Ticket/$ticketId/Document',
            data: uploadManifest,
          );
          if (responseUpload.statusCode == 201) {
            await sendDocumentNotification(ticketId);
            isLoading = false;
            return true;
          } else {
            isLoading = false;
            return false;
          }
        } else {
          isLoading = false;
          return false;
        }
      }
      isLoading = false;
      return true;
    } on DioException catch (e) {
      //print(e);
      isLoading = false;
      return false;
    }
  }

  Future<void> sendDocumentNotification(ticketId) async {
    List<String> externalIds = [];
    var ticketData =
        await db.collection('tickets').doc(ticketId.toString()).get();
    if (ticketData.exists) {
      var author = ticketData.data()!['author'];

      if (ticket!.status == 1) {
        if (user!.id != author) {
          externalIds.add(author.toString());
        }
      } else {
        var technician = ticketData.data()!['technician'];
        if (user!.id != author && user!.id != technician) {
          externalIds.add(author.toString());
          externalIds.add(technician.toString());
        } else {
          if (user!.id == author) {
            externalIds.add(technician.toString());
          }
          if (user!.id == technician) {
            externalIds.add(author.toString());
          }
        }
      }
      if (externalIds.isEmpty) {
        return;
      }
      await sendPushNotification(
          'Novo documento adicionado',
          'Um novo documento foi adicionado ao chamado #${ticket!.id.toString()}',
          externalIds,
          'Document');
    }
  }
}
