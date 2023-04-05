class UsersModel {
  String? uid;
  String? email;
  String? name;
  String? keyName;
  String? photoUrl;
  String? creationTime;
  String? lastSignIn;
  String? updatedTime;
  List<ChatUser>? chats;

  UsersModel(
      {this.uid,
      this.email,
      this.name,
      this.keyName,
      this.photoUrl,
      this.creationTime,
      this.lastSignIn,
      this.updatedTime,
      this.chats});

  UsersModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    name = json['name'];
    keyName = json['keyName'];
    photoUrl = json['photoUrl'];
    creationTime = json['creationTime'];
    lastSignIn = json['lastSignIn'];
    updatedTime = json['updatedTime'];
    if (json['chats'] != null) {
      chats = <ChatUser>[];
      json['chats'].forEach((v) {
        chats?.add(ChatUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['name'] = name;
    data['keyName'] = keyName;
    data['photoUrl'] = photoUrl;
    data['creationTime'] = creationTime;
    data['lastSignIn'] = lastSignIn;
    data['updatedTime'] = updatedTime;
    if (chats != null) {
      data['chats'] = chats?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatUser {
  String? connection;
  String? chatId;
  String? lastTime;

  ChatUser({this.connection, this.chatId, this.lastTime});

  ChatUser.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    chatId = json['chat_id'];
    lastTime = json['lastTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connection'] = connection;
    data['chat_id'] = chatId;
    data['lastTime'] = lastTime;
    return data;
  }
}
