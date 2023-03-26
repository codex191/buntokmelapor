import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
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
