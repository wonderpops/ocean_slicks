import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthController extends GetxController {
  bool isAuthInProcess = false;

  Future<bool> check_auth() async {
    await Future.delayed(const Duration(seconds: 10));
    return false;
  }

  Future<bool> auth(String username, String password) async {
    await Future.delayed(const Duration(seconds: 10));
    print(username);
    print(password);
    return true;
  }
}
