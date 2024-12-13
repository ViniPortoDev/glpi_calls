import 'package:app_glpi_ios/app/modules/profile/profile_store.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';


class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final store = Modular.get<ProfileStore>();
  @override
  void initState() {
    super.initState();
    store.user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    var userColor = getUserColor();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: Observer(
        builder: (_) {
          if (store.user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding:
                const EdgeInsets.only(top: 40, bottom: 20, left: 40, right: 40),
            child: Row(
              children: [
                Stack(children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: CircleAvatar(
                      backgroundColor: userColor[0],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Observer(
                              builder: (context) {
                                if (store.isLoadingImage) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return store.user!.profileImage != null
                                      ? Image.network(
                                          store.user!.profileImage!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.person);
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/novalogo.png',
                                          fit: BoxFit.cover,
                                        );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Container(
                        width: 35,
                        height: 35,
                        //padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: userColor[0],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          //size: 16,
                        ),
                      ),
                      onTap: () async {
                        try {
                          await store.pickImage(context);
                        } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 2),
    content: Text('Erro ao carregar imagem Erro: $e'),
  ),
);

                        }
                      },
                    ),
                  ),
                ]),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.user!.realName + ' ' + store.user!.firstName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'login: ' + store.user!.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Modular.to.pushNamed('/changePassword',
                                  arguments: [store.user]);
                            },
                            child: Text('Alterar Senha',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[600],
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ]),

                    /* SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Modular.to
                              .pushNamed('/changePassword', arguments: [store.user]);
                        },
                        child: Text('Mudar Senha'),
                        style: ElevatedButton.styleFrom(
                          primary: userColor[0],
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ), */
                    /* SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 10), */
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
