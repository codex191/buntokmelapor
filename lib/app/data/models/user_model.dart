class UserModel {
  String? uid;
  String? name;
  String? email;
  String? creationTime;
  String? lastSignIn;
  String? photoUrl;
  String? updatedTime;

  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.creationTime,
      this.lastSignIn,
      this.photoUrl,
      this.updatedTime});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    creationTime = json['creationTime'];
    lastSignIn = json['lastSignIn'];
    photoUrl = json['photoUrl'];
    updatedTime = json['updatedTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['creationTime'] = creationTime;
    data['lastSignIn'] = lastSignIn;
    data['photoUrl'] = photoUrl;
    data['updatedTime'] = updatedTime;
    return data;
  }
}
