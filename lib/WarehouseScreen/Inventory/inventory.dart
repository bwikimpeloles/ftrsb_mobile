// ignore_for_file: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Barcode/barcode_scanner.dart';
import 'package:flutter/services.dart';

import '../../services/database.dart';
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
        stream: FirebaseFirestore.instance
            .collection('Product')
            .orderBy('name')
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return Container(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: docs.length,
                padding: const EdgeInsets.all(1.0),
                itemBuilder: (context, index) {
                  final data = docs[index].data();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InventoryDetailScreen(
                                  name: data['name'],
                                  quantity: (data['quantity']).toString(),
                                  imageUrl: data['imageUrl'],
                                  lastUpdate: data['lastUpdate'])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                          image: DecorationImage(
                            image: NetworkImage(data['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              gradient: new LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 80, 80, 80),
                                    const Color.fromARGB(24, 121, 121, 121),
                                  ],
                                  begin: const FractionalOffset(0.0, 1.0),
                                  end: const FractionalOffset(0.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 160, 202, 159),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Quantity ' + data['quantity'].toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 160, 202, 159),
                                        fontSize: 11,
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

          return const Center(child: CircularProgressIndicator());
        });
  }
}
