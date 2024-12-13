import 'dart:developer';
import 'dart:io';

import 'package:app_glpi_ios/app/modules/home/home_store.dart';
import 'package:app_glpi_ios/app/shared/models/location.dart';
import 'package:app_glpi_ios/app/shared/utils/custom_dio.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';

import '../../shared/utils/admin_token.dart';
import '../../shared/utils/logger.dart';
import '../../shared/utils/storage.dart';
import 'package:path/path.dart' as Path;

part 'orcamento_form_store.g.dart';
/* class OrcamentoStore = _OrcamentoStoreBase with _$OrcamentoStore; */

class OrcamentoFormStore = OrcamentoFormStoreBase with _$OrcamentoFormStore;

abstract class OrcamentoFormStoreBase with Store {
  @observable
  bool isLoading = false;
  @observable
  bool isImageLoading = false;

  @observable
  bool sendLoading = false;

  @observable
  bool equipLoading = false;

  @observable
  bool isOutroEquipVisible = false;

  @observable
  bool isVisibleCaixa = true;

  @observable
  List<Location> locations = [];

  @observable
  List<String> filiaisName = [];

  @observable
  String? selectedFilialName;

  @observable
  Location? selectedLocationObject;

  @observable
  File? imagemOrcamento;

  @observable
  String? urlImage;

  @observable
  String? selectedSector = 'Selecione o setor';

  @observable
  List<String> sector = [
    'Frente de loja',
    'Recepção',
    'Salão',
    'Recebimento',
    'Outros',
  ];

  @observable
  String? selectedEquip;

  @observable
  List<String> equip = [];

  final HomeStore _homeStore = Modular.get<HomeStore>();

  @action
  Future<dynamic> getTicketDetail() async {
    isLoading = true;
    var token = await getAdminToken();
    var queryParameters = {
      'expand_dropdowns': 'true',
      'range': '0-1000',
    };

    try {
      dio.options.headers['Session-Token'] = token;
      dio.options.headers['Content-Type'] = 'application/json';
      //print(token);
      var response =
          await dio.get('/Entity/', queryParameters: queryParameters);
      if (response.statusCode == 200 || response.statusCode == 206) {
        //print(response.data);

        killAdminSession(token);
        response.data.forEach((element) {
          var location = Location.fromJson(element);
          filiaisName.add(location.name);
          locations.add(location);
        });
        isLoading = false;
        return locations;
      } else {
        killAdminSession(token);
        isLoading = false;
        return false;
      }
    } on DioException catch (e) {
      logger.e(e);
      killAdminSession(token);
      isLoading = false;
      return false;
    }
  }

  @action
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      imagemOrcamento = File(result.files.single.path ?? '');
    }
  }

  @action
  Future<void> pickImage() async {
    sendLoading = true;
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      imagemOrcamento = File(pickedFile.path);
    }
    sendLoading = false;
  }

  @action
  Future<void> uploadImage() async {
    sendLoading = true;

    if (imagemOrcamento != null) {
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now()) +
          DateTime.now().millisecond.toString().padLeft(3, '0');

      String fileName = 'image_$timestamp';

      final usersRef = firebaseStorage.ref().child('orcamento');
      //  usersRef.child(fileName);

      try {
        final putFile =
            await usersRef.child(fileName).putFile(imagemOrcamento!);
        urlImage = await putFile.ref.getDownloadURL();
        sendLoading = false;
      } catch (e) {
        log(e.toString());
        sendLoading = false;
      }
    }
  }

  Future<void> sendFormOrcamento(
      {required String filial,
      required String? caixa,
      required String? patrimonio,
      required int quantidade,
      String? observacao}) async {
    List<String> gerentes = [];
    List<Map<String, dynamic>> gerentesInfo = [];

    var data = {
      // 'input': {
      'autor': _homeStore.user!.name,
      'data': DateTime.now(),
      'filial': filial,
      'setor': selectedSector,
      'equipamento': selectedEquip,
      'caixa': caixa ?? '',
      'patrimonio': patrimonio ?? '',
      'quantidade': quantidade,
      'observacao': observacao ?? '',
      'gerentes': gerentes,
      'gerentes_info': gerentesInfo,
      'status': 'Novo',
      'imageUrl': urlImage,
      //}
    };

    try {
      sendLoading = true;
      for (var location in locations) {
        if (location.name.contains(selectedFilialName!)) {
          selectedLocationObject = location;
        }
      }
      var querySnapshot = await db
          .collection('entidades')
          .doc(selectedLocationObject!.id.toString())
          .get();
      List<dynamic> listGerentes = querySnapshot['gerentes'];
      for (var gerenteMap in listGerentes) {
        gerentes.add(gerenteMap['name']);
        gerentesInfo.add(gerenteMap);
      }
      await db.collection('orcamento').doc().set(data);
      sendLoading = false;
    } on DioException catch (e) {
      log(e.toString());
      sendLoading = false;
    } finally {
      sendLoading = false;
    }
  }

  Future<void> updateOrcamento({
    required String id,
    required String autor,
    required String editor,
    required DateTime dataCriacao,
    required String filial,
    required String? caixa,
    required String? patrimonio,
    required int quantidade,
    String? observacao,
  }) async {
    List<String> gerentes = [];
    List<Map<String, dynamic>> gerentesInfo = [];
    var data = {
      'autor': autor,
      'editor': editor,
      'data': dataCriacao,
      'data_edicao': DateTime.now(),
      'filial': filial,
      'setor': selectedSector,
      'equipamento': selectedEquip,
      'caixa': caixa ?? '',
      'patrimonio': patrimonio ?? '',
      'quantidade': quantidade,
      'observacao': observacao ?? '',
      'gerentes': gerentes,
      'gerentes_info': gerentesInfo,
      'status': 'Novo',
      'imageUrl': urlImage,
    };

    try {
      if (id.isNotEmpty || id != '') {
        sendLoading = true;
        for (var location in locations) {
          if (location.name.contains(selectedFilialName!)) {
            selectedLocationObject = location;
          }
        }
        var querySnapshot = await db
            .collection('entidades')
            .doc(selectedLocationObject!.id.toString())
            .get();
        List<dynamic> listGerentes = querySnapshot['gerentes'];
        for (var gerenteMap in listGerentes) {
          gerentes.add(gerenteMap['name']);
          gerentesInfo.add(gerenteMap);
        }

        await db.collection('orcamento').doc(id).update(data);
        sendLoading = false;
      }
    } on DioException catch (e) {
      log(e.toString());
      sendLoading = false;
    }
    sendLoading = false;
  }

  Future<void> getEquipament(
      {required String currentSector, String? editedEquip}) async {
    equipLoading = true;
    try {
      equipLoading = true;

      var querySnapshot = await db.collection('setor').get();

      equip.clear();
      if (editedEquip != null) {
        equip.add(editedEquip);
      }

      for (var doc in querySnapshot.docs) {
        if (doc['descricao'] == currentSector) {
          var equipMap = doc.data();
          List<dynamic> equipamentos = equipMap['equipamentos'];
          List<String> equipamentosList = List<String>.from(equipamentos);
          equip.addAll(equipamentosList);
          equip = equip.toSet().toList();
          logger.i('Equipamentos do setor $currentSector: $equip');
        }
        // logger.i(equipMap.toString());
      }
      equipLoading = false;
    } catch (e) {
      logger.e('Erro ao buscar setor: $e');
      equipLoading = false;
    }
    equipLoading = false;
  }

  Future<File> urlToFile(String imageUrl) async {
    try {
      isImageLoading = true;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String fileName = Path.basename(imageUrl);
      String fullPath = '$tempPath/$fileName';

      await dio.download(imageUrl, fullPath);
      File file = File(fullPath);
      isImageLoading = false;
      imagemOrcamento = file;
      return file;
    } catch (e) {
      logger.e("Erro ao baixar o arquivo: $e");
      isImageLoading = false;
      rethrow;
    }
  }
}
