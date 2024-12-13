import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../shared/utils/validation_status.dart';

Widget ticketValidationWidget(dynamic entity) {
  //print(entity);
  /*  final dateFormat = DateFormat('dd/MM/yyyy HH:mm'); */
  if (entity.length > 0) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
          children: List.generate(entity.length, (index) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTicketInfoLabel('Requisicao'),
                buildTicketInfo('${entity[index]['comment_submission']}'),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                basicInfoElement(
                    'Requisitante', '${entity[index]['users_id']}'),
                basicInfoElementDateFormated(
                    'Dt. Requisição',
                    entity[index]['submission_date'] != null
                        ? DateTime.parse(entity[index]['submission_date'])
                        : null),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTicketInfoLabel('Feedback'),
                buildTicketInfo(
                    '${entity[index]['comment_validation'] ?? ''}'),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                basicInfoElement(
                    'Validador', '${entity[index]['users_id_validate']}'),
                basicInfoElementDateFormated(
                    'Dt. Validação',
                    entity[index]['validation_date'] != null
                        ? DateTime.parse(entity[index]['validation_date'])
                        : null),
                statusElement(
                    "Status",
                    validationStatus[entity[index]['status']]!['name'],
                    validationStatus[entity[index]['status']]!['color']!)
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTicketInfoLabel('Data'),
                  buildTicketInfo(
                      '${dateFormat.format(DateTime.parse(entity[index]['date'] ?? ''))}'),
                  // Add more Text widgets for additional texts as needed
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTicketInfoLabel('Criado'),
                  buildTicketInfo(
                      '${dateFormat.format(DateTime.parse(entity[index]['date_creation'] ?? ''))}'),
                  // Add more Text widgets for additional texts as needed
                ],
              ),
            ],
          ), */
          ],
        );
      })),
    );
  } else {
    return const Text('Sem Validações');
  }
}
