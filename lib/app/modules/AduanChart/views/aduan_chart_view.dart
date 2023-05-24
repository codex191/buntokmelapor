import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/aduan_chart_controller.dart';

class AduanChartView extends GetView<AduanChartController> {
  const AduanChartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AduanChartView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AduanChartView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
