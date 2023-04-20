import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  late TextEditingController chatC;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int total_unread = 0;

  @override
  void onInit() {
    chatC = TextEditingController();
    super.onInit();
  }

  void newChat(String email, Map<String, dynamic> argument, String chat) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    String date = DateTime.now().toIso8601String();

    final newchat =
        await chats.doc(argument["chat_id"]).collection("chat").add({
      "pengirim": email,
      "penerima": argument["friendEmail"],
      "msg": chat,
      "time": date,
      "isRead": false,
    });

    await users.doc(email).collection("chats").doc(argument["chat_id"]).update({
      "lastTime": date,
    });

    final checkChatsFriend = await users
        .doc(argument["friendEmail"])
        .collection("chats")
        .doc(argument["chat_id"])
        .get();

    if (checkChatsFriend.exists) {
      await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chat_id"])
          .get()
          .then((value) => total_unread = value.data()!["total_unread"] as int);

      // update for friend database
      await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chat_id"])
          .update({
        "lastTime": date,
        "total_unread": total_unread + 1,
      });
    } else {
      // new for friend database
      await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chat_id"])
          .set({
        "connection": email,
        "lastTime": date,
        "total_unread": total_unread + 1,
      });
    }
  }

  @override
  void onClose() {
    chatC.dispose();
    super.onClose();
  }
}
