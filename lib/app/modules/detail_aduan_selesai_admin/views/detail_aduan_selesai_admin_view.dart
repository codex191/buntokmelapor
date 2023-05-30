import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_aduan_selesai_admin_controller.dart';

class DetailAduanSelesaiAdminView
    extends GetView<DetailAduanSelesaiAdminController> {
  const DetailAduanSelesaiAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailAduanSelesaiAdminView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailAduanSelesaiAdminView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
