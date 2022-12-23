class CustomerModel {
  String? name;
  String? phone;
  String? address;
  String? email;
  String? channel;

  //constructor
  CustomerModel({this.name, this.phone, this.address, this.email, this.channel});

  //receive data from server
  factory CustomerModel.from(map) {
    return CustomerModel(    
    name: map["name"],
    phone: map["phone"],
    address: map["address"],
    email: map["email"],
    channel: map["channel"],);
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
      'channel': channel,
    };
  }
}