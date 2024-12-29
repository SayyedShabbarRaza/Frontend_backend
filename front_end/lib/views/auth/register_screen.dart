import 'package:flutter/material.dart';
import 'package:front_end/controllers/image_controller.dart';
import 'package:front_end/services/api.dart';
import 'package:front_end/views/auth/login_screen.dart';
import 'package:front_end/widgets/app_custom_button.dart';
import 'package:front_end/widgets/app_custom_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  ImageController imageController = Get.find<ImageController>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('SignUP'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    imageController.pickImage();
                  },
                  child: Obx(() {
                    return CircleAvatar(
                      backgroundColor: Colors.amber,
                      backgroundImage: imageController.image.value == null
                          ? const AssetImage('assets/images/user_icon.png')
                          : FileImage(imageController.image.value!),
                      minRadius: 36,
                    );
                  }),
                )
              ],
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        text: 'Name',
                        controller: nameController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: 'Username',
                        controller: usernameController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Username is required'
                            : null,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: 'Age',
                        controller: ageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age is required';
                          }
                          if (int.tryParse(value) == null ||
                              int.parse(value) <= 0) {
                            return 'Enter a valid age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: 'Email',
                        controller: emailController,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: 'Password',
                        controller: passwordController,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryButton(
                            text: 'Submit',
                            function: () async {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.amber)),
                                );
                                var data = {
                                  "name": nameController.text.trim(),
                                  "username": usernameController.text.trim(),
                                  "age": ageController.text.trim(),
                                  "email": emailController.text.trim(),
                                  "password": passwordController.text.trim(),
                                };
                                final ress = await Api.uploadAvatar(data);
                                Navigator.pop(context); // Close loader

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(ress)));
                                imageController.clearImage();

                                nameController.clear();
                                usernameController.clear();
                                ageController.clear();
                                emailController.clear();
                                passwordController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text('Already have an account? Login'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
