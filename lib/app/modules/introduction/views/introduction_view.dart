import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Selamat Datang di Buntok Melapor",
          body: "Welcome to the app! This is a description of how it works.",
          image: Container(
            width: Get.width * 0.6,
            height: Get.height * 0.6,
            child: Center(
              child: Lottie.asset("assets/lottie/welcomesatu.json"),
            ),
          ),
        ),
        PageViewModel(
          title: "Laporkan masalah Anda",
          body: "Laporkan temuan yang menurut Anda perlu diperbaiki.",
          image: Container(
            width: Get.width * 0.6,
            height: Get.height * 0.6,
            child: Center(
              child: Lottie.asset("assets/lottie/aduan.json"),
            ),
          ),
        ),
        PageViewModel(
          title: "Lihat Status Laporan Anda",
          body: "Lihat status yang Anda laporkan.",
          image: Container(
            width: Get.width * 0.6,
            height: Get.height * 0.6,
            child: Center(
              child: Lottie.asset("assets/lottie/orangmainhp.json"),
            ),
          ),
        ),
        PageViewModel(
          title: "Gabung Sekarang Juga",
          body: "Daftarkan diri Anda untuk menjadi bagian dari kami.",
          image: Container(
            width: Get.width * 0.6,
            height: Get.height * 0.6,
            child: Center(
              child: Lottie.asset("assets/lottie/register.json"),
            ),
          ),
        ),
      ],
      showSkipButton: true,
      skip: Text("Skip"),
      next: Text(
        "Next",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
      onDone: () => Get.offAllNamed(Routes.LOGIN),
    ));
  }
}
