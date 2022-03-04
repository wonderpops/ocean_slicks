import 'package:flutter/material.dart';
import 'package:ocean_slicks/constants/colors.dart';

class ChatScreenWidget extends StatelessWidget {
  ChatScreenWidget({Key? key, required this.chat_id}) : super(key: key);

  int chat_id;

  @override
  Widget build(BuildContext context) {
    print(chat_id);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            _ChatHeaderWidget(),
            _ChatBodyWidget(),
          ],
        ),
      ),
    );
  }
}

class _ChatHeaderWidget extends StatelessWidget {
  _ChatHeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: secondary_color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      color: dark_color,
                      size: 30,
                    )),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    splashColor: accent_color.withOpacity(.1),
                    hoverColor: accent_color.withOpacity(.1),
                    highlightColor: accent_color.withOpacity(.1),
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
          const Text(
            'Title',
            textAlign: TextAlign.center,
            style: TextStyle(color: dark_color, fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: accent_color,
            ),
          )
        ],
      ),
    );
  }
}

class _ChatBodyWidget extends StatelessWidget {
  const _ChatBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: gray_color,
        child: SingleChildScrollView(
            child: Column(
          children: [],
        )),
      ),
    );
  }
}
