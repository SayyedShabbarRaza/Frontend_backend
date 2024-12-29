// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:front_end/controllers/controller.dart';
import 'package:front_end/controllers/post_controller.dart';
import 'package:front_end/services/api.dart';
import 'package:front_end/widgets/app_custom_button.dart';
import 'package:front_end/widgets/app_custom_text_field.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class EditView extends StatefulWidget {
  const EditView({super.key});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  var postController = TextEditingController();
  final PController pController =
      Get.find<PController>(); 
  final PpController ppController =
      Get.find<PpController>(); 

  @override
  void initState() {
    postController.text = pController.editText.value;
    super.initState();
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Screen'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.all(15),
              child: CustomTextField(controller: postController, text: 'post')),
          PrimaryButton(
            function: () async {
              var data = {
                "id": pController.pId.value.toString(),
                "post": postController.text.toString(),
              };
              var res = await Api.updatePost(data);
              if (res['status'] == 200) {
                ppController.fetchData();
                Navigator.pop(context);
              }
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(res['message'])));
              postController.clear();
            },
            text: 'Update',
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
