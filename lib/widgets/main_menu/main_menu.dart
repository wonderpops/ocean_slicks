import 'package:flutter/material.dart';
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

class _MainMenuWidgetState extends State<MainMenuWidget> {
  Color? bg_color = Colors.indigo[50];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
        backgroundColor: bg_color,
        bottomNavigationBar: Container(
          color: Colors.white,
          child: SalomonBottomBar(
            currentIndex: _current_index,
            onTap: (i) => setState(() {
              _current_index = i;
              switch (_current_index) {
                case 0:
                  bg_color = Colors.indigo[50];
                  break;
                case 1:
                  bg_color = Colors.pink[50];
                  break;
                case 2:
                  bg_color = Colors.orange[50];
                  break;
                case 3:
                  bg_color = Colors.teal[50];
                  break;
              }
            }),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                selectedColor: Colors.indigo,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.map_outlined),
                title: const Text("Map"),
                selectedColor: Colors.pink,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.message_outlined),
                title: const Text("Messages"),
                selectedColor: Colors.orange,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_outline),
                title: const Text("Profile"),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
        body: _current_index == 0
            ? HomeScreenWidget()
            : _current_index == 1
                ? MapWidget()
                : _current_index == 2
                    ? MessagesScreenWidget()
                    : Container());
  }
}
