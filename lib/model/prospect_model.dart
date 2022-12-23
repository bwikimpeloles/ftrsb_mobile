class ProspectModel {
  String? name;
  String? phone;
  String? email;
  String? channel;

  ProspectModel({this.name, this.phone, this.email, this.channel});

  factory ProspectModel.fromMap(map) {
    return ProspectModel(
      name: map["name"],
      phone: map["phone"],
      email: map["email"],
      channel: map["channel"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'channel': channel,
    };
  }
}
