import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/CamerasController.dart';
import 'package:path_provider/path_provider.dart';
// A screen that allows users to take a picture using a given camera.

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

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Stack(
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
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.white.withOpacity(.9),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.camera,
                                        size: 60,
                                        color: Colors.indigo.withOpacity(.6))),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    // Take the Picture in a try / catch block. If anything goes wrong,
                                    // catch the error.
                                    try {
                                      // Ensure that the camera is initialized.
                                      await _initializeControllerFuture;

                                      // Attempt to take a picture and get the file `image`
                                      // where it was saved.
                                      final image =
                                          await _controller.takePicture();

                                      String timestamp() => DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                      final Directory extDir =
                                          await getApplicationDocumentsDirectory();
                                      final String dirPath =
                                          '${extDir.path}/Pictures/flutter_test';
                                      await Directory(dirPath)
                                          .create(recursive: true);
                                      final String filePath =
                                          '$dirPath/${timestamp()}.jpg';

                                      image.saveTo(filePath);

                                      // If the picture was taken, display it on a new screen.
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DisplayPictureScreen(
                                            // Pass the automatically generated path to
                                            // the DisplayPictureScreen widget.
                                            imagePath: filePath,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      // If an error occurs, log the error to the console.
                                      print(e);
                                    }
                                  },
                                  splashColor: Colors.indigo.withOpacity(.1),
                                  hoverColor: Colors.indigo.withOpacity(.1),
                                  highlightColor: Colors.indigo.withOpacity(.1),
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
                            splashColor: Colors.indigo.withOpacity(.1),
                            hoverColor: Colors.indigo.withOpacity(.1),
                            highlightColor: Colors.indigo.withOpacity(.1),
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
              )
            ],
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
