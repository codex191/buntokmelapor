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

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chat_id) {
    CollectionReference chats = firestore.collection("chats");

    return chats.doc(chat_id).collection("chat").orderBy("time").snapshots();
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
      // Jika ada di user database
      // Cek total unread

      final checkTotalUnread = await chats
          .doc(argument["chat_id"])
          .collection("chat")
          .where("isRead", isEqualTo: false)
          .where("pengirim", isEqualTo: email)
          .get();

      // Total unread user(pengadu)
      total_unread = checkTotalUnread.docs.length;

      await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chat_id"])
          .update({
        "lastTime": date,
        "total_unread": total_unread,
      });
    } else {
      // Jika tidak ada di user database
      await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chat_id"])
          .set({
        "connection": email,
        "lastTime": date,
        "total_unread": 1,
      });
    }

    chatC.clear();
  }

  @override
  void onClose() {
    chatC.dispose();
    super.onClose();
  }
}
