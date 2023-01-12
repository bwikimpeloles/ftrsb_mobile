import 'package:cloud_firestore/cloud_firestore.dart';

class OrderB2BModel {
  String? orderid;
  String? custName;
  DateTime? orderDate;
  String? channel;
  String? amount;

  //constructor
  OrderB2BModel(
      {
        this.orderid,
        this.custName,
        this.orderDate,
        this.channel,
        this.amount
      });

  // receive data from server
  factory OrderB2BModel.fromMap(map) {
    return OrderB2BModel(
      orderid: map["orderid"],
      custName: map["custName"],
      orderDate: map["orderDate"],
      channel: map["channel"],
      amount: map["amount"]
    );
  }

  fromJson(Map<String, dynamic> json) {
    return OrderB2BModel(
      orderid: json["orderid"],
      custName: json["custName"],
      orderDate: (json["orderDate"]as Timestamp).toDate(),
      channel: json["channel"],
      amount: json["amount"],
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'orderid': orderid,
      'custName': custName,
      'orderDate': orderDate,
      'channel': channel,
      'amount': amount
    };
  }



  toJson() {
    return {
      'orderid': orderid,
      'custName': custName,
      'orderDate': orderDate,
      'channel': channel,
      'amount': amount
    };
  }
}

