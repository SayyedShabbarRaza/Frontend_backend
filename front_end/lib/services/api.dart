import 'dart:convert';
import 'package:front_end/controllers/image_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // static const baseUrl = "http://server-theta-taupe-81.vercel.app/api/";
  static const baseUrl = "http://192.168.93.188:3000/api/";

  // static Future<dynamic> register(Map data) async {
  //   print(data);
  //   var url = Uri.parse("${baseUrl}register");
  //   try {
  //     final res = await http.post(url, body: data);
  //     if (res.statusCode == 200) {
  //       var responseData = jsonDecode(res.body.toString());
  //       // print("code 200:$data");
  //       if (responseData['token'] != null) {
  //         _storeToken(responseData['token']);
  //         return responseData['message'];
  //       }
  //     } else {
  //       print("failed to get response");
  //       return 'Data not submitted';
  //     }
  //   } catch (e) {
  //     print("...${e.toString()} ....");
  //     return 'An error occured';
  //   }
  // }

  static Future<dynamic> uploadAvatar(Map userData) async {
    ImageController imageController = Get.find<ImageController>();
    if (imageController.image.value == null) return 'Avatar is empty';

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.93.188:3000/api/register'));

    //Attach user data as fields
    userData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageController.image.value!.path,
      contentType:
          MediaType('image', 'jpeg'), // Define content type using MediaType
    ));

    // Send the request
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        var responseBody = await response.stream.bytesToString();
        var res = jsonDecode(responseBody);
        if (res['token'] != null) {
          _storeToken(res['token']);
          return res['message'];
        }

        print('Response: ${res['message']}');
        return res['message'];
        // Handle the response, like displaying the image URL
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
    }
  }

//login
  static Future<dynamic> login(Map data) async {
    print(data);
    var url = Uri.parse("${baseUrl}login");
    try {
      final res = await http.post(url, body: data);
      var responseData = jsonDecode(res.body.toString());
      if (res.statusCode == 200) {
        if (responseData['token'] != null) {
          _storeToken(responseData['token']);
          return responseData;
        }
      } else {
        return responseData;
      }
    } catch (e) {
      print("...${e.toString()} ....");
      return 'An error occured';
    }
  }

// Function to remove the JWT token during logout
  static Future<dynamic> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    print("Token removed");
    return "token removed";
  }

  // Function to make an API request with the token
  static Future<dynamic> getPosts() async {
    var url = Uri.parse("${baseUrl}getPost");

    try {
      String? token = await getToken();
      if (token == null) {
        return "No token found";
      }
      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var responseData = jsonDecode(res.body.toString());
      // print(responseData);
      if (res.statusCode == 200) {
        return responseData;
      } else {
        return "Failed to make request";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  // Function to make an API request with the token
  static Future<dynamic> uploaPost(dynamic data) async {
    var url = Uri.parse("${baseUrl}post");

    try {
      String? token = await getToken();
      if (token == null) {
        return "No token found";
      }
      final res = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      var responseData = jsonDecode(res.body.toString());

      if (res.statusCode == 200) {
        return responseData;
      } else {
        return "Failed to make request";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  // Function to make an API request with the token
  static Future<dynamic> updatePost(dynamic data) async {
    var url = Uri.parse("${baseUrl}update/${data['id']}");
    try {
      String? token = await getToken();
      if (token == null) {
        return "No token found";
      }
      final res = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      var responseData = jsonDecode(res.body.toString());

      if (res.statusCode == 200) {
        print(responseData);
        return responseData;
      } else {
        return "Failed to make request";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  static Future<dynamic> delete(dynamic data) async {
    var url = Uri.parse("${baseUrl}delete/$data");
    try {
      String? token = await getToken();
      if (token == null) {
        return "No token found";
      }
      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var responseData = jsonDecode(res.body.toString());

      if (res.statusCode == 200) {
        return responseData;
      } else {
        return "Failed to make request";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  static Future<dynamic> like(dynamic id) async {
    var url = Uri.parse("${baseUrl}like/$id");

    try {
      String? token = await getToken();
      if (token == null) {
        return "No token found";
      }
      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var responseData = jsonDecode(res.body.toString());

      if (res.statusCode == 200) {
        print(responseData);

        return responseData;
      } else {
        return "Failed to make request";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  //Token_operations
  // Function to store the JWT token in SharedPreferences
  static Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
    // print("Token stored: $token");
  }

  // Function to get the stored JWT token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');
    // print(token);
    return token;
  }
}
