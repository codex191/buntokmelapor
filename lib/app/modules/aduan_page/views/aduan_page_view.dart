import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/aduan_page_controller.dart';

class AduanPageView extends GetView<AduanPageController> {
  const AduanPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AduanPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AduanPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
