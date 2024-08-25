import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/list_aduan_user_controller.dart';

class ListAduanUserView extends GetView<ListAduanUserController> {
  const ListAduanUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Aduan'),
      ),
      child: StreamBuilder<QuerySnapshot<Object?>>(
          stream: controller.streamData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Tidak ada data',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Masukkan aduan Anda',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
              }
              var listAllAduan = snapshot.data!.docs;
              return ListView.builder(
                itemCount: listAllAduan.length,
                itemBuilder: (context, index) => Card(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(0),
                    child: Row(children: [
                      // Expanded(
                      //   flex: 6,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: NetworkImage(
                      //               "${(listAllAduan[index].data() as Map<String, dynamic>)["gambarUrl"]}"),
                      //           fit: BoxFit.fill),
                      //     ),
                      //   ),
                      // ),
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
                                    "Status : ",
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
                                      onPressed: () {},
                                      // onPressed: () => Get.toNamed(
                                      //     RouteName.DetailAduan,
                                      //     arguments: listAllAduan[index].id),
                                      child: Text("Detail Aduan"),
                                    ),
                                    // TextButton(
                                    //   onPressed: null,
                                    //   child: Text("Selesaikan"),
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
