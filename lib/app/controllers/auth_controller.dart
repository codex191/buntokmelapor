import 'package:buntokmelapor/app/data/models/users_model.dart';
import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    //mengubah isSkipIntro menjadi true
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    //mengubah isAuth menjadi true
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);
        print("user credential");
        print(userCredential);

        // Memasukan data user ke firebase
        CollectionReference users = firestore.collection('users');

        await users.doc(_currentUser!.email).update({
          "lasSignIn":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  Future<void> login() async {
    // Get.offAllNamed(Routes.HOME);
    try {
      //Menghandle bocornya data user sebelum login
      await _googleSignIn.signOut();

      // Untuk mendapatkan user google account
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      // Untuk mengecek status login user
      final isSignin = await _googleSignIn.isSignedIn();

      if (isSignin) {
        // kondisi sudah login
        print("Berhasil Login");
        print(_currentUser);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);
        print("user credential");
        print(userCredential);

        //menyimpan status user bahwa sudah pernah login dan tidak akan menampilkan intro kembali
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // Memasukan data user ke firebase
        CollectionReference users = firestore.collection('users');

        final checkuser = await users.doc(_currentUser!.email).get();

        if (checkuser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName?.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lasSignIn": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
            "chats": []
          });
        } else {
          await users.doc(_currentUser!.email).update({
            "lasSignIn": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        //kondisi tidak login
        print("Tidak berhasil Login");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

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
          });
    } catch (e) {
      Get.defaultDialog(
          title: "Gagal",
          middleText: "Gagal menambahkan kritik dan saran",
          onConfirm: () {
            Get.back();
          });
    }
  }

  // UNTUK PROFILE
  void changeProfile(String name) {
    final date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "lasSignIn":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    // update Model
    user.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.lastSignIn =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(
      title: "Update Berhasil",
      middleText: "Berhasil update profile",
    );
  }

  // Untuk Chat
  void addNewConnection(String friendEmail) async {
    var chat_id;
    bool flagNewConnection = false;
    CollectionReference chats = firestore.collection('chats');
    String date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');

    final docUser = await users.doc(_currentUser!.email).get();
    final docChats = (docUser.data() as Map<String, dynamic>)["chats"] as List;

    if (docChats.length != 0) {
      // user pernah chat dengan siapapun
      docChats.forEach((singleChat) {
        if (singleChat["connection"] == friendEmail) {
          chat_id = singleChat["chat_id"];
        }
      });

      if (chat_id != null) {
        // sudah pernah buat oneksi dengan friendlist
        flagNewConnection = false;
      } else {
        //belum pernah buat koneksi
        flagNewConnection = true;
      }
    } else {
      // user belum pernah chat dengan siapapun
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      //Mengecek chats collections
      final chatsDocs = await chats.where("connecions", whereIn: [
        [
          _currentUser!.email,
          friendEmail,
        ],
        [
          friendEmail,
          _currentUser!.email,
        ],
      ]).get();

      if (chatsDocs.docs.length != 0) {
        // sudah ada koneksi
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users.doc(_currentUser!.email).update({
          "chats": [
            {
              "connection": friendEmail,
              "chat_id": chatDataId,
              "lasttime": chatsData["lastTime"],
            }
          ]
        });

        user.update((user) {
          user!.chats = [
            ChatUser(
              chatId: chatDataId,
              connection: friendEmail,
              lastTime: chatsData["lastTime"],
            )
          ];
        });

        chat_id = chatDataId;
        user.refresh();
      } else {
        // buat baru apabila user dan admin belum memiliki koneksi
        final newChatDoc = await chats.add({
          "connection": [
            _currentUser!.email,
            friendEmail,
          ],
          "total_chats": 0,
          "total_read": 0,
          "total_unread": 0,
          "chat": [],
          "lastTime": date,
        });

        await users.doc(_currentUser!.email).update({
          "chats": [
            {
              "connection": friendEmail,
              "chat_id": newChatDoc.id,
              "lasttime": date,
            }
          ]
        });

        user.update((user) {
          user!.chats = [
            ChatUser(
              chatId: newChatDoc.id,
              connection: friendEmail,
              lastTime: date,
            )
          ];
        });

        chat_id = newChatDoc.id;
        user.refresh();
      }
    }

    Get.toNamed(Routes.CHAT, arguments: chat_id);
  }
}
