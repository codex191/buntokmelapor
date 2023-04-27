import 'dart:async';

import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 5),
              Icon(Icons.arrow_back),
              SizedBox(width: 5),
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                child: StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: controller.streamFriendData(
                      (Get.arguments as Map<String, dynamic>)["friendEmail"]),
                  builder: (context, snapFriendUser) {
                    if (snapFriendUser.connectionState ==
                        ConnectionState.active) {
                      var dataFriend =
                          snapFriendUser.data!.data() as Map<String, dynamic>;

                      if (dataFriend["photoUrl"] == "noimage") {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/logo/noimage.png",
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            dataFriend["photoUrl"],
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/logo/noimage.png",
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        title: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: controller.streamFriendData(
              (Get.arguments as Map<String, dynamic>)["friendEmail"]),
          builder: (context, snapFriendUser) {
            if (snapFriendUser.connectionState == ConnectionState.active) {
              var dataFriend =
                  snapFriendUser.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataFriend["name"],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dataFriend["email"],
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamChats(chat_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var alldata = snapshot.data!.docs;
                    Timer(
                      Duration.zero,
                      () => controller.scrollC
                          .jumpTo(controller.scrollC.position.maxScrollExtent),
                    );
                    return ListView.builder(
                      controller: controller.scrollC,
                      itemCount: alldata.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "${alldata[index]["groupTime"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ItemChat(
                                msg: "${alldata[index]["msg"]}",
                                isSender: alldata[index]["pengirim"] ==
                                        authC.user.value.email!
                                    ? true
                                    : false,
                                time: "${alldata[index]["time"]}",
                              ),
                            ],
                          );
                        } else {
                          if (alldata[index]["groupTime"] ==
                              alldata[index - 1]["groupTime"]) {
                            return ItemChat(
                              msg: "${alldata[index]["msg"]}",
                              isSender: alldata[index]["pengirim"] ==
                                      authC.user.value.email!
                                  ? true
                                  : false,
                              time: "${alldata[index]["time"]}",
                            );
                          } else {
                            return Column(
                              children: [
                                Text(
                                  "${alldata[index]["groupTime"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ItemChat(
                                  msg: "${alldata[index]["msg"]}",
                                  isSender: alldata[index]["pengirim"] ==
                                          authC.user.value.email!
                                      ? true
                                      : false,
                                  time: "${alldata[index]["time"]}",
                                ),
                              ],
                            );
                          }
                        }
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      autocorrect: false,
                      controller: controller.chatC,
                      onEditingComplete: () => controller.newChat(
                        authC.user.value.email!,
                        Get.arguments as Map<String, dynamic>,
                        controller.chatC.text,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blueAccent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => controller.newChat(
                      authC.user.value.email!,
                      Get.arguments as Map<String, dynamic>,
                      controller.chatC.text,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            padding: EdgeInsets.all(15),
            child: Text(
              "$msg",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(DateFormat.jm().format(DateTime.parse(time))),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
