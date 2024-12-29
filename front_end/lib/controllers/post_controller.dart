import 'package:get/get.dart';

class PController extends GetxController {
  var editText = ''.obs;
  var pId = ''.obs;
  var avatar = ''.obs;
  var name = ''.obs;

  void passUser(dynamic dp) {
    avatar.value = dp['avatar'];
    name.value = dp['name'];
  }

  void passPost(dynamic editT, dynamic id) {
    editText.value = editT;
    pId.value = id;
  }
}
