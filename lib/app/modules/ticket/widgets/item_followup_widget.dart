import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/utils/utils.dart';

Widget itemFollowupWidget(dynamic entity, User user, BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  bool myMessage = entity['users_id'] == user.name;
  bool pending = false;
  if (entity['pending'] != null) {
    pending = entity['pending'];
  }
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Row(
        mainAxisAlignment:
            myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          myMessage
              ? _buildMessageBlock(width, entity, context, myMessage)
              : _buildAvatarBlock(entity),
          const SizedBox(width: 8.0),
          myMessage
              ? _buildAvatarBlock(entity)
              : _buildMessageBlock(width, entity, context, myMessage),
          myMessage
              ? pending
                  ? const Icon(Icons.info_outline, size: 12.0, color: Colors.red)
                  : const SizedBox(width: 0.0)
              : const SizedBox(width: 0.0),
          
        ]),
  );
}

Widget _buildMessageBlock(
    double width, dynamic entity, BuildContext context, bool myMessage) {
  return Column(
    crossAxisAlignment:
        myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Container(
        constraints: BoxConstraints(
          maxWidth: width - 160,
        ),
        //width: width - 220,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Text(
          cleanHtmlTags(entity['content'] ?? ''),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12.0,
            //fontWeight: FontWeight.w600,
          ),
          textAlign: myMessage ? TextAlign.right : TextAlign.left,
          //maxLines: 10,
        ),
      ),
      const SizedBox(height: 2.0),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          entity['date_creation'] != null
              ? DateFormat('dd/MM/yyyy HH:mm')
                  .format(DateTime.parse(entity['date_creation']))
              : '',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 8.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

Widget _buildAvatarBlock(dynamic entity) {
  return Column(
    children: [
      const CircleAvatar(
        child: Icon(Icons.person),
      ),
      Text(entity['users_id'] ?? '',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
    ],
  );
}
