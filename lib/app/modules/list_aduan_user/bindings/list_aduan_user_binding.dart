import 'package:get/get.dart';

import '../controllers/list_aduan_user_controller.dart';

class ListAduanUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAduanUserController>(
      () => ListAduanUserController(),
    );
  }
}
