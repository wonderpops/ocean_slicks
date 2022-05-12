import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universe/universe.dart';

import '../../constants/colors.dart';

class PostScreenWidget extends StatefulWidget {
  PostScreenWidget({Key? key, required this.post_id}) : super(key: key);
  final int post_id;
  int selected_photo_id = 0;

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> {
  List photos = [
    {
      'id': 0,
      'filePath':
          '/data/user/0/com.example.ocean_slicks/app_flutter/Pictures/flutter_test/1649146019308.jpg',
      'xInclination': 0.26,
      'yInclination': 81.5,
      'zInclination': 44.68,
      'latitude': 43.1020794,
      'longitude': 131.9621254,
      'altitude': 185.1,
      'azimuth': 138.7
    },
    {
      'id': 1,
      'filePath':
          '/data/user/0/com.example.ocean_slicks/app_flutter/Pictures/flutter_test/1649146024116.jpg',
      'xInclination': 1.56,
      'yInclination': 26.36,
      'zInclination': 23.9,
      'latitude': 43.1020678,
      'longitude': 131.9621578,
      'altitude': 185.1,
      'azimuth': 121.17
    },
    {
      'id': 2,
      'filePath':
          '/data/user/0/com.example.ocean_slicks/app_flutter/Pictures/flutter_test/1649146028209.jpg',
      'xInclination': -1.3,
      'yInclination': 10.09,
      'zInclination': 9.85,
      'latitude': 43.1020645,
      'longitude': 131.9621113,
      'altitude': 185.1,
      'azimuth': 102.23
    }
  ];

  String title = 'Post Title';

  String description =
      'Description Description Description Description Description Description Description Description Description Description Description Description Description Description';

  @override
  Widget build(BuildContext context) {
    void update_data(int ph_id) {
      widget.selected_photo_id = ph_id;
      setState(() {});
    }

    return Scaffold(
      backgroundColor: gray_color,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: accent_color,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  _TopNavigationWidget(),
                  _PlacePreview(
                      selected_image: photos.firstWhere((element) =>
                          element['id'] == widget.selected_photo_id)),
                  _PhotosWidget(
                    title: title,
                    images: photos,
                    selected_image_id: widget.selected_photo_id,
                  ),
                ])),
                SliverVisibility(
                    visible: true,
                    sliver: SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        sliver: _PhotosGrid(
                          update_data: update_data,
                          images: photos,
                          selected_image_id: widget.selected_photo_id,
                        ))),
                SliverList(
                    delegate: SliverChildListDelegate([
                  _DescriptionWidget(description: description),
                  _PostCommentsWidget(),
                  // _PostData(),
                  // _AddPostButton()
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopNavigationWidget extends StatelessWidget {
  const _TopNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondary_color,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Stack(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(35)),
                height: 50,
                width: 50,
                child: Icon(
                  Icons.arrow_back,
                  size: 35,
                  color: dark_color.withOpacity(.8),
                ),
              ),
              Positioned.fill(
                  child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) =>
                    //         PostScreenWidget(post_id: 0),
                    //   ),
                    // );
                    Navigator.of(context).pop();
                  },
                  splashColor: accent_color.withOpacity(.1),
                  hoverColor: accent_color.withOpacity(.1),
                  focusColor: accent_color.withOpacity(.1),
                  highlightColor: accent_color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(35),
                ),
              ))
            ],
          ),
          Stack(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(35)),
                height: 50,
                width: 50,
                child: Icon(
                  Icons.bookmark_add,
                  size: 35,
                  color: dark_color.withOpacity(.8),
                ),
              ),
              Positioned.fill(
                  child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) =>
                    //         PostScreenWidget(post_id: 0),
                    //   ),
                    // );
                    print('lol');
                  },
                  splashColor: accent_color.withOpacity(.1),
                  hoverColor: accent_color.withOpacity(.1),
                  focusColor: accent_color.withOpacity(.1),
                  highlightColor: accent_color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(35),
                ),
              ))
            ],
          ),
        ]),
      ),
    );
  }
}

class _PlacePreview extends StatelessWidget {
  _PlacePreview({Key? key, required this.selected_image}) : super(key: key);
  Map selected_image;

  final _mapKey = UniqueKey();

  double map_height = 200;

  @override
  Widget build(BuildContext context) {
    double map_width = MediaQuery.of(context).size.width;
    print(selected_image['latitude']);
    return Stack(children: [
      Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          height: map_height,
          child: U.OpenStreetMap(
              key: _mapKey,
              type: OpenStreetMapType.Mapnik,
              options: TileLayerOptions(),
              size: Size(map_width, map_height),
              showCompass: false,
              showLocator: false,
              center: [selected_image['latitude'], selected_image['longitude']],
              zoom: 15,
              markers: U.MarkerLayer(
                [
                  Marker([
                    selected_image['latitude'],
                    selected_image['longitude'],
                  ],
                      widget: Icon(
                        Icons.place_rounded,
                        color: accent_color,
                        size: 50,
                      ))
                ],
              ))),
      InkWell(
        onTap: () {
          //TODO change position here
          // map_size = 600;
          // setState(() {});
        },
        child: Container(
          height: map_height,
        ),
      )
    ]);
  }
}

class _PhotosWidget extends StatefulWidget {
  _PhotosWidget(
      {Key? key,
      required this.title,
      required this.images,
      required this.selected_image_id})
      : super(key: key);
  final String title;
  final List images;
  final int selected_image_id;

  @override
  State<_PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<_PhotosWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: TextStyle(
                    fontSize: 32,
                    color: dark_color.withOpacity(.8),
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: accent_color.withOpacity(.1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '18-02-1998',
                      style: TextStyle(
                          color: accent_color.withOpacity(.6), fontSize: 16),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.remove_red_eye_outlined),
                    SizedBox(width: 8),
                    Text(
                      '200',
                      style: TextStyle(color: dark_color, fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.file(
                      File(widget.images.firstWhere((element) =>
                          element['id'] ==
                          widget.selected_image_id)['filePath']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35)),
                            height: 70,
                            width: 70,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 30,
                                  ),
                                  Text(
                                    '200',
                                    style: TextStyle(
                                        color: dark_color, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned.fill(
                              child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute<void>(
                                //     builder: (BuildContext context) =>
                                //         PostScreenWidget(post_id: 0),
                                //   ),
                                // );
                                print('lol');
                              },
                              splashColor: accent_color.withOpacity(.1),
                              hoverColor: accent_color.withOpacity(.1),
                              focusColor: accent_color.withOpacity(.1),
                              highlightColor: accent_color.withOpacity(.1),
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotosGrid extends StatefulWidget {
  _PhotosGrid(
      {Key? key,
      required this.update_data,
      required this.images,
      required this.selected_image_id})
      : super(key: key);
  final update_data;
  final images;
  final selected_image_id;

  @override
  State<_PhotosGrid> createState() => _PhotosGridState();
}

class _PhotosGridState extends State<_PhotosGrid> {
  void photo_on_click(ph_id) {
    widget.update_data(ph_id);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> photos = widget.images
        .map<Widget>((e) => _PhotoPreview(
              image: e,
              phOnclick: photo_on_click,
              selected_image_id: widget.selected_image_id,
            ))
        .toList();
    // print(photos);
    return Container(
      child: SliverGrid.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 3,
        children: photos,
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  _PhotoPreview({
    Key? key,
    required this.image,
    required this.phOnclick,
    required this.selected_image_id,
  }) : super(key: key);
  final image;
  final selected_image_id;
  final phOnclick;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: selected_image_id == image['id']
                    ? accent_color.withOpacity(.2)
                    : Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(image['filePath']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // print(image['id']);
                phOnclick(image['id']);
              },
              onLongPress: () {},
              splashColor: accent_color.withOpacity(.2),
              hoverColor: accent_color.withOpacity(.2),
              highlightColor: accent_color.withOpacity(.2),
              borderRadius: BorderRadius.circular(30),
              enableFeedback: true,
            ))
      ]),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  _DescriptionWidget({Key? key, required this.description}) : super(key: key);
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: light_color,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 24),
                    child: Text(description,
                        style: TextStyle(
                            fontSize: 20,
                            color: dark_color.withOpacity(.8),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            left: 24,
            child: Align(
              alignment: Alignment.topLeft,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: secondary_color,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: light_color,
                      size: 30,
                    ),
                  ),
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute<void>(
                        //     builder: (BuildContext context) =>
                        //         PostScreenWidget(post_id: 0),
                        //   ),
                        // );
                        print('lol');
                      },
                      splashColor: accent_color.withOpacity(.1),
                      hoverColor: accent_color.withOpacity(.1),
                      focusColor: accent_color.withOpacity(.1),
                      highlightColor: accent_color.withOpacity(.1),
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCommentsWidget extends StatelessWidget {
  _PostCommentsWidget({Key? key}) : super(key: key);

  List comments = [
    {'post_id': 2, 'username': 'pop', 'comment': 'Hello', 'date': '10.10.2020'},
    {'post_id': 2, 'username': 'max', 'comment': 'Yep', 'date': '10.10.2020'},
    {
      'post_id': 2,
      'username': 'Frank',
      'comment': 'So quite',
      'date': '10.10.2020'
    },
    {
      'post_id': 2,
      'username': 'SamRox',
      'comment': 'No, he did',
      'date': '10.10.2020'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: secondary_color,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //     height: 1,
              //     width: double.maxFinite,
              //     color: accent_color.withOpacity(.2)),
              SizedBox(height: 8),
              Text('Comments',
                  style: TextStyle(
                      fontSize: 32,
                      color: dark_color.withOpacity(.8),
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                child: Column(
                    children: comments
                        .map((e) => _PostCommentWidget(
                              username: e['username'],
                              comment: e['comment'],
                              date: e['date'],
                            ))
                        .toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCommentWidget extends StatelessWidget {
  _PostCommentWidget(
      {Key? key,
      required this.username,
      required this.comment,
      required this.date})
      : super(key: key);
  String username;
  String comment;
  String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
            color: light_color, borderRadius: BorderRadius.circular(20)),
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment,
                            style: TextStyle(
                                color: dark_color.withOpacity(.8),
                                fontSize: 16)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: secondary_color,
                    child: Icon(
                      Icons.person,
                      color: light_color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Comment by: ' + username,
                      style: TextStyle(color: dark_color.withOpacity(.4))),
                  Text(
                    date,
                    style: TextStyle(color: dark_color.withOpacity(.4)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
