import 'package:app_glpi_ios/app/modules/orcamento_details/widgets/timeline_status_widget.dart';
import 'package:app_glpi_ios/app/shared/models/orcamento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrcamentoDetailWidget extends StatelessWidget {
  final Orcamento orcamento;
  final String? updatedAt;
  final String? updatedBy;

  const OrcamentoDetailWidget({
    super.key,
    required this.orcamento,
    this.updatedAt,
    this.updatedBy,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Column(
      children: [
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Orçamento',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Autor: ',
                      style: TextStyle(),
                    ),
                    Expanded(
                      child: Text(
                        orcamento.autor.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Emissão: ',
                      style: TextStyle(),
                    ),
                    Expanded(
                      child: Text(
                        formatter.format(orcamento.data),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            border:  Border(
              left: BorderSide(),
              right: BorderSide(),
              bottom: BorderSide(),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: orcamento.editor != null,
                          child: Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 8),
                              const Text(
                                'Editor: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  orcamento.editor ?? '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: orcamento.editor != null,
                          child: const SizedBox(height: 8),
                        ),
                        Visibility(
                          visible: orcamento.dataEdicao != null,
                          child: Row(
                            children: [
                              const Icon(Icons.date_range),
                              const SizedBox(width: 8),
                              const Text(
                                'Data de edição: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('dd/MM/yyyy HH:mm:ss').format(
                                    orcamento.dataEdicao ?? DateTime(0),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: orcamento.dataEdicao != null,
                          child: const SizedBox(height: 8),
                        ),
                        HorizontalStatusTimelineWidget(
                          currentStatus: orcamento.status,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(height: 8),
                            const Icon(Icons.store),
                            const SizedBox(width: 8),
                            const Text(
                              'Filial: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                orcamento.filial,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.construction),
                            const SizedBox(width: 8),
                            const Text(
                              'Equipamento: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                orcamento.equipamento,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.apartment),
                            const SizedBox(width: 8),
                            const Text(
                              'Setor: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                orcamento.setor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.production_quantity_limits),
                            const SizedBox(width: 8),
                            const Text(
                              'Quantidade: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(orcamento.quantidade.toString()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.request_quote),
                            const SizedBox(width: 8),
                            const Text(
                              'Caixa: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                orcamento.caixa == ''
                                    ? 'Não informado'
                                    : orcamento.caixa,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.account_balance),
                            const SizedBox(width: 8),
                            const Text(
                              'Patrimonio: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                orcamento.patrimonio == ''
                                    ? 'Não informado'
                                    : orcamento.patrimonio,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.description),
                            const SizedBox(width: 8),
                            const Text(
                              'Observação: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.45,
                              child: Text(
                                orcamento.observacao == ''
                                    ? 'Sem Observações'
                                    : orcamento.observacao,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Imagem do Produto:'),
                                const SizedBox(height: 12),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: orcamento.imageUrl == ''
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: const Color.fromARGB(
                                                  255, 243, 243, 243)),
                                          width: size.width * 0.6,
                                          height: size.height * 0.25,
                                          child:
                                              const Center(child: Text('Sem Imagem')),
                                        )
                                      : Image.network(
                                          orcamento.imageUrl,
                                          width: size.width * 0.6,
                                          height: size.height * 0.25,
                                          fit: BoxFit
                                              .cover, // Usar BoxFit.cover para manter a proporção
                                        ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
