import 'package:app_glpi_ios/app/app_module.dart';
import 'package:app_glpi_ios/app/app_widget.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  logger.i('User permission: ${settings.authorizationStatus}');

  OneSignal.initialize('id');

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
