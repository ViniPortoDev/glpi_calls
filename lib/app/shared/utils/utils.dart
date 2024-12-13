import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../modules/home/home_store.dart';

Widget basicInfoElement(String label, String value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    ],
  );
}

Widget inLineInfoElement(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    ],
  );
}

Widget buildTicketInfoLabel(String label) {
  return Text(
    "$label: ",
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
  );
}

Widget buildTicketInfo(String value,
    {int maxLines = 4, double fontSize = 14.0}) {
  value = cleanHtmlTags(value);
  return Text(
    value,
    style: TextStyle(
      fontSize: fontSize,
    ),
    maxLines: maxLines,
  );
}

String cleanHtmlTags(String value) {
  var unescape = HtmlUnescape();
  value = unescape.convert(value);
  value = value.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  return value;
}

Widget basicInfoElementDateFormated(String label, DateTime? value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
      value == null
          ? Container()
          : Text(
              DateFormat('dd/MM/yyyy').format(value),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
      value == null
          ? Container()
          : Text(
              DateFormat('HH:mm').format(value),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
    ],
  );
}

Widget inLineFormatedDate(String label, DateTime? value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      value == null
          ? Container()
          : Text(
              DateFormat('dd/MM/yyyy').format(value),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
      value == null
          ? Container()
          : Text(
              DateFormat(' HH:mm').format(value),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
    ],
  );
}

Widget statusElement(String label, String value, Color color) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '$label: ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ],
  );
}

Future<File?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    return File(result.files.single.path ?? '');
  }
  return null;
}

Future<File?> pickImage() async {
  var pickedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 50,
  );
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

List<Color> getUserColor() {
  //1 - Self-service
  //2 - Observador
  //3 - Administrador
  //4 - Super administrador
  //5 - Hotline
  //6 - Tecnico
  //7 - Supervisor
  //10 - Administrador Engenharia
  //11 - Técnico Engenharia
  HomeStore homeStore = Modular.get<HomeStore>();

  switch (homeStore.user!.type) {
    case 1:
      return [
        const Color.fromARGB(255, 0, 55, 255),
        const Color.fromARGB(255, 220, 237, 252)
      ]; // Azul escuro
    case 2:
      return [
        const Color.fromARGB(255, 0, 100, 0),
        const Color.fromARGB(255, 220, 223, 164)
      ]; // Verde musgo
    case 3:
      return [
        const Color.fromARGB(255, 139, 0, 0),
        const Color.fromARGB(255, 255, 180, 180)
      ]; // Vermelho vinho
    case 4:
      return [
        const Color.fromARGB(255, 80, 0, 100),
        const Color.fromARGB(255, 239, 150, 255)
      ]; // Roxo escuro
    case 5:
      return [
        const Color.fromARGB(255, 204, 102, 0),
        const Color.fromARGB(255, 255, 208, 137)
      ]; // Laranja queimado
    case 6:
      return [
        const Color.fromARGB(255, 100, 85, 0),
        const Color.fromARGB(255, 230, 224, 176)
      ]; // Amarelo escuro
    case 7:
      return [
        const Color.fromARGB(255, 139, 0, 70),
        const Color.fromARGB(255, 252, 174, 200)
      ]; // Rosa escuro
    case 10:
      return [
        const Color.fromARGB(255, 80, 60, 0),
        const Color.fromARGB(255, 185, 175, 26)
      ]; // Marrom escuro
    default:
      return [
        const Color.fromARGB(255, 10, 30, 100),
        const Color.fromARGB(255, 176, 229, 245)
      ]; // Azul petróleo
  }
}

String getUserTypeDesc(int type) {
  //1 - Self-service
  //2 - Observador
  //3 - Administrador
  //4 - Super administrador
  //5 - Hotline
  //6 - Tecnico
  //7 - Supervisor
  //10 - Administrador Engenharia
  //11 - Técnico Engenharia
  switch (type) {
    case 1:
      return 'Colaborador';
    case 2:
      return 'Observador';
    case 3:
      return 'Administrador';
    case 4:
      return 'Super administrador';
    case 5:
      return 'Hotline';
    case 6:
      return 'Técnico';
    case 7:
      return 'Supervisor';
    case 10:
      return 'Administrador Engenharia';
    case 11:
      return 'Técnico Engenharia';
    default:
      return 'Colaborador';
  }
}

String getStatusDesc(int status) {
  switch (status) {
    case 1:
      return 'Novo';
    case 2:
      return 'Processando (atribuído)';
    case 3:
      return 'Processando (planejado)';
    case 4:
      return 'Pendente';
    case 5:
      return 'Solucionado';
    case 6:
      return 'Fechado';
    default:
      return 'Pendente';
  }
}

String getUserTypeDescription(int type) {
  switch (type) {
    case 1:
      return 'Colaborador';
    case 2:
      return 'Observador';
    case 3:
      return 'Administrador';
    case 4:
      return 'Super Adm';
    case 5:
      return 'Hotliner';
    case 6:
      return 'Técnico';
    case 7:
      return 'Supervisor';
    case 9:
      return 'Gestor';
    case 10:
      return 'Administrador Engenharia';
    case 11:
      return 'Técnico Engenharia';
    default:
      return 'Colaborador';
  }
  //1 - Self-service
  //2 - Observador
  //3 - Administrador
  //4 - Super administrador
  //5 - Hotline
  //6 - Tecnico
  //7 - Supervisor
  //10 - Administrador Engenharia
  //11 - Técnico Engenharia
}
