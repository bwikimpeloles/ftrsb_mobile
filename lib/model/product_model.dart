import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? name;
  String? category;
  String? sku;
  String? barcode;
  int? quantity;
  String? imageUrl;

  ProductModel(
      {this.name,
      this.category,
      this.sku,
      this.barcode,
      this.quantity,
      this.imageUrl});

  factory ProductModel.fromMap(map) {
    return ProductModel(
        name: map["name"],
        category: map["category"],
        sku: map["sku"],
        barcode: map["barcode"],
        quantity: map["quantity"],
        imageUrl: map["imageUrl"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'sku': sku,
      'barcode': barcode,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  ProductModel.fromDocumenSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["name"],
        category = doc.data()!["category"],
        sku = doc.data()!["sku"],
        barcode = doc.data()!["barcode"],
        quantity = doc.data()!["quantity"],
        imageUrl = doc.data()!["imageUrl"];
}
