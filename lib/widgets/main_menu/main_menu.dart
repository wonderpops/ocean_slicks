import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/widgets/add_post_screen/add_post_screen.dart';
import 'package:ocean_slicks/widgets/home_screen/home_screen.dart';
import 'package:ocean_slicks/widgets/map_screen/map_screen.dart';
import 'package:ocean_slicks/widgets/messages_screen/messages_screen.dart';
import 'package:ocean_slicks/widgets/profile_screen/profile_screen.dart';
// import 'package:ocean_slicks/widgets/take_picture_screen/take_picture_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/services.dart';

import '../../controllers/add_post_controller.dart';

class MainMenuWidget extends StatefulWidget {
  const MainMenuWidget({Key? key}) : super(key: key);

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

int _current_index = 0;

Widget getBodyByIndex(index) {
  switch (index) {
    case 0:
      return HomeScreenWidget();
    case 1:
      return MapWidget();
    case 2:
      return AddPostWidget();
    case 3:
      return MessagesScreenWidget();
    case 4:
      return ProfileScreenWidget();
    default:
      return HomeScreenWidget();
  }
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    AddPostController ap_ctrl = Get.find();
    _dismissDialog() {
      Navigator.pop(context);
    }

    void _showMaterialDialog(i) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Warning!'),
              content: Text(
                  'If you leave this screen, all data will be lost. \n\nContinue?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      _dismissDialog();
                    },
                    child: Text('Back',
                        style: TextStyle(color: accent_color.withOpacity(.8)))),
                TextButton(
                  onPressed: () {
                    _dismissDialog();
                    ap_ctrl.clear_data();
                    _current_index = i;
                    setState(() {});
                  },
                  child: Text(
                    'Leave',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                )
              ],
            );
          });
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Container(
          color: light_color,
          child: SalomonBottomBar(
            currentIndex: _current_index,
            onTap: (i) => setState(() {
              if ((_current_index == 2) && (i != 2)) {
                if (ap_ctrl.photos.isNotEmpty) {
                  _showMaterialDialog(i);
                } else {
                  _current_index = i;
                }
              } else {
                _current_index = i;
              }
            }),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                selectedColor: accent_color.withOpacity(.4),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.map_outlined),
                title: const Text("Map"),
                selectedColor: accent_color.withOpacity(.4),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.add_circle_rounded),
                title: const Text("Add post"),
                selectedColor: accent_color.withOpacity(.4),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.message_outlined),
                title: const Text("Messages"),
                selectedColor: accent_color.withOpacity(.4),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_outline),
                title: const Text("Profile"),
                selectedColor: accent_color.withOpacity(.4),
              ),
            ],
          ),
        ),
        body: SafeArea(child: getBodyByIndex(_current_index)));
  }
}
