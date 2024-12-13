import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../shared/models/orcamento.dart';
import '../../shared/models/profile.dart';
import '../../shared/models/user.dart';
import '../../shared/utils/custom_dio.dart';
import '../../shared/utils/firestore.dart';
import '../home/home_store.dart';
part 'orcamento_details_store.g.dart';

class OrcamentoDetailsStore = OrcamentoDetailsStoreBase
    with _$OrcamentoDetailsStore;

abstract class OrcamentoDetailsStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isPdfLoading = false;

  @observable
  bool isButtonLoading = false;

  @observable
  bool isPasswordValid = false;

  @observable
  bool sendLoading = false;

  @observable
  bool approveLoading = false;

  @observable
  bool updateOrcamentoLoading = false;

  @observable
  bool sendOrcamento = false;

  @observable
  String userBasicAuth = '';

  @observable
  List<String> notificationsIds = [];

  @observable
  List<String> userContailListIds = [];

  @observable
  List<dynamic> cotacoes = [];

  @observable
  String? userLog;

  @observable
  File? selectedPdf;

  @observable
  File? cotacaoAprovadaFile;

  @observable
  ObservableList<File> pdfFiles = ObservableList<File>();

  HomeStore homeStore = Modular.get<HomeStore>();

  late final SharedPreferences storage;

  Future<void> cancelQuote(String documentId) async {
    try {
      isLoading = true;

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('orcamento').doc(documentId);

      await documentReference.delete();
      isLoading = false;
    } catch (e) {
      logger.e(e);
      isLoading = false;
    }
  }

  @action
  Future<void> signPdf(Orcamento orcamento, File pdf, String fileInitialName,
      List<double> fromLTWH) async {
    String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    String fileName = '$fileInitialName$timestamp.pdf';

    final pdfBytes = await pdf.readAsBytes();

    try {
      isLoading = true;
      // Carregar o PDF existente
      PdfDocument document = PdfDocument(inputBytes: pdfBytes);

      // Pegar a primeira página do PDF
      PdfPage firstPage = document.pages[0];

      // Determinar a largura da página para posicionar o texto no centro
      double pageWidth = firstPage.getClientSize().width;

      // Adicionar texto na parte inferior central da primeira página
      firstPage.graphics.drawString(
        userLog!,
        PdfStandardFont(PdfFontFamily.helvetica, 6),
        bounds: Rect.fromLTWH(
          pageWidth / fromLTWH[0],
          firstPage.getClientSize().height - fromLTWH[1],
          fromLTWH[2],
          fromLTWH[3],
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      );

      // Salvar o PDF editado
      List<int> updatedPdfBytes = await document.save();
      document.dispose();

      final outputFile =
          File('${(await getTemporaryDirectory()).path}/$fileName');
      await outputFile.writeAsBytes(updatedPdfBytes);

      // Enviar o arquivo para o Firebase Storage
      final usersRef = FirebaseStorage.instance.ref().child('orcamento');
      final cotacaoAprovadaTaskShot =
          await usersRef.child(fileName).putFile(outputFile);
      var cotacaoAprovadaUrl =
          await cotacaoAprovadaTaskShot.ref.getDownloadURL();
      var cotacaoAprovada = {
        'cotacao_aprovada': cotacaoAprovadaUrl,
      };
      await db
          .collection('orcamento')
          .doc(orcamento.id)
          .update(cotacaoAprovada);
      isLoading = false;
    } catch (e) {
      logger.e(e.toString());
      isLoading = false;

      return;
    }
  }

  @action
  Future<String?> uploadPdf(File? pdf) async {
    // sendLoading = true;

    if (pdf != null) {
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now()) +
          DateTime.now().millisecond.toString().padLeft(3, '0');

      String fileName = 'pdf_$timestamp.pdf';

      final pdfBytes = await pdf.readAsBytes();
      logger.i('Tamanho do arquivo em bytes: ${pdfBytes.length}');
      if (pdfBytes.isEmpty) {
        logger.e('Erro ao ler o arquivo');
        // sendLoading = false;
        return null;
      }

      try {
        final usersRef = FirebaseStorage.instance.ref().child('orcamento');
        var putPdfFile = await usersRef.child(fileName).putFile(pdf);
        var urlPdf = await putPdfFile.ref.getDownloadURL();

        return urlPdf;
      } catch (e) {
        logger.e(e.toString());
        return null;
      } finally {
        // sendLoading = false;
      }
    } else {
      logger.e('Nenhum arquivo PDF selecionado');
      // sendLoading = false;
      return null;
    }
  }

  @action
  Future<void> updateOrcamento(String documentId, String newStatus) async {
    try {
      isLoading = true;

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('orcamento').doc(documentId);

      await documentReference.update({'status': newStatus});
      isLoading = false;
    } catch (e) {
      logger.e(e);
      isLoading = false;
    }
  }

  @action
  Future<String> generateLog(
      String password, User user, bool isContador) async {
    try {
      isLoading = true;

      // Gerar o hash da senha
      final passwordHash = sha256.convert(utf8.encode(password)).toString();

      // Capturar o IP
      final ip = await getIpAddress();

      // Capturar informações do dispositivo
      final deviceInfo = await getDeviceInfo();

      // Capturar localização
      final location = await getLocation(ip);

      userLog = isContador
          ? 'Aprovação contábil\n'
              'Hash: ${passwordHash.substring(0, 15)}\n'
              'Autor: ${user.firstName} ${user.realName}\n'
              'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())} às ${DateFormat('HH:mm').format(DateTime.now())}\n'
              'IP: $ip\n'
              'Location: $location\n'
              'Device Info: $deviceInfo'
          : 'Aprovação gerencial\n'
              'Hash: ${passwordHash.substring(0, 15)}\n'
              'Autor: ${user.firstName} ${user.realName}\n'
              'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())} às ${DateFormat('HH:mm').format(DateTime.now())}\n'
              'IP: $ip\n'
              'Location: $location\n'
              'Device Info: $deviceInfo';
      logger.i('Log: $userLog');
      isLoading = false;

      return userLog!;
    } catch (e, stackTrace) {
      logger.e('Failed to generate log', error:e, stackTrace:stackTrace);
      isLoading = false;

      return 'Error generating log: $e';
    }
  }

  @action
  Future<String> getIpAddress() async {
    try {
      final response = await dio.get('https://api.ipify.org');
      if (response.statusCode == 200) {
        logger.i('Ip: ${response.data}');
        return response.data;
      } else {
        logger.w('Failed to get IP. Status code: ${response.statusCode}');
        return 'Failed to get IP';
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching IP address', error:e, stackTrace:stackTrace);
      return 'Error: $e';
    }
  }

  @action
  Future<String> getLocation(String ip) async {
    try {
      final response = await dio.get('https://ipapi.co/$ip/json/');
      if (response.statusCode == 200) {
        final data = response.data;
        logger.i(
            'Location ${data['city']}, ${data['region']}, ${data['country_name']}');

        return '${data['city']}, ${data['region']}, ${data['country_name']}';
      } else {
        logger.w('Failed to get location. Status code: ${response.statusCode}');
        return 'Failed to get location';
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching location', error: e, stackTrace:stackTrace);
      return 'Error: $e';
    }
  }

  @action
  Future<String> getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        logger.i(
            'Device: Android - ${androidInfo.model}, ${androidInfo.version.sdkInt}');
        return 'Android - ${androidInfo.model}, ${androidInfo.version.sdkInt}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        logger.i('Device: iOS - ${iosInfo.name}, ${iosInfo.systemVersion}');
        return 'iOS - ${iosInfo.name}, ${iosInfo.systemVersion}';
      } else {
        return 'Unknown Device';
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching device info', error:e, stackTrace:stackTrace);
      return 'Error: $e';
    }
  }

  @action
  Future<void> validatePassword(String password) async {
    try {
      var userPasswordSaved = storage.getString('password');
      if (userPasswordSaved == password) {
        isPasswordValid = true;
      } else {
        isPasswordValid = false;
      }
    } catch (e) {
      logger.e(e);
      isPasswordValid = false;
    }
  }

  @action
  Future<void> getMyProfiles(Map<String, dynamic> profileList) async {
    logger.i(profileList);
    profileList.forEach((key, value) {
      logger.i(value);
      Profile myProfile = Profile.fromJson(value, int.parse(key));
      if (homeStore.user!.profiles == null) {
        homeStore.user!.profiles = [];
      }
      homeStore.user!.profiles!.add(myProfile);
    });
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

  @action
  Future<void> uploadCotacoes(List<File> pdfList, Orcamento orcamento) async {
    sendLoading = true;

    try {
      for (var pdf in pdfList) {
        var pdfUrlLink = await uploadPdf(pdf);
        cotacoes.add(pdfUrlLink);
      }
      var cotacoesLink = {
        'cotacoes': cotacoes,
      };

      await db.collection('orcamento').doc(orcamento.id).update(cotacoesLink);
      sendLoading = false;
    } catch (e) {
      logger.e(e);
      sendLoading = false;
    }
  }

  @action
  Future<void> getCotacoes(Orcamento orcamento) async {
    pdfFiles.clear();

    try {
      isPdfLoading = true;

      var cotacoesData =
          await db.collection('orcamento').doc(orcamento.id).get();
      if (!cotacoesData.exists) {
        isPdfLoading = false;

        return pdfFiles.clear();
      }
      var cotacoes = cotacoesData.data()!['cotacoes'];
      var cotacaoAprovada = cotacoesData.data()!['cotacao_aprovada'];
      if (cotacoes == null || cotacoes.isEmpty || cotacoes.contains(null)) {
        isPdfLoading = false;

        return pdfFiles.clear();
      }
      if (cotacaoAprovada != null) {
        cotacaoAprovadaFile = await downloadFile(cotacaoAprovada);
      }
      var cotacoesFileList = await downloadFiles(cotacoes);
      pdfFiles.addAll(cotacoesFileList);

      isPdfLoading = false;
    } catch (e) {
      logger.e(e);
      isPdfLoading = false;
    }
  }

  @action
  Future<List<File>> downloadFiles(List<dynamic> urls) async {
    List<File> downloadedFiles = [];

    try {
      final tempDir = await getTemporaryDirectory();

      for (String url in urls) {
        // Faz o download de cada PDF
        final response = await Dio()
            .get(url, options: Options(responseType: ResponseType.bytes));

        if (response.statusCode == 200) {
          // Gera um caminho único para salvar cada arquivo PDF
          final fileName = path.basename(url); // Usa o nome original do arquivo
          final filePath = path.join(tempDir.path, fileName);

          // Salva o PDF como um arquivo
          final file = File(filePath);
          downloadedFiles.add(await file.writeAsBytes(response.data));
        } else {
          throw Exception("Falha ao baixar o PDF de $url");
        }
      }
    } catch (e) {
      logger.e('Erro ao baixar os PDFs: $e');
      rethrow;
    }

    return downloadedFiles;
  }

  @action
  Future<File> downloadFile(String url) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();

        final filePath = path.join(tempDir.path, 'cotacao.pdf');

        final file = File(filePath);
        return file.writeAsBytes(response.data);
      } else {
        throw Exception("Falha ao baixar o PDF");
      }
    } catch (e) {
      logger.e('Erro ao baixar o PDF: $e');
      rethrow;
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
