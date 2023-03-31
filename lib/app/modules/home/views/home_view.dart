import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
  var friendEmail = "codexgaming191@gmail.com";
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        elevation: 4,
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset('assets/logo/LogoKominfoTanpaTeks.png'),
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Container(
                margin: EdgeInsets.all(15),
                width: 250,
                height: 175,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: authC.user.value.photoUrl! == "noimage"
                      ? Image.asset(
                          "assets/logo/LogoKominfoTanpaTeks.png",
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          authC.user.value.photoUrl!,
                          fit: BoxFit.fill,
                          height: 250,
                          width: 250,
                        ),
                ),
              ),
              accountName: Obx(() => Text("${authC.user.value.name}")),
              accountEmail: Obx(() => Text("${authC.user.value.email}")),
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text('Profil Anda'),
              onTap: () => Get.toNamed(Routes.PROFILE),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Apakah Anda yakin untuk keluar?'),
                        content: const Text('Tekan Ya jika ingin logout'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('TIDAK')),
                          TextButton(
                              onPressed: () => authC.logout(),
                              child: Text('YA')),
                        ],
                      );
                    });
              },
            ),
            Expanded(child: Text("")),
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Buntok Melapor"),
                    Text("v.0.0.1"),
                  ]),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {}, child: const Text('Masukan Laporan Anda')),
            Expanded(
              child: Text(""),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/LogoUPR.png',
                    width: 75,
                    height: 75,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    'assets/logo/LogoPemko.png',
                    width: 75,
                    height: 75,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    'assets/logo/LogoKominfo.png',
                    width: 75,
                    height: 75,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          authC.addNewConnection(friendEmail);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.help_rounded),
      ),
    );
  }
}
