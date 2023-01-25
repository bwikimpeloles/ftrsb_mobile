import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Inventory/inventory.dart';
import 'package:provider/provider.dart';
import '../FinanceScreen/sidebar_navigation.dart';
import '../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Barcode/barcode_scanner.dart';

import 'Inspection/inspectionDetail.dart';
import 'Inspection/inspectionForm.dart';

class HomeScreenWarehouse extends StatefulWidget {
  const HomeScreenWarehouse({Key? key, required this.changePage})
      : super(key: key);

  final void Function(int index) changePage;

  @override
  _HomeScreenWarehouseState createState() => _HomeScreenWarehouseState();
}

class _HomeScreenWarehouseState extends State<HomeScreenWarehouse> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text('Item that are currently low in stock',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 202, 108, 108))),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.only(left: 3),
              height: 100,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Product')
                      .where('quantity', isLessThanOrEqualTo: 20)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');

                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
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
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  image: DecorationImage(
                                    image: NetworkImage(data['imageUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 80, 80, 80),
                                            Color.fromARGB(24, 121, 121, 121),
                                          ],
                                          begin:
                                              const FractionalOffset(0.0, 1.0),
                                          end: const FractionalOffset(0.0, 0.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Quantity ' +
                                                data['quantity'].toString(),
                                            style: TextStyle(
                                                color: Colors.white,
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
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  })),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text('Packaging B2B',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 127, 172, 126))),
              ),
              TextButton(
                  onPressed: () {
                    widget.changePage(3);
                  },
                  child: const Text(
                    'See More',
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 3),
            height: 100,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('OrderB2B')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasError)
                    return Text('Error = ${snapshot.error}');

                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data();

                        return GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                    image: AssetImage(
                                  "assets/Packaging.png",
                                )),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data['custName'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              /* add child content here */
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                }),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text('Packaging B2C',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 127, 172, 126))),
              ),
              TextButton(
                  onPressed: () {
                    widget.changePage(3);
                  },
                  child: const Text(
                    'See More',
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 3),
            height: 100,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('OrderB2C')
                    .where('action', isEqualTo: 'Approved')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasError)
                    return Text('Error = ${snapshot.error}');

                  if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data();

                        return GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                    image: AssetImage(
                                  "assets/Packaging.png",
                                )),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data['custName'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              /* add child content here */
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                }),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
