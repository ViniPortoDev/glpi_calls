import 'dart:developer';

import 'package:app_glpi_ios/app/modules/orcamento/orcamento_store.dart';
import 'package:app_glpi_ios/app/modules/orcamento/widget/orcamento_card_widget.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/status_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../shared/utils/send_notification.dart';
import '../../shared/utils/utils.dart';

class OrcamentoPage extends StatefulWidget {
  const OrcamentoPage({super.key});
  @override
  State<OrcamentoPage> createState() => _OrcamentoPageState();
}

class _OrcamentoPageState extends State<OrcamentoPage> {
  late final OrcamentoStore store;
  User user = Modular.args.data;
  int selectedToggleIndex = 0; // 0 = Pendentes, 1 = Concluídos

  @override
  void initState() {
    super.initState();
    store = Modular.get<OrcamentoStore>();
    store.getOrcamentos(user);
  }

  Future<void> _navegarParaDetalhes(int index) async {
    Object? result;
    if ((user.type == 3 || user.type == 4) &&
        store.orcamentoList[index].status == 'Aguardando Faturamento') {
      try {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Atenção'),
              content: Container(
                padding: const EdgeInsets.all(20),
                child: const Text('A cotação foi faturada?'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  child: const Text('Não'),
                ),
                TextButton(
                  onPressed: () async {
                    await store
                        .getNotificationsIds(store.orcamentoList[index].autor);

                    store.orcamentoList[index].status = 'Aguardando Entrega';
                    await store.updateOrcamento(
                        store.orcamentoList[index].id, 'Aguardando Entrega');
                    ScaffoldMessenger.of(context).showSnackBar(
                     const  SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Cotação faturado com sucesso!'),
                      ),
                    );
                    if (store.orcamentoList[index].gerentesInfo.isNotEmpty) {
                      for (var gerenteInfoMap
                          in store.orcamentoList[index].gerentesInfo) {
                        store.notificationsIds.add(gerenteInfoMap['glpiId']);
                      }
                    }
                    await sendPushNotification(
                        'O orçamento de ${store.orcamentoList[index].filial} foi faturado com sucesso!',
                        'Item ${store.orcamentoList[index].equipamento} atualizou o status para Aguardando Entrega.',
                        store.notificationsIds,
                        'Orçamento - Aguardando Faturamento');

                    result = Modular.to.popAndPushNamed(
                      '/receipt',
                      arguments: store.orcamentoList[index],
                    );
                    if (result == true) {
                      await store.getOrcamentos(user);
                    }
                  },
                  child: const Text('Sim'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
    if ((user.type == 3 ||
            user.type == 4 ||
            store.orcamentoList[index].gerentes.contains(user.name)) &&
        store.orcamentoList[index].status == 'Aguardando Entrega') {
      log(store.orcamentoList[index].status);
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                  'Importe a nota fiscal e o boleto do orçamento faturado'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  result = Modular.to.popAndPushNamed(
                    '/receipt',
                    arguments: store.orcamentoList[index],
                  );
                  if (result == true) {
                    await store.getOrcamentos(user);
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
    result = await Modular.to.pushNamed(
      '/orcamento_details',
      arguments: [
        store.orcamentoList[index],
        user,
        store.isContabilUser,
      ],
    );
    if (result == true) {
      await store.getOrcamentos(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color userColor1 = getUserColor()[1];

    // Função para filtrar orçamentos com base no índice do ToggleSwitch
    List<dynamic> filteredOrcamentos() {
      if (selectedToggleIndex == 1) {
        // Mostrar orçamentos concluídos
        return store.orcamentoList
            .where((orcamento) => orcamento.status == 'Concluído')
            .toList();
      } else {
        // Mostrar orçamentos pendentes
        return store.orcamentoList
            .where((orcamento) => orcamento.status != 'Concluído')
            .toList();
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: userColor1,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          final result = await Modular.to.pushNamed('/orcamento_form',
          arguments: [null, user],
          );
          if (result == true) {
            store.getOrcamentos(user);
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: userColor1,
        title: const Text('Orçamentos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ToggleSwitch(
                initialLabelIndex: selectedToggleIndex,
                totalSwitches: 2,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey[300],
                inactiveFgColor: Colors.black,
                activeBgColors: const [
                  [Colors.lightBlue],
                  [Colors.green]
                ],
                labels: const ['Pendentes', 'Concluídos'],
                icons: const [Icons.pending_actions, Icons.check_circle],
                customTextStyles: const [
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ],
                minHeight: 60,
                minWidth: MediaQuery.of(context).size.width * 0.4,
                onToggle: (index) {
                  setState(() {
                    selectedToggleIndex = index!;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Observer(
                  builder: (_) => store.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: filteredOrcamentos().isEmpty
                              ? [
                                   SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: const Center(
                                      child: Text(
                                        'Sem orçamentos!',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ]
                              : List.generate(
                                  filteredOrcamentos().length,
                                  (index) {
                                    DateTime dateTime =
                                        filteredOrcamentos()[index].data;
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(dateTime);

                                    return OrcamentoCardWidget(
                                      filial:
                                          filteredOrcamentos()[index].filial,
                                      equipamento: filteredOrcamentos()[index]
                                          .equipamento,
                                      autor: filteredOrcamentos()[index].autor,
                                      data: formattedDate,
                                      urlImage:
                                          filteredOrcamentos()[index].imageUrl,
                                      status:
                                          filteredOrcamentos()[index].status,
                                      statusColor: getStatusColor(
                                          filteredOrcamentos()[index].status),
                                      onTap: () => _navegarParaDetalhes(index),
                                    );
                                  },
                                ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
