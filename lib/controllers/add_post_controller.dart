import 'package:get/get.dart';

class AddPostController extends GetxController {
  List photos = [].obs;
  double latitude = 0;
  double longitude = 0;
  double altitude = 0;
  double xInclination = 0;
  double yInclination = 0;
  double zInclination = 0;

  void clear_data() {
    photos = [].obs;
    latitude = 0;
    longitude = 0;
    altitude = 0;
    xInclination = 0;
    yInclination = 0;
    zInclination = 0;
  }
}
