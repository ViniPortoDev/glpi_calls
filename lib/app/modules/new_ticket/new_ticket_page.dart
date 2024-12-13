import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'new_ticket_store.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/modules/home/home_store.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';

class NewTicketPage extends StatefulWidget {
  final User user;
  final int entityId;
  const NewTicketPage({
    super.key,
    required this.user,
    required this.entityId,
  });

  @override
  State<NewTicketPage> createState() => _NewTicketPageState();
}

class _NewTicketPageState extends State<NewTicketPage> {
  NewTicketStore store = Modular.get<NewTicketStore>();
  HomeStore homeStore = Modular.get<HomeStore>();

  String _title = '';
  String _description = '';

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      store.selectedFile = File(result.files.single.path ?? '');
    }
  }

  Future<void> _pickImage() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      store.selectedFile = File(pickedFile.path);
    }
  }

  @override
  void initState() {
    super.initState();
    store.user = widget.user;
    store.getDetail();
  }

  @override
  Widget build(BuildContext context) {
    var userColor = getUserColor();

    InputDecoration customInputDecoration({
      String? labelText,
      String? hintText,
      IconData? prefixIcon,
    }) {
      return InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: userColor[0]),
        hintStyle: TextStyle(color: userColor[0]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Define o raio da borda
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Ticket'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Observer(builder: (_) {
            if (store.isLoading) {
              return Center(
                  child: Column(
                children: [
                  const CircularProgressIndicator(),
                  Text(store.statusMessage),
                ],
              ));
            } else {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: customInputDecoration(
                        labelText: 'Título',
                        hintText: 'Informe o título',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o título';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value ?? '';
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: 3,
                      decoration: customInputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Informe a descrição',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a descrição';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value ?? '';
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: customInputDecoration(
                              labelText: 'Categoria',
                              hintText: 'Selecione a categoria',
                            ),
                            value: store.categoriaSelecionada,
                            items: List.generate(store.categoriaList.length,
                                (index) {
                              return DropdownMenuItem(
                                value: store.categoriaList[index]['id'],
                                child: Text(
                                  store.categoriaList[index]['name'],
                                ),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                store.categoriaSelecionada = value ??
                                    store.categoriaList[0]['id'] as int;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: customInputDecoration(
                        labelText: 'Tipo',
                        hintText: 'Selecione o tipo',
                      ),
                      value: store.tipoSelecionada,
                      items: List.generate(store.tipoList.length, (index) {
                        return DropdownMenuItem(
                            value: store.tipoList[index]['id'],
                            child: Text(store.tipoList[index]['name']));
                      }),
                      onChanged: (value) {
                        setState(() {
                          store.tipoSelecionada =
                              value ?? store.tipoList[0]['id'] as int;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: customInputDecoration(
                        labelText: 'Urgência',
                        hintText: 'Selecione a urgência',
                      ),
                      value: store.urgenciaSelecionada,
                      items: List.generate(store.urgencia.length, (index) {
                        return DropdownMenuItem(
                            value: store.urgencia[index]['id'],
                            child: Text(store.urgencia[index]['name']));
                      }),
                      onChanged: (value) {
                        setState(() {
                          store.urgenciaSelecionada =
                              value ?? store.urgencia[0]['id'] as int;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (store.selectedFile != null) {
                              setState(() {
                                store.selectedFile = null;
                              });
                            }
                            PermissionStatus permissionStatus =
                                await Permission.storage.request();
                            if (permissionStatus.isGranted) {
                              await _pickFile();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Permissão Negada'),
                                        content: const Text(
                                            'É necessário conceder permissão para acessar os arquivos.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ));
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: userColor[0],
                              borderRadius: BorderRadius.circular(20.0), // Adiciona o borderRadius
                            ),
                            child: const Center(
                              child: Text(
                                'Anexar arquivo',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (store.selectedFile != null) {
                              setState(() {
                                store.selectedFile = null;
                              });
                            }
                            var cameraPermission =
                                await Permission.camera.request();
                            if (cameraPermission.isGranted) {
                              await _pickImage();
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
                                      ));
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: userColor[0],
                              borderRadius: BorderRadius.circular(20.0), // Adiciona o borderRadius
                            ),
                            child: const Center(
                              child: Text(
                                'Câmera',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Arquivo Selecionado:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      store.selectedFile!.path.split('/').last,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        store.selectedFile = null;
                                      });
                                    },
                                    color: Colors.blue,
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await store
                              .createNewTicket(
                                  _title, _description, store.selectedFile, widget.entityId)
                              .then((value) => value.fold(
                                  (l) => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Erro'),
                                            content:
                                                Text('Erro ao criar ticket: $l'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          )),
                                  (r) => {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text('Sucesso'),
                                                  content: const Text(
                                                      'Ticket criado com sucesso!'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        homeStore
                                                            .getTicketsByUser();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Modular.to.pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                )),
                                      }));
                        }
                      },
                      icon: Icon(
                        Icons.download,
                        color: userColor[0],
                      ),
                      label: Text(
                        'Enviar',
                        style: TextStyle(fontSize: 16, color: userColor[0]),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(userColor[1])),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
