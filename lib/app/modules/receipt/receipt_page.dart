import 'package:app_glpi_ios/app/modules/receipt/receipt_store.dart';
import 'package:app_glpi_ios/app/modules/receipt/widgets/import_buttom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/models/orcamento.dart';
import '../../shared/utils/send_notification.dart';
import '../../shared/utils/utils.dart';
import '../../shared/widgets/custom_button_widget.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});
  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final store = Modular.get<ReceiptStore>();

  final orcamento = Modular.args.data as Orcamento;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    store.getNotificationsIds(orcamento.autor);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color userColor = getUserColor()[0];
    Color userColor1 = getUserColor()[1];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: userColor1,
        title: const Text('Recebimento'),
      ),
      body: Observer(builder: (context) {
        if (store.finishLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Observer(builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Importe a nota fiscal'),
                      const SizedBox(height: 12),
                      store.isLoading
                          ? const CircularProgressIndicator()
                          : store.selectedNF == null
                              ? ImportButtomWidget(
                                  onTap: () async {
                                    var cameraPermission =
                                        await Permission.camera.request();
                                    if (cameraPermission.isGranted) {
                                      await store.pickImage();
                                      store.selectedNF = store.selectedFile;
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Permissão Negada'),
                                          content: const Text(
                                              'É necessário conceder permissão para acessar a câmera.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                )
                              : InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Atenção'),
                                        content: const Text(
                                            'Deseja alterar a imagem?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Não'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Modular.to.pop();

                                              if (store.selectedNF != null) {
                                                store.selectedNF = null;
                                              }

                                              await store.pickImage();
                                              store.selectedNF =
                                                  store.selectedFile;
                                            },
                                            child: const Text('Sim'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: size.height * 0.4,
                                    width: size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: userColor1,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.file(
                                        store.selectedNF!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Importe o boleto'),
                      const SizedBox(height: 12),
                      store.isLoading
                          ? const CircularProgressIndicator()
                          : store.selectedBoleto == null
                              ? ImportButtomWidget(
                                  onTap: () async {
                                    var cameraPermission =
                                        await Permission.camera.request();
                                    if (cameraPermission.isGranted) {
                                      await store.pickImage();
                                      store.selectedBoleto = store.selectedFile;
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Permissão Negada'),
                                          content: const Text(
                                              'É necessário conceder permissão para acessar a câmera.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                )
                              : InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Atenção'),
                                        content: const Text(
                                            'Deseja alterar a imagem?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Não'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Modular.to.pop();

                                              if (store.selectedBoleto !=
                                                  null) {
                                                store.selectedBoleto = null;
                                              }

                                              await store.pickImage();
                                              store.selectedBoleto =
                                                  store.selectedFile;
                                            },
                                            child: const Text('Sim'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: size.height * 0.4,
                                    width: size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: userColor1,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.file(
                                        store.selectedBoleto!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 32),
            Observer(builder: (context) {
              return CustomButtonWidget(
                title: 'Concluir Orçamento',
                color: userColor,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Atenção'),
                      content: const Text('Deseja concluir o orçamento?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Modular.to.pop();
                          },
                          child: const Text('Não'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Modular.to.pop();

                            if (store.selectedNF == null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Atenção'),
                                  content: const Text('Importe a nota fiscal'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Modular.to.pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              try {
                                orcamento.status = 'Concluído';
                                await store.updateOrcamento(
                                    orcamento.id, 'Concluído');
                                await store.uploadDocs(orcamento);
                                if (orcamento.gerentesInfo.isNotEmpty) {
                                  for (var gerenteInfoMap
                                      in orcamento.gerentesInfo) {
                                    store.notificationsIds
                                        .add(gerenteInfoMap['glpiId']);
                                  }
                                }
                                store.notificationsIds
                                    .addAll(store.userContailListIds);

                                await sendPushNotification(
                                    'O orçamento de ${orcamento.filial} foi concluído com sucesso!',
                                    'O processo foi finalizado',
                                    store.notificationsIds,
                                    'Orçamento - Concluído');
                                ScaffoldMessenger.of(
                                        _scaffoldKey.currentContext!)
                                    .showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        'Orçamento concluido com sucesso!'),
                                  ),
                                );

                                Modular.to.pop(true);
                              } catch (e) {
                                ScaffoldMessenger.of(
                                        _scaffoldKey.currentContext!)
                                    .showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Erro ao concluir orçamento'),
                                  ),
                                );
                              }
                            }
                          },
                          child: store.finishLoading
                              ? const CircularProgressIndicator()
                              : const Text('Sim'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        );
      }),
    );
  }
}
