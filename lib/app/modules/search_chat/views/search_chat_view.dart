import 'package:buntokmelapor/app/controllers/auth_controller.dart';
import 'package:buntokmelapor/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_chat_controller.dart';

class SearchChatView extends GetView<SearchChatController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                )),
            centerTitle: true,
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  onChanged: (value) =>
                      controller.searchUser(value, authC.user.value.email!),
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      hintText: "Cari user",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {},
                      )),
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(140),
        ),
        body: Obx(
          () => controller.tempSearch.length == 0
              ? Center(
                  child: Container(
                    width: Get.width * 0.7,
                    height: Get.width * 0.7,
                    child: Lottie.asset("assets/lottie/search-users.json"),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.tempSearch.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {},
                    leading: CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: controller.tempSearch[index]["photoUrl"] ==
                                "noimage"
                            ? Image.network(
                                "assets/logo/LogoKominfoTanpaTeks.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                controller.tempSearch[index]["photoUrl"],
                                fit: BoxFit.cover,
                              ),
                      ),
                      radius: 30,
                    ),
                    title: Text(
                      "${controller.tempSearch[index]["name"]}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "${controller.tempSearch[index]["email"]}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => authC.addNewConnection(
                          controller.tempSearch[index]["email"]),
                      child: Chip(
                        label: Text("Pesan"),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
