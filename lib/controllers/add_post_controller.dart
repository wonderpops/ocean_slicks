// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddPostController extends GetxController {
  TextEditingController title_ctrl = TextEditingController();
  TextEditingController descryption_ctrl = TextEditingController();
  List photos = [].obs;
  int selectedImageId = -1;
  bool isPostUploadingInProgress = false;

  // TODO check fields on emptyness

  void clear_data() {
    photos = [].obs;
    title_ctrl = TextEditingController();
    descryption_ctrl = TextEditingController();
    selectedImageId = -1;
  }

  int remove_photo(id) {
    photos.remove(photos.elementAt(id));
    for (var i = 0; i < photos.length; i++) {
      photos[i]['id'] = i;
    }
    return photos.isEmpty ? -1 : photos.last['id'];
  }
}
