class ProductModel {
  String? name;
  String? sku;
  String? barcode;
  int? quantity;

  ProductModel({this.name, this.sku, this.barcode, this.quantity});

  factory ProductModel.fromMap(map) {
    return ProductModel(
      name: map["name"],
      sku: map["sku"],
      barcode: map["barcode"],
      quantity: map["quantity"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'quantity': quantity,
    };
  }
}
