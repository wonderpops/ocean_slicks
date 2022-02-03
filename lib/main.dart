import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/widgets/main_menu/main_menu.dart';

import 'controllers/CamerasController.dart';

Future<void> main() async {
  CamerasController cam_ctrl = CamerasController();
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  cam_ctrl.cameras = await availableCameras();
  Get.put(cam_ctrl);

  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: const MainMenuWidget(),
    ),
  );
}

// TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
