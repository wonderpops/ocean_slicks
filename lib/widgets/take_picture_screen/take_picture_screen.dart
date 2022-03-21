import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/CamerasController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../constants/colors.dart';
import '../../controllers/add_post_controller.dart';
import 'dart:math';

class _SensorsListeners {
  var accelerometer_listener =
      accelerometerEvents.listen((AccelerometerEvent event) {
    print(event);
  });
  var gyroscope_listener = gyroscopeEvents.listen((GyroscopeEvent event) {
    print(event);
  });
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  double xInclination = 0;
  double yInclination = 0;
  double zInclination = 0;
  String angles_data = '';

  @override
  void initState() {
    CamerasController cam_ctrl = Get.find();
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cam_ctrl.cameras.first,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // _sensorsListeners = _SensorsListeners();

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  void get_camera_angles() async {
    AccelerometerEvent accelerometer_data = await accelerometerEvents.first;
    double x = accelerometer_data.x,
        y = accelerometer_data.y,
        z = accelerometer_data.z;
    double norm_Of_g = sqrt(accelerometer_data.x * accelerometer_data.x +
        accelerometer_data.y * accelerometer_data.y +
        accelerometer_data.z * accelerometer_data.z);
    x = accelerometer_data.x / norm_Of_g;
    y = accelerometer_data.y / norm_Of_g;
    z = accelerometer_data.z / norm_Of_g;

    xInclination = -(asin(x) * (180 / pi));
    yInclination = (acos(y) * (180 / pi));
    zInclination = (atan(z) * (180 / pi));

    xInclination = (xInclination * 100).round() / 100;
    yInclination = (yInclination * 100).round() / 100;
    zInclination = (zInclination * 100).round() / 100;

    String xAngle = "$xInclination°";
    String yAngle = "$yInclination°";
    String zAngle = "$zInclination°";
    angles_data = "$xAngle $yAngle $zAngle";
    setState(() {});
  }

  void take_picture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/Pictures/flutter_test';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${timestamp()}.jpg';

      image.saveTo(filePath);

      AddPostController ap_ctrl = Get.find();

      ap_ctrl.selectedImageId = ap_ctrl.photos.length;
      ap_ctrl.photos.add({'id': ap_ctrl.photos.length, 'filePath': filePath});

      // TODO optimization needed

      ap_ctrl.photos.last['xInclination'] = xInclination;
      ap_ctrl.photos.last['yInclination'] = yInclination;
      ap_ctrl.photos.last['zInclination'] = zInclination;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      ap_ctrl.photos.last['latitude'] = position.latitude;
      ap_ctrl.photos.last['longitude'] = position.longitude;
      ap_ctrl.photos.last['altitude'] = position.altitude;

      // If the picture was taken, display it on a new screen.
      Navigator.of(context).pop();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    // _sensorsListeners.accelerometer_listener.cancel();
    // _sensorsListeners.gyroscope_listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    get_camera_angles();
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return SafeArea(
            child: Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_controller),
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          child: Center(
                            child: Container(
                              height: 80,
                              width: 80,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Colors.white.withOpacity(.9),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.camera,
                                            size: 60,
                                            color:
                                                accent_color.withOpacity(.6))),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: take_picture,
                                      splashColor: accent_color.withOpacity(.1),
                                      hoverColor: accent_color.withOpacity(.1),
                                      highlightColor:
                                          accent_color.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(40),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.indigo.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 40,
                                )),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  print('alo');
                                  Navigator.of(context).pop();
                                },
                                splashColor: accent_color.withOpacity(.1),
                                hoverColor: accent_color.withOpacity(.1),
                                highlightColor: accent_color.withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      child: Text(
                    angles_data,
                    style: TextStyle(color: Colors.red, fontSize: 28),
                  )),
                ],
              ),
            ),
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
