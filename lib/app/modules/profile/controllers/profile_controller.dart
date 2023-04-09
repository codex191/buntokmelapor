import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;

  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
  }
}
