import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_slicks/widgets/messages_screen/chat_screen.dart';

class MessagesScreenWidget extends StatefulWidget {
  MessagesScreenWidget({Key? key}) : super(key: key);

  @override
  State<MessagesScreenWidget> createState() => _MessagesScreenWidgetState();
}

class _MessagesScreenWidgetState extends State<MessagesScreenWidget> {
  List chats = [
    {
      'title': 'Mr. Polygon',
      'subtitle': 'Hello, people!',
      'time': DateTime.now(),
      'chat_id': 1343,
    },
    {
      'title': 'Ms. Poppy',
      'subtitle': 'Are you there?',
      'time': DateTime.now(),
      'chat_id': 8734,
    },
    {
      'title': 'Sara',
      'subtitle': 'You awesome',
      'time': DateTime.now(),
      'chat_id': 1987,
    },
    {
      'title': 'Frank',
      'subtitle': 'Be quite, man',
      'time': DateTime.now(),
      'chat_id': 3904,
    }
  ];

  void onChatPreviewClick(int chat_id) {
    chat_is_opened = true;
    current_chat_id = chat_id;
    setState(() {});
  }

  void onBackClick() {
    chat_is_opened = false;
    setState(() {});
  }

  bool chat_is_opened = false;
  int current_chat_id = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !chat_is_opened,
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: chats
                      .map((e) => _ChatPreviewWidget(
                            title: e['title'],
                            subtitle: e['subtitle'],
                            time: e['time'],
                            chat_id: e['chat_id'],
                            onChatPreviewClick: onChatPreviewClick,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: chat_is_opened,
          child: ChatScreenWidget(
            onBackClick: onBackClick,
            chat_id: current_chat_id,
          ),
        ),
      ],
    );
  }
}

class _ChatPreviewWidget extends StatelessWidget {
  _ChatPreviewWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.time,
      required this.chat_id,
      required this.onChatPreviewClick})
      : super(key: key);
  String title;
  String subtitle;
  DateTime time;
  int chat_id;
  final void Function(int) onChatPreviewClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 70,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.orange.withOpacity(.6),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(subtitle,
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16))),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(DateFormat('h:mm a').format(time),
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onChatPreviewClick(chat_id),
                splashColor: Colors.orange.withOpacity(.1),
                hoverColor: Colors.orange.withOpacity(.1),
                focusColor: Colors.orange.withOpacity(.1),
                highlightColor: Colors.orange.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  alignment: Alignment.center,
                  height: 78,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(height: 1, color: Colors.white),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
