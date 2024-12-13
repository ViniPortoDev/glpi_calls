import 'package:app_glpi_ios/app/modules/ticket/ticket_store.dart';
import 'package:app_glpi_ios/app/shared/models/document.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class DocumentItemWidget extends StatefulWidget {
  final dynamic entity;
  final List<Document> documentList;
  const DocumentItemWidget(
      {super.key, required this.entity, required this.documentList});

  @override
  DocumentItemWidgetState createState() => DocumentItemWidgetState();
}

class DocumentItemWidgetState extends State<DocumentItemWidget> {
  TicketStore ticketStore = Modular.get<TicketStore>();
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  Widget overflowedText(String filename) {
    var fileExtension = filename.split('.').last;
    var name = filename.split('.').first;
    return Text(
      '${name.substring(0, name.length > 15 ? 15 : name.length)}${name.length > 15 ? '...' : ''}.$fileExtension',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  void showDownloadConfirmationDialog(
      BuildContext context, String documentName, int documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Confirmação de Download',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Você realmente deseja fazer o download do arquivo? ',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                documentName,
                style: const TextStyle(
                  fontSize: 15,
                ),
                maxLines: 3,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ticketStore.downloadDocument(documentId, documentName);
                Navigator.of(context).pop();
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                // Feche o diálogo sem realizar o download
                Navigator.of(context).pop();
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /* var width = MediaQuery.of(context).size.width; */
    return Observer(builder: (_) {
      return ticketStore.isTileLoading
          ? const Center(
              child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Carregando...'),
              ],
            ))
          : Container(
              constraints: const BoxConstraints(maxHeight: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.documentList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Adiciona o código para exibir o diálogo de confirmação aqui
                        showDownloadConfirmationDialog(
                            context,
                            widget.documentList[index].filename,
                            widget.documentList[index].id);
                      },
                      child: Container(
                        height: 150,
                        /* decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ), */
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                FileIcon(widget.documentList[index].filename,
                                    size: 60),
                                const SizedBox(width: 8),
                                overflowedText(
                                    widget.documentList[index].filename),
                                const SizedBox(width: 5),
                                Text(
                                  'Usuário: ${widget.documentList[index].userCreation}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  dateFormat.format(
                                      widget.documentList[index].dateCreation),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
    });
  }
}
