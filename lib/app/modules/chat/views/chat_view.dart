import 'dart:async';
import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authC = Get.find<AuthController>();
  final String chat_id = Get.arguments is Map ? Get.arguments["chat_id"] : "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: ListTile(
          leading: StreamBuilder<DocumentSnapshot>(
            stream: controller.streamFriendData((Get.arguments as Map)["friendEmail"]),
            builder: (context, snapFriendUser) {
              if (snapFriendUser.connectionState == ConnectionState.active) {
                var dataFriend = snapFriendUser.data!.data() as Map;
                return CircleAvatar(
                  backgroundImage: dataFriend["photoUrl"] == "noimage"
                      ? AssetImage("assets/logo/noimage.png") as ImageProvider<Object>?
                      : NetworkImage(dataFriend["photoUrl"]),
                );
              }
              return CircleAvatar(
                backgroundColor: Colors.grey,
              );
            },
          ),
          title: StreamBuilder<DocumentSnapshot>(
            stream: controller.streamFriendData((Get.arguments as Map)["friendEmail"]),
            builder: (context, snapFriendUser) {
              if (snapFriendUser.connectionState == ConnectionState.active) {
                var dataFriend = snapFriendUser.data!.data() as Map;
                return Text(
                  dataFriend["name"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              }
              return Text(
                'Loading...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            },
          ),
          subtitle: StreamBuilder<DocumentSnapshot>(
            stream: controller.streamFriendData((Get.arguments as Map)["friendEmail"]),
            builder: (context, snapFriendUser) {
              if (snapFriendUser.connectionState == ConnectionState.active) {
                var dataFriend = snapFriendUser.data!.data() as Map;
                return Text(dataFriend["email"]);
              }
              return Text('Loading...');
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.streamChats(chat_id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  var alldata = snapshot.data!.docs;
                  Timer(
                    Duration.zero,
                    () => controller.scrollC.jumpTo(controller.scrollC.position.maxScrollExtent),
                  );
                  return ListView.builder(
                    controller: controller.scrollC,
                    itemCount: alldata.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(
                        message: "${alldata[index]["msg"]}",
                        isSender: alldata[index]["pengirim"] == authC.user.value.email!,
                        time: "${alldata[index]["time"]}",
                        groupTime: "${alldata[index]["groupTime"]}",
                        showGroupTime: index == 0 ||
                            alldata[index]["groupTime"] != alldata[index - 1]["groupTime"],
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          ChatInput(
            controller: controller,
            authC: authC,
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String time;
  final String groupTime;
  final bool showGroupTime;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSender,
    required this.time,
    required this.groupTime,
    required this.showGroupTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showGroupTime)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              groupTime,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: isSender ? Theme.of(context).primaryColor : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isSender ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat.jm().format(DateTime.parse(time)),
                    style: TextStyle(
                      color: isSender ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatInput extends StatelessWidget {
  final ChatController controller;
  final AuthController authC;

  const ChatInput({
    Key? key,
    required this.controller,
    required this.authC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.chatC,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
IconButton(
  icon: Icon(Icons.send),
  onPressed: () => controller.newChat(
    authC.user.value.email!,
    Get.arguments as Map<String, dynamic>? ?? {},
    controller.chatC.text,
  ),
  color: Theme.of(context).primaryColor,
),
        ],
      ),
    );
  }
}