import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  DatabaseService.withoutUID() : uid = "";

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //scan product
  Future<bool> scanProduct(ProductModel a) async {
    try {
      await _db.collection("product").doc(a.barcode).set({
        "name": a.name,
        "category": a.category,
        "sku": a.sku,
        "quantity": a.quantity,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //retrive product

}
