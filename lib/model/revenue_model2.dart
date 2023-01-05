import 'package:cloud_firestore/cloud_firestore.dart';

class RevenueModel2 {
  String? amount;
  String? bankName;
  String? channel;
  DateTime? orderDate;

  //constructor
  RevenueModel2(
      {
        this.amount,
        this.bankName,
        this.channel,
        this.orderDate,
      });

  // receive data from server
  factory RevenueModel2.fromMap(map) {
    return RevenueModel2(
      amount: map["amount"],
      bankName: map["bankName"],
      channel: map["channel"],
      orderDate: map["orderDate"],
    );
  }


  fromJson(Map<String, dynamic> json) {
    return RevenueModel2(
      amount: json["amount"],
      bankName: json["bankName"],
      channel: json["channel"],
      orderDate: (json["orderDate"]as Timestamp).toDate(),
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'bankName': bankName,
      'channel': channel,
      'orderDate': orderDate,
    };
  }



  toJson() {
    return {
      'amount': amount,
      'bankName': bankName,
      'channel': channel,
      'orderDate': orderDate,
    };
  }
}

