import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pertanyaan_controller.dart';

class PertanyaanView extends GetView<PertanyaanController> {
  const PertanyaanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PertanyaanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PertanyaanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
