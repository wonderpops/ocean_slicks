import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/controllers/add_post_controller.dart';
import 'package:path/path.dart';
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
    AddPostController ap_ctrl = Get.find();
    return Container(
      color: gray_color,
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: accent_color,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                _PlacePreview(),
                _PhotosWidget(),
              ])),
              SliverVisibility(
                  visible: ap_ctrl.photos.isNotEmpty,
                  sliver: SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: _PhotosGrid(
                        update_data: update_data,
                      ))),
              SliverList(
                  delegate: SliverChildListDelegate([
                _AddPhotoButton(update_widget: update_data),
                _MetadataWidget(),
                _PostData(),
                _AddPostButton()
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlacePreview extends StatelessWidget {
  _PlacePreview({Key? key}) : super(key: key);

  final _mapKey = UniqueKey();

  double map_height = 200;

  @override
  Widget build(BuildContext context) {
    AddPostController ap_ctrl = Get.find();
    double map_width = MediaQuery.of(context).size.width;
    var selected_image = {};
    if (ap_ctrl.selectedImageId < ap_ctrl.photos.length) {
      selected_image = ap_ctrl.photos[ap_ctrl.selectedImageId];
    }
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
              center: selected_image.isNotEmpty
                  ? [selected_image['latitude'], selected_image['longitude']]
                  : [0, 0],
              zoom: 15,
              markers: selected_image.isNotEmpty
                  ? U.MarkerLayer(
                      [
                        Marker([
                          ap_ctrl.photos[ap_ctrl.selectedImageId]['latitude'],
                          ap_ctrl.photos[ap_ctrl.selectedImageId]['longitude']
                        ],
                            widget: Icon(
                              Icons.place_rounded,
                              color: accent_color,
                              size: 50,
                            ))
                      ],
                    )
                  : U.MarkerLayer(
                      [],
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
  const _PhotosWidget({Key? key}) : super(key: key);

  @override
  State<_PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<_PhotosWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Text('Photos',
            style: TextStyle(
                fontSize: 32,
                color: dark_color.withOpacity(.8),
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _PhotosGrid extends StatefulWidget {
  _PhotosGrid({Key? key, required this.update_data}) : super(key: key);
  final update_data;

  @override
  State<_PhotosGrid> createState() => _PhotosGridState();
}

class _PhotosGridState extends State<_PhotosGrid> {
  void photo_on_click(ph_id) {
    AddPostController ap_ctrl = Get.find();
    ap_ctrl.selectedImageId = ph_id;
    widget.update_data();
  }

  @override
  Widget build(BuildContext context) {
    AddPostController ap_ctrl = Get.find();
    print(ap_ctrl.selectedImageId);
    List<Widget> photos = ap_ctrl.photos
        .map((e) => _PhotoPreview(
              image: e,
              phOnclick: photo_on_click,
            ))
        .toList();
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
  }) : super(key: key);
  final image;
  final phOnclick;

  @override
  Widget build(BuildContext context) {
    AddPostController ap_ctrl = Get.find();
    return GridTile(
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: ap_ctrl.selectedImageId == image['id']
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
                print(image['id']);
                phOnclick(image['id']);
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Warning!'),
                        content: Text(
                            'You trying to delete photo. All photo data will be lost. \n\nContinue?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Back',
                                  style: TextStyle(
                                      color: accent_color.withOpacity(.8)))),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              phOnclick(ap_ctrl.remove_photo(image['id']));
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red[300]),
                            ),
                          )
                        ],
                      );
                    });
              },
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

class _AddPhotoButton extends StatelessWidget {
  _AddPhotoButton({Key? key, required this.update_widget}) : super(key: key);
  final update_widget;

  @override
  Widget build(BuildContext context) {
    AddPostController ap_ctrl = Get.find();
    return Padding(
      padding: ap_ctrl.photos.isEmpty
          ? const EdgeInsets.only(left: 16, right: 16, bottom: 16)
          : const EdgeInsets.all(16),
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
  _MetadataWidget({Key? key}) : super(key: key);
  final TextEditingController latitude_ctrl = TextEditingController();
  final TextEditingController longitude_ctrl = TextEditingController();
  final TextEditingController altitude_ctrl = TextEditingController();

  final TextEditingController x_angle_ctrl = TextEditingController();
  final TextEditingController y_angle_ctrl = TextEditingController();
  final TextEditingController z_angle_ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AddPostController ap_ctrl = Get.find();

    var selected_image = {};
    if (ap_ctrl.selectedImageId < ap_ctrl.photos.length) {
      selected_image = ap_ctrl.photos[ap_ctrl.selectedImageId];
    }

    if (selected_image.isNotEmpty) {
      x_angle_ctrl.text = selected_image['xInclination'].toString();
      y_angle_ctrl.text = selected_image['yInclination'].toString();
      z_angle_ctrl.text = selected_image['zInclination'].toString();

      latitude_ctrl.text = selected_image['latitude'].toString();
      longitude_ctrl.text = selected_image['longitude'].toString();
      altitude_ctrl.text = selected_image['altitude'].toString();
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metadata',
                style: TextStyle(
                    fontSize: 32,
                    color: dark_color.withOpacity(.8),
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextField(
                        controller: latitude_ctrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: dark_color.withOpacity(.8)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle:
                              TextStyle(color: dark_color.withOpacity(.4)),
                          hintStyle:
                              TextStyle(color: dark_color.withOpacity(.1)),
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
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextField(
                        controller: longitude_ctrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: dark_color.withOpacity(.8)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle:
                              TextStyle(color: dark_color.withOpacity(.4)),
                          hintStyle:
                              TextStyle(color: dark_color.withOpacity(.1)),
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
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextField(
                        controller: x_angle_ctrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: dark_color.withOpacity(.8)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle:
                              TextStyle(color: dark_color.withOpacity(.4)),
                          hintStyle:
                              TextStyle(color: dark_color.withOpacity(.1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(.4))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                BorderSide(color: dark_color.withOpacity(.4)),
                          ),
                          labelText: 'X Angle',
                          hintText: 'X Angle',
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
                        controller: y_angle_ctrl,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: dark_color.withOpacity(.8)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle:
                              TextStyle(color: dark_color.withOpacity(.4)),
                          hintStyle:
                              TextStyle(color: dark_color.withOpacity(.1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(.4))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                BorderSide(color: dark_color.withOpacity(.4)),
                          ),
                          labelText: 'Y Angle',
                          hintText: 'Y Angle',
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextField(
                        controller: z_angle_ctrl,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: dark_color.withOpacity(.8)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle:
                              TextStyle(color: dark_color.withOpacity(.4)),
                          hintStyle:
                              TextStyle(color: dark_color.withOpacity(.1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(.4))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide:
                                BorderSide(color: dark_color.withOpacity(.4)),
                          ),
                          labelText: 'Z Angle',
                          hintText: 'Z Angle',
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
                    padding: const EdgeInsets.only(right: 4),
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
                          hintStyle:
                              TextStyle(color: dark_color.withOpacity(.1)),
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
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextField(
                        controller: altitude_ctrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: dark_color.withOpacity(.8)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelStyle:
                              TextStyle(color: dark_color.withOpacity(.4)),
                          hintStyle:
                              TextStyle(color: dark_color.withOpacity(.1)),
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
        padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
