class UsersModel {
  String? uid;
  String? email;
  String? role;
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
      this.role,
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
    role = json['role'];
    name = json['name'];
    keyName = json['keyName'];
    photoUrl = json['photoUrl'];
    creationTime = json['creationTime'];
    lastSignIn = json['lastSignIn'];
    updatedTime = json['updatedTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['role'] = role;
    data['name'] = name;
    data['keyName'] = keyName;
    data['photoUrl'] = photoUrl;
    data['creationTime'] = creationTime;
    data['lastSignIn'] = lastSignIn;
    data['updatedTime'] = updatedTime;
    return data;
  }
}

class ChatUser {
  String? connection;
  String? chatId;
  String? lastTime;
  int? total_unread;

  ChatUser({this.connection, this.chatId, this.lastTime, this.total_unread});

  ChatUser.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    chatId = json['chat_id'];
    lastTime = json['lastTime'];
    total_unread = json['total_unread'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connection'] = connection;
    data['chat_id'] = chatId;
    data['lastTime'] = lastTime;
    data['total_unread'] = total_unread;
    return data;
  }
}
