// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/api_controller.dart';
import 'package:ocean_slicks/widgets/take_picture_screen/take_picture_screen.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../post_screen/post_screen.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: gray_color,
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: accent_color,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PersonDataWidget(),
                  // SizedBox(height: 32),
                  // _AddPostWidget(),
                  // _ActionButtons(),
                  SizedBox(height: 16),
                  Text('Discover',
                      style: TextStyle(
                          fontSize: 32,
                          color: dark_color.withOpacity(.8),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  _SortingButtons(),
                  SizedBox(height: 16),
                  _DiscoverWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonDataWidget extends StatelessWidget {
  _PersonDataWidget({Key? key}) : super(key: key);

  List notifications = [
    {'text': 'lol'},
    {'text': 'lol'},
    {'text': 'lol'},
    {'text': 'lol'}
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: secondary_color.withOpacity(.8),
                borderRadius: BorderRadius.circular(20)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Text(
                'Hello, Wonderpop 🖐',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Icon(Icons.notifications_none,
                          color: dark_color.withOpacity(.8)),
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
                      splashColor: secondary_color.withOpacity(.1),
                      hoverColor: secondary_color.withOpacity(.1),
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
              SizedBox(width: 16),
              CircleAvatar(
                radius: 30,
                backgroundColor: secondary_color,
                child: Icon(Icons.person_outline_outlined, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _AddPostWidget extends StatelessWidget {
  const _AddPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
                color: accent_color.withOpacity(.1),
                borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(width: 16),
              Icon(
                Icons.face_outlined,
                color: accent_color.withOpacity(.4),
              ),
              SizedBox(width: 16),
              Text(
                'My posts',
                style: TextStyle(color: accent_color.withOpacity(.4)),
              ),
            ]),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const TakePictureScreen(),
                  ),
                );
              },
              splashColor: accent_color.withOpacity(.1),
              hoverColor: accent_color.withOpacity(.1),
              highlightColor: accent_color.withOpacity(.1),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                alignment: Alignment.center,
                height: 60,
              ),
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
                        color: accent_color.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.photo_camera_outlined,
                            color: accent_color.withOpacity(.4),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Camera',
                            style:
                                TextStyle(color: accent_color.withOpacity(.4)),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const TakePictureScreen(),
                          ),
                        );
                      },
                      splashColor: accent_color.withOpacity(.1),
                      hoverColor: accent_color.withOpacity(.1),
                      highlightColor: accent_color.withOpacity(.1),
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
                        color: accent_color.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.photo_library_outlined,
                            color: accent_color.withOpacity(.4),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Gallery',
                            style:
                                TextStyle(color: accent_color.withOpacity(.4)),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const TakePictureScreen(),
                          ),
                        );
                      },
                      splashColor: accent_color.withOpacity(.1),
                      hoverColor: accent_color.withOpacity(.1),
                      highlightColor: accent_color.withOpacity(.1),
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
                        color: accent_color.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.bookmarks_outlined,
                            color: accent_color.withOpacity(.4),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Bookmarks',
                            style:
                                TextStyle(color: accent_color.withOpacity(.4)),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const TakePictureScreen(),
                          ),
                        );
                      },
                      splashColor: accent_color.withOpacity(.1),
                      hoverColor: accent_color.withOpacity(.1),
                      highlightColor: accent_color.withOpacity(.1),
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
                        color: accent_color.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.face_outlined,
                            color: accent_color.withOpacity(.4),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'My posts',
                            style:
                                TextStyle(color: accent_color.withOpacity(.4)),
                          ),
                        ]),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const TakePictureScreen(),
                          ),
                        );
                      },
                      splashColor: accent_color.withOpacity(.1),
                      hoverColor: accent_color.withOpacity(.1),
                      highlightColor: accent_color.withOpacity(.1),
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

class _SortingButtons extends StatelessWidget {
  const _SortingButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            color: light_color, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  height: 47,
                  decoration: BoxDecoration(
                      color: accent_color.withOpacity(.2),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    'Newest',
                    style: TextStyle(color: accent_color.withOpacity(.8)),
                  )),
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  child: Center(
                      child: Text('Popular',
                          style: TextStyle(color: dark_color.withOpacity(.4)))),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  child: Center(
                      child: Text('Nearest',
                          style: TextStyle(color: dark_color.withOpacity(.4)))),
                ))
          ],
        ));
  }
}

class _DiscoverWidget extends StatelessWidget {
  _DiscoverWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiController api_ctrl = Get.find();
    return FutureBuilder(
        future: api_ctrl.get_all_posts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Visibility(
                  visible: snapshot.hasData,
                  child: Text(
                    snapshot.data.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 24),
                  ),
                )
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Center(
                child: Container(
                    child: Column(
                  children: snapshot.data['posts'].map<Widget>((e) {
                    // print(e['user'] == null);
                    return _PostWidget(
                      post: e,
                    );
                  }).toList(),
                )),
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        });
  }
}

class _PostWidget extends StatelessWidget {
  _PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Map post;

  @override
  Widget build(BuildContext context) {
    String image_path = post['images'][0]['image_path'];
    final parsedDate = DateTime.parse(post['created_at']);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String form_date = formatter.format(parsedDate);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: secondary_color,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: dark_color,
                        radius: 26,
                        child: Icon(
                          Icons.person,
                          color: light_color,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        post['user']['username'],
                        style: TextStyle(
                            color: dark_color.withOpacity(.8), fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 300,
                  width: double.maxFinite,
                  child: Image.network(
                    'http://192.168.0.198:5002/get_image?file_name=$image_path',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          post['title'],
                          style: TextStyle(
                              color: dark_color.withOpacity(.8), fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: accent_color.withOpacity(.1)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              form_date,
                              style: TextStyle(
                                  color: accent_color.withOpacity(.6),
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        PostScreenWidget(post: post),
                  ),
                );
                print('lol');
              },
              splashColor: accent_color.withOpacity(.1),
              hoverColor: accent_color.withOpacity(.1),
              focusColor: accent_color.withOpacity(.1),
              highlightColor: accent_color.withOpacity(.1),
              borderRadius: BorderRadius.circular(20),
            ),
          ))
        ],
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
