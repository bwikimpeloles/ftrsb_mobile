class UserModel {
  String? uid;
  String? email;
  String? name;
  String? role;
  bool? paymentnotification;
  bool? approvalnotification;
  bool? consignmentnotification;

  UserModel({this.uid, this.email, this.name, this.role, this.paymentnotification, this.approvalnotification, this.consignmentnotification});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      role: map['role'],
      paymentnotification: map['paymentnotification'],
      approvalnotification: map['approvalnotification'],
      consignmentnotification: map['consignmentnotification'],
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
      'approvalnotification': approvalnotification,
      'consignmentnotification': consignmentnotification,
    };
  }
}
