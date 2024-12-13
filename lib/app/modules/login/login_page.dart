import 'dart:developer';

import 'package:app_glpi_ios/app/modules/login/login_store.dart';
import 'package:app_glpi_ios/app/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../shared/utils/logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginStore store = Modular.get<LoginStore>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    store.isPasswordVisible = false;
    store.instantiateSharedPreferences();
    OneSignal.Notifications.requestPermission(true).then((value) {
      logger.i('Permissão: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    /*  _emailController.text = 'kemerson';
    _passwordController.text = '1';  */
    /*  _emailController.text = 'teste_app';
    _passwordController.text = '@Elizeu15';  */
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/icons/back.png',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: width > 600 ? 250 : 0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/icons/glpi.png',
                          height: 250,
                          //width: 240,
                        ),
                      ),
                      const SizedBox(height: 1),
                      SizedBox(
                        width: 600,
                        height: 60,
                        child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Usuario',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, informe o usuario';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: 600, // Defina a largura desejada aqui
                        height: 60,
                        child: TextFormField(
                            controller: _passwordController,
                            obscureText: !store.isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Senha',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                child: const Icon(Icons.visibility),
                                onTap: () {
                                  setState(() {
                                    store.isPasswordVisible =
                                        !store.isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, informe a senha';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(height: 16.0),
                      Observer(builder: (_) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  AppColors.primary)),
                          onPressed: store.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await store
                                        .login(_emailController.text,
                                            _passwordController.text)
                                        .then((result) {
                                      result.fold((l) {
                                        log(l.toString());
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Atenção'),
                                                content: Text(l.message),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      if (l.message ==
                                                          'Atualize sua senha!') {
                                                        Modular.to.pushNamed(
                                                            '/changePassword',
                                                            arguments: [
                                                              store.user,
                                                            ]);
                                                      } else {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            });
                                      }, (r) async {
                                        // await store.getCurrentLocation();
                                        Modular.to.pushReplacementNamed('/home',
                                            arguments: [store.user]);
                                      });
                                    });
                                  }
                                },
                          child: SizedBox(
                              width: width * 0.3,
                              child: Center(
                                  child: store.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(color: Colors.white),
                                        ))),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
