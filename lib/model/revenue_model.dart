import 'package:cloud_firestore/cloud_firestore.dart';

class RevenueModel {
  String? amount;
  String? bankName;
  String? channel;
  DateTime? paymentDate;

  //constructor
  RevenueModel(
      {
        this.amount,
        this.bankName,
        this.channel,
        this.paymentDate,
      });

  // receive data from server
  factory RevenueModel.fromMap(map) {
    return RevenueModel(
      amount: map["amount"],
      bankName: map["bankName"],
      channel: map["channel"],
      paymentDate: map["paymentDate"],
    );
  }


  fromJson(Map<String, dynamic> json) {
    return RevenueModel(
      amount: json["amount"],
      bankName: json["bankName"],
      channel: json["channel"],
      paymentDate: (json["paymentDate"]as Timestamp).toDate(),
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'bankName': bankName,
      'channel': channel,
      'paymentDate': paymentDate,
    };
  }



  toJson() {
    return {
      'amount': amount,
      'bankName': bankName,
      'channel': channel,
      'paymentDate': paymentDate,
    };
  }
}

