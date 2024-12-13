import 'package:app_glpi_ios/app/shared/utils/custom_dio.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:dio/dio.dart';

Future<bool> sendPushNotification(String title, String content,
    List externalIds, String notificationType) async {
  try {
    var data = {
      "app_id": "id",
      "name": notificationType,
      "include_aliases": {"external_id": externalIds},
      "target_channel": "push",
      "contents": {"en": content},
      "headings": {"en": title},
      "priority": 10,
    };
    dioPush.options.headers['Authorization'] =
        'Bearer ';
    dioPush.options.headers['Content-Type'] = 'application/json';
    var response = await dioPush.post('/notifications', data: data);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } on DioException catch (e) {
    logger.e('Erro ao enviar notificação');
    logger.e(e);
    return false;
  }
}
