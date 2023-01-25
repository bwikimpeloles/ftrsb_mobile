import 'package:cloud_firestore/cloud_firestore.dart';

class SoldProductModel {
  String? name;
  String? quantity;

  SoldProductModel(
      {this.name,
      this.quantity,
});

  factory SoldProductModel.fromMap(map) {
    return SoldProductModel(
      name: map["name"],
      quantity: map["quantity"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }

  SoldProductModel.fromDocumenSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["name"],
        quantity = doc.data()!["quantity"];
}
