import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/auth_controller.dart';
import 'package:ocean_slicks/widgets/auth/sign_in_widget.dart';
import 'package:ocean_slicks/widgets/auth/sign_up_widget.dart';
import 'package:ocean_slicks/widgets/main_menu/main_menu.dart';

import '../../constants/colors.dart';

class LoginScreenWidget extends StatefulWidget {
  LoginScreenWidget({Key? key}) : super(key: key);

  final username_ctrl = TextEditingController();
  final password_ctrl = TextEditingController();
  final repeat_password_ctrl = TextEditingController();

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  bool is_sign_up_clicked = false;

  Future<bool> onSignInClick(String username, String password) async {
    AuthController auth_ctrl = Get.find();
    //* Auth logic here
    auth_ctrl.isAuthInProcess = true;
    setState(() {});

    bool auth = await auth_ctrl.auth(username, password);

    auth_ctrl.isAuthInProcess = false;
    setState(() {});
    return auth;
  }

  Future<bool> onSignUp(
      String username, String password, String repeat_password) async {
    //* SignUp logic here
    AuthController auth_ctrl = Get.find();
    bool auth;

    auth_ctrl.isSignUpInProcess = true;
    setState(() {});
    if (password == repeat_password) {
      auth = await auth_ctrl.sign_up(username, password);
    } else {
      auth = false;
    }
    auth_ctrl.isSignUpInProcess = false;
    setState(() {});
    return auth;
  }

  void onSignUpClick() {
    is_sign_up_clicked = true;
    setState(() {});
  }

  void signUpComplete() {
    is_sign_up_clicked = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            light_color,
            gray_color,
          ],
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: !is_sign_up_clicked,
                  child: SignInWidget(
                    username_ctrl: widget.username_ctrl,
                    password_ctrl: widget.password_ctrl,
                    onSignInClick: onSignInClick,
                    onSignUpClick: onSignUpClick,
                  ),
                ),
                Visibility(
                  visible: is_sign_up_clicked,
                  child: SignUpWidget(
                    username_ctrl: widget.username_ctrl,
                    password_ctrl: widget.password_ctrl,
                    repeat_password_ctrl: widget.repeat_password_ctrl,
                    on_sign_up: onSignUp,
                    sign_up_complete: signUpComplete,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
