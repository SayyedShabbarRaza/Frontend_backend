import 'package:flutter/material.dart';
import 'package:front_end/controllers/controller.dart';
import 'package:front_end/controllers/post_controller.dart';
import 'package:front_end/services/api.dart';
import 'package:front_end/views/edit_view.dart';
import 'package:get/get.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PpController ppController = Get.find<PpController>();
  final PController pController = Get.find<PController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Obx(() {
        if (ppController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: ppController.posts.length,
          itemBuilder: (context, index) {
            final post = ppController.posts[index];
            final isLiked = post['isLiked'] ?? false;

            return ListTile(
              title: Text(post['content']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final res = await Api.delete(post['_id']);
                      if (res['status'] == 200) {
                        setState(() {
                          ppController.fetchData();
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(res['message'])));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      pController.passPost(
                        post['content'],
                        post['_id'],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      ppController.toggleLike(post['_id'], index);
                    },
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
