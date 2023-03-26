class Chats {
  List<String>? connections;
  int? totalChats;
  int? totalRead;
  int? totalUnread;
  List<Chat>? chat;
  String? lastTime;

  Chats(
      {this.connections,
      this.totalChats,
      this.totalRead,
      this.totalUnread,
      this.chat,
      this.lastTime});

  Chats.fromJson(Map<String, dynamic> json) {
    connections = json['connections'].cast<String>();
    totalChats = json['total_chats'];
    totalRead = json['total_read'];
    totalUnread = json['total_unread'];
    if (json['chat'] != null) {
      chat = <Chat>[];
      json['chat'].forEach((v) {
        chat?.add(Chat.fromJson(v));
      });
    }
    lastTime = json['lastTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connections'] = connections;
    data['total_chats'] = totalChats;
    data['total_read'] = totalRead;
    data['total_unread'] = totalUnread;
    if (chat != null) {
      data['chat'] = chat?.map((v) => v.toJson()).toList();
    }
    data['lastTime'] = lastTime;
    return data;
  }
}

class Chat {
  String? pengirim;
  String? penerima;
  String? pesan;
  String? time;
  bool? isRead;

  Chat({this.pengirim, this.penerima, this.pesan, this.time, this.isRead});

  Chat.fromJson(Map<String, dynamic> json) {
    pengirim = json['pengirim'];
    penerima = json['penerima'];
    pesan = json['pesan'];
    time = json['time'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pengirim'] = pengirim;
    data['penerima'] = penerima;
    data['pesan'] = pesan;
    data['time'] = time;
    data['isRead'] = isRead;
    return data;
  }
}
