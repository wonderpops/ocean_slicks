import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/constants/colors.dart';
import 'package:ocean_slicks/controllers/auth_controller.dart';
import 'package:ocean_slicks/widgets/auth/sign_up_widget.dart';
import 'package:ocean_slicks/widgets/main_menu/main_menu.dart';

class SignInWidget extends StatelessWidget {
  SignInWidget({
    Key? key,
  }) : super(key: key);

  TextEditingController username_ctrl = TextEditingController();
  TextEditingController password_ctrl = TextEditingController();

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
                      'Sign In',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: dark_color.withOpacity(.8)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.login_outlined,
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
                'Welcome back to ocean slicks!',
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
                    readOnly: auth_ctrl.isAuthInProcess,
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
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    onChanged: (text) {
                      print('First text field: $text');
                    },
                    readOnly: auth_ctrl.isAuthInProcess,
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
                )
              ],
            )),
            const SizedBox(
              height: 16,
            ),
            // const _errorMessageWidget(),
            _AuthButtonWidget(
              username: username_ctrl,
              password: password_ctrl,
            ),
            const SizedBox(
              height: 16,
            ),
            _SignUpButtonWidget(),
          ],
        ),
      ),
    );
  }
}

class _AuthButtonWidget extends StatefulWidget {
  _AuthButtonWidget({Key? key, required this.username, required this.password})
      : super(key: key);
  TextEditingController username;
  TextEditingController password;

  @override
  State<_AuthButtonWidget> createState() => _AuthButtonWidgetState();
}

class _AuthButtonWidgetState extends State<_AuthButtonWidget> {
  Future<bool> onSignInClick(String username, String password) async {
    AuthController auth_ctrl = Get.find();
    //* Auth logic here
    auth_ctrl.isAuthInProcess = true;
    setState(() {});

    Map response =
        await auth_ctrl.signIn(username: username, password: password);

    bool isAuth = response.containsKey('error') ? false : true;

    auth_ctrl.isAuthInProcess = false;
    setState(() {});
    print(await auth_ctrl.access_token);
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
                  borderRadius: BorderRadius.circular(30),
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
                  print(widget.username.text);
                  print(widget.password.text);
                  bool auth = await onSignInClick(
                      widget.username.text, widget.password.text);
                  print(auth);
                  if (auth) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const MainMenuWidget(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("SignIn error"),
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

class _SignUpButtonWidget extends StatelessWidget {
  _SignUpButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController auth_ctrl = Get.find();

    return Container(
      height: 60,
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
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
              child: const Text(
                'Sign Up',
                style: TextStyle(color: dark_color, fontSize: 20),
              )),
          Material(
            color: Colors.transparent,
            child: Visibility(
              visible: !auth_ctrl.isAuthInProcess,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SignUpWidget(),
                    ),
                  );
                },
                focusColor: dark_color.withOpacity(.2),
                splashColor: dark_color.withOpacity(.4),
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
