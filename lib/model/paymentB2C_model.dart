import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentB2C {
  String? paymentMethod;
  String? amount;
  Timestamp? paymentDate;
  String? tempDate;
  String? bankName;
  String? paymentVerify;
  String? action;

  //constructor
  PaymentB2C(
      {this.paymentMethod,
      this.amount,
      this.paymentDate,
      this.bankName,
      this.paymentVerify,
      this.action});

  // receive data from server
  factory PaymentB2C.fromMap(map) {
    return PaymentB2C(
      paymentMethod: map["paymentMethod"],
      amount: map["amount"],
      paymentDate: map["paymentDate"],
      bankName: map["bankName"],
      paymentVerify: map["paymentVerify"],
      action: map["action"],
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'amount': amount,
      'paymentDate': paymentDate,
      'bankName': bankName,
      'paymentVerify': paymentVerify,
      'action': action,
    };
  }
}
