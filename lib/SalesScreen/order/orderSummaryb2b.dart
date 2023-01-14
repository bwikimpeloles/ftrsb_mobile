import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/product_details.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:intl/intl.dart';

class OrderSummaryB2B extends StatefulWidget {
  const OrderSummaryB2B({Key? key}) : super(key: key);

  @override
  State<OrderSummaryB2B> createState() => _OrderSummaryB2BState();
}

User? user = FirebaseAuth.instance.currentUser;

class _OrderSummaryB2BState extends State<OrderSummaryB2B> {
  String? orderid = 'TEST12345';

  PlatformFile? pickedFile;

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random.secure();
  final now = DateTime.now();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  getProductlist() {
    List<String> list = [];
    print(list.toString());
    for (int i = 0; i < selectedProduct.length; i++) {
      list.add(selectedProduct[i].name.toString() +
          ":" +
          selectedProduct[i].quantity.toString());
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
//select file button
    String dateStr = DateFormat('yy-MM-dd').format(now).replaceAll('-', '');
    final selectFileButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        color: Colors.lightGreen,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: 10,
            onPressed: (() async {
              final resultFile = await FilePicker.platform.pickFiles();
              if (resultFile == null) return;

              setState(() {
                pickedFile = resultFile.files.first;
              });
            }),
            child: const Text(
              "Select File",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                //fontWeight: FontWeight.bold
              ),
            )));

    //Delete file button
    final deleteFileButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        color: Colors.red,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: 10,
            onPressed: (() {
              setState(() {
                pickedFile = null;
              });
            }),
            child: const Text(
              "Remove File",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                //fontWeight: FontWeight.bold
              ),
            )));

    //preview doc
    final previewDoc = Column(
      children: [
        if (pickedFile != null)
          SizedBox(
            child: Text(
              pickedFile!.name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
      ],
    );

    //preview product list
    final previewProductList = Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
        children: [
          SizedBox(
              child: Text(
            'Selected Product:',
            style: TextStyle(color: Colors.grey),
          )),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: selectedProduct.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                        title: Text(selectedProduct[index].name.toString(),
                            style: TextStyle(fontSize: 15.0)),
                        subtitle: Text(
                            'Qty: ' +
                                selectedProduct[index].quantity.toString(),
                            style: TextStyle(fontSize: 13.0)),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedProduct.removeAt(index);
                            });
                          },
                        ))),
              );
            },
          ),
        ],
      ),
    );

    //submit button
    final submitButton = Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(15),
              color: Colors.green,
              child: MaterialButton(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () async {
                    setState(() {
                      orderid = getRandomString(10);
                    });

                    Future<int> getOrderCount(String? phone) async {
                      var docs = await FirebaseFirestore.instance
                          .collection('OrderB2C')
                          .where('custPhone', isEqualTo: phone)
                          .get();
                      int count = docs.size;
                      return count;
                    }

                    int _count = await getOrderCount(cust.phone) + 1;

                    Map<String, dynamic> customer = {
                      'name': cust.name,
                      'phone': cust.phone,
                      'address': cust.address,
                      'email': cust.email,
                      'channel': cust.channel,
                      'salesStaff': user?.uid,
                      'count': _count
                    };

                    if (cust.name != null) {
                      FirebaseFirestore.instance
                          .collection('Customer')
                          .add(customer);
                    }

                    Map<String, dynamic> orderb2b = {
                      'custName': cust.name,
                      'custPhone': cust.phone,
                      'custAddress': cust.address,
                      'orderDate': payb.orderDate,
                      'orderID': dateStr + orderid.toString(),
                      'amount': payb.amount,
                      'collectionDate': Timestamp.fromDate(
                          DateFormat('dd-MM-yyyy h:mm:ssa', 'en_US').parseLoose(
                              '${DateFormat('dd-MM-yyyy').format((payb.collectionDate as Timestamp).toDate()).toString()} 10:00:00AM')),
                      'pic': payb.pic,
                      'paymentStatus': payb.status,
                      'salesStaff': user?.uid,
                      'product': getProductlist(),
                      'channel': cust.channel,
                    };

                    Future uploadFile() async {
                      final path =
                          dateStr + orderid.toString() + '/${pickedFile!.name}';
                      final file = File(pickedFile!.path!);

                      Reference ref =
                          FirebaseStorage.instance.ref().child(path);
                      ref.putFile(file);
                    }

                    if (cust.name != null && payb.pic != null) {
                      FirebaseFirestore.instance
                          .collection('OrderB2B')
                          .doc(dateStr + orderid.toString())
                          .set(orderb2b);
                      if (pickedFile != null) {
                        uploadFile();
                      }
                      Fluttertoast.showToast(
                          msg: 'Order submitted',
                          gravity: ToastGravity.CENTER,
                          fontSize: 16.0);
                      setState(
                        () {},
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => HomeScreenSales()),
                          (Route<dynamic> route) => false);
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Order submission failed!',
                        gravity: ToastGravity.CENTER,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      //bottomNavigationBar: CurvedNavBar(
      // indexnum: 1,
      //),
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Order Summary'),
        preferredSize: Size.fromHeight(65),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text("${user!.uid}"),
              Text('Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(cust.name.toString(), style: TextStyle(fontSize: 16)),
              Text(cust.phone.toString(), style: TextStyle(fontSize: 16)),
              Text(cust.address.toString(), style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text('Order Date : ' + payb.orderDate.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Collection Date : ' + payb.collectionDate.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Payment Status : ' + payb.status.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 20),
              Text('Order List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              previewProductList,
              SizedBox(height: 20),
              Text('Order Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('RM ' + payb.amount.toString(),
                  style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Column(
                  children: [
                    SizedBox(
                        child: Text(
                      'Upload Sales Document',
                      style: TextStyle(color: Colors.grey),
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        selectFileButton,
                        deleteFileButton,
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    previewDoc,
                  ],
                ),
              ),
              SizedBox(height: 20),
              submitButton
            ],
          ),
        ),
      ),
    );
  }
}
