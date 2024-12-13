import 'package:app_glpi_ios/app/modules/ticket/ticket_store.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EntityWidget extends StatefulWidget {
  final dynamic entity;
  const EntityWidget({super.key, required this.entity});

  @override
  EntityWidgetState createState() => EntityWidgetState();
}

class EntityWidgetState extends State<EntityWidget> {
  TicketStore ticketStore = Modular.get<TicketStore>();
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (ticketStore.isLoading) {
        return const Center(child: Column(
          children: [
            CircularProgressIndicator(),
            Text('Carregando...')
          ],
        ));
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTicketInfoLabel('Local'),
                  buildTicketInfo('${widget.entity['completename']}'),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTicketInfoLabel('Endereço'),
                  buildTicketInfo('${widget.entity['address']}'),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTicketInfoLabel('Cidade'),
                      buildTicketInfo('${widget.entity['town']}'),
                      // Add more Text widgets for additional texts as needed
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTicketInfoLabel('Estado'),
                      buildTicketInfo('${widget.entity['state']}'),
                      // Add more Text widgets for additional texts as needed
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTicketInfoLabel('País'),
                      buildTicketInfo('${widget.entity['country']}'),
                      // Add more Text widgets for additional texts as needed
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });
  }
}
