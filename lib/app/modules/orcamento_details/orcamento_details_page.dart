import 'dart:io';

import 'package:app_glpi_ios/app/shared/utils/send_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:app_glpi_ios/app/modules/orcamento_details/orcamento_details_store.dart';
import 'package:app_glpi_ios/app/modules/orcamento_details/widgets/orcamento_widget.dart';
import 'package:app_glpi_ios/app/shared/models/orcamento.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:app_glpi_ios/app/shared/widgets/custom_button_widget.dart';

import '../../shared/utils/utils.dart';
import '../../shared/widgets/action_button.dart';
import '../ticket/widgets/fab_column.dart';

class OrcamentoDetailsPage extends StatefulWidget {
  const OrcamentoDetailsPage({super.key});
  @override
  State<OrcamentoDetailsPage> createState() => _OrcamentoDetailsPageState();
}

class _OrcamentoDetailsPageState extends State<OrcamentoDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final orcamento = Modular.args.data[0] as Orcamento;
  final user = Modular.args.data[1] as User;
  final isContabilUser = Modular.args.data[2] as bool;
  final store = Modular.get<OrcamentoDetailsStore>();
  bool openFab = false;
  final _passwordController = TextEditingController();
  Color userColor = getUserColor()[0];
  Color userColor1 = getUserColor()[1];
  List<Widget> buttons = <Widget>[];
  @override
  void initState() {
    super.initState();
    store.getNotificationsIds(orcamento.autor);
    store.getContabilIds();
    getCotacoes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCotacoes() async {
    await store.getCotacoes(orcamento);
  }

  _mountButtons(BuildContext context) {
    buttons = <Widget>[];

    if ((user.type == 3 ||
            user.type == 4 ||
            orcamento.gerentes.contains(user.name)) &&
        orcamento.status != 'Concluído') {
      buttons.add(
        ActionButton(
          text: 'Cancelar',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmar Cancelamento'),
                  content: const Text(
                      'Tem certeza que quer cancelar este orçamento?'),
                  actions: [
                    TextButton(
                      child: const Text('Não'),
                      onPressed: () {
                        Modular.to.pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Sim'),
                      onPressed: () async {
                        Modular.to.pop();

                        try {
                          await store.cancelQuote(orcamento.id);

                          setState(() {
                            orcamento.status = 'Cancelado';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Orçamento cancelado com sucesso!'),
                            ),
                          );
                          Modular.to.pop(true);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Houve um erro: $e'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.cancel),
          color: userColor,
        ),
      );
    }
    if (orcamento.status == 'Novo' ||
        orcamento.status == 'Aguardando Cotação') {
      buttons.add(
        ActionButton(
          text: 'Editar',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Atenção'),
                  content: const Text('Deseja editar este orçamento?'),
                  actions: [
                    TextButton(
                      child: const Text('Não'),
                      onPressed: () {
                        Modular.to.pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Sim'),
                      onPressed: () async {
                        Map<String, dynamic> orcamentoMap = orcamento.toMap();
                        Modular.to.pop(true);
                        Modular.to.pushNamed(
                          '/orcamento_form',
                          arguments: [orcamentoMap, user],
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.edit),
          color: userColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _mountButtons(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: userColor1,
        title: const Text('Detalhes orçamento'),
        leading: IconButton(
          onPressed: () async => Navigator.pop(context, true),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: ExpandableFabColumn(
        distance: 50,
        //distance: buttons.length * 15.0,
        backgroundColor: getUserColor()[1],
        foregroundColor: getUserColor()[0],
        isExpanded: openFab,
        children: buttons,
      ),
      body: Observer(builder: (context) {
        if (store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Observer(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrcamentoDetailWidget(orcamento: orcamento),
                  const SizedBox(height: 20),

                  //Coluna com os botões

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if ((user.type == 3 || user.type == 4) &&
                              orcamento.status == 'Novo')
                            CustomButtonWidget(
                              title: 'Buscar cotação',
                              color: userColor,
                              onTap: () async {
                                orcamento.status = 'Aguardando Cotação';

                                await store.updateOrcamento(
                                    orcamento.id, 'Aguardando Cotação');

                                await sendPushNotification(
                                    'O orçamento de ${orcamento.filial} atualizou seu status.',
                                    'Item ${orcamento.equipamento} atualizou o status para Aguardando Cotação.',
                                    store.notificationsIds,
                                    'Orçamento - Buscar cotação');
                              },
                            ),
                          if ((user.type == 3 || user.type == 4) &&
                              orcamento.status == 'Aguardando Cotação')
                            CustomButtonWidget(
                              title: 'Importar cotações',
                              color: userColor,
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );

                                if (result != null) {
                                  // Verifica se o arquivo selecionado tem a extensão '.pdf'
                                  String? fileExtension = result
                                      .files.single.extension
                                      ?.toLowerCase();
                                  if (fileExtension == 'pdf') {
                                    File file = File(result.files.single.path!);
                                    setState(() {
                                      store.pdfFiles.add(file);
                                    });
                                  } else {
                                    // Exibe um diálogo de aviso se o arquivo não for PDF
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Formato Inválido"),
                                          content: const Text(
                                              "Por favor, selecione um arquivo PDF."),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          if ((user.type == 3 || user.type == 4) &&
                              orcamento.status == 'Aguardando Cotação')
                            store.sendLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Observer(builder: (context) {
                                    return CustomButtonWidget(
                                      title: 'Enviar Cotações',
                                      color: userColor,
                                      onTap: () async {
                                        if (store.pdfFiles.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Atenção'),
                                              content: const Text(
                                                  'Importe em pdf os orçamentos antes de enviar'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Modular.to.pop(),
                                                  child: const Text('Ok'),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          try {
                                            await store.uploadCotacoes(
                                                store.pdfFiles, orcamento);
                                            orcamento.status =
                                                'Aguardando Aprovação';
                                            await store.updateOrcamento(
                                                orcamento.id,
                                                'Aguardando Aprovação');
                                            setState(() {
                                              store.pdfFiles.clear();
                                            });

                                            await sendPushNotification(
                                                'O orçamento de ${orcamento.filial} atualizou seu status.',
                                                'Item ${orcamento.equipamento} atualizou o status para Aguardando Aprovação.',
                                                store.notificationsIds,
                                                'Orçamento - Aguardando Cotação');

                                            ScaffoldMessenger.of(_scaffoldKey
                                                    .currentContext!)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    'Cotações enviadas com sucesso!'),
                                              ),
                                            );
                                            store.selectedPdf = null;

                                            Modular.to.pop(true);
                                          } catch (e) {
                                            ScaffoldMessenger.of(_scaffoldKey
                                                    .currentContext!)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    'Erro ao enviar cotações'),
                                              ),
                                            );
                                            logger.e(e);
                                          }
                                        }
                                      },
                                    );
                                  }),
                          if (orcamento.gerentes.contains(user.name) &&
                              orcamento.status == 'Aguardando Aprovação')
                            store.approveLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Observer(builder: (context) {
                                    return CustomButtonWidget(
                                      title: 'Aprovar cotação',
                                      color: userColor,
                                      onTap: () async {
                                        if (store.selectedPdf != null) {
                                          try {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return Observer(
                                                    builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('Atenção'),
                                                    content: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: const Text(
                                                          'Deseja confirmar a aprovação desta cotação selecionada?'),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Modular.to.pop();
                                                        },
                                                        child:
                                                            const Text('Não'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Modular.to.pop();
                                                          _passwordController
                                                              .clear();

                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Digite a Senha'),
                                                                content: Form(
                                                                  key: _formKey,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _passwordController,
                                                                    obscureText:
                                                                        true,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      hintText:
                                                                          'Senha',
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) {
                                                                        return 'A senha é obrigatória';
                                                                      }
                                                                      if (!store
                                                                          .isPasswordValid) {
                                                                        return 'Senha incorreta';
                                                                      }

                                                                      if (value
                                                                              .length <
                                                                          3) {
                                                                        return 'A senha deve ter pelo menos 3 caracteres';
                                                                      }

                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: const Text(
                                                                        'Cancelar'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              true);
                                                                    },
                                                                  ),
                                                                  Observer(builder:
                                                                      (context) {
                                                                    if (store
                                                                        .isButtonLoading) {
                                                                      return const CircularProgressIndicator();
                                                                    }
                                                                    return TextButton(
                                                                      child: const Text(
                                                                          'OK'),
                                                                      onPressed:
                                                                          () async {
                                                                        await store
                                                                            .validatePassword(_passwordController.text);
                                                                        if (_formKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          try {
                                                                            Modular.to.pop();
                                                                            await store.generateLog(
                                                                                _passwordController.text,
                                                                                user,
                                                                                false);

                                                                            orcamento.status =
                                                                                'Aprovação Contábil';
                                                                            await store.updateOrcamento(orcamento.id,
                                                                                'Aprovação Contábil');
                                                                            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                                                                              const SnackBar(
                                                                                backgroundColor: Colors.green,
                                                                                content: Text('Cotação aprovada e enviada com sucesso!'),
                                                                              ),
                                                                            );

                                                                            await store.signPdf(
                                                                              orcamento,
                                                                              store.selectedPdf!,
                                                                              "cotacao_aprovada_",
                                                                              [
                                                                                4,
                                                                                80,
                                                                                180,
                                                                                70
                                                                              ],
                                                                            );
                                                                            if (orcamento.gerentesInfo.isNotEmpty) {
                                                                              for (var gerenteInfoMap in orcamento.gerentesInfo) {
                                                                                store.notificationsIds.add(gerenteInfoMap['glpiId']);
                                                                              }
                                                                            }
                                                                            await sendPushNotification(
                                                                                'O orçamento de ${orcamento.filial} foi aprovado pelo gerente!',
                                                                                'Item ${orcamento.equipamento} atualizou o status para Aprovação Contábil.',
                                                                                store.notificationsIds,
                                                                                'Orçamento - Aguardando Aprovação');

                                                                            Modular.to.pop(true);
                                                                          } catch (e) {
                                                                            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                                                                              const SnackBar(
                                                                                backgroundColor: Colors.red,
                                                                                content: Text('Ocorreu um erro ao aprovar cotação'),
                                                                              ),
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                    );
                                                                  }),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child:
                                                            const Text('Sim'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                              },
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  e.toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Atenção'),
                                                content: Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: const Text(
                                                      'Selecione uma cotação!'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Modular.to.pop();
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }),
                          if (isContabilUser == true &&
                              orcamento.status == 'Aprovação Contábil')
                            store.approveLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Observer(builder: (context) {
                                    return CustomButtonWidget(
                                      title: 'Aprovação Contábil',
                                      color: userColor,
                                      onTap: () async {
                                        if (store.cotacaoAprovadaFile != null) {
                                          try {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return Observer(
                                                    builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('Atenção'),
                                                    content: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: const Text(
                                                          'Deseja confirmar a aprovação desta cotação selecionada?'),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Modular.to.pop();
                                                        },
                                                        child:
                                                            const Text('Não'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Modular.to.pop();
                                                          _passwordController
                                                              .clear();

                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Digite a Senha'),
                                                                content: Form(
                                                                  key: _formKey,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _passwordController,
                                                                    obscureText:
                                                                        true,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      hintText:
                                                                          'Senha',
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) {
                                                                        return 'A senha é obrigatória';
                                                                      }
                                                                      if (!store
                                                                          .isPasswordValid) {
                                                                        return 'Senha incorreta';
                                                                      }

                                                                      if (value
                                                                              .length <
                                                                          3) {
                                                                        return 'A senha deve ter pelo menos 3 caracteres';
                                                                      }

                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: const Text(
                                                                        'Cancelar'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  Observer(builder:
                                                                      (context) {
                                                                    if (store
                                                                        .isButtonLoading) {
                                                                      return const CircularProgressIndicator();
                                                                    }
                                                                    return TextButton(
                                                                      child: const Text(
                                                                          'OK'),
                                                                      onPressed:
                                                                          () async {
                                                                        await store
                                                                            .validatePassword(_passwordController.text);
                                                                        if (_formKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          try {
                                                                            Modular.to.pop();
                                                                            await store.generateLog(
                                                                                _passwordController.text,
                                                                                user,
                                                                                true);

                                                                            orcamento.status =
                                                                                'Aguardando Faturamento';
                                                                            await store.updateOrcamento(orcamento.id,
                                                                                'Aguardando Faturamento');
                                                                            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                                                                              const SnackBar(
                                                                                backgroundColor: Colors.green,
                                                                                content: Text('Cotação aprovada e enviada com sucesso!'),
                                                                              ),
                                                                            );

                                                                            await store.signPdf(
                                                                              orcamento,
                                                                              store.cotacaoAprovadaFile!,
                                                                              "aguardando_faturamento_",
                                                                              [
                                                                                2.1,
                                                                                80,
                                                                                180,
                                                                                70
                                                                              ],
                                                                            );
                                                                            store.notificationsIds.addAll(store.userContailListIds);
                                                                            await sendPushNotification(
                                                                                'O orçamento de ${orcamento.filial} foi aprovado pela contabilidade!',
                                                                                'Item ${orcamento.equipamento} atualizou o status para Aguardando Faturamento.',
                                                                                store.notificationsIds,
                                                                                'Orçamento - Aprovação Contábil');

                                                                            Modular.to.pop(true);
                                                                          } catch (e) {
                                                                            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                                                                              const SnackBar(
                                                                                backgroundColor: Colors.red,
                                                                                content: Text('Ocorreu um erro ao aprovar cotação'),
                                                                              ),
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                    );
                                                                  }),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child:
                                                            const Text('Sim'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                              },
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  e.toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Atenção'),
                                                content: Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: const Text(
                                                      'Houve um erro ao carregar a cotação'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Modular.to.pop();
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }),
                          // if ((user.type == 3 || user.type == 4) &&
                          //     orcamento.status == 'Aguardando Faturamento')
                          //   CustomButtonWidget(
                          //     title: 'Faturar',
                          //     color: userColor,
                          //     onTap: () async {
                          //       try {
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               title: Text('Atenção'),
                          //               content: Container(
                          //                 padding: EdgeInsets.all(20),
                          //                 child: Text(
                          //                     'Deseja faturar a cotação aprovada?'),
                          //               ),
                          //               actions: [
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Modular.to.pop();
                          //                   },
                          //                   child: Text('Não'),
                          //                 ),
                          //                 TextButton(
                          //                   onPressed: () async {
                          //                     orcamento.status =
                          //                         'Aguardando Entrega';
                          //                     await store.updateOrcamento(
                          //                         orcamento.id,
                          //                         'Aguardando Entrega');
                          //                     ScaffoldMessenger.of(context)
                          //                         .showSnackBar(
                          //                       SnackBar(
                          //                         backgroundColor: Colors.green,
                          //                         content: Text(
                          //                             'Cotação faturado com sucesso!'),
                          //                       ),
                          //                     );
                          //                     if (orcamento
                          //                         .gerentesInfo.isNotEmpty) {
                          //                       for (var gerenteInfoMap
                          //                           in orcamento.gerentesInfo) {
                          //                         store.notificationsIds.add(
                          //                             gerenteInfoMap['glpiId']);
                          //                       }
                          //                     }
                          //                     await sendPushNotification(
                          //                         'O orçamento de ${orcamento.filial} foi faturado com sucesso!.',
                          //                         'Item ${orcamento.equipamento} atualizou o status para Aguardando Entrega.',
                          //                         store.notificationsIds,
                          //                         'Orçamento - Aguardando Faturamento');

                          //                     // Modular.to.popAndPushNamed(
                          //                     //   '/receipt',
                          //                     //   arguments: orcamento,
                          //                     // );
                          //                   },
                          //                   child: Text('Sim'),
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       } catch (e) {
                          //         ScaffoldMessenger.of(context).showSnackBar(
                          //           SnackBar(
                          //             backgroundColor: Colors.red,
                          //             content: Text(
                          //               e.toString(),
                          //             ),
                          //           ),
                          //         );
                          //       }
                          //     },
                          //   ),
                          CustomButtonWidget(
                            title: 'Sair',
                            color: userColor,
                            onTap: () async {
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if ((user.type == 3 || user.type == 4) &&
                              orcamento.status == 'Aguardando Cotação' ||
                          orcamento.status == 'Aguardando Aprovação' ||
                          orcamento.status == 'Aprovação Contábil')
                        Column(
                          children: [
                            const Text(
                              'Cotações:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            // Lista de PDFs importados
                            store.isPdfLoading
                                ? const CircularProgressIndicator()
                                : store.pdfFiles.isNotEmpty
                                    ? verifyStatusList()
                                    : const Text(
                                        'Nenhuma cotação importada.',
                                        style: TextStyle(fontSize: 16),
                                      ),

                            const SizedBox(height: 50),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget verifyStatusList() {
    if (orcamento.status == 'Aguardando Cotação') {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: store.pdfFiles.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ExpansionTile(
                title: Text(
                    'PDF ${index + 1}: ${store.pdfFiles[index].path.split('/').last} - Clique para vizualizar'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      if (store.selectedPdf == store.pdfFiles[index]) {
                        store.selectedPdf = null;
                      }
                      store.pdfFiles.removeAt(index);
                    });
                  },
                ),
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    setState(() {
                      store.selectedPdf = store.pdfFiles[index];
                    });
                  }
                },
                children: [
                  store.selectedPdf != null &&
                          store.selectedPdf == store.pdfFiles[index]
                      ? Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Visualizando: ${store.selectedPdf!.path.split('/').last}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: Scrollbar(
                                // Adiciona uma barra de rolagem visível
                                child: ListView(
                                  children: [
                                    SizedBox(
                                      height:
                                          1100, // Defina um valor maior que o conteúdo do PDF se necessário
                                      child: PDFView(
                                        filePath: store.selectedPdf!.path,
                                        enableSwipe: true,
                                        swipeHorizontal: true,
                                        autoSpacing: false,
                                        pageFling: false,
                                        onRender: (pages) {
                                          setState(() {});
                                        },
                                        onError: (error) {
                                          logger.e(error.toString());
                                        },
                                        onPageError: (page, error) {
                                          logger
                                              .e('$page: ${error.toString()}');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const Divider(),
            ],
          );
        },
      );
    }

    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    if (orcamento.status == 'Aguardando Aprovação') {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: store.pdfFiles.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ExpansionTile(
                leading: Radio(
                  value: store.pdfFiles[index],
                  groupValue: store.selectedPdf,
                  onChanged: (File? selectedPdf) {
                    setState(() {
                      store.selectedPdf = selectedPdf;
                    });
                  },
                ),
                title: Text('Cotação ${index + 1} - Clique para vizualizar'),
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    setState(() {
                      store.selectedPdf = store.pdfFiles[index];
                    });
                  }
                },
                children: [
                  store.selectedPdf != null &&
                          store.selectedPdf == store.pdfFiles[index]
                      ? Column(
                          children: [
                            const SizedBox(height: 20),
                            Text('Cotação ${index + 1}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: Scrollbar(
                                // Adiciona uma barra de rolagem visível
                                child: ListView(
                                  children: [
                                    SizedBox(
                                      height:
                                          1100, // Defina um valor maior que o conteúdo do PDF se necessário
                                      child: PDFView(
                                        filePath: store.selectedPdf!.path,
                                        enableSwipe: true,
                                        swipeHorizontal: true,
                                        autoSpacing: false,
                                        pageFling: false,
                                        onRender: (pages) {
                                          setState(() {});
                                        },
                                        onError: (error) {
                                          logger.e(error.toString());
                                        },
                                        onPageError: (page, error) {
                                          logger
                                              .e('$page: ${error.toString()}');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const Divider(),
            ],
          );
        },
      );
    }

    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    if (orcamento.status == 'Aprovação Contábil') {
      return ExpansionTile(
        leading: const Icon(
          Icons.check_box,
          color: Colors.green,
        ),
        title:
            const Text('Cotação aprovada pelo gestor - Clique para visualizar'),
        children: [
          store.cotacaoAprovadaFile != null
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Cotação selecionada:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: Scrollbar(
                        // Adiciona uma barra de rolagem visível
                        child: ListView(
                          children: [
                            SizedBox(
                              height:
                                  1100, // Defina um valor maior que o conteúdo do PDF se necessário
                              child: PDFView(
                                filePath: store.cotacaoAprovadaFile!.path,
                                enableSwipe: true,
                                swipeHorizontal: true,
                                autoSpacing: false,
                                pageFling: false,
                                onRender: (pages) {
                                  setState(() {});
                                },
                                onError: (error) {
                                  logger.e(error.toString());
                                },
                                onPageError: (page, error) {
                                  logger.e('$page: ${error.toString()}');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      );
    }
    return const Text('Erro');
  }
}
