import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_admin_controller.dart';

// ignore: must_be_immutable
class HomeAdminView extends GetView<HomeAdminController> {
  final authC = Get.find<AuthController>();
  var friendEmail = "codexgaming191@gmail.com";

  Stream<DateTime> clockStream =
      Stream<DateTime>.periodic(Duration(seconds: 1), (i) => DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            StreamBuilder<DateTime>(
              stream: clockStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('dd MMMM yyyy').format(DateTime.now())),
                      SizedBox(height: 8),
                      Text(
                        '${snapshot.data!.hour}:${snapshot.data!.minute}:${snapshot.data!.second}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ],
                  );
                } else {
                  return Text('Loading...');
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('aduan').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                int totalReports = snapshot.data!.docs.length;
                int unresolvedReports = snapshot.data!.docs
                    .where((doc) => doc['status'] == 'Belum Ditanggapi')
                    .toList()
                    .length;
                int resolvedReports = snapshot.data!.docs
                    .where((doc) => doc['status'] == 'Selesai')
                    .toList()
                    .length;

                return Expanded(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(12),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    children: [
                      _buildCard(
                        title: 'TOTAL LAPORAN MASUK',
                        value: totalReports.toString(),
                        color: Colors.blueAccent,
                      ),
                      _buildCard(
                        title: 'LAPORAN BELUM SELESAI',
                        value: unresolvedReports.toString(),
                        color: Colors.orange,
                      ),
                      _buildCard(
                        title: 'LAPORAN SELESAI',
                        value: resolvedReports.toString(),
                        color: Colors.green,
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
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
      drawer: Drawer(
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
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          authC.user.value.photoUrl!,
                          fit: BoxFit.cover,
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
              leading: const Icon(Icons.chat),
              title: const Text('Aduan Masuk'),
              onTap: () => Get.toNamed(Routes.LIST_ADUAN_MASUK_ADMIN),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Aduan Diproses'),
              onTap: () => Get.toNamed(Routes.LIST_ADUAN_PROSES_ADMIN),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Analisis Data Aduan'),
              onTap: () => Get.toNamed(Routes.ADUAN_ANALISIS),
            ),
            //UNTUK TEST SAJA
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text('Cari'),
              onTap: () => Get.toNamed(Routes.SEARCH_CHAT),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Kontak Masuk'),
              onTap: () => Get.toNamed(Routes.ADMIN_CHAT),
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
          ],
        ),
      ),
    );
  }
}

Widget _buildCard(
    {required String title, required String value, required Color color}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 5,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}
