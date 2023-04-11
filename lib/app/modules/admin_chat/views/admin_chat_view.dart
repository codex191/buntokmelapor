import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_chat_controller.dart';

class AdminChatView extends GetView<AdminChatController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(Routes.SEARCH_CHAT),
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ))
          ],
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          flexibleSpace: Material(
            elevation: 0,
            child: Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kontak Masuk",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(110),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.chatsStream(authC.user.value.email!),
              builder: (context, snapshot1) {
                print(snapshot1.data);
                if (snapshot1.connectionState == ConnectionState.active) {
                  var allChats = (snapshot1.data!.data()
                      as Map<String, dynamic>)["chats"] as List;
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: allChats.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller
                                .friendStream(allChats[index]["connection"]),
                            builder: ((context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.active) {
                                var data = snapshot2.data!.data();
                                return ListTile(
                                  onTap: () {},
                                  leading: CircleAvatar(
                                      radius: 30,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: data!["photoUrl"] == "noimage"
                                              ? Image.asset(
                                                  "assets/logo/LogoKominfoTanpaTeks.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  "${data["photoUrl"]}"))),
                                  title: Text(
                                    "${data["name"]}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${data["email"]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: allChats[index]["total_unread"] == 0
                                      ? SizedBox()
                                      : Chip(
                                          label: Text(
                                              "${allChats[index]["total_unread"]}"),
                                        ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }));
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            // child: ListView.builder(
            //     padding: EdgeInsets.zero,
            //     itemCount: myChat.length,
            //     itemBuilder: (context, index) => myChat[index]),
          ),
        ],
      ),
    );
  }
}
