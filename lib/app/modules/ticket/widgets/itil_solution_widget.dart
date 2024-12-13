import 'package:app_glpi_ios/app/shared/models/ticket.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../ticket_store.dart';

Widget itilSolutionWidget(
    dynamic entity,
    Function respondSolution,
    Ticket ticket,
    User user,
    Function notify,
    BuildContext context,
    TicketStore store) {
  //print(entity);
  if (entity.length > 0) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
          children: List.generate(entity.length, (index) {
        return Column(children: [
                  const Divider(),
                  Column(children: [
                          Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Solução: #${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                          ),
                          Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    cleanHtmlTags(entity[index]['content']),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                          ),
                          const SizedBox(
                  height: 2,
                          ),
                          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_month, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'Data de envio:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(entity[index]['date_creation'])),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      DateFormat(' HH:mm')
                          .format(DateTime.parse(entity[index]['date_creation'])),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'Técnico:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entity[index]['users_id']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                          ),
                          ]),
                  const SizedBox(
        height: 8,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        entity[index]['status'] == 2 //Aguardando aprovação
                            ? Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.timer, size: 16),
                                      SizedBox(width: 6),
                                      Text(
                                        'Aguardando aprovação',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (ticket.userCreation == user.name) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                    
                  
                                          Observer(builder: (context) {
                                            if (store.isSolucionarLoading) {
                                              return const CircularProgressIndicator();
                                            } else {
                                              return ElevatedButton(
                                                onPressed: () async {
                                                  var result = await respondSolution(
                                                      entity[index]['id'],
                                                      ticket.id,
                                                      true);
                                                  if (result) {
                                                    entity[index]['status'] = 3;
                                                    entity[index]['date_approval'] =
                                                        DateTime.now().toString();
                                                    entity[index]
                                                            ['users_id_approval'] =
                                                        user.name;
                                                    notify();
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Aprovado'),
                                                            content: const Text(
                                                                'Solução aprovada com sucesso!'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text('Fechar'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Erro'),
                                                            content: const Text(
                                                                'Erro ao aprovar solução!'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text('Fechar'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: getUserColor()[0],
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(32.0),
                                                  ),
                                                ),

                                                child: const Text('Aprovar'),
                                              );
                                            }
                                          }),
                                          ElevatedButton(
                                            onPressed: () async {
                                              var result = await respondSolution(
                                                  entity[index]['id'],
                                                  ticket.id,
                                                  false);
                                              if (result) {
                                                entity[index]['status'] = 4;
                                                entity[index]['date_approval'] =
                                                    DateTime.now().toString();
                                                entity[index]['users_id_approval'] =
                                                    user.name;
                                                notify();
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Recusado'),
                                                        content: const Text(
                                                            'Solução recusada com sucesso!'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text('Fechar'),
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Erro'),
                                                        content: const Text(
                                                            'Erro ao recusar solução!'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text('Fechar'),
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: getUserColor()[0],
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                            ),
                                            child: const Text('Recusar'),
                                          ),
                                        ])
                                  ]
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                    const Text(
                                      'Status:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    entity[index]['status'] == 3
                                        ? const Icon(Icons.check_circle,
                                            size: 16, color: Colors.green)
                                        : const Icon(Icons.timer,
                                            size: 16, color: Colors.red),
                                    const SizedBox(width: 6),
                                    Text(
                                      entity[index]['status'] == 3
                                          ? 'Aprovado'
                                          : 'Recusado',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ]),
                        const SizedBox(
                          height: 4,
                        ),
                        entity[index]['status'] !=
                                2 //Diferente de "Aguardando aprovação"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Data d${entity[index]['status'] == 3 ? 'a aprovação' : 'e recusa'}:',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                          entity[index]['date_approval'])),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      DateFormat(' HH:mm').format(DateTime.parse(
                                          entity[index]['date_approval'])),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                                  Row(children: [
                                    const SizedBox(width: 10),
                                    const Icon(Icons.person, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${entity[index]['users_id_approval']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ]),
                                ],
                              )
                            : Container(),
                      ]),
                ]);
      })),
    );
  } else {
    return const Text('Sem informacoes');
  }
}
