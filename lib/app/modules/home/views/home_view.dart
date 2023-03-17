import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();
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
          child: Image.asset('assets/LogoKominfoTanpaTeks.png'),
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: Image.network(authC.user.photoUrl!),
              // ),
              accountName: Text("test@gmail.com"),
              accountEmail: Text("test@gmail.com"),
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text('Profil Anda'),
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
                    Text("Lapor! Palangka Raya"),
                    Text("v.1.0.0"),
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
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.help_rounded),
      ),
    );
  }
}
