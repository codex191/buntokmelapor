import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Admin Bunlapor'),
        centerTitle: true,
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
                      return ListView.builder(
                        itemCount: alldata.length,
                        itemBuilder: (context, index) => ItemChat(
                          isSender: alldata[index]["pengirim"] ==
                                  authC.user.value.email!
                              ? true
                              : false,
                          msg: "${alldata[index]["msg"]}",
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              // child: ListView(
              //   children: [
              //     ItemChat(
              //       msg: "Haloo",
              //       isSender: true,
              //     ),
              //     ItemChat(
              //       msg: "Halo...",
              //       isSender: false,
              //     ),
              //   ],
              // ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: Get.width,
            //color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: controller.chatC,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blueAccent,
                  child: InkWell(
                    onTap: () => controller.newChat(
                        authC.user.value.email!,
                        Get.arguments as Map<String, dynamic>,
                        controller.chatC.text),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
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
    super.key,
    required this.isSender,
    required this.msg,
  });

  final bool isSender;
  final String msg;

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
                      )),
            //color: Colors.blueAccent,
            padding: EdgeInsets.all(15),
            child: Text(
              "$msg",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text("13:22"),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
