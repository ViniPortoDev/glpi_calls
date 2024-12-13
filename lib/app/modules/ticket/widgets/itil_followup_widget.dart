import 'package:app_glpi_ios/app/modules/ticket/widgets/item_followup_widget.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:flutter/material.dart';

class ItilFollowupWidget extends StatefulWidget {
  final dynamic entity;
  final User user;
  final double width;
  final Function callback;
  final int ticketId;
  final Function() notifyParent;

  const ItilFollowupWidget({
    super.key,
    required this.entity,
    required this.user,
    required this.width,
    required this.callback,
    required this.ticketId,
    required this.notifyParent,
  });

  @override
  ItilFollowupWidgetState createState() => ItilFollowupWidgetState();
}

class ItilFollowupWidgetState extends State<ItilFollowupWidget> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(
              maxHeight: 400,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                return itemFollowupWidget(
                    widget.entity[index], widget.user, context);
              },
              itemCount: widget.entity.length,
              shrinkWrap: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    enabled: widget.user.type == 2 ? false : true, 
                    decoration: const InputDecoration(
                      hintText: 'Digite sua mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (messageController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Atenção'),
                            content: const Text('Digite uma mensagem'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      widget.entity.add({
                        'content': messageController.text,
                        'date_creation': DateTime.now().toString(),
                        'users_id': widget.user.name,
                        'pending': true,
                      });
                      var result = await widget.callback(widget.ticketId, messageController.text);
                      if (result){
                        widget.entity.last['pending'] = false;
                      }
                      widget.notifyParent();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      });
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
