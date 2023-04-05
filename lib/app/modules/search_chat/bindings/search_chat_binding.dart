import 'package:get/get.dart';

import '../controllers/search_chat_controller.dart';

class SearchChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchChatController>(
      () => SearchChatController(),
    );
  }
}
