import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/list_aduan_masuk_admin_controller.dart';

class ListAduanMasukAdminView extends GetView<ListAduanMasukAdminController> {
  const ListAduanMasukAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Aduan Masuk',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: controller.getAduanList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var listAllAduan = snapshot.data!.docs;
              return ListView.builder(
                itemCount: listAllAduan.length,
                itemBuilder: (context, index) => Card(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(0),
                    child: Row(children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (listAllAduan[index].data() as Map<String,
                                              dynamic>)["photoUrl"] !=
                                          null &&
                                      (listAllAduan[index].data() as Map<String,
                                              dynamic>)["photoUrl"] !=
                                          ''
                                  ? NetworkImage(
                                      "${(listAllAduan[index].data() as Map<String, dynamic>)["photoUrl"]}")
                                  : Image.asset("assets/logo/gambar-kosong.png")
                                      .image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 14,
                        child: Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "${(listAllAduan[index].data() as Map<String, dynamic>)["judul"]}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Tanggal aduan : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${(listAllAduan[index].data() as Map<String, dynamic>)["tanggal"]}",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Status :",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${(listAllAduan[index].data() as Map<String, dynamic>)["status"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => Get.toNamed(
                                          Routes.DETAIL_ADUAN_MASUK_ADMIN,
                                          arguments: listAllAduan[index].id),
                                      child: Text("Detail Aduan"),
                                    ),
                                    // TextButton(
                                    //   onPressed: () => controller
                                    //       .editAduan(listAllAduan[index].id),
                                    //   child: Text("Proseskan"),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
