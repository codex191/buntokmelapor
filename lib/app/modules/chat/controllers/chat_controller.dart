import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  //TODO: Implement ChatController

  late TextEditingController chatC;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    chatC = TextEditingController();
    super.onInit();
  }

  void newChat(String email, Map<String, dynamic> arguments, String chat) {
    CollectionReference chats = firestore.collection("chats");

    chats.doc(arguments["chat_id"]).collection("chat").add({
      "pemgirim": email,
      "penerima": arguments["friendEmail"],
      "msg": chat,
      "time": DateTime.now().toIso8601String(),
      "isRead": false,
    });
  }

  @override
  void onClose() {
    chatC.dispose();
    super.onClose();
  }
}
