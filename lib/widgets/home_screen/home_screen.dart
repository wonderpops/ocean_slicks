import 'package:flutter/material.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _PersonDataWidget(),
              SizedBox(height: 16),
              _ActionButtons(),
              SizedBox(height: 16),
              Text('Discover',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.indigo.withOpacity(.4),
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _SearchWidget(),
              SizedBox(height: 16),
              _DiscoverWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonDataWidget extends StatelessWidget {
  _PersonDataWidget({Key? key}) : super(key: key);

  List notifications = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(.1),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Text(
                'Hello, Wonderpop 🖐',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 32),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Icon(Icons.notifications_none, color: Colors.indigo),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return _NotificationsBoxWidget(
                              notifications: notifications);
                        });
                  },
                  splashColor: Colors.indigo.withOpacity(.1),
                  hoverColor: Colors.indigo.withOpacity(.1),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              Visibility(
                visible: notifications.isNotEmpty,
                child: Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(.8),
                          borderRadius: BorderRadius.circular(8)),
                    )),
              )
            ],
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.indigo.withOpacity(.4),
            child: Icon(Icons.person_outline_outlined, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.indigo),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  suffixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.indigo,
                  ),
                  labelStyle: TextStyle(color: Colors.indigo.withOpacity(.4)),
                  hintStyle: TextStyle(color: Colors.indigo.withOpacity(.1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  labelText: 'Search...',
                  hintText: 'Search',
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  width: 55,
                  height: 55,
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.indigo,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      print('lol');
                    },
                    splashColor: Colors.white.withOpacity(.1),
                    hoverColor: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      alignment: Alignment.center,
                      width: 55,
                      height: 55,
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

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Take a photo',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print('lol');
                      },
                      splashColor: Colors.white.withOpacity(.1),
                      hoverColor: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Flexible(
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Galery',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print('lol');
                      },
                      splashColor: Colors.white.withOpacity(.1),
                      hoverColor: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Flexible(
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.bookmarks_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Bookmarks',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print('lol');
                      },
                      splashColor: Colors.white.withOpacity(.1),
                      hoverColor: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Flexible(
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.face_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'My posts',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print('lol');
                      },
                      splashColor: Colors.white.withOpacity(.1),
                      hoverColor: Colors.white.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DiscoverWidget extends StatelessWidget {
  _DiscoverWidget({Key? key}) : super(key: key);
  List<Widget> posts = [
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget(),
    _PostWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Wrap(
        children: posts,
      )),
    );
  }
}

class _PostWidget extends StatelessWidget {
  const _PostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        width: 150,
        child: Placeholder(),
      ),
    );
  }
}

class _NotificationsBoxWidget extends StatelessWidget {
  _NotificationsBoxWidget({Key? key, required this.notifications})
      : super(key: key);

  List notifications;

  @override
  Widget build(BuildContext context) {
    print(notifications.isEmpty);
    return Container(
      height: 400,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white),
      child: notifications.isEmpty
          ? Center(
              child: Text('You have no notifications 😢',
                  style: TextStyle(color: Colors.black54, fontSize: 18)))
          : SingleChildScrollView(
              child: Column(
                children: notifications
                    .map((e) => _NotificationWidget(text: e['text']))
                    .toList(),
              ),
            ),
    );
  }
}

class _NotificationWidget extends StatefulWidget {
  _NotificationWidget({Key? key, required this.text}) : super(key: key);

  String text;

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget> {
  bool is_visible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: is_visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Column(
          children: [
            Container(
              height: 60,
              child: Row(
                children: [
                  Icon(Icons.message_outlined, color: Colors.black54),
                  SizedBox(width: 16),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(widget.text,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16))),
                  )),
                  SizedBox(width: 16),
                  InkWell(
                      onTap: () {
                        print(widget.text);
                        is_visible = false;
                        setState(() {});
                      },
                      child: Icon(Icons.cancel, color: Colors.red[200]))
                ],
              ),
            ),
            Container(height: 1, color: Colors.grey[200])
          ],
        ),
      ),
    );
  }
}
