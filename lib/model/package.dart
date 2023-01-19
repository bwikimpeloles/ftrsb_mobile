import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Package {
  String name;
  String description;
  String imageUrl;
  String status;
  String address;
  String phoneNo;

  Package(
      {required this.name,
      required this.description,
      required this.phoneNo,
      required this.address,
      required this.imageUrl,
      required this.status});

  Package.fromDocumenSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["custName"],
        description = doc.data()!["product"],
        address = doc.data()!["custAddress"],
        phoneNo = doc.data()!["custPhone"],
        status = doc.data()!["orderID"],
        imageUrl = doc.data()!["channel"];
}
