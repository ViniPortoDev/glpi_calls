import 'dart:convert';
import 'dart:io';

import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});
  @override
  InitPageState createState() => InitPageState();
}

class InitPageState extends State<InitPage> {
  late final SharedPreferences storage;
  bool _loading = false;
  _instantiateSharedPreferences() async {
    storage = await SharedPreferences.getInstance();
  }

  _checkLogged() async {
    try {
      var userString = storage.getString('user');
      if (userString != null) {
        var user = User.fromJson2(jsonDecode(userString));
        if (user.passwordExpiresAt == null ||
            user.passwordExpiresAt!.isBefore(DateTime.now())) {
          Modular.to.pushReplacementNamed('/changePassword', arguments: [user]);
          return;
        }
        OneSignal.login(user.id.toString());
        Modular.to.pushReplacementNamed('/home', arguments: [user]);
      } else {
        Modular.to.pushReplacementNamed('/login');
      }
    } catch (e) {
      logger.e(e);
      _loading = false;
      Modular.to.pushReplacementNamed('/login');
    }
  }

  Future<String> _getVersion() async {
    var version = '';
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });
    return version;
  }

  _checkVersionFirestore() async {
    _loading = true;
    try {
      final versionData = db.collection('version');
      final query = versionData
          .where('valid', isEqualTo: true)
          .orderBy('releaseDate', descending: true)
          .limit(1);
      final querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        final version = querySnapshot.docs[0].data();
        final currentVersion = await _getVersion();
        // if (currentVersion != version['version']) {

        if (version['version'] != '1.1.8') {
          setState(() {
            _loading = false;
          });
          if (Platform.isIOS) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Nova versão disponível'),
                  content: const Text(
                      'Uma nova versão do aplicativo está disponível. Contate o suporte'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _checkLogged();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Nova versão disponível'),
                  content: const Text(
                      'Uma nova versão do aplicativo está disponível. Deseja atualizar?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Atualizar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _launchURL(version['file_location']);
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          _checkLogged();
        }
      }
    } catch (e) {
      _loading = false;
      logger.e(e);
    }
  }

  Future<void> _launchURL(String url) async {
    // const url = 'https://flutter.dev';
    var uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Nao foi possível abrir o link');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkVersionFirestore();
    _instantiateSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: avoid_unnecessary_containers
            Container(
              child: Image.asset(
                'assets/icons/glpi.png',
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      _checkVersionFirestore();
                    },
                    child: const Text('Verificar atualizações'),
                  ),
          ],
        ),
      ),
    );
  }
}
