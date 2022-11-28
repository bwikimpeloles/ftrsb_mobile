class CustomerDetails {
  String? name;
  String? phone;
  String? address;
  String? email;
  String? channel;

  //constructor
  CustomerDetails({this.name, this.phone, this.address, this.email, this.channel});

  // we need to create map
  CustomerDetails.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    phone = json["phone"];
    address = json["address"];
    email = json["email"];
    channel = json["channel"];
  }
  Map<String, dynamic> toJson() {
    // object - data
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email'] = this.email;
    data['channel]'] = this.channel;

    return data;

  }
}