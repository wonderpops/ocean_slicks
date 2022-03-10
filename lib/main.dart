import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/widgets/auth/login_screen.dart';
import 'package:ocean_slicks/widgets/main_menu/main_menu.dart';

import 'controllers/CamerasController.dart';
import 'controllers/add_post_controller.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  CamerasController cam_ctrl = CamerasController();
  AuthController auth_ctrl = AuthController();
  Get.put(auth_ctrl);
  AddPostController ap_ctrl = AddPostController();
  Get.put(ap_ctrl);
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  cam_ctrl.cameras = await availableCameras();
  Get.put(cam_ctrl);

  bool user_is_auth = await auth_ctrl.check_auth();

  // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: secondary_color,
  // ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: secondary_color,
    systemNavigationBarColor: secondary_color,
  ));

  runApp(
    MaterialApp(
      title: 'Ocean slicks',
      home: user_is_auth ? const MainMenuWidget() : LoginScreenWidget(),
    ),
  );
}
