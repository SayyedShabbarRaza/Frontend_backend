import 'package:get/get.dart';
import 'package:front_end/services/api.dart';

class PpController extends GetxController {
  var posts = [].obs; // Reactive posts list
  var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    fetchData();
  }

  Future<dynamic> fetchData() async {
    isLoading.value = true;
    posts.value = await Api.getPosts();
    isLoading.value = false;
  }

  Future<void> toggleLike(String postId, int index) async {
    final currentLikeState = posts[index]['isLiked'] ?? false;

//     if (posts[index]['isLiked'] != null) {
//   currentLikeState = posts[index]['isLiked'];
// } else {
//   currentLikeState = false;

    // Update UI optimistically
    posts[index]['isLiked'] = !currentLikeState;
    posts.refresh();
    try {
      final res = await Api.like(postId);
      if (res['status'] == 200) {
        // Sync with server's state
        posts[index]['isLiked'] = res['isLiked'];
        posts.refresh();
      } else {
        throw Exception("Failed to update like status");
      }
    } catch (e) {
      // Revert state on error
      posts[index]['isLiked'] = currentLikeState;
      posts.refresh();
      print("Error toggling like: $e");
    }
  }
}






















// import 'package:get/get.dart';
// import 'package:front_end/services/api.dart';

// class PpController extends GetxController {
//   var posts = [].obs; // Reactive posts list
//   var isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchPosts();
//   }

//   Future<void> fetchPosts() async {
//     isLoading.value = true;
//     try {
//       final data = await Api.getPosts();
//       posts.value = data; // Update posts list
//     } catch (e) {
//       print("Error fetching posts: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> toggleLike(String postId, int index) async {
//     final currentLikeState = posts[index]['isLiked'] ?? false;

//     // Update UI optimistically
//     posts[index]['isLiked'] = !currentLikeState;
//     posts.refresh();

//     try {
//       final res = await Api.like(postId);
//       if (res['status'] == 200) {
//         // Sync with server's state
//         posts[index]['isLiked'] = res['isLiked'];
//         posts.refresh();
//       } else {
//         throw Exception("Failed to update like status");
//       }
//     } catch (e) {
//       // Revert state on error
//       posts[index]['isLiked'] = currentLikeState;
//       posts.refresh();
//       print("Error toggling like: $e");
//     }
//   }
// }
