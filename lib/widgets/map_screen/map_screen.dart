import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/universe.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

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
      center: [51.555158, -0.108343],
      zoom: 12,
      showLocator: true,
      moveWhenLive: true,
      live: true,
      onChanged: (center, zoom, rotation) {
        setState(() {
          // TODO update markers here
          // Marker marker = U.Marker(center, data: center);
          // markers.add(marker);
        });
      },
      markers: U.MarkerLayer(
        markers,
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
