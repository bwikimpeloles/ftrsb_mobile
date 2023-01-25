import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftrsb_mobile/model/package.dart';
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
  //retrieve product from scan
  Future scannnedProduct(String barcode) async {
    try {
      var snapshot = await _db
          .collection("product")
          .where("barcode", isEqualTo: barcode)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromMap(e).toMap());
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> update(String name, int quantity, String latest) async {
    try {
      await _db
          .collection("Product")
          .doc(name)
          .update({"quantity": quantity, "lastUpdate": latest});
    } catch (e) {}
  }

  //update product
  Future<bool> scanProduct(ProductModel a) async {
    try {
      await _db.collection("Product").doc(a.name).set({
        "name": a.name,
        "barcode": a.barcode,
        "category": a.category,
        "sku": a.sku,
        "quantity": a.quantity,
        "imageUrl": a.imageUrl
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //retrieve
  Future<List<ProductModel>> retrieveProductItem() async {
    try {
      var snapshot = await _db.collection("product").get();
      return snapshot.docs
          .map((e) => ProductModel.fromDocumenSnapshot(e))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  //retrieve product that is low than 7
  Future<List<ProductModel>> lowProductItem() async {
    // ignore: non_constant_identifier_names
    int stockLow = 7;
    try {
      var snapshot = await _db
          .collection("product")
          .where('quantity', isLessThanOrEqualTo: stockLow)
          .get();
      return snapshot.docs
          .map((e) => ProductModel.fromDocumenSnapshot(e))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  //retrieve customer order item for b2b
  Future<List<Package>> retrievePackageB2B() async {
    try {
      var snapshot = await _db.collection("OrderB2B").get();
      return snapshot.docs.map((e) => Package.fromDocumenSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  //retrieve customer order item for b2c
  Future<List<Package>> retrievePackageB2C() async {
    try {
      var snapshot = await _db.collection("OrderB2C").get();
      return snapshot.docs.map((e) => Package.fromDocumenSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
