// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/api_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:universe/universe.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';

class PostScreenWidget extends StatefulWidget {
  PostScreenWidget({Key? key, required this.post}) : super(key: key);
  Map post;
  int selected_photo_id = 0;

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ApiController api_ctrl = Get.find();

  void _onRefresh() async {
    widget.post = await api_ctrl.get_posts_by_id(widget.post['id']);
    print('refreshed');
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print('sdgdsgs');
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    widget.selected_photo_id = widget.post['images'].first['id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void update_data(int ph_id) {
      widget.selected_photo_id = ph_id;
      setState(() {});
    }

    final parsedDate = DateTime.parse(widget.post['created_at']);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String form_date = formatter.format(parsedDate);

    print(widget.post);

    return Scaffold(
        backgroundColor: gray_color,
        body: SafeArea(
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: accent_color,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: SmartRefresher(
                enablePullUp: false,
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate([
                      _TopNavigationWidget(),
                      _PlacePreview(
                          selected_image: widget.post['images'].firstWhere(
                              (element) =>
                                  element['id'] == widget.selected_photo_id)),
                      _PhotosWidget(
                        title: widget.post['title'],
                        date: form_date,
                        views: 201,
                        likes: 2002,
                        images: widget.post['images'],
                        selected_image_id: widget.selected_photo_id,
                      ),
                    ])),
                    SliverVisibility(
                        visible: true,
                        sliver: SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            sliver: _PhotosGrid(
                              update_data: update_data,
                              images: widget.post['images'],
                              selected_image_id: widget.selected_photo_id,
                            ))),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      _DescriptionWidget(
                          description: widget.post['descryption'],
                          avatar_path: '',
                          username: 'wonderpop'),
                      _PostCommentsWidget(),
                      // _PostData(),
                      // _AddPostButton()
                    ])),
                  ],
                ),
              ),
            ),
          ),
        ));
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
      required this.date,
      required this.views,
      required this.likes,
      required this.images,
      required this.selected_image_id})
      : super(key: key);
  final String title, date;
  final List images;
  final int selected_image_id, views, likes;

  @override
  State<_PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<_PhotosWidget> {
  @override
  Widget build(BuildContext context) {
    String selected_image_path = widget.images.firstWhere(
        (element) => element['id'] == widget.selected_image_id)['image_path'];
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
                      widget.date,
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
                      widget.views.toString(),
                      style: TextStyle(color: dark_color, fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      'http://192.168.0.198:5002/get_image?file_name=$selected_image_path',
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
                                  const Icon(
                                    Icons.favorite_border,
                                    size: 30,
                                  ),
                                  Text(
                                    widget.likes.toString(),
                                    style: const TextStyle(
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
    String image_path = image['image_path'];
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
                child: Image.network(
                  'http://192.168.0.198:5002/get_image?file_name=$image_path',
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
  _DescriptionWidget(
      {Key? key,
      required this.description,
      required this.avatar_path,
      required this.username})
      : super(key: key);
  final String description, avatar_path, username;

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
