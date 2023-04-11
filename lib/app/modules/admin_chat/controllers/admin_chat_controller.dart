import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminChatController extends GetxController {
  //TODO: Implement AdminChatController

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }
}
