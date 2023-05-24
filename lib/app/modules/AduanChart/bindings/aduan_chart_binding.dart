import 'package:get/get.dart';

import '../controllers/aduan_chart_controller.dart';

class AduanChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AduanChartController>(
      () => AduanChartController(),
    );
  }
}
