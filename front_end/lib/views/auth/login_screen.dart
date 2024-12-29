import 'package:flutter/material.dart';
import 'package:front_end/controllers/post_controller.dart';
import 'package:front_end/services/api.dart';
import 'package:front_end/views/profile_screen.dart';
import 'package:front_end/widgets/app_custom_button.dart';
import 'package:front_end/widgets/app_custom_text_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PController pController = Get.find<PController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogIn'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTextField(
                  text: 'Email',
                  controller: emailController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  text: 'Password',
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                        text: 'Login',
                        function: () async {
                          var data = {
                            "email": emailController.text.toString(),
                            "password": passwordController.text.toString(),
                          };
                          final res = await Api.login(data);
                          if (res['status'] == "200") {
                            pController.passUser(res['user']);

                            Navigator.pushReplacement(
                                context,
                                (MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                )));
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(res['message'])));
                          emailController.clear();
                          passwordController.clear();
                        }),
                  ],
                ),
                TextButton(
                    onPressed: () async {
                      final res = await Api.getToken();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(res.toString())));
                    },
                    child: const Text('print token'))
              ],
            ),
          )),
        ],
      ),
    );
  }
}
