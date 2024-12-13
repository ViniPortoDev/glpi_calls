import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget ticketTaskWidget(
    dynamic entity, Function editTicketTask, int ticketId, int userType,Function() notifyParent) {
      
  //print(entity);
  int taskOk = 0;
  for (var task in entity) {
    if (task['state'] == 2) {
      taskOk++;
    }
  }
  if (entity.length > 0) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(children: [
        Center(
                  child: Text(
        '$taskOk/${entity.length} Completo',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
                  ),
                ),
        ...List.generate(entity.length, (index) {
          bool value = entity[index]['state'] == 2 ? true : false;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //add a checkbox here
              Checkbox(
                              value: value,
                              onChanged: (bool? value) async {
              if ([3, 4, 6, 7].contains(userType)) {
                bool ok = await editTicketTask(
                    ticketId, entity[index]['id'], value);
                if (ok) {
                  entity[index]['state'] = value! ? 2 : 1;
                  value = value;
                  notifyParent();
                }
              }
              //print(value);
                        
                              },
                            ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTicketInfo('${entity[index]['content']}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 6),
                      buildTicketInfo('${entity[index]['users_id_tech']}'),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      buildTicketInfo(
                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(entity[index]['date'] ?? ''))),
                      // Add more Text widgets for additional texts as needed
                    ],
                  ),
                  index == entity.length - 1
                      ? Container()
                      : const Divider(
                          color: Colors.blue,
                        ),
                ],
              ),
            ],
          );
        })
      ]),
    );
  } else {
    return const Text('Sem informacoes');
  }
}
