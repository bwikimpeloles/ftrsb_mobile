import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentB2B {
  String? amount;
  String? orderDateDisplay;
  Timestamp? orderDate;
  Timestamp? collectionDate;
  String? pic;
  String? status;
  String? purchaseType;

  //constructor
  PaymentB2B(
      {this.orderDate,
      this.amount,
      this.collectionDate,
      this.pic,
      this.status,
      this.purchaseType});

  // receive data from server
  factory PaymentB2B.fromMap(map) {
    return PaymentB2B(
      orderDate: map["orderDate"],
      amount: map["amount"],
      collectionDate: map["collectionDate"],
      pic: map["pic"],
      status: map["status"],
      purchaseType: map["purchaseType"],
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
      'purchaseType': purchaseType,
    };
  }
}
