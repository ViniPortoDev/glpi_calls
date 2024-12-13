import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';

class OrcamentoCardWidget extends StatelessWidget {
  final String? filial;
  final String? equipamento;
  final String? autor;
  final String? data;
  final String? urlImage;
  final String? status;
  final Color? statusColor;
  final void Function()? onTap;

  const OrcamentoCardWidget({
    super.key,
    this.filial,
    this.equipamento,
    this.autor,
    this.data,
    this.urlImage,
    this.statusColor,
    this.onTap,
    this.status,
  });
  @override
  Widget build(BuildContext context) {
    Color secColor1 = getUserColor()[1];
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 10,
            clipBehavior: Clip.hardEdge,
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: statusColor ?? secColor1,
                  // borderRadius: BorderRadius.circular(12),
                ),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      status ?? 'Status',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        urlImage == null || urlImage == ''
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: const Color.fromARGB(255, 243, 243, 243)),
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.14,
                                child: const Center(
                                    child: Text(
                                  'Sem Imagem',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )),
                              )
                            : Image.network(
                                urlImage!,
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.14,
                                fit: BoxFit.cover,
                              )
                      ],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.store),
                            const SizedBox(width: 8),
                            const Text(
                              'Filial: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(filial ?? ''),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.32, // Limita a largura do texto
                              child: Text(
                                equipamento ?? '',
                                maxLines: 1, // Limita a uma linha
                                overflow:
                                    TextOverflow.ellipsis, // Adiciona "..."
                                softWrap: false, // Evita quebra de linha
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 8),
                            const Text(
                              'Autor: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(autor ?? ''),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(width: 8),
                            const Text(
                              'Data: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(data ?? ''),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
