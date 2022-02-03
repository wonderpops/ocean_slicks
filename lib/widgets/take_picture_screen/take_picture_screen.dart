import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/CamerasController.dart';
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
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Stack(
            children: [
              Transform.scale(
                scale: _controller.value.aspectRatio / deviceRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      color: Colors.grey.withOpacity(.4))),
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

                                    // If the picture was taken, display it on a new screen.
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DisplayPictureScreen(
                                          // Pass the automatically generated path to
                                          // the DisplayPictureScreen widget.
                                          imagePath: image.path,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print(e);
                                  }
                                },
                                splashColor:
                                    Colors.yellowAccent.withOpacity(.7),
                                hoverColor: Colors.yellowAccent.withOpacity(.7),
                                borderRadius: BorderRadius.circular(40),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
    // floatingActionButton: FloatingActionButton(
    //   // Provide an onPressed callback.
    //   onPressed: () async {
    //     // Take the Picture in a try / catch block. If anything goes wrong,
    //     // catch the error.
    //     try {
    //       // Ensure that the camera is initialized.
    //       await _initializeControllerFuture;

    //       // Attempt to take a picture and get the file `image`
    //       // where it was saved.
    //       final image = await _controller.takePicture();

    //       // If the picture was taken, display it on a new screen.
    //       await Navigator.of(context).push(
    //         MaterialPageRoute(
    //           builder: (context) => DisplayPictureScreen(
    //             // Pass the automatically generated path to
    //             // the DisplayPictureScreen widget.
    //             imagePath: image.path,
    //           ),
    //         ),
    //       );
    //     } catch (e) {
    //       // If an error occurs, log the error to the console.
    //       print(e);
    //     }
    //   },
    //   child: const Icon(Icons.camera_alt),
    // ),
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
