import 'package:app_glpi_ios/app/shared/models/ticket.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final User user;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    var entityString =
        ticket.entity != null ? ticket.entity!.split('>').last : '';
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/ticket', arguments: [user, ticket]);
      },
      child: SizedBox(
        width: 200,
        child: Card(
          elevation: 2,
          color: getUserColor()[1],
          margin: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '#${ticket.id.toString()} ${ticket.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                    padding: const  EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: buildTicketInfo(
                              ticket.category,
                              fontSize: 12,
                              maxLines: 2,
                            ),
                          )
                        ])),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: buildTicketInfo(ticket.userCreation))
                        ])),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: buildTicketInfo(entityString))
                        ])),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: buildTicketInfo(DateFormat('dd/MM/yyyy')
                                  .format(ticket.dateCreation))
                              /* child: buildTicketInfo(ticket.dateCreation.toString()) */
                              )
                        ])),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.alarm,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: buildTicketInfo(
                                  DateFormat.Hm().format(ticket.dateCreation)))
                        ])),
                if (ticket.technician != null)
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.build_rounded,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: buildTicketInfo(ticket.technician!.name)
                                /* child: buildTicketInfo(ticket.dateCreation.toString()) */
                                )
                          ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
