import 'dart:convert';

import 'package:app_glpi_ios/app/shared/utils/custom_dio.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:dio/dio.dart';

Future<String> getAdminToken() async {
  String adminToken = '';
  try {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode(''))}';
    dio.options.headers['Session-Token'] = null;
    dio.options.headers['Authorization'] = basicAuth;
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.listFormat = ListFormat.multiCompatible;
    var response = await dio.post('/initSession?get_full_session=true');
    if (response.statusCode == 200) {
      adminToken = response.data['session_token'];
      dio.options.headers['Authorization'] = null;
    } else {}
  } on Exception catch (e) {
    logger.e(e);
  }
  return adminToken;
}

Future<void> killAdminSession(adminToken) async {
  try {
    dio.options.headers['Session-Token'] = adminToken;
    await dio.get('/killSession');
  } on Exception catch (e) {
    logger.e(e);
  }
}
