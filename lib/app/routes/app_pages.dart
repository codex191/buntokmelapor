import 'package:get/get.dart';

import '../modules/admin_chat/bindings/admin_chat_binding.dart';
import '../modules/admin_chat/views/admin_chat_view.dart';
import '../modules/aduan_page/bindings/aduan_page_binding.dart';
import '../modules/aduan_page/views/aduan_page_view.dart';
import '../modules/change_profile/bindings/change_profile_binding.dart';
import '../modules/change_profile/views/change_profile_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/feedback_page/bindings/feedback_page_binding.dart';
import '../modules/feedback_page/views/feedback_page_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/list_aduan_user/bindings/list_aduan_user_binding.dart';
import '../modules/list_aduan_user/views/list_aduan_user_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pertanyaan/bindings/pertanyaan_binding.dart';
import '../modules/pertanyaan/views/pertanyaan_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_chat/bindings/search_chat_binding.dart';
import '../modules/search_chat/views/search_chat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PERTANYAAN,
      page: () => PertanyaanView(),
      binding: PertanyaanBinding(),
    ),
    GetPage(
      name: _Paths.ADUAN_PAGE,
      page: () => AduanPageView(),
      binding: AduanPageBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PROFILE,
      page: () => ChangeProfileView(),
      binding: ChangeProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.HOME_ADMIN,
      page: () => HomeAdminView(),
      binding: HomeAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CHAT,
      page: () => AdminChatView(),
      binding: AdminChatBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_CHAT,
      page: () => SearchChatView(),
      binding: SearchChatBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK_PAGE,
      page: () => FeedbackPageView(),
      binding: FeedbackPageBinding(),
    ),
    GetPage(
      name: _Paths.LIST_ADUAN_USER,
      page: () => ListAduanUserView(),
      binding: ListAduanUserBinding(),
    ),
  ];
}
