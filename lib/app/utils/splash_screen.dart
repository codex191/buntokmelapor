import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: Get.width * 0.75,
            height: Get.height * 0.75,
            // color: Colors.amber,
            child: Lottie.asset("assets/lottie/welcome.json"),
          ),
        ),
      ),
    );
  }
}
