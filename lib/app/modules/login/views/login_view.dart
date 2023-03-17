import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.9,
              height: Get.width * 0.9,
              child: Lottie.asset("assets/lottie/aduan.json"),
            ),
            SizedBox(
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: () => authC.login(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/logo/google.png",
                        width: 45,
                        height: 45,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Masuk dengan Google",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red[800],
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text("Buntok Melapor"),
            Text("v.0.1")
          ],
        ),
      ),
    )));
  }
}
