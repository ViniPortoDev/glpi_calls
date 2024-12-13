import 'package:app_glpi_ios/app/modules/home/widgets/ticket_card.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/fab_column.dart';
import 'package:app_glpi_ios/app/shared/app_colors.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:app_glpi_ios/app/shared/utils/status.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:app_glpi_ios/app/shared/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeStore store = Modular.get<HomeStore>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool openFab = true;
  List<Widget> buttons = <Widget>[];
  late Color secColor;
  late Color secColor0;
  @override
  void initState() {
    super.initState();
    store.user = widget.user;
    //store.getIds();
    store.instantiateSharedPreferences();
    store.prepareDropdownItems();
    store.getTicketsByUser();
    secColor = getUserColor()[1];
    secColor0 = getUserColor()[0];

    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    }); */
  }

  String getStatusLabel(int status, int userType) {
    switch (status) {
      case 1:
        return 'Chamados Novos';
      case 2:
        if (userType == 6) {
          return 'Chamados em Atendimento';
        }
        return 'Técnico resolvendo';
      case 3:
        return 'Aguardando Técnico';
      case 4:
        return 'Com pendências';
      case 5:
        return 'Solucionados';
      case 6:
        return 'Ultimos Chamados Concluídos';
      default:
        return 'Pendente';
    }
  }

  _mountButtons() {
    buttons = <Widget>[];
    buttons.add(
      ActionButton(
        text: 'Sair',
        onPressed: () {
          store.logout();
          Modular.to.pushReplacementNamed('/login');
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        color: secColor0,
      ),
    );
    buttons.add(
      ActionButton(
        text: 'Orçamento',
        onPressed: () {
          Modular.to.pushNamed('/orcamento', arguments: widget.user);
        },
        icon: const Icon(Icons.attach_money, color: Colors.white),
        color: secColor0,
      ),
    );

    buttons.add(
      ActionButton(
        text: 'Novo Chamado',
        onPressed: () {
          Modular.to.pushNamed('/newticket',
              arguments: [store.user!, store.selectedEntity!['id']]);
        },
        icon: const Icon(Icons.add, color: Colors.white),
        color: secColor0,
      ),
    );
  }

  bool serviceEnabled = false;

  @override
  Widget build(BuildContext context) {
    String userName = '${store.user!.firstName} ${store.user!.realName}';
    if (userName.trim() == '') {
      userName = store.user!.name;
    }

    _mountButtons();

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ExpandableFabColumn(
        distance: 50,
        //distance: buttons.length * 15.0,
        backgroundColor: Colors.white,
        foregroundColor: secColor0,
        isExpanded: openFab,
        children: buttons,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          //return await store.getIds();
          return await store.getTicketsByUser();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Modular.to.pushNamed('/profile',
                                  arguments: [store.user!]);
                            },
                            child: CircleAvatar(
                                radius: 25,
                                backgroundColor: secColor,
                                child: store.user!.profileImage == null ||
                                        store.user!.profileImage == ""
                                    ? Text(
                                        userName[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              store.user!.profileImage!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      )),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(children: [
                                store.dropdownProfiles.length > 1
                                    ? DropdownButton<Map<String, dynamic>>(
                                        value: store.selectedProfile,
                                        items: store.dropdownProfiles
                                            .map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: value,
                                            child: Text(
                                              getUserTypeDescription(
                                                  value['id']),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged:
                                            (Map<String, dynamic>? value) {
                                          setState(() {
                                            logger.i('Profile: $value');
                                            store.user!.type = value!['id'];
                                            store.selectedProfile = value;
                                            store.changeProfile(value['id']);
                                            secColor = getUserColor()[1];
                                            secColor0 = getUserColor()[0];
                                            store.getTicketsByUser();
                                          });
                                        })
                                    : Text(
                                        getUserTypeDescription(
                                            store.user!.type),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                const SizedBox(width: 16),
                                store.dropdownEntities.length > 1
                                    ? DropdownButton<Map<String, dynamic>>(
                                        value: store.selectedEntity,
                                        items: store.dropdownEntities
                                            .map((Map<String, dynamic> value) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: value,
                                            child: Text(
                                              value['name'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged:
                                            (Map<String, dynamic>? value) {
                                          logger.i('Entity: $value');
                                          setState(() {
                                            store.selectedEntity = value;
                                            store.getTicketsByUser();
                                          });
                                        })
                                    : Text(
                                        store.dropdownEntities[0]['name'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                              ]),
                              store.user!.type > 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Row(
                                        children: [
                                          const Text('Nº de Chamados:',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          const SizedBox(width: 8),
                                          Observer(builder: (_) {
                                            return Container(
                                              margin: const EdgeInsets.all(2),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 100, 100, 150),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                store.qtdTickets.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          })
                                        ],
                                      ))
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) {
              return store.isLoading
                  ? Center(
                      //heightFactor: 10,
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(store.statusMessage),
                          ),
                        ],
                      ),
                    )
                  : store.ticketMap.isEmpty
                      ? Center(
                          //heightFactor: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              const Text(
                                  'Não há chamados. Para abrir um novo, clique no botão abaixo.'),
                              const SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Modular.to.pushNamed('/newticket',
                                      arguments: [
                                        store.user!,
                                        store.selectedEntity!['id']
                                      ]);
                                },
                                child: const Text('Novo Chamado'),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  store.getTicketsByUser();
                                },
                                child: const Text('Atualizar'),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: store.ticketMap.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getStatusLabel(
                                              store.ticketMap[index].keys
                                                  .elementAt(0),
                                              widget.user.type,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(2),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: status[store
                                                  .ticketMap[index].keys
                                                  .elementAt(0)]!['color'],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              store
                                                  .ticketMap[index][store
                                                      .ticketMap[index].keys
                                                      .elementAt(0)]!
                                                  .length
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: getUserColor()[0],
                                      thickness: 2,
                                      height: 1,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                    SizedBox(
                                      height: 225,
                                      child: ListView.builder(
                                        shrinkWrap: false,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: store
                                            .ticketMap[index][store
                                                .ticketMap[index].keys
                                                .elementAt(0)]!
                                            .length,
                                        itemBuilder: (context, index2) {
                                          return TicketCard(
                                            ticket: store.ticketMap[index][store
                                                .ticketMap[index].keys
                                                .elementAt(0)]![index2],
                                            user: store.user!,
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }
}
