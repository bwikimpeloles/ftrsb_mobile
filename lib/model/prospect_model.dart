class ProspectDetails {
  String? name;
  String? phone;
  String? email;
  String? channel;

  //constructor
  ProspectDetails({this.name, this.phone,  this.email, this.channel});

  // we need to create map
 ProspectDetails.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
    channel = json["channel"];
  }
  Map<String, dynamic> toJson() {
    // object - data
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['channel]'] = this.channel;

    return data;

  }
}