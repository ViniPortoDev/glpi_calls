import 'dart:async';
import 'package:app_glpi_ios/app/modules/ticket/ticket_store.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/fab_column.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/itil_followup_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/change_ticket_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/document_item_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/item_ticket_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/itil_solution_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/problem_ticket_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/ticket_cost_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/ticket_task_widget.dart';
import 'package:app_glpi_ios/app/modules/ticket/widgets/ticket_validation_widget.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:app_glpi_ios/app/shared/utils/translate_pt_br.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:app_glpi_ios/app/shared/utils/status.dart';
import 'package:app_glpi_ios/app/shared/utils/urgency.dart';
import 'package:app_glpi_ios/app/shared/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:app_glpi_ios/app/shared/models/ticket.dart';
import 'package:intl/intl.dart';
import 'widgets/entity_widget.dart';

class TicketPage extends StatefulWidget {
  final User user;
  final Ticket ticket;

  const TicketPage({
    super.key,
    required this.user,
    required this.ticket,
  });

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  TicketStore store = Modular.get<TicketStore>();
  @override
  void initState() {
    super.initState();
    store.ticket = widget.ticket;
    store.user = widget.user;
    store.getTicketDetails();
  }

  Widget sessionWidget(
      String entity, dynamic data, double width, BuildContext context) {
    //print(entity);
    switch (entity) {
      case 'Location':
        return EntityWidget(entity: data);
      case 'Document_Item':
        store.getDocumentList(data);
        return DocumentItemWidget(
            entity: data, documentList: store.documentList);
      case 'TicketTask':
        return ticketTaskWidget(data, store.editTicketTask, widget.ticket.id,
            widget.user.type, refresh);
      case 'TicketValidation':
        return ticketValidationWidget(data);
      case 'TicketCost':
        return ticketCostWidget(data);
      case 'Problem_Ticket':
        return problemTicketWidget(data);
      case 'Change_Ticket':
        return changeTicketWidget(data);
      case 'Item_Ticket':
        return itemTicketWidget(data);
      case 'ITILSolution':
        return itilSolutionWidget(data, store.respondSolution, widget.ticket,
            widget.user, refresh, context, store);
      case 'ITILFollowup':
        return ItilFollowupWidget(
          entity: data,
          user: widget.user,
          width: width,
          callback: store.addFollowup,
          ticketId: widget.ticket.id,
          notifyParent: refresh,
        );
      default:
        return Container();
    }
  }

  refresh() {
    setState(() {});
  }

  List<Widget> getMenuOptionsByUserTypeAndTicketStatus(
      int userType, int ticketStatus) {
    var enviarMensagem = ActionButton(
      text: 'Enviar Mensagem',
      icon: const Icon(Icons.message),
      onPressed: () async {
        _showMessageDialog();
      },
      color: getUserColor()[0],
    );
    var anexarArquivo = ActionButton(
      text: 'Anexar Documento',
      icon: const Icon(Icons.attach_file),
      onPressed: () async {
        if (store.user!.sessionToken!.isEmpty) {
          store.user!.sessionToken = await store.getUserToken();
        }
        var result = await Modular.to.pushNamed('/upload', arguments: [
          widget.ticket,
          widget.user,
          store.user!.sessionToken,
        ]);
        if (result == true) {
          store.getTicketDetails();
        }
      },
      color: getUserColor()[0],
    );
    /* var _repovarSolucao = ActionButton(
      text: 'Reprovar Solução',
      icon: Icon(Icons.close),
      onPressed: () async {
        for (var detail in store.ticketDetails) {
          if (detail['rel'] == 'ITILSolution') {
            for (var solution in detail['data']) {
              if (solution['status'] == 2) {
                await store
                    .respondSolution(solution['id'], widget.ticket.id, false)
                    .then((value) => {
                          if (value == true)
                            {
                              setState(() {
                                solution['status'] = 4;
                                solution['content'] = solution['content'] +
                                    '\n\nReprovado por ${widget.user.name}';
                                solution['users_id_approval'] =
                                    widget.user.name;
                                solution['date_approval'] =
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(DateTime.now());
                              }),
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Solução reprovada.'),
                                ),
                              )
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Erro ao reprovar solução,Tente novamente.'),
                                ),
                              )
                            }
                        });
                return;
              }
            }
          }
        }
      },
      color: getUserColor()[0],
    );
    var _aprovarSolucao = ActionButton(
      text: 'Aprovar Solução',
      icon: Icon(Icons.check),
      onPressed: () async {
        for (var detail in store.ticketDetails) {
          if (detail['rel'] == 'ITILSolution') {
            for (var solution in detail['data']) {
              if (solution['status'] == 2) {
                //await _showValidationDialog();
                await store.respondSolution(
                    solution['id'], widget.ticket.id, true);
                setState(() {
                  solution['status'] = 3;
                  solution['content'] = solution['content'] +
                      '\n\nAprovado por ${widget.user.name}';
                  solution['users_id_approval'] = widget.user.name;
                  solution['date_approval'] =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Solução aprovada.'),
                  ),
                );
                return;
              }
            }
          }
        }
      },
      color: getUserColor()[0],
    ); */
//================== NÃO APAGAR ==================
    /* var _criarTarefa = ActionButton(
      text: 'Criar Tarefa',
      icon: Icon(Icons.add_task),
      onPressed: () async {
        // Chame o método para exibir a Dialog
        await _showCreateTaskDialog();
      },
      color: getUserColor()[0],
    ); */
    /* var _criarSolicitacao = ActionButton(
      text: 'Criar Solicitação',
      icon: Icon(Icons.add_circle),
      onPressed: () async {},
      color: getUserColor()[0],
    ); */
    var solucionar = ActionButton(
      text: 'Solucionar',
      icon: const Icon(Icons.check_circle),
      onPressed: () async {
        // Chame o método para exibir a Dialog
        await _showValidationDialog();
      },
      color: getUserColor()[0],
    );
    var atribuirTecnico = ActionButton(
      text: 'Atribuir Técnico',
      icon: const Icon(Icons.person_add_alt),
      onPressed: () async {
        bool isEngenharia = widget.ticket.category.contains('ENGENHARIA >');

        bool isAdm = widget.user.type == 3 ||
            widget.user.type == 4 ||
            widget.user.type == 10;
        await store
            .getAllTechnicians(
              isAtribuir: true,
              isEscalar: false,
              isEngenharia: isEngenharia,
              isAdm: isAdm,
            )
            .then((value) => {
                  if (value == true)
                    {
                      _showAssignTechDialog(),
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao carregar usuários.'),
                        ),
                      )
                    }
                });
      },
      color: getUserColor()[0],
    );

    var scaleTicket = ActionButton(
      text: 'Escalar Chamado',
      icon: const Icon(Icons.arrow_upward),
      onPressed: () async {
        bool isEngenharia = widget.ticket.category.contains('ENGENHARIA >');

        await store
            .getAllTechnicians(
              isAtribuir: false,
              isEscalar: true,
              isEngenharia: isEngenharia,
            )
            .then((value) => {
                  if (value == true)
                    {
                      _showAssignTechDialog(change: true),
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao carregar usuários.'),
                        ),
                      )
                    }
                });
      },
      color: getUserColor()[0],
    );

    List<Widget> menuOptions = [];
    if (userType == 1) {
      if (ticketStatus == 1 || ticketStatus == 2) {
        menuOptions.add(enviarMensagem);
        menuOptions.add(anexarArquivo);
      }
      if (ticketStatus == 5) {
        //menuOptions.add(_repovarSolucao);
        //menuOptions.add(_aprovarSolucao);
      }
    }
    if (userType == 3 || userType == 4 || userType == 7 || userType == 10) {
      if (ticketStatus == 1) {
        menuOptions.add(atribuirTecnico);
      }
      if (ticketStatus == 2) {
        menuOptions.add(scaleTicket);
      }
      if (ticketStatus == 1 || ticketStatus == 2 || ticketStatus == 4) {
        menuOptions.add(enviarMensagem);
        menuOptions.add(anexarArquivo);
        /*  menuOptions.add(_criarTarefa); */
        /* menuOptions.add(_criarSolicitacao); */
        menuOptions.add(solucionar);
      }
    }
    if (userType == 6 || userType == 11) {
      if (ticketStatus == 2) {
        menuOptions.add(scaleTicket);
      }
      if (ticketStatus == 2 || ticketStatus == 4) {
        menuOptions.add(enviarMensagem);
        menuOptions.add(anexarArquivo);
        /*      menuOptions.add(_criarTarefa); */
        /*      menuOptions.add(_criarSolicitacao); */
        menuOptions.add(solucionar);
      }
    }
    return menuOptions;
  }

  Widget sessionTitle(String title, dynamic data) {
    if (title == 'ITILSolution') {
      for (var solution in data) {
        if (solution['status'] == 2 &&
            widget.user.name == widget.ticket.userCreation) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslatePtBr(text: (title)).translate,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Icon(Icons.notifications_active_rounded,
                  color: getUserColor()[0], size: 18),
            ],
          );
        }
      }
    }
    return Text(
      TranslatePtBr(text: (title)).translate,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Widget spaceBetween = const SizedBox(height: 12);
    //var mainColor = getUserColor(widget.user.type)[0];
    var secColor = getUserColor()[1];
    var entityString = widget.ticket.entity != null
        ? widget.ticket.entity!.split('>').last
        : '';
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      floatingActionButton: ExpandableFabColumn(
        distance: 150.0,
        backgroundColor: getUserColor()[1],
        foregroundColor: getUserColor()[0],
        isExpanded: false,
        children:  [
          ActionButton(
            text: 'Voltar',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: getUserColor()[0],
          ),
          ...getMenuOptionsByUserTypeAndTicketStatus(
            widget.user.type,
            widget.ticket.status,
          ),
        ],
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20.0),
        physics: const ScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Chamado #${widget.ticket.id.toString()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //inLineFormatedDate('Aberto em', widget.ticket.dateCreation),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(widget.ticket.dateCreation),
                        style:const  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        DateFormat(' HH:mm').format(widget.ticket.dateCreation),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        widget.ticket.userCreation,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  //inLineInfoElement('Usuário', widget.ticket.userCreation),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  statusElement(
                    'Status',
                    status[widget.ticket.status]!['name'],
                    status[widget.ticket.status]!['color'],
                  ),
                  const SizedBox(width: 16),
                  statusElement(
                    'Urgência',
                    urgency[widget.ticket.urgency]!['name'],
                    urgency[widget.ticket.urgency]!['color'],
                  ),
                ],
              ),
              if (widget.ticket.status == 2 &&
                  widget.ticket.timeToResolve != null) ...[
                const SizedBox(height: 6),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tempo para solução: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    CountdownTimer(
                      endTime:
                          widget.ticket.timeToResolve!.millisecondsSinceEpoch,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      endWidget: const Text(
                        'Este chamado ultrapassou o tempo de resolução.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              //Ticket Info Session
              Material(
                  color: secColor,
                  elevation: 4,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                      width: width - 32,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTicketInfoLabel('Prolema'),
                          buildTicketInfo(widget.ticket.name),
                          spaceBetween,
                          buildTicketInfoLabel('Descrição'),
                          Text(
                            cleanHtmlTags(widget.ticket.content),
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          spaceBetween,
                          buildTicketInfoLabel('Categoria'),
                          buildTicketInfo(widget.ticket.category),
                          spaceBetween,
                          Row(
                                                      children: [
                          buildTicketInfoLabel('Local'),
                          buildTicketInfo(entityString),
                                                      ],
                                                    ),
                        ],
                      ))),
              const SizedBox(height: 12),
              Observer(builder: (_) {
                if (store.isLoadingDetails) {
                  return Center(
                      child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      Text(store.loadingMessage),
                    ],
                  ));
                } else {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: store.ticketDetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Material(
                            color: secColor,
                            elevation: 4,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: width - 32,
                              padding: const EdgeInsets.all(8.0),
                              child: Observer(builder: (_) {
                                return ExpansionTile(
                                    onExpansionChanged: (value) {},
                                    title: sessionTitle(
                                        store.ticketDetails[index]['rel'],
                                        store.ticketDetails[index]['data']),
                                    /* Text(widget.ticket.links![index]
                                        ['rel'] ??
                                    'Sem nome'), */
                                    children: store.ticketDetails[index]
                                                ['data'] ==
                                            null
                                        ? [
                                            const Center(
                                                child: Text('Sem informações')),
                                          ]
                                        : [
                                            sessionWidget(
                                                store.ticketDetails[index]
                                                    ['rel'],
                                                store.ticketDetails[index]
                                                    ['data'],
                                                width,
                                                context),
                                          ]);
                              }),
                            ),
                          ),
                        );
                      });
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showValidationDialog() async {
    TextEditingController commentController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Adicionar Solução',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Digite seu comentário...',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        await store
                            .validacaoTicketWithComment(
                              widget.ticket.id,
                              commentController.text,
                            )
                            .then((value) => {
                                  if (value == true)
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Solução Adicionada'),
                                            content: const Text(
                                                'Sua solução foi adicionada com sucesso.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      setState(() {
                                        var detailFound = false;
                                        for (var detail
                                            in store.ticketDetails) {
                                          if (detail['rel'] == 'ITILSolution') {
                                            detail['data'].add({
                                              'content': commentController.text,
                                              'date_creation':
                                                  DateTime.now().toString(),
                                              'users_id': widget.user.name,
                                              'status': 2,
                                            });
                                            detailFound = true;
                                          }
                                        }
                                        if (!detailFound) {
                                          store.ticketDetails.add({
                                            'rel': 'ITILSolution',
                                            'data': [
                                              {
                                                'content':
                                                    commentController.text,
                                                'date_creation':
                                                    DateTime.now().toString(),
                                                'users_id': widget.user.name,
                                                'status': 2,
                                              }
                                            ]
                                          });
                                        }
                                      }),
                                    }
                                  else
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Erro'),
                                            content: const Text(
                                                'Erro ao adicionar solução. Tente novamente.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    }
                                });

                        // Fecha o diálogo
                      },
                      child: const Text('Enviar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMessageDialog() async {
    TextEditingController commentController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enviar Mensagem',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  //maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Digite sua mensagem...',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          var detailFound = false;
                          for (var detail in store.ticketDetails) {
                            if (detail['rel'] == 'ITILFollowup') {
                              detail['data'].add({
                                'content': commentController.text,
                                'date_creation': DateTime.now().toString(),
                                'users_id': widget.user.name,
                                'pending': true,
                              });
                              detailFound = true;
                            }
                          }
                          if (!detailFound) {
                            store.ticketDetails.add({
                              'rel': 'ITILFollowup',
                              'data': [
                                {
                                  'content': commentController.text,
                                  'date_creation': DateTime.now().toString(),
                                  'users_id': widget.user.name,
                                  'pending': true,
                                }
                              ]
                            });
                          }
                        });
                        await store
                            .addFollowup(
                              widget.ticket.id,
                              commentController.text,
                            )
                            .then((value) => {
                                  if (value == true)
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Mensagem enviada'),
                                            content: const Text(
                                                'Sua mensagem foi enviada com sucesso.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    }
                                  else
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Erro'),
                                            content: const Text(
                                                'Erro ao enviar mensagem,Tente novamente.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    }, // Fecha o diálogo
                                });
                      },
                      child: const Text('Enviar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
//==================================== NAO APAGAR ==============================
  /* Future<void> _showCreateTaskDialog() async {
    TextEditingController taskController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();

    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Criar Tarefa'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: 'Digite o nome da tarefa...',
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: store.showDateFields,
                        onChanged: (value) {
                          setState(() {
                            store.showDateFields = value!;
                          });
                        },
                      ),
                      Text('Agendar tarefa'),
                    ],
                  ),
                  Observer(builder: (context) {
                    if (store.showDateFields) {
                      return Column(children: [
                        SizedBox(height: 16),
                        TextField(
                          controller: startDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Data de Início',
                          ),
                          onTap: () async {
                            final DateTime? picked = await _showDateTimePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              //firstDate: DateTime(2015, 8),
                              //lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              startDateController.text =
                                  DateFormat('dd-MM-yyyy HH:mm').format(picked);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: endDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Data de Término',
                          ),
                          onTap: () async {
                            DateTime initialDate = DateTime.now();
                            if (startDateController.text.isNotEmpty) {
                              initialDate = DateFormat('dd-MM-yyyy HH:mm')
                                  .parse(startDateController.text);
                            }
                            final DateTime? picked = await _showDateTimePicker(
                              context: context,
                              initialDate: initialDate,
                              //firstDate: DateTime(2015, 8),
                              //lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              endDateController.text =
                                  DateFormat('dd-MM-yyyy HH:mm').format(picked);
                            }
                          },
                        )
                      ]);
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await store
                      .creatTask(
                        widget.ticket.id,
                        taskController.text,
                        startDateController.text,
                        endDateController.text,
                      )
                      .then((value) => {
                            if (value == true)
                              {
                                setState(() {
                                  var detailFound = false;
                                  for (var detail in store.ticketDetails) {
                                    if (detail['rel'] == 'TicketTask') {
                                      detail['data'].add({
                                        'name': taskController.text,
                                        'date_creation':
                                            DateTime.now().toString(),
                                        'date_mod': DateTime.now().toString(),
                                        'begin_date': startDateController.text,
                                        'end_date': endDateController.text,
                                        'status': 1,
                                        'users_id_recipient': widget.user.name,
                                        'users_id_lastupdater':
                                            widget.user.name,
                                      });
                                      detailFound = true;
                                    }
                                  }
                                  if (!detailFound) {
                                    store.ticketDetails.add({
                                      'rel': 'TicketTask',
                                      'data': [
                                        {
                                          'name': taskController.text,
                                          'date_creation':
                                              DateTime.now().toString(),
                                          'date_mod': DateTime.now().toString(),
                                          'begin_date':
                                              startDateController.text,
                                          'end_date': endDateController.text,
                                          'status': 1,
                                          'users_id_recipient':
                                              widget.user.name,
                                          'users_id_lastupdater':
                                              widget.user.name,
                                        }
                                      ]
                                    });
                                  }
                                })
                              }
                          });

                  // Feche a dialog
                  Navigator.of(context).pop();
                },
                child: Text('Criar'),
              ),
            ],
          );
        });
      },
    );
  } */

  /* Future<DateTime?> _showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime.now();
    lastDate ??= initialDate.add(Duration(days: 365));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
 */
  Future<void> _showAssignTechDialog({bool change = false}) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                change
                    ? Text(
                        'Alterar técnico do chamado #${widget.ticket.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        'Atribuir técnico ao chamado #${widget.ticket.id}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                const SizedBox(height: 16),
                const Text('Escolha um técnico:'),
                // Aqui você pode adicionar uma lista de opções de técnicos ou um campo de pesquisa.
                // Por exemplo, um DropdownButton, ListView, TextFormField, etc.
                DropdownButton<int>(
                  value: store.selectedTechnician,
                  key: UniqueKey(),
                  //icon: const Icon(Icons.arrow_downward),
                  //iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (int? newValue) {
                    logger.i(store.selectedTechnician);
                    setState(() {
                      store.selectedTechnician = newValue!;
                    });
                    logger.i(store.selectedTechnician);
                  },
                  items: store.techList
                      .map<DropdownMenuItem<int>>((dynamic value) {
                    return DropdownMenuItem<int>(
                      value: value["2"],
                      child: Text(value["1"]),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o diálogo
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  Observer(builder: (context) {
                    if (store.isAtribuirLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                        onPressed: () async {
                          /* showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      Text(store.loadingMessage),
                                    ],
                                  ),
                                );
                              }); */
                          if (change) {
                            await store
                                .changeTechnician(
                                  widget.ticket.id,
                                  store.selectedTechnician,
                                )
                                .then((value) => {
                                      if (value == true)
                                        {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Atenção'),
                                                content:
                                                    const Text('Técnico alterado.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        }
                                      else
                                        {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Atenção'),
                                                content: const Text(
                                                    'Erro ao alterar técnico.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child:const  Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        }
                                    });
                          } else {
                            await store
                                .assignTech(
                                  widget.ticket.id,
                                  store.selectedTechnician,
                                )
                                .then((value) => {
                                      if (value == true)
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Técnico atribuido com sucesso!'),
                                            ),
                                          ),
                                          widget.ticket.status = 2,
                                          Modular.to.pop(),
                                          Modular.to.pop(),
                                        }
                                      else
                                        {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Atenção'),
                                                content: const Text(
                                                    'Erro ao atribuir técnico,Tente novamente.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        }
                                    });
                          }
                        },
                        child: const Text('Atribuir'),
                      );
                    }
                  }),
                ])
              ],
            ),
          );
        }));
      },
    );
  }
}
