import 'package:get/get.dart';

class AddPostController extends GetxController {
  List photos = [].obs;
  int selectedImageId = -1;

  void clear_data() {
    photos = [].obs;
    int selectedImageId = -1;
  }

  int remove_photo(id) {
    photos.remove(photos.elementAt(id));
    return selectedImageId -= 1;
  }
}
