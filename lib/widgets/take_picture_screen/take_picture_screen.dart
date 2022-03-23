import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/CamerasController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock/wakelock.dart';

import '../../constants/colors.dart';
import '../../controllers/add_post_controller.dart';
import 'dart:math';

import 'package:flutter/foundation.dart';

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
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  double xInclination = 0;
  double yInclination = 0;
  double zInclination = 0;
  double azimuth = 0;
  String angles_data = '';
  bool is_taking_picture = false;

  @override
  void initState() {
    CamerasController cam_ctrl = Get.find();
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      cam_ctrl.cameras.first,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // _sensorsListeners = _SensorsListeners();

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _cameraController.initialize();

    _cameraController.setFlashMode(FlashMode.off);

    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ));
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

    final CompassEvent tmp = await FlutterCompass.events!.first;
    azimuth = tmp.heading!;

    String xAngle = "$xInclination°";
    String yAngle = "$yInclination°";
    String zAngle = "$zInclination°";
    String sAzimuth = "$azimuth°";
    angles_data = "$xAngle $yAngle $zAngle $sAzimuth";
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
      final image = await _cameraController.takePicture();

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
      ap_ctrl.photos.last['altitude'] = (position.altitude * 100).round() / 100;

      ap_ctrl.photos.last['azimuth'] = (azimuth * 100).round() / 100;

      Wakelock.disable();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: secondary_color,
        systemNavigationBarColor: secondary_color,
      ));

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

    _cameraController.dispose();
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
              backgroundColor: Colors.black,
              body: Stack(
                alignment: Alignment.center,
                children: [
                  _CameraPreview(controller: _cameraController),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 40,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 40,
                                    )),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Wakelock.disable();
                                    SystemChrome.setEnabledSystemUIMode(
                                        SystemUiMode.manual);
                                    SystemChrome.setSystemUIOverlayStyle(
                                        SystemUiOverlayStyle(
                                      statusBarColor: secondary_color,
                                      systemNavigationBarColor: secondary_color,
                                    ));
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
                      Text(
                        angles_data,
                        style: TextStyle(color: Colors.red, fontSize: 28),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 250,
                            // color: Colors.lightGreenAccent,
                            child: Center(
                              child: Container(
                                height: 90,
                                width: 90,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white,
                                          ),
                                          alignment: Alignment.center,
                                          child: is_taking_picture
                                              ? CircularProgressIndicator(
                                                  color: accent_color
                                                      .withOpacity(.6),
                                                )
                                              : Icon(Icons.camera,
                                                  size: 70,
                                                  color: accent_color
                                                      .withOpacity(.6))),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          is_taking_picture = true;
                                          setState(() {});
                                          take_picture();
                                        },
                                        splashColor:
                                            accent_color.withOpacity(.1),
                                        hoverColor:
                                            accent_color.withOpacity(.1),
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
                    ],
                  ),
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

class _CameraPreview extends StatelessWidget {
  const _CameraPreview({Key? key, required this.controller, this.child})
      : super(key: key);

  /// The controller for the camera that the preview is shown for.
  final CameraController controller;

  /// A widget to overlay on top of the camera preview
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? ValueListenableBuilder<CameraValue>(
            valueListenable: controller,
            builder: (BuildContext context, Object? value, Widget? child) {
              return AspectRatio(
                aspectRatio: _isLandscape()
                    ? controller.value.aspectRatio
                    : (1 / controller.value.aspectRatio),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _wrapInRotatedBox(child: controller.buildPreview()),
                    child ?? Container(),
                  ],
                ),
              );
            },
            child: child,
          )
        : Container();
  }

  Widget _wrapInRotatedBox({required Widget child}) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return child;
    }

    return RotatedBox(
      quarterTurns: _getQuarterTurns(),
      child: child,
    );
  }

  bool _isLandscape() {
    return <DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ].contains(_getApplicableOrientation());
  }

  int _getQuarterTurns() {
    final Map<DeviceOrientation, int> turns = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeRight: 1,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeLeft: 3,
    };
    return turns[_getApplicableOrientation()]!;
  }

  DeviceOrientation _getApplicableOrientation() {
    return controller.value.isRecordingVideo
        ? controller.value.recordingOrientation!
        : (controller.value.previewPauseOrientation ??
            controller.value.lockedCaptureOrientation ??
            controller.value.deviceOrientation);
  }
}
