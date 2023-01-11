// ignore_for_file: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Barcode/barcode_scanner.dart';
import 'package:flutter/services.dart';

import 'inventory_detail.dart';

class InventoryScreenWarehouse extends StatefulWidget {
  const InventoryScreenWarehouse({Key? key}) : super(key: key);

  @override
  _InventoryScreenWarehouseState createState() =>
      _InventoryScreenWarehouseState();
}

class _InventoryScreenWarehouseState extends State<InventoryScreenWarehouse> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('product').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: docs.length,
                padding: EdgeInsets.all(1.0),
                itemBuilder: (context, index) {
                  final data = docs[index].data();

                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://cdn.store-assets.com/s/888158/i/39648906.png?width=480"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              gradient: new LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 80, 80, 80),
                                    Color.fromARGB(24, 121, 121, 121),
                                  ],
                                  begin: const FractionalOffset(0.0, 1.0),
                                  end: const FractionalOffset(0.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data['name'],
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Quantity :' + data['quantity'].toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ), /* add child content here */
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
