import 'package:flutter/material.dart';

class ChatScreenWidget extends StatelessWidget {
  ChatScreenWidget({Key? key, required this.onBackClick, required this.chat_id})
      : super(key: key);

  final VoidCallback onBackClick;
  int chat_id;

  @override
  Widget build(BuildContext context) {
    print(chat_id);
    return Container(
      child: Column(
        children: [
          _ChatHeaderWidget(
            onBackClick: onBackClick,
          )
        ],
      ),
    );
  }
}

class _ChatHeaderWidget extends StatelessWidget {
  _ChatHeaderWidget({Key? key, required this.onBackClick}) : super(key: key);
  final VoidCallback onBackClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.orange[100],
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Container(
                    height: 40,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    )),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onBackClick,
                    splashColor: Colors.orange.withOpacity(.1),
                    hoverColor: Colors.orange.withOpacity(.1),
                    highlightColor: Colors.orange.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
