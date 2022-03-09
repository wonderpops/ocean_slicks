import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/controllers/add_post_controller.dart';
import 'package:universe/universe.dart';
import 'package:geolocator/geolocator.dart';

import '../take_picture_screen/take_picture_screen.dart';

class AddPostWidget extends StatefulWidget {
  const AddPostWidget({Key? key}) : super(key: key);

  @override
  State<AddPostWidget> createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  void update_data() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: gray_color,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
            _PlacePreview(),
            _PhotosWidget(),
          ])),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: _PhotosGrid(),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            _AddPhotoButton(update_widget: update_data),
            _MetadataWidget(),
            _PostData(),
            _AddPostButton()
          ])),
        ],
      ),
    );
  }
}

class _PlacePreview extends StatefulWidget {
  _PlacePreview({Key? key}) : super(key: key);

  @override
  State<_PlacePreview> createState() => _PlacePreviewState();
}

class _PlacePreviewState extends State<_PlacePreview> {
  final _mapKey = UniqueKey();

  List markers = [];

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
          center: [51.555158, -0.108343],
          zoom: 12,
          markers: U.MarkerLayer(
            markers,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          //TODO change position here
          // map_size = 600;
          // setState(() {});
        },
        child: Container(
          height: 200,
        ),
      )
    ]);
  }
}

class _PhotosWidget extends StatefulWidget {
  const _PhotosWidget({Key? key}) : super(key: key);

  @override
  State<_PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<_PhotosWidget> {
  void update_photos() {
    print('photos_was_updated');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: gray_color,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Photos',
                style: TextStyle(
                    fontSize: 32,
                    color: dark_color.withOpacity(.8),
                    fontWeight: FontWeight.bold)),
            // Visibility(visible: photos.isNotEmpty, child: SizedBox(height: 16)),
            // _AddPhotoButton(
            //   update_widget: update_photos,
            // ),
          ],
        ),
      ),
    );
  }
}

class _PhotosGrid extends StatelessWidget {
  const _PhotosGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddPostController ap_ctrl = Get.find();
    List<Widget> photos = ap_ctrl.photos
        .map((e) => _PhotoPreview(
              image_path: e,
            ))
        .toList();
    photos.add(_PhotoPreview(image_path: 'lol'));
    photos.add(_PhotoPreview(image_path: 'lol'));
    return Container(
      child: SliverGrid.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 3,
        children: photos.reversed.toList(),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  _PhotoPreview({Key? key, required this.image_path}) : super(key: key);
  final image_path;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(
        File(image_path),
        fit: BoxFit.cover,
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          color: secondary_color,
          child: Center(
              child: Icon(
            Icons.add_a_photo_rounded,
            color: dark_color,
            size: 40,
          )),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const TakePictureScreen(),
                ),
              );
            },
            splashColor: accent_color.withOpacity(.1),
            hoverColor: accent_color.withOpacity(.1),
            highlightColor: accent_color.withOpacity(.1),
            child: Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  _AddPhotoButton({Key? key, required this.update_widget}) : super(key: key);
  final update_widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: secondary_color,
                borderRadius: BorderRadius.circular(30)),
            height: 60,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.add_a_photo_rounded,
                color: dark_color.withOpacity(.8),
                size: 25,
              ),
              SizedBox(width: 8),
              Text(
                'Add photo',
                style:
                    TextStyle(color: dark_color.withOpacity(.8), fontSize: 20),
              ),
            ]),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const TakePictureScreen(),
                      ),
                    )
                    .then((_) => update_widget());
              },
              splashColor: accent_color.withOpacity(.1),
              hoverColor: accent_color.withOpacity(.1),
              highlightColor: accent_color.withOpacity(.1),
              borderRadius: BorderRadius.circular(30),
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

class _MetadataWidget extends StatelessWidget {
  const _MetadataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: gray_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Metadata',
                style: TextStyle(
                    fontSize: 32,
                    color: dark_color.withOpacity(.8),
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: dark_color.withOpacity(.8)),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle:
                            TextStyle(color: dark_color.withOpacity(.4)),
                        hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(.4))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: dark_color.withOpacity(.4)),
                        ),
                        labelText: 'Latitude',
                        hintText: 'Latitude',
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: dark_color.withOpacity(.8)),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle:
                            TextStyle(color: dark_color.withOpacity(.4)),
                        hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(.4))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: dark_color.withOpacity(.4)),
                        ),
                        labelText: 'Longitude',
                        hintText: 'Longitude',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: dark_color.withOpacity(.8)),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle:
                            TextStyle(color: dark_color.withOpacity(.4)),
                        hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(.4))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: dark_color.withOpacity(.4)),
                        ),
                        labelText: 'X',
                        hintText: 'X',
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: dark_color.withOpacity(.8)),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle:
                            TextStyle(color: dark_color.withOpacity(.4)),
                        hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(.4))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: dark_color.withOpacity(.4)),
                        ),
                        labelText: 'Y',
                        hintText: 'Y',
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: dark_color.withOpacity(.8)),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle:
                            TextStyle(color: dark_color.withOpacity(.4)),
                        hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(.4))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: dark_color.withOpacity(.4)),
                        ),
                        labelText: 'Z',
                        hintText: 'Z',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: dark_color.withOpacity(.8)),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle:
                            TextStyle(color: dark_color.withOpacity(.4)),
                        hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(.4))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: dark_color.withOpacity(.4)),
                        ),
                        labelText: 'Azimuth',
                        hintText: 'Azimuth',
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: dark_color.withOpacity(.8)),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle:
                            TextStyle(color: dark_color.withOpacity(.4)),
                        hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(.4))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: dark_color.withOpacity(.4)),
                        ),
                        labelText: 'Altitude',
                        hintText: 'Altitude',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostData extends StatelessWidget {
  const _PostData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Post data',
                style: TextStyle(
                    fontSize: 32,
                    color: dark_color.withOpacity(.8),
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyle(color: dark_color.withOpacity(.8)),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: dark_color.withOpacity(.4)),
                  hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(.4))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: dark_color.withOpacity(.4)),
                  ),
                  labelText: 'Title',
                  hintText: 'Title',
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                keyboardType: TextInputType.text,
                style: TextStyle(color: dark_color.withOpacity(.8)),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: dark_color.withOpacity(.4)),
                  hintStyle: TextStyle(color: dark_color.withOpacity(.1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(.4))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: dark_color.withOpacity(.4)),
                  ),
                  labelText: 'Description',
                  hintText: 'Description',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPostButton extends StatelessWidget {
  const _AddPostButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: accent_color.withOpacity(.1),
                borderRadius: BorderRadius.circular(30)),
            height: 60,
            child: Center(
              child: Text(
                'Add post',
                style: TextStyle(color: accent_color, fontSize: 20),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO send post here
              },
              splashColor: accent_color.withOpacity(.1),
              hoverColor: accent_color.withOpacity(.1),
              highlightColor: accent_color.withOpacity(.1),
              borderRadius: BorderRadius.circular(30),
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
