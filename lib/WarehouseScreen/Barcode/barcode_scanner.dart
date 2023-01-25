import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Barcode/manual_input.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Barcode/scan_detail.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:ftrsb_mobile/services/database.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);

  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String _scanBarcode = '';

  static get user => null;
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      //db.scannnedProduct(barcodeScanRes);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Container(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () => scanBarcodeNormal(),
                      child: Text('Start barcode scan'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 160, 202, 159)),
                      )),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Product')
                        .where('barcode', isEqualTo: _scanBarcode)
                        .snapshots(),
                    builder: (_, snapshot) {
                      //log(snapshot.data.toString());
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        var products = snapshot.data!.docs;

                        return Expanded(
                          child: ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final data = products[index].data();
                                return Card(
                                  child: ListTile(
                                    title: Text(data['name'].toString()),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(data['quantity'].toString()),
                                      ],
                                    ),
                                    leading: Image.network(data['imageUrl']),
                                    trailing: Icon(Icons.arrow_forward_rounded),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => scan_detail(
                                                    name:
                                                        data['name'].toString(),
                                                    quantity: data['quantity'],
                                                  )));
                                    },
                                  ),
                                );
                              }),
                        );
                      }
                    },
                  ),
                  /* ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManualInput()));
                      },
                      child: Text('Manual Input'))*/
                ],
              ),
            );
          },
        );
      },
    );
  }
}
