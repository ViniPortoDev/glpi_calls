import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'change_password_store.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;
  const ChangePasswordPage({super.key, required this.user});
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ChangePasswordStore store = Modular.get<ChangePasswordStore>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> orcFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    store.user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*       appBar: AppBar(
        title: Text('Alterar senha'),
      ), */
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 100),
                const Text('Alteração de senha',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Image.asset(
                  'assets/icons/glpi.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  'Insira uma nova senha para o usuário ${widget.user.name}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Form(
                  key: orcFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 600,
                        height: 60,
                        child: TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Nova Senha',
                              prefixIcon: Icon(Icons.key),
                            ),
                            obscureText: true,
                            obscuringCharacter: '+',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe a nova senha';
                              }
                              return null;
                            }),
                      ),
                      const SizedBox(height: 20),
                       SizedBox(
                        width: 600,
                        height: 60,
                        child: TextFormField(
                            controller: confirmPasswordController,
                            decoration: const InputDecoration(
                              hintText: 'Confirme a nova senha',
                              prefixIcon: Icon(Icons.key),
                            ),
                            obscureText: true,
                            obscuringCharacter: '+',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirme a nova senha';
                              }
                              if (value != passwordController.text) {
                                return 'As senhas não conferem';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              orcFormKey.currentState!.validate();
                            }),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (orcFormKey.currentState!.validate()) {
                            var result = await store
                                .changePassword(passwordController.text);
                            if (result) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                      padding: const EdgeInsets.all(20),
                                      child:
                                          const Text('Senha alterada com sucesso!'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Modular.to
                                              .pushReplacementNamed('/login');
                                        },
                                        child: const Text('OK'),
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
                                    title: const Text('Erro ao alterar a senha!'),
                                    content: const Text(
                                        'Verifique sua identidade usando a senha atual e tente novamente.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Modular.to
                                              .pushReplacementNamed('/login');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: const Text('Alterar senha'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
