import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesScreenWidget extends StatelessWidget {
  MessagesScreenWidget({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _ChatPreviewWidget extends StatelessWidget {
  _ChatPreviewWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.time,
      required this.chat_id})
      : super(key: key);
  String title;
  String subtitle;
  DateTime time;
  int chat_id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  onTap: () {
                    print(chat_id);
                  },
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
          Container(height: 1, color: Colors.white),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
