// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:front_end/controllers/post_controller.dart';
import 'package:front_end/services/api.dart';
import 'package:front_end/views/post_screen.dart';
import 'package:front_end/widgets/app_custom_button.dart';
import 'package:front_end/widgets/app_custom_text_field.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final postController = TextEditingController();
  final PController pController =
      Get.find<PController>(); // Fetch the existing instance.

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: PrimaryButton(
                text: 'Logout',
                function: () async {
                  final res = await Api.logout();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(res)));
                },
                color: Colors.redAccent,
                width: MediaQuery.of(context).size.width * .25,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(pController.avatar.value.toString()),
                minRadius: 36,
              ),
            ],
          ),
          Center(
            child: Text(pController.name.value.toString()),
          ),
          Container(
              margin: const EdgeInsets.all(15),
              child: CustomTextField(controller: postController, text: 'post')),
          PrimaryButton(
            function: () async {
              var data = {
                "post": postController.text.toString(),
              };
              var res = await Api.uploaPost(data);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(res['message'])));
              postController.clear();
            },
            text: 'Post',
          ),
          TextButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostScreen()));
              },
              child: const Text('view Posts'))
        ],
      ),
    );
  }
}
