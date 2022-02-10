import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ocean_slicks/controllers/auth_controller.dart';
import 'package:ocean_slicks/widgets/main_menu/main_menu.dart';

class LoginScreenWidget extends StatefulWidget {
  LoginScreenWidget({Key? key}) : super(key: key);

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  final username_ctrl = TextEditingController();
  final password_ctrl = TextEditingController();

  Future<bool> onSignInClick() async {
    AuthController auth_ctrl = Get.find();
    //* Auth logic here
    auth_ctrl.isAuthInProcess = true;
    setState(() {});

    bool auth = await auth_ctrl.auth(username_ctrl.text, password_ctrl.text);

    auth_ctrl.isAuthInProcess = false;
    setState(() {});
    return auth;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    AuthController auth_ctrl = Get.find();
    return Scaffold(
      body: Container(
        color: Colors.indigo[50],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.login_outlined,
                              color: Colors.indigo,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Welcome back to ocean slicks!',
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AutofillGroup(
                          child: Column(
                        children: [
                          TextField(
                            readOnly: auth_ctrl.isAuthInProcess,
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email
                            ],
                            keyboardType: TextInputType.text,
                            controller: username_ctrl,
                            style: const TextStyle(color: Colors.indigo),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(.6)),
                              hintStyle: TextStyle(
                                  color: Colors.indigo.withOpacity(.4)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      const BorderSide(color: Colors.indigo)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide:
                                    const BorderSide(color: Colors.indigo),
                              ),
                              labelText: 'username',
                              hintText: 'my_username',
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            readOnly: auth_ctrl.isAuthInProcess,
                            autofillHints: const [AutofillHints.password],
                            keyboardType: TextInputType.text,
                            controller: password_ctrl,
                            obscureText: true,
                            style: const TextStyle(color: Colors.indigo),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(.6)),
                              hintStyle: TextStyle(
                                  color: Colors.indigo.withOpacity(.4)),
                              fillColor: Colors.indigo,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      const BorderSide(color: Colors.indigo)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide:
                                    const BorderSide(color: Colors.indigo),
                              ),
                              counterStyle:
                                  const TextStyle(color: Colors.indigo),
                              labelText: 'Password',
                              hintText: 'my_pass_1234',
                              focusColor: Colors.indigo,
                            ),
                          )
                        ],
                      )),
                      const SizedBox(
                        height: 15,
                      ),
                      const _errorMessageWidget(),
                      _AuthButtonWidget(
                        onSignInClick: onSignInClick,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class AuthButtonWidget extends StatefulWidget {
//   AuthButtonWidget({Key? key, required this.onSignInClick}) : super(key: key);

//   final void Function() onSignInClick;

//   @override
//   State<AuthButtonWidget> createState() => _AuthButtonWidgetState();
// }

// class _AuthButtonWidgetState extends State<AuthButtonWidget> {
//   @override
//   Widget build(BuildContext context) {
//     AuthController auth_ctrl = Get.find();

//     return Container(
//       height: 60,
//       child: Stack(
//         children: [
//           Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.indigo,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.indigo.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 7,
//                       offset: const Offset(0, 20),
//                     ),
//                   ]),
//               alignment: Alignment.center,
//               width: double.maxFinite,
//               child: auth_ctrl.isAuthInProcess
//                   ? const SizedBox(
//                       height: 30,
//                       width: 30,
//                       child: CircularProgressIndicator(color: Colors.white))
//                   : const Text(
//                       'Sign In',
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     )),
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 widget.onSignInClick();
//               },
//               focusColor: Colors.indigo.withOpacity(.1),
//               splashColor: Colors.indigo.withOpacity(.1),
//               hoverColor: Colors.indigo.withOpacity(.1),
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 alignment: Alignment.center,
//                 width: double.maxFinite,
//                 height: double.maxFinite,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _AuthButtonWidget extends StatelessWidget {
  _AuthButtonWidget({Key? key, required this.onSignInClick}) : super(key: key);
  final Future<bool> Function() onSignInClick;

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
                  bool auth = await onSignInClick();
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
                splashColor: Colors.indigo.withOpacity(.1),
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
      padding: const EdgeInsets.only(bottom: 15),
      // child: Text(
      //   errorMessage.toString(),
      //   style: const TextStyle(color: Colors.redAccent),
      // ),
    );
  }
}
