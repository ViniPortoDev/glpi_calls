import 'dart:io';

import 'package:app_glpi_ios/app/shared/models/orcamento.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../shared/utils/logger.dart';
import '../../shared/utils/storage.dart';

part 'receipt_store.g.dart';

class ReceiptStore = ReceiptStoreBase with _$ReceiptStore;

abstract class ReceiptStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool finishLoading = false;

  @observable
  File? selectedNF;

  @observable
  File? selectedBoleto;

  @observable
  File? selectedFile;

  @observable
  List<String> notificationsIds = [];

  @observable
  List<String> userContailListIds = [];

  @action
  Future<void> pickImage() async {
    isLoading = true;
    selectedFile = null;
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      selectedFile = File(pickedFile.path);
      isLoading = false;
    }
    isLoading = false;
  }

  @action
  Future<void> updateOrcamento(String documentId, String newStatus) async {
    try {
      finishLoading = true;

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('orcamento').doc(documentId);

      await documentReference.update({'status': newStatus});
      finishLoading = false;
    } catch (e) {
      logger.e(e);
      finishLoading = false;
    }
  }

  @action
  Future<void> uploadDocs(Orcamento orcamento) async {
    String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    String notaFiscalName = 'recebimento_notafiscal_${orcamento.id}_$timestamp';
    String boletoName = 'recebimento_boleto_${orcamento.id}_$timestamp';

    final usersRef = firebaseStorage.ref().child('orcamento');

    try {
      finishLoading = true;

      final putNotaFiscalFile =
          await usersRef.child(notaFiscalName).putFile(selectedNF!);
      var urlNotaFiscalImage = await putNotaFiscalFile.ref.getDownloadURL();

      var recebimentoLinks = {
        'recebimento': {
          'notafiscal': urlNotaFiscalImage,
        }
      };

      if (selectedBoleto != null) {
        final putBoletoFile =
            await usersRef.child(boletoName).putFile(selectedBoleto!);
        var urlBoletoImage = await putBoletoFile.ref.getDownloadURL();

        recebimentoLinks['recebimento']!['boleto'] = urlBoletoImage;
      }

      await db
          .collection('orcamento')
          .doc(orcamento.id)
          .update(recebimentoLinks);

      finishLoading = false;
    } catch (e) {
      logger.e(e);
      finishLoading = false;
    }
  }

  Future<void> getNotificationsIds(String autor) async {
    notificationsIds.clear();
    try {
      List<QueryDocumentSnapshot> querySnapshotDocs = [];

      //Pegaos ids dos adms
      QuerySnapshot querySnapshotAdms = await db
          .collection('users')
          .where('glpiactiveprofile', whereIn: [3, 4, 10]).get();

      //Pega o id do autor
      QuerySnapshot querySnapshotAutor = await db
          .collection('users')
          .where('glpiname', isEqualTo: autor)
          .get();

      querySnapshotDocs.addAll(querySnapshotAdms.docs);
      querySnapshotDocs.addAll(querySnapshotAutor.docs);

      for (var doc in querySnapshotDocs) {
        var admsIdsMap = doc.data()
            as Map<String, dynamic>?; // Verifica se o valor não é nulo
        if (admsIdsMap != null) {
          notificationsIds.add(admsIdsMap['glpiID'].toString());
        }
      }
      notificationsIds = notificationsIds.toSet().toList();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> getContabilIds() async {
    try {
      userContailListIds.clear();
      var querySnapshot = await db.collection('contabil').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userContabilMap = doc.data();
        userContailListIds.add(userContabilMap['glpiId']);
        userContailListIds = userContailListIds.toSet().toList();
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
