import 'package:cloud_firestore/cloud_firestore.dart';

class OrderB2CModel {
  String? orderid;
  String? custName;
  DateTime? paymentDate;
  String? channel;
  String? amount;

  //constructor
  OrderB2CModel(
      {
        this.orderid,
        this.custName,
        this.paymentDate,
        this.channel,
        this.amount
      });

  // receive data from server
  factory OrderB2CModel.fromMap(map) {
    return OrderB2CModel(
      orderid: map["orderid"],
      custName: map["custName"],
      paymentDate: map["paymentDate"],
      channel: map["channel"],
      amount: map["amount"]
    );
  }

  fromJson(Map<String, dynamic> json) {
    return OrderB2CModel(
      orderid: json["orderid"],
      custName: json["custName"],
      paymentDate: (json["paymentDate"]as Timestamp).toDate(),
      channel: json["channel"],
      amount: json["amount"],
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'orderid': orderid,
      'custName': custName,
      'paymentDate': paymentDate,
      'channel': channel,
      'amount': amount
    };
  }



  toJson() {
    return {
      'orderid': orderid,
      'custName': custName,
      'paymentDate': paymentDate,
      'channel': channel,
      'amount': amount
    };
  }
}

