import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_chat_controller.dart';

class AdminChatView extends GetView<AdminChatController> {
  final List<Widget> myChat = List.generate(
    20,
    (index) => ListTile(
      onTap: () {},
      leading: CircleAvatar(
        radius: 30,
      ),
      title: Text(
        "Orang ke ${index = 1}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        "Email orang ke ${index = 1}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Chip(
        label: Text("3"),
      ),
    ),
  ).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminChatView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Material(
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: Colors.black38,
                )),
              ),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kontak Masuk",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: myChat.length,
                itemBuilder: (context, index) => myChat[index]),
          ),
        ],
      ),
    );
  }
}
