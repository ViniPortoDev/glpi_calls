import 'package:app_glpi_ios/app/modules/upload/upload_store.dart';
import 'package:app_glpi_ios/app/shared/models/ticket.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadPage extends StatefulWidget {
  final Ticket ticket;
  final User user;
  final String sessionToken;

  const UploadPage({
    super.key,
    required this.ticket,
    required this.user,
    required this.sessionToken,
  });

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final store = Modular.get<UploadStore>();
  @override
  void initState() {
    super.initState();
    store.ticket = widget.ticket;
    store.user = widget.user;
    store.sessionToken = widget.sessionToken;
    Permission.camera.request();
  }

  bool _validateForm() {
    if (store.selectedFile == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Erro de Validação'),
          content: const Text('Selecione um arquivo antes de enviar.'),
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
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Anexe um arquivo ao chamado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Id do Chamado: ${widget.ticket.id}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (store.selectedFile != null) {
                    setState(() {
                      store.selectedFile = null;
                    });
                  }
                  if (await Permission.camera.request().isGranted) {
                    await pickImage().then((value) {
                      setState(() {
                        store.selectedFile = value;
                      });
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Permissão Negada'),
                        content: const Text(
                          'É necessário conceder permissão para acessar a câmera.',
                        ),
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
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      Text(
                        'Camera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () async {
                  if (store.selectedFile != null) {
                    setState(() {
                      store.selectedFile = null;
                    });
                  }
                  if (await Permission.camera.request().isGranted) {
                    await pickFile().then((value) {
                      setState(() {
                        store.selectedFile = value;
                      });
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Permissão Negada'),
                        content: const Text(
                          'É necessário conceder permissão para acessar a câmera.',
                        ),
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
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_copy,
                        color: Colors.white,
                      ),
                      Text(
                        'Carregar arquivo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          if (store.selectedFile != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Arquivo selecionado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            store.selectedFile!.path.split('/').last,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    await store
                        .uploadTicket(widget.ticket.id, store.selectedFile)
                        .then((value) {
                      if (value) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Upload realizado com sucesso'),
                            content: const Text(
                              'O arquivo foi anexado ao chamado com sucesso.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Modular.to.pop(true);
                                  Modular.to.pop(true);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Erro ao realizar upload'),
                            content: const Text(
                              'Ocorreu um erro ao anexar o arquivo ao chamado.',
                            ),
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
                    });
                  }
                },
                child: const SizedBox(
                  width: 100,
                  child: Center(child: Text('Enviar')),
                ),
              ),
              ElevatedButton(
                onPressed: () => Modular.to.pop(),
                child: const SizedBox(
                  width: 100,
                  child: Center(child: Text('Cancelar')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
