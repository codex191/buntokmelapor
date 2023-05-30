import 'package:get/get.dart';

import '../controllers/list_aduan_proses_admin_controller.dart';

class ListAduanProsesAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAduanProsesAdminController>(
      () => ListAduanProsesAdminController(),
    );
  }
}
