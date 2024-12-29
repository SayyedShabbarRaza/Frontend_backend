import 'package:flutter/material.dart';
import 'package:front_end/controllers/controller.dart';
import 'package:front_end/controllers/image_controller.dart';
import 'package:front_end/controllers/post_controller.dart';
import 'package:front_end/views/auth/register_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  Get.put(PpController());
  Get.put(PController());
  Get.put(ImageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.amber,
          primaryColor: Colors.amber,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.amber)),
      color: Colors.amber,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:const FormScreen(),
    );
  }
}
