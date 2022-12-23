class PaymentB2B {
  String? amount;
  String? orderDate;
  String? collectionDate;
  String? pic;
  String? status;

  //constructor
  PaymentB2B(
      {this.orderDate,
      this.amount,
      this.collectionDate,
      this.pic,
      this.status});

  // receive data from server
  factory PaymentB2B.fromMap(map) {
    return PaymentB2B(
      orderDate: map["orderDate"],
      amount: map["amount"],
      collectionDate: map["collectionDate"],
      pic: map["pic"],
      status: map["status"],
    );
  }

  // send data to server
  Map<String, dynamic> toMap() {
    return {
      'orderDate': orderDate,
      'amount': amount,
      'collectionDate': collectionDate,
      'pic': pic,
      'status': status,
    };
  }
}
