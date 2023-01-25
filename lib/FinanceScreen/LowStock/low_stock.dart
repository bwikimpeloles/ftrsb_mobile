import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Inventory/inventory_detail.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../SalesScreen/customAppBar.dart';
import '../../services/database.dart';
import '../sidebar_navigation.dart';

class LowStock extends StatefulWidget {
  const LowStock({Key? key}) : super(key: key);

  @override
  State<LowStock> createState() => _LowStockState();
}

class _LowStockState extends State<LowStock> {
  int lowStock = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          title: const Text("Welcome - Finance"),
          centerTitle: true,
        ),
        body: (StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Product')
                .where('quantity', isLessThanOrEqualTo: 20)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;
                return Container(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: docs.length,
                    padding: const EdgeInsets.all(1.0),
                    itemBuilder: (context, index) {
                      final data = docs[index].data();

                      return GestureDetector(
                        onTap: () {},
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 160, 202, 159),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Quantity ' +
                                            data['quantity'].toString(),
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 160, 202, 159),
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
            })));
    /*final user = Provider.of<UserModel?>(context);
    final db = DatabaseService(uid: user!.uid!);

    return FutureProvider.value(
        value: db.lowProductItem(),
        catchError: (_, __) => [],
        initialData: [],
        builder: (context, child) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Product",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: Provider.of<List<ProductModel>>(context).length,
                itemBuilder: (context, index) {
                  ProductModel product =
                      Provider.of<List<ProductModel>>(context).elementAt(index);
                  return Card(
                    color: Colors.red[900],
                    margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: ListTile(
                      title: Text(
                        product.name.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        product.quantity.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ],
          );
        });*/
  }
}
