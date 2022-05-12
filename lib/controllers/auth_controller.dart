// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AuthController extends GetxController {
  bool isAuthInProcess = false;
  bool isSignUpInProcess = false;

  final storage = new FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<String> get access_token async {
    print('lol');
    return await storage.read(
            key: 'access_token', aOptions: _getAndroidOptions()) ??
        '';
  }

  Future<String> get refresh_token async {
    return await storage.read(
            key: 'refresh_token', aOptions: _getAndroidOptions()) ??
        '';
  }

  Future<int> get expires_at async {
    return int.parse(
        await storage.read(key: 'expires_at', aOptions: _getAndroidOptions()) ??
            '0');
  }

  setAccessToken(String token) async {
    print('token: $token');
    await storage.write(
        key: 'access_token', value: token, aOptions: _getAndroidOptions());
  }

  setRefreshToken(String token) async {
    await storage.write(
        key: 'refresh_token', value: token, aOptions: _getAndroidOptions());
  }

  setExpires_at(int seconds) async {
    await storage.write(
        key: 'expires_at',
        value: seconds.toString(),
        aOptions: _getAndroidOptions());
  }

  // set access_token(Future<String> token) {
  //   () async {}();
  // }

  // set refresh_token(Future<String> token) {
  //   () async {}();
  // }

  final _client = http.Client();
  static const _host = 'http://192.168.0.196:5002';

  Future<bool> check_auth() async {
    print('auth cheking...');
    DateTime now = DateTime.now();
    bool isRefreshed = false;
    int _expires_at = await expires_at;
    var epochTime = now.millisecondsSinceEpoch / 1000;
    if (access_token != '') {
      print('_expires_at: $_expires_at, epochTime: $epochTime');
      if (await _expires_at < epochTime - 10) {
        print('refreshing tokens...');
        isRefreshed = await _refresh_tokens(await refresh_token);
        print('auth cheked');
        return isRefreshed;
      } else {
        print('auth cheked');
        return true;
      }
    } else {
      print('auth error');
      return false;
    }
  }

  Future<bool> auth(String username, String password) async {
    await Future.delayed(const Duration(seconds: 10));
    print(username);
    print(password);
    return true;
  }

  Future<Map<String, dynamic>> signIn({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$_host/login?username=$username&password=$password');
    try {
      final response =
          await _client.post(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print(json);
        setAccessToken(json['access_token']);
        setRefreshToken(json['refresh_token']);
        setExpires_at(json['expires_at']);
        return json;
      } else {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return {'error': json};
      }
    } catch (error) {
      return {
        'error': {'detail': 'Server connection failed'}
      };
    }
  }

  Future<Map<String, dynamic>> sign_up(
      String username, String email, String password) async {
    final url = Uri.parse(
        '$_host/signup?username=$username&email=$email&password=$password');
    try {
      final response =
          await _client.post(url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return json;
      } else {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return {'error': json};
      }
    } catch (error) {
      return {
        'error': {'detail': 'Server connection failed'}
      };
    }
  }

  Future<bool> _refresh_tokens(String refresh_token) async {
    final url = Uri.parse('$_host/refresh');
    try {
      final response = await _client.post(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $refresh_token'
      });
      if (response.statusCode == 200) {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        setAccessToken(json['access_token']);
        setRefreshToken(json['refresh_token']);
        setExpires_at(json['expires_at']);
        print({'Refreshing complite: ': json});
        return true;
      } else {
        final json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print({'Refreshing error: ': json});
        return false;
      }
    } catch (error) {
      print('Refreshing error: server connection failed');
      return false;
    }
  }
}
