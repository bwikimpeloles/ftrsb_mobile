import 'package:cloud_firestore/cloud_firestore.dart';

class PackageModel {
  String? name;
  String? address;
  String? docUrl;

  PackageModel({this.name, this.address, this.docUrl});

  factory PackageModel.fromMap(map) {
    return PackageModel(
        name: map["name"], address: map["address"], docUrl: map["docUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'docUrl': docUrl,
    };
  }

  PackageModel.fromDocumenSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["name"],
        address = doc.data()!["address"],
        docUrl = doc.data()!["docUrl"];
}
