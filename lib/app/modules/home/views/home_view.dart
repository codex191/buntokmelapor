import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var friendEmail = "codexgaming191@gmail.com";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Inisialisasi GlobalKey di Scaffold
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset('assets/logo/LogoKominfoTanpaTeks.png'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.blueAccent),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(), // Membuka drawer menggunakan GlobalKey
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: authC.user.value.photoUrl! == "noimage"
                  ? AssetImage("assets/logo/LogoKominfoTanpaTeks.png")
                  : NetworkImage(authC.user.value.photoUrl!) as ImageProvider,
            ),
            accountName: Obx(() => Text("${authC.user.value.name}")),
            accountEmail: Obx(() => Text("${authC.user.value.email}")),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          _buildDrawerItem(Icons.face, 'Profil Anda', Routes.PROFILE),
          _buildDrawerItem(Icons.list, 'Aduan Anda', Routes.LIST_ADUAN_USER),
          _buildDrawerItem(Icons.search, 'Cari', Routes.SEARCH_CHAT),
          _buildDrawerItem(Icons.chat, 'Kontak Masuk', Routes.ADMIN_CHAT),
          _buildDrawerItem(Icons.logout, 'Log Out', () => _showLogoutDialog()),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                Text("Buntok Melapor", style: TextStyle(color: Colors.grey)),
                Text("v.0.0.1", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, dynamic route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      onTap: () => route is String ? Get.toNamed(route) : route(),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'Keluar',
      middleText: 'Apakah Anda yakin ingin keluar?',
      textCancel: 'TIDAK',
      textConfirm: 'YA',
      confirmTextColor: Colors.white,
      onConfirm: () => authC.logout(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.ADUAN_PAGE),
            child: const Text('Masukan Laporan Anda'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo('assets/logo/LogoUPR.png'),
                SizedBox(width: 16),
                _buildLogo('assets/logo/LogoPemko.png'),
                SizedBox(width: 16),
                _buildLogo('assets/logo/LogoKominfo.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String path) {
    return Image.asset(
      path,
      width: 75,
      height: 75,
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFloatingActionButton(Icons.help_rounded, 'btnChat', () {
          authC.addNewConnection(friendEmail);
        }),
        SizedBox(height: 10),
        _buildFloatingActionButton(Icons.feedback_rounded, 'btnFeedback', () {
          Get.toNamed(Routes.FEEDBACK_PAGE);
        }),
      ],
    );
  }

  Widget _buildFloatingActionButton(
      IconData icon, String heroTag, VoidCallback onPressed) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: Colors.blueAccent,
      child: Icon(icon),
    );
  }
}
