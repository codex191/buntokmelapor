import 'package:buntokmelapor/app/data/models/users_model.dart';
import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;
  var user = UsersModel().obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn.signInSilently().then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        // Memasukan data user ke firebase
        CollectionReference users = firestore.collection('users');
        await users.doc(_currentUser!.email).update({
          "lasSignIn": userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;
        user.value = UsersModel.fromJson(currUserData);

        final listChats = await users.doc(_currentUser!.email).collection("chats").get();
        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        if (currUser.exists) {
          final role = currUser.get('role');
          if (role == "user") {
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.offAllNamed(Routes.HOME_ADMIN);
          }
        }

        return true;
      }
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      // Reset data pengguna di aplikasi
      user.value = UsersModel();
      isAuth.value = false;

      // Mendapatkan user google account
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      // Mengecek status login user
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        print("Berhasil Login");
        Get.snackbar(
          'Berhasil',
          'Berhasil Login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        // Menyimpan status user bahwa sudah pernah login
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // Memasukan data user ke firebase
        CollectionReference users = firestore.collection('users');
        final checkuser = await users.doc(_currentUser!.email).get();
        if (!checkuser.exists) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "role": "user",
            "keyName": _currentUser!.displayName?.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "creationTime": userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lasSignIn": userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });
          await users.doc(_currentUser!.email).collection("chats");
        } else {
          await users.doc(_currentUser!.email).update({
            "lasSignIn": userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
          });
          final currUser = await users.doc(_currentUser!.email).get();
          final currUserData = currUser.data() as Map<String, dynamic>;
          user.value = UsersModel.fromJson(currUserData);

          final listChats = await users.doc(_currentUser!.email).collection("chats").get();
          if (listChats.docs.isNotEmpty) {
            List<ChatUser> dataListChats = [];
            for (var element in listChats.docs) {
              var dataDocChat = element.data();
              var dataDocChatId = element.id;
              dataListChats.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"],
              ));
            }
            user.update((user) {
              user!.chats = dataListChats;
            });
          } else {
            user.update((user) {
              user!.chats = [];
            });
          }
        }

        isAuth.value = true;
        if (checkuser.exists) {
          final role = checkuser.get('role');
          if (role == "user") {
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.offAllNamed(Routes.HOME_ADMIN);
          }
        }
      } else {
        print("Tidak berhasil Login");
      }
    } catch (error) {
      print(error);
      Get.snackbar(
        'Terjadi Kesalahan',
        'Tidak dapat melakukan login. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    // Menghapus data pengguna dari GetStorage
    final box = GetStorage();
    await box.erase();

    // Reset data pengguna di aplikasi
    user.value = UsersModel();
    isAuth.value = false;

    Get.offAllNamed(Routes.LOGIN);
  }

  void addFeedback(String kritik, String saran) async {
    CollectionReference feedback = firestore.collection("feedback");
    try {
      await feedback.add({
        "pengirim": _currentUser!.email,
        "kritik": kritik,
        "saran": saran,
      });
      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil menambahkan kritik dan saran",
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Gagal",
        middleText: "Gagal menambahkan kritik dan saran. Silakan coba lagi.",
        onConfirm: () {
          Get.back();
        },
      );
    }
  }

  void changeProfile(String name) {
    final date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');
    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "lasSignIn": userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    // Update Model
    user.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.lastSignIn = userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    Get.defaultDialog(
      title: "Update Berhasil",
      middleText: "Berhasil update profile",
    );
  }

  Future<void> addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    var chatId;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docChats = await users.doc(_currentUser!.email).collection("chats").get();

    if (docChats.docs.isNotEmpty) {
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        flagNewConnection = false;
        chatId = checkConnection.docs[0].id;
      } else {
        flagNewConnection = true;
      }
    } else {
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.isNotEmpty) {
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users.doc(_currentUser!.email).collection("chats").doc(chatDataId).set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats = await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chatId = chatDataId;
      } else {
        final newChatDoc = await chats.add({
          "connections": [
            _currentUser!.email,
            friendEmail,
          ],
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await users.doc(_currentUser!.email).collection("chats").doc(newChatDoc.id).set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats = await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chatId = newChatDoc.id;
      }

      final updateStatusChat = await chats
          .doc(chatId)
          .collection("chat")
          .where("isRead", isEqualTo: false)
          .where("penerima", isEqualTo: _currentUser!.email)
          .get();

      for (var element in updateStatusChat.docs) {
        await chats.doc(chatId).collection("chat").doc(element.id).update({
          "isRead": true,
        });
      }

      await users
          .doc(_currentUser!.email)
          .collection("chats")
          .doc(chatId)
          .update({"total_unread": 0});

      Get.toNamed(Routes.CHAT, arguments: {
        "chat_id": chatId,
        "friendEmail": friendEmail,
      });
    }
  }
}