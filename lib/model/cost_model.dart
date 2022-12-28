import 'package:cloud_firestore/cloud_firestore.dart';

class CostModel {
  String? category;
  String? amount;
  DateTime? date;
  String? name;
  String? supplier;
  String? referenceno;

  //constructor
  CostModel(
      {
        this.category,
        this.amount,
        this.date,
        this.name,
        this.supplier,
        this.referenceno,
      });

  // receive data from server
  factory CostModel.fromMap(map) {
    return CostModel(
      category: map["category"],
      amount: map["amount"],
      date: map["date"],
      name: map["name"],
      supplier: map["supplier"],
      referenceno: map["referenceno"],
    );
  }


  fromJson(Map<String, dynamic> json) {
    return CostModel(
      category: json["category"],
      amount: json["amount"],
      date: (json["date"]as Timestamp).toDate(),
      name: json["name"],
      supplier: json["supplier"],
      referenceno: json["referenceno"],
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'date': date,
      'name': name,
      'supplier': supplier,
      'referenceno': referenceno,
    };
  }



  toJson() {
    return {
      'category': category,
      'amount': amount,
      'date': date,
      'name': name,
      'supplier': supplier,
      'referenceno': referenceno,
    };
  }
}

