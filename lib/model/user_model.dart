class UserModel {
  String? uid;
  String? email;
  String? name;
  String? role;
  bool? paymentnotification;

  UserModel({this.uid, this.email, this.name, this.role, this.paymentnotification});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      role: map['role'],
      paymentnotification: map['paymentnotification'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'paymentnotification': paymentnotification,
    };
  }
}
