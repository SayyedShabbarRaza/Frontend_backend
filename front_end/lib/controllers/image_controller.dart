import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  Rx<File?> image = Rx<File?>(null);
  var pickedFile;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      update();
    }
  }

  void clearImage() {
    image.value = null;
    update();
  }
}
