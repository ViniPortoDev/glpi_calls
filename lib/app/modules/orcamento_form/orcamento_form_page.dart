import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:app_glpi_ios/app/shared/widgets/custom_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/models/user.dart';
import 'orcamento_form_store.dart';

class OrcamentoFormPage extends StatefulWidget {
  const OrcamentoFormPage({super.key});
  @override
  State<OrcamentoFormPage> createState() => _OrcamentoFormPageState();
}

class _OrcamentoFormPageState extends State<OrcamentoFormPage> {
  OrcamentoFormStore store = Modular.get<OrcamentoFormStore>();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? orcamentoMap;
  late User user;
  TextEditingController caixaController = TextEditingController();
  TextEditingController outroEquipamentoController = TextEditingController();
  TextEditingController patrimonioController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController observacaoController = TextEditingController();
  final dropdownFilialKey = LabeledGlobalKey<FormFieldState>("filial");
  final dropdownSetorKey = LabeledGlobalKey<FormFieldState>("setor");
  final dropdownEquipKey = LabeledGlobalKey<FormFieldState>("equip");
  String id = '';
  String? editor;
  String? autor;
  String? imageUrl;
  DateTime? dataCriacao;
  bool _hasTextBeenSet = false;

  @override
  void initState() {
    super.initState();
    var data = Modular.args.data;
    if (data != null) {
      orcamentoMap = data[0];
      user = data[1];
    }
    store.getTicketDetail();
    getEditOrcamento();
  }

  void getEditOrcamento() async {
    if ( orcamentoMap != null && orcamentoMap!.isNotEmpty) {
      id = orcamentoMap!['id'];

      autor = orcamentoMap!['autor'];

      editor = user.name;

      dataCriacao = orcamentoMap!['data'];

      store.selectedFilialName = orcamentoMap!['filial'];

      store.selectedSector = orcamentoMap!['setor'];

      store.selectedEquip = orcamentoMap!['equipamento'];

      await store.getEquipament(
          currentSector: orcamentoMap!['setor'],
          editedEquip: orcamentoMap!['equipamento']);

      caixaController.text = orcamentoMap!['caixa'].toString();

      patrimonioController.text = orcamentoMap!['patrimonio'];

      quantidadeController.text = orcamentoMap!['quantidade'].toString();

      observacaoController.text = orcamentoMap!['observacao'];

      imageUrl = orcamentoMap!['imageUrl'];
      if (imageUrl != null && imageUrl != "") {
        store.imagemOrcamento = await store.urlToFile(imageUrl!);
      }

      verifyVisible();
    }
  }

  void verifyVisible() {
    if (orcamentoMap!['setor'] != "Frente de loja") {
      store.isVisibleCaixa = false;
      caixaController.clear();
    }
    // if (orcamentoMap!['equipamento'] == "Outros") {
    //   store.isOutroEquipVisible = true;
    //   _outroEquipamentoController.text = orcamentoMap!['equipamento'];
    // }
  }

  void _clearFields() async {
    caixaController.clear();
    outroEquipamentoController.clear();
    patrimonioController.clear();
    quantidadeController.clear();
    observacaoController.clear();
    dropdownFilialKey.currentState!.reset();
    dropdownSetorKey.currentState!.reset();
    dropdownEquipKey.currentState!.reset();

    store.selectedFilialName = null;
    store.selectedEquip = null;
    store.selectedSector = null;

    store.isOutroEquipVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Color secColor = getUserColor()[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Orçamento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Observer(builder: (_) {
            return store.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Observer(
                      builder: (context) => Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 700,
                              ),
                              child: Observer(builder: (context) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField(
                                      key: dropdownFilialKey,
                                      focusColor: secColor,
                                      value: orcamentoMap?['filial'],
                                      items: store.filiaisName.map((location) {
                                        return DropdownMenuItem(
                                          value: location,
                                          child: Text(location),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        store.selectedFilialName =
                                            newValue as String;
                                        setState(() {
                                          store.selectedFilialName = newValue;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Selecione a Filial',
                                        labelStyle: TextStyle(color: secColor),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: secColor)),
                                      ),
                                      dropdownColor: secColor,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Selecione uma filial';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField(
                                      key: dropdownSetorKey,
                                      focusColor: secColor,
                                      value: orcamentoMap?['setor'],
                                      items: store.sector.map((String sector) {
                                        return DropdownMenuItem<String>(
                                          value: sector,
                                          child: Text(sector),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) async {
                                        store.selectedSector =
                                            newValue.toString();
                                        if (newValue != "Frente de loja") {
                                          store.isVisibleCaixa = false;
                                        } else {
                                          store.isVisibleCaixa = true;
                                        }
                                        if (orcamentoMap == null ||
                                            orcamentoMap!.isEmpty) {
                                          await store.getEquipament(
                                              currentSector:
                                                  newValue.toString());
                                        } else {
                                          await store.getEquipament(
                                            currentSector: newValue.toString(),
                                            editedEquip:
                                                orcamentoMap!['equipamento'],
                                          );
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Selecione o setor',
                                        labelStyle: TextStyle(color: secColor),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide:
                                                BorderSide(color: secColor)),
                                      ),
                                      dropdownColor: secColor,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Selecione um setor';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    store.equipLoading
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : Observer(
                                            builder: (_) =>
                                                DropdownButtonFormField(
                                              key: dropdownEquipKey,
                                              focusColor: secColor,
                                              value:
                                                  orcamentoMap?['equipamento'],
                                              items: store.equip
                                                  .map((String equipament) {
                                                return DropdownMenuItem<String>(
                                                  value: equipament,
                                                  child: Text(equipament),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                store.selectedEquip =
                                                    newValue.toString();
                                                if (newValue == "Outros") {
                                                  store.isOutroEquipVisible =
                                                      true;
                                                } else {
                                                  store.isOutroEquipVisible =
                                                      false;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Selecione o equipamento',
                                                labelStyle:
                                                    TextStyle(color: secColor),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    borderSide: BorderSide(
                                                        color: secColor)),
                                              ),
                                              dropdownColor: secColor,
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Selecione um equipamento';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                    Visibility(
                                      visible: store.isOutroEquipVisible,
                                      child: const SizedBox(height: 10),
                                    ),
                                    Visibility(
                                      visible: store.isOutroEquipVisible,
                                      child: CustomTextFormField(
                                        controller: outroEquipamentoController,
                                        labelColor: secColor,
                                        labelText:
                                            'Digite o nome do equipamento',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Campo obrigatório';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: store.isVisibleCaixa,
                                      child: const SizedBox(height: 10),
                                    ),
                                    Visibility(
                                      visible: store.isVisibleCaixa,
                                      child: CustomTextFormField(
                                        controller: caixaController,
                                        labelColor: secColor,
                                        labelText: 'IP Caixa',
                                        keyboardType: TextInputType.number,
                                        onTap: () {
                                          // Verifica se o texto já foi inserido
                                          if (!_hasTextBeenSet) {
                                            caixaController.text = "192.168.";
                                            caixaController.selection =
                                                TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: caixaController.text
                                                      .length), // Coloca o cursor no final
                                            );
                                            _hasTextBeenSet =
                                                true; // Define que o texto foi inserido
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Campo obrigatório';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      controller: patrimonioController,
                                      labelColor: secColor,
                                      labelText: 'Patrimonio',
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      controller: quantidadeController,
                                      labelColor: secColor,
                                      labelText: 'Quantidade',
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Campo obrigatório';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      controller: observacaoController,
                                      labelColor: secColor,
                                      labelText: 'Observação',
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (store.imagemOrcamento != null) {
                                              store.imagemOrcamento = null;
                                            }

                                            PermissionStatus permissionStatus =
                                                await Permission.storage
                                                    .request();
                                            if (permissionStatus.isGranted) {
                                              await store.pickFile();
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Permissão Negada'),
                                                            content: const Text(
                                                                'É necessário conceder permissão para acessar os arquivos.'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          ));
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: secColor,
                                              borderRadius: BorderRadius.circular(
                                                  20.0), // Adiciona o borderRadius
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Anexar arquivo',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (store.imagemOrcamento != null) {
                                              setState(() {
                                                store.imagemOrcamento = null;
                                              });
                                            }
                                            var cameraPermission =
                                                await Permission.camera
                                                    .request();
                                                    
                                            if (cameraPermission.isGranted) {
                                              await store.pickImage();
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Permissão Negada'),
                                                            content: const Text(
                                                                'É necessário conceder permissão para acessar a câmera.'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          ));
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: secColor,
                                              borderRadius: BorderRadius.circular(
                                                  20.0), // Adiciona o borderRadius
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Câmera',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    if (store.imagemOrcamento != null)
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 32),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Arquivo Selecionado:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 42),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Observer(builder: (context) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    store.isImageLoading
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.2,
                                                            width: size.width *
                                                                0.35,
                                                            child: Image.file(
                                                              store
                                                                  .imagemOrcamento!,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                logger.e(
                                                                    'Erro ao carregar imagem. Erro:$error StackTrance: $stackTrace');
                                                                return Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey),
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          243,
                                                                          243,
                                                                          243)),
                                                                  height:
                                                                      size.height *
                                                                          0.2,
                                                                  width:
                                                                      size.width *
                                                                          0.35,
                                                                  child: const Center(
                                                                      child: Text(
                                                                          'Imagem não carregada')),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                    const SizedBox(width: 20),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          store.imagemOrcamento =
                                                              null;
                                                        });
                                                      },
                                                      color: Colors.red,
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          size: 42),
                                                    ),
                                                  ],
                                                );
                                              }),
                                              const SizedBox(height: 16),
                                              Text(
                                                store.imagemOrcamento!.path
                                                    .split('/')
                                                    .last,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        if (orcamentoMap == null ||
                                            orcamentoMap!.isEmpty)
                                          store.sendLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Center(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      store.sendLoading = true;
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        if (store
                                                                .selectedEquip ==
                                                            'Outros') {
                                                          store.selectedEquip =
                                                              outroEquipamentoController
                                                                  .text;
                                                        }
                                                        if (store
                                                                .isVisibleCaixa ==
                                                            false) {
                                                          caixaController
                                                              .clear();
                                                        }

                                                        await store
                                                            .uploadImage();

                                                        await store
                                                            .sendFormOrcamento(
                                                          filial: store
                                                              .selectedFilialName!,
                                                          caixa: caixaController
                                                              .text,
                                                          patrimonio:
                                                              patrimonioController
                                                                  .text,
                                                          quantidade: int.parse(
                                                              quantidadeController
                                                                  .text),
                                                          observacao:
                                                              observacaoController
                                                                  .text,
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                                'Orçamento enviado com sucesso!'),
                                                          ),
                                                        );
                                                        store.sendLoading =
                                                            false;
                                                        Navigator.pop(
                                                            context, true);
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Campos não preenchidos'),
                                                              content: const Text(
                                                                  'Por favor, preencha todos os campos antes de enviar.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        store.sendLoading =
                                                            false;
                                                      }
                                                      store.sendLoading = false;
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all<Color>(
                                                                  secColor),
                                                    ),
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: 8),
                                                        Icon(Icons.download,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(width: 8),
                                                        Text('Enviar',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white)),
                                                        SizedBox(width: 8),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        if (orcamentoMap != null &&
                                            orcamentoMap!.isNotEmpty)
                                          store.sendLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Center(
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all<Color>(
                                                                  secColor),
                                                    ),
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: 8),
                                                        Icon(Icons.edit,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(width: 8),
                                                        Text('Enviar edição',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white)),
                                                        SizedBox(width: 8),
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      store.sendLoading = true;
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        if (store
                                                                .selectedEquip ==
                                                            'Outros') {
                                                          store.selectedEquip =
                                                              outroEquipamentoController
                                                                  .text;
                                                        }
                                                        if (store
                                                                .isVisibleCaixa ==
                                                            false) {
                                                          caixaController
                                                              .clear();
                                                        }
                                                        try {
                                                          await store
                                                              .uploadImage();

                                                          await store
                                                              .updateOrcamento(
                                                                
                                                            id: id,
                                                            autor: autor!,
                                                            editor: editor!,
                                                            dataCriacao:
                                                                dataCriacao!,
                                                            filial: store
                                                                .selectedFilialName!,
                                                            caixa:
                                                                caixaController
                                                                    .text,
                                                            patrimonio:
                                                                patrimonioController
                                                                    .text,
                                                            quantidade: int.parse(
                                                                quantidadeController
                                                                    .text),
                                                            observacao:
                                                                observacaoController
                                                                    .text,
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              content: Text(
                                                                  'Orçamento editado com sucesso!'),
                                                            ),
                                                          );
                                                          store.sendLoading =
                                                              false;
                                                          Navigator.pop(
                                                              context, true);
                                                          Navigator.pop(
                                                              context, true);
                                                        } catch (e) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Text(
                                                                  'Erro ao finalizar edição de orçamento'),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                      store.sendLoading = false;
                                                    },
                                                  ),
                                                ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            _clearFields();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    secColor),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(width: 8),
                                              Icon(Icons.clear,
                                                  color: Colors.white),
                                              SizedBox(width: 8),
                                              Text(
                                                'Limpar campos',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
