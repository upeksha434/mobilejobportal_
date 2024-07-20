import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilejobportal/utils/backgrounds.dart';
import 'package:mobilejobportal/utils/text_styles.dart';
import 'package:mobilejobportal/controllers/auth_controller.dart';
class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Backgrounds.themeBackground(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * 0.8,
                  height: Get.height * 0.7,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/Icon.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Sign In',
                            style: TextStyles.h1(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: AuthController.emailController,
                            decoration:
                            const InputDecoration(label: Text('Email')),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            controller: AuthController.passwordController,
                            obscureText: AuthController.isPasswordVisible.value,
                            decoration:
                            const InputDecoration(label: Text('Password')),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: Obx(() => ElevatedButton(
                                onPressed: () {
                                  AuthController.signIn();
                                },
                                child: AuthController.loading.value
                                    ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.white),
                                )
                                    : const Text('Sign In'),
                              )))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
