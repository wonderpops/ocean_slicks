import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/auth_controller.dart';
import 'package:ocean_slicks/widgets/main_menu/main_menu.dart';

class SignInWidget extends StatelessWidget {
  SignInWidget(
      {Key? key,
      required this.username_ctrl,
      required this.password_ctrl,
      required this.onSignInClick,
      required this.onSignUpClick})
      : super(key: key);
  final Future<bool> Function(String, String) onSignInClick;
  final Function() onSignUpClick;

  TextEditingController username_ctrl;
  TextEditingController password_ctrl;

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
                color: Colors.indigo.withOpacity(.1),
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.withOpacity(.8)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.login_outlined,
                      color: Colors.indigo.withOpacity(.8),
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
              'Welcome back to ocean slicks!',
              style: TextStyle(color: Colors.indigo),
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
                  readOnly: auth_ctrl.isAuthInProcess,
                  autofillHints: const [
                    AutofillHints.username,
                    AutofillHints.email
                  ],
                  keyboardType: TextInputType.text,
                  controller: username_ctrl,
                  style: const TextStyle(color: Colors.indigo),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.6)),
                    hintStyle: TextStyle(color: Colors.indigo.withOpacity(.4)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.indigo)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                    labelText: 'username',
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
                  readOnly: auth_ctrl.isAuthInProcess,
                  autofillHints: const [AutofillHints.password],
                  keyboardType: TextInputType.text,
                  controller: password_ctrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.indigo),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.6)),
                    hintStyle: TextStyle(color: Colors.indigo.withOpacity(.4)),
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.indigo)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                    counterStyle: const TextStyle(color: Colors.indigo),
                    labelText: 'Password',
                    hintText: 'my_pass_1234',
                    focusColor: Colors.indigo,
                  ),
                ),
              )
            ],
          )),
          const SizedBox(
            height: 16,
          ),
          // const _errorMessageWidget(),
          _AuthButtonWidget(
            onSignInClick: onSignInClick,
            username: username_ctrl.text,
            password: password_ctrl.text,
          ),
          const SizedBox(
            height: 16,
          ),
          _SignUpButtonWidget(
            onSignUpClick: onSignUpClick,
          ),
        ],
      ),
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  _AuthButtonWidget(
      {Key? key,
      required this.onSignInClick,
      required this.username,
      required this.password})
      : super(key: key);
  final Future<bool> Function(String, String) onSignInClick;
  String username;
  String password;

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
                  color: Colors.indigo,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 20),
                    ),
                  ]),
              alignment: Alignment.center,
              width: double.maxFinite,
              child: auth_ctrl.isAuthInProcess
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(color: Colors.white))
                  : const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
          Material(
            color: Colors.transparent,
            child: Visibility(
              visible: !auth_ctrl.isAuthInProcess,
              child: InkWell(
                onTap: () async {
                  bool auth = await onSignInClick(username, password);
                  print(auth);
                  if (auth) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const MainMenuWidget(),
                      ),
                    );
                  }
                },
                focusColor: Colors.indigo.withOpacity(.1),
                splashColor: Colors.white.withOpacity(.1),
                hoverColor: Colors.indigo.withOpacity(.1),
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

class _errorMessageWidget extends StatelessWidget {
  const _errorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      // child: Text(
      //   errorMessage.toString(),
      //   style: const TextStyle(color: Colors.redAccent),
      // ),
    );
  }
}

class _SignUpButtonWidget extends StatelessWidget {
  _SignUpButtonWidget({Key? key, required this.onSignUpClick})
      : super(key: key);
  final Function() onSignUpClick;

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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 20),
                    ),
                  ]),
              alignment: Alignment.center,
              width: double.maxFinite,
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.indigo, fontSize: 20),
              )),
          Material(
            color: Colors.transparent,
            child: Visibility(
              visible: !auth_ctrl.isAuthInProcess,
              child: InkWell(
                onTap: () {
                  onSignUpClick();
                },
                focusColor: Colors.indigo.withOpacity(.2),
                splashColor: Colors.indigo.withOpacity(.4),
                hoverColor: Colors.indigo.withOpacity(.1),
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
