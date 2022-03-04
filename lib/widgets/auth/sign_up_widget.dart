import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/controllers/auth_controller.dart';

class SignUpWidget extends StatelessWidget {
  SignUpWidget(
      {Key? key,
      required this.username_ctrl,
      required this.password_ctrl,
      required this.repeat_password_ctrl,
      required this.on_sign_up,
      required this.sign_up_complete})
      : super(key: key);
  final Future<bool> Function(String, String, String) on_sign_up;
  final Function() sign_up_complete;

  TextEditingController username_ctrl;
  TextEditingController password_ctrl;
  TextEditingController repeat_password_ctrl;

  @override
  Widget build(BuildContext context) {
    AuthController auth_ctrl = Get.find();
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: dark_color.withOpacity(.1),
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: dark_color.withOpacity(.8)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.how_to_reg_rounded,
                      color: dark_color.withOpacity(.8),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
            child: Text(
              'Sign up to ocean slicks!',
              style: TextStyle(color: dark_color),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          AutofillGroup(
              child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  readOnly: auth_ctrl.isSignUpInProcess,
                  autofillHints: const [
                    AutofillHints.username,
                    AutofillHints.email
                  ],
                  keyboardType: TextInputType.text,
                  controller: username_ctrl,
                  style: const TextStyle(color: dark_color),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.6)),
                    hintStyle: TextStyle(color: dark_color.withOpacity(.4)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: dark_color)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: dark_color),
                    ),
                    labelText: 'Username',
                    hintText: 'my_username',
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  readOnly: auth_ctrl.isSignUpInProcess,
                  autofillHints: const [AutofillHints.password],
                  keyboardType: TextInputType.text,
                  controller: password_ctrl,
                  obscureText: true,
                  style: const TextStyle(color: dark_color),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.6)),
                    hintStyle: TextStyle(color: dark_color.withOpacity(.4)),
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: dark_color)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: dark_color),
                    ),
                    counterStyle: const TextStyle(color: dark_color),
                    labelText: 'Password',
                    hintText: 'my_pass_1234',
                    focusColor: dark_color,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  readOnly: auth_ctrl.isSignUpInProcess,
                  autofillHints: const [
                    AutofillHints.password,
                  ],
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  controller: repeat_password_ctrl,
                  style: const TextStyle(color: dark_color),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.6)),
                    hintStyle: TextStyle(color: dark_color.withOpacity(.4)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: dark_color)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: dark_color),
                    ),
                    labelText: 'Repeat password',
                    hintText: 'my_pass_1234',
                  ),
                ),
              ),
            ],
          )),
          const SizedBox(
            height: 16,
          ),
          // const _errorMessageWidget(),
          _SignUpButtonWidget(
            on_sign_up: on_sign_up,
            sign_up_complete: sign_up_complete,
            username: username_ctrl.text,
            password: password_ctrl.text,
            repeat_password: password_ctrl.text,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class _SignUpButtonWidget extends StatelessWidget {
  _SignUpButtonWidget(
      {Key? key,
      required this.on_sign_up,
      required this.sign_up_complete,
      required this.username,
      required this.password,
      required this.repeat_password})
      : super(key: key);

  final Future<bool> Function(String, String, String) on_sign_up;
  final Function() sign_up_complete;

  String username;
  String password;
  String repeat_password;

  @override
  Widget build(BuildContext context) {
    AuthController auth_ctrl = Get.find();
    return Container(
      height: 60,
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: dark_color,
                  boxShadow: [
                    BoxShadow(
                      color: dark_color.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 20),
                    ),
                  ]),
              alignment: Alignment.center,
              width: double.maxFinite,
              child: auth_ctrl.isSignUpInProcess
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(color: Colors.white))
                  : const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
          Material(
            color: Colors.transparent,
            child: Visibility(
              visible: !auth_ctrl.isSignUpInProcess,
              child: InkWell(
                onTap: () async {
                  bool auth =
                      await on_sign_up(username, password, repeat_password);
                  print(auth);
                  if (auth) {
                    sign_up_complete();
                  }
                },
                focusColor: dark_color.withOpacity(.1),
                splashColor: Colors.white.withOpacity(.1),
                hoverColor: dark_color.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
