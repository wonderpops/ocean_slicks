// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'auth_controller.dart';

class ApiController extends GetxController {
  final _client = http.Client();
  AuthController auth_ctrl = Get.find();
  static const _host = 'http://192.168.0.198:5002';

  Future<String> upload_image(String file_path) async {
    final _file = File(file_path);
    String _server_path = '';

    var stream = new http.ByteStream(_file.openRead());
    stream.cast();

    var length = await _file.length();

    var uri = Uri.parse("$_host/upload_image");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(_file.path));

    request.files.add(multipartFile);

    var response = await request.send();
    print(response.statusCode);

    _server_path = await response.stream.transform(convert.utf8.decoder).first;

    _server_path = _server_path.replaceAll('"', '');

    return _server_path;
  }

  Future<Map<String, dynamic>> upload_image_data(Map image_data) async {
    var img_data = {
      "user_id": 1,
      "image_path": image_data['server_path'],
      "latitude": image_data['latitude'],
      "longitude": image_data['longitude'],
      "x_angle": image_data['xInclination'] ?? null,
      "y_angle": image_data['yInclination'] ?? null,
      "z_angle": image_data['zInclination'] ?? null,
      "azimuth": image_data['azimuth'] ?? null,
      "altitude": image_data['altitude'] ?? null,
    };

    var body = convert.jsonEncode(img_data);

    final url = Uri.parse('$_host/upload_image_data');

    try {
      final response = await _client.post(url,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: body);
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

  Future<Map<String, dynamic>> add_post(
      String title, String descryption, List images) async {
    List images_formatted = [];
    for (var img in images) {
      var img_data = {
        "user_id": 1,
        "image_path": img['server_path'],
        "latitude": img['latitude'],
        "longitude": img['longitude'],
        "x_angle": img['xInclination'] ?? null,
        "y_angle": img['yInclination'] ?? null,
        "z_angle": img['zInclination'] ?? null,
        "azimuth": img['azimuth'] ?? null,
        "altitude": img['altitude'] ?? null,
      };
      images_formatted.add(img_data);
    }

    var pst_data = {
      "user_id": 1,
      "images": images_formatted,
      "title": title,
      "descryption": descryption,
    };

    String access_token = await auth_ctrl.access_token;

    var body = convert.jsonEncode(pst_data);
    print('body: $body');

    final url = Uri.parse('$_host/add_post');

    try {
      final response = await _client.post(url,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $access_token'
          },
          body: body);
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

  Future<Map<String, dynamic>> get_all_posts() async {
    final url = Uri.parse('$_host/get_all_posts');

    try {
      final response = await _client.get(url, headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        final json =
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as List;
        print(json);
        return {'posts': json};
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

  Future<Map<String, dynamic>> get_posts_by_id(int id) async {
    final url = Uri.parse('$_host/get_post?id=$id');

    try {
      final response = await _client.get(url, headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        final json = convert.jsonDecode(convert.utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
        // print(json);
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

  Future<Map<String, dynamic>> get_posts_in_bounds(
      min_lat, min_lng, max_lat, max_lng) async {
    final url = Uri.parse(
        '$_host/get_posts_in_bounds?min_lat=$min_lat&min_lng=$min_lng&max_lat=$max_lat&max_lng=$max_lng');

    try {
      final response = await _client.get(url, headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        final json =
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as List;
        // print(json);
        return {'posts': json};
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
}
