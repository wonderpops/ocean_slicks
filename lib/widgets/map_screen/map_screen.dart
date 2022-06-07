// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/api_controller.dart';
import 'package:ocean_slicks/widgets/post_screen/post_screen.dart';
import 'package:universe/universe.dart';

class MapWidget extends StatefulWidget {
  MapWidget({Key? key}) : super(key: key);
  MapController mp_ctrl = MapController();
  DateTime last_request = DateTime.now();
  ApiController api_ctrl = Get.find();

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final _mapKey = UniqueKey();
  List markers = [];
  @override
  Widget build(BuildContext context) {
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return U.OpenStreetMap(
      key: _mapKey,
      controller: widget.mp_ctrl,
      center: [51.555158, -0.108343],
      zoom: 12,
      showLocator: true,
      moveWhenLive: false,
      live: true,
      onReady: () async {
        widget.mp_ctrl.move(await widget.mp_ctrl.locate());
        widget.last_request = DateTime.now();
        Map posts = await widget.api_ctrl.get_posts_in_bounds(
            widget.mp_ctrl.bounds?.southWest?.lat,
            widget.mp_ctrl.bounds?.southWest?.lng,
            widget.mp_ctrl.bounds?.northEast?.lat,
            widget.mp_ctrl.bounds?.northEast?.lng);
        posts['posts'].forEach((e) {
          Marker mk = U.Marker(
              [e['images'][0]['latitude'], e['images'][0]['longitude']],
              data: e);
          markers.add(mk);
        });

        setState(() {});
      },
      onChanged: (center, zoom, rotation) async {
        if (DateTime.now().difference(widget.last_request).inSeconds > 1 &&
            widget.mp_ctrl.zoom! > 10) {
          widget.last_request = DateTime.now();
          markers = [];
          Map posts = await widget.api_ctrl.get_posts_in_bounds(
              widget.mp_ctrl.bounds?.southWest?.lat,
              widget.mp_ctrl.bounds?.southWest?.lng,
              widget.mp_ctrl.bounds?.northEast?.lat,
              widget.mp_ctrl.bounds?.northEast?.lng);
          posts['posts'].forEach((e) {
            Marker mk = U.Marker(
                [e['images'][0]['latitude'], e['images'][0]['longitude']],
                data: e);
            markers.add(mk);
          });
        }

        setState(() {});
      },
      markers: U.MarkerLayer(
        markers,
        onTap: (cords, data) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => PostScreenWidget(post: data),
            ),
          );
        },
        onLongPress: (position, latlng) {
          if (latlng is LatLng && mounted)
            setState(() {
              markers.removeWhere((marker) => marker.latlng == latlng);
            });
        },
      ),
    );
  }
}
