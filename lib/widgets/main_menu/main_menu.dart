import 'package:flutter/material.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/widgets/add_post_screen/add_post_screen.dart';
import 'package:ocean_slicks/widgets/home_screen/home_screen.dart';
import 'package:ocean_slicks/widgets/map_screen/map_screen.dart';
import 'package:ocean_slicks/widgets/messages_screen/messages_screen.dart';
// import 'package:ocean_slicks/widgets/take_picture_screen/take_picture_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/services.dart';

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
      return Container();
    default:
      return HomeScreenWidget();
  }
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: accent_color,
    ));
    return Scaffold(
        bottomNavigationBar: Container(
          color: light_color,
          child: SalomonBottomBar(
            currentIndex: _current_index,
            onTap: (i) => setState(() {
              _current_index = i;
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
        body: getBodyByIndex(_current_index));
  }
}
