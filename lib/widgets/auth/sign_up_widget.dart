// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/controllers/auth_controller.dart';

class SignUpWidget extends StatelessWidget {
  SignUpWidget({
    Key? key,
  }) : super(key: key);

  TextEditingController username_ctrl = TextEditingController();
  TextEditingController email_ctrl = TextEditingController();
  TextEditingController password_ctrl = TextEditingController();
  TextEditingController repeat_password_ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthController auth_ctrl = Get.find();
    return Scaffold(
      backgroundColor: gray_color,
      body: Container(
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
                      borderRadius: BorderRadius.circular(30)),
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
                      labelStyle: TextStyle(color: dark_color.withOpacity(.4)),
                      hintStyle: TextStyle(color: dark_color.withOpacity(.2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(.4))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: dark_color.withOpacity(.4)),
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
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    readOnly: auth_ctrl.isSignUpInProcess,
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email
                    ],
                    keyboardType: TextInputType.text,
                    controller: email_ctrl,
                    style: const TextStyle(color: dark_color),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: dark_color.withOpacity(.4)),
                      hintStyle: TextStyle(color: dark_color.withOpacity(.2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(.4))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: dark_color.withOpacity(.4)),
                      ),
                      labelText: 'Email',
                      hintText: 'my_username@mail.com',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    readOnly: auth_ctrl.isSignUpInProcess,
                    autofillHints: const [AutofillHints.password],
                    keyboardType: TextInputType.text,
                    controller: password_ctrl,
                    obscureText: true,
                    style: const TextStyle(color: dark_color),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: dark_color.withOpacity(.4)),
                      hintStyle: TextStyle(color: dark_color.withOpacity(.2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(.4))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: dark_color.withOpacity(.4)),
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
                      borderRadius: BorderRadius.circular(30)),
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
                      labelStyle: TextStyle(color: dark_color.withOpacity(.4)),
                      hintStyle: TextStyle(color: dark_color.withOpacity(.2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(.4))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: dark_color.withOpacity(.4)),
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
              username: username_ctrl,
              email: email_ctrl,
              password: password_ctrl,
              repeat_password: repeat_password_ctrl,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpButtonWidget extends StatefulWidget {
  _SignUpButtonWidget(
      {Key? key,
      required this.username,
      required this.email,
      required this.password,
      required this.repeat_password})
      : super(key: key);

  TextEditingController username;
  TextEditingController email;
  TextEditingController password;
  TextEditingController repeat_password;

  @override
  State<_SignUpButtonWidget> createState() => _SignUpButtonWidgetState();
}

class _SignUpButtonWidgetState extends State<_SignUpButtonWidget> {
  Future<bool> onSignUp(String username, String email, String password,
      String repeat_password) async {
    //* SignUp logic here
    AuthController auth_ctrl = Get.find();
    bool isAuth;
    Map response;

    auth_ctrl.isSignUpInProcess = true;
    setState(() {});
    print(password);
    print(repeat_password);

    if (password == repeat_password) {
      response = await auth_ctrl.sign_up(username, email, password);
      isAuth = response.containsKey('error') ? false : true;
    } else {
      isAuth = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords does not match"),
      ));
    }

    auth_ctrl.isSignUpInProcess = false;
    setState(() {});
    return isAuth;
  }

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
                  bool auth = await onSignUp(
                      widget.username.text,
                      widget.email.text,
                      widget.password.text,
                      widget.repeat_password.text);
                  print(auth);
                  if (auth) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("SignUp error"),
                    ));
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
