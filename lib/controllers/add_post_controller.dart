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
    for (var i = 0; i < photos.length; i++) {
      photos[i]['id'] = i;
    }
    return photos.isEmpty ? -1 : photos.last['id'];
  }
}
