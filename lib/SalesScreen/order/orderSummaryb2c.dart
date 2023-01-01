import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2c.dart';
import 'package:ftrsb_mobile/SalesScreen/order/product_details.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:intl/intl.dart';

class OrderSummaryB2C extends StatefulWidget {
  const OrderSummaryB2C({Key? key}) : super(key: key);

  @override
  State<OrderSummaryB2C> createState() => _OrderSummaryB2CState();
}

User? user = FirebaseAuth.instance.currentUser;

class _OrderSummaryB2CState extends State<OrderSummaryB2C> {
  late DatabaseReference dbRefCustomer =
      FirebaseDatabase.instance.ref().child('Customer');

  late DatabaseReference dbRefPayment =
      FirebaseDatabase.instance.ref().child('PaymentB2C');

  late DatabaseReference dbRefOrder =
      FirebaseDatabase.instance.ref().child('OrderB2C');

  String? orderid = 'TEST12345';

  PlatformFile? pickedFile;

  static const _chars ='AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random.secure();
  final now = DateTime.now();
  
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

    //submit button
    final submitButton = Expanded(
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
                  onPressed: () {
                    setState(() {
                      orderid = getRandomString(10);
                    });
                    Map<String?, String?> customer = {
                      'name': cust.name,
                      'phone': cust.phone,
                      'address': cust.address,
                      'email': cust.email,
                      'channel': cust.channel,
                      'salesStaff': user?.uid
                    };

                    if (cust.phone != null) {
                      dbRefCustomer.push().set(customer);
                    }

                    Map<String?, String?> paymentb2c = {
                      'paymentMethod': payc.paymentMethod.toString().substring(
                          payc.paymentMethod.toString().indexOf('.') + 1),
                      'amount': payc.amount,
                      'paymentDate': payc.paymentDate,
                      'bankName': payc.bankName,
                      'paymentVerify': payc.paymentVerify,
                      'custname': cust.name,
                      'custphone': cust.phone,
                      'salesStaff': user?.uid
                    };

                    if (payc.paymentMethod != null) {
                      dbRefPayment.push().set(paymentb2c);
                    }

                    Map<String, String?> orderb2c = {
                      'custName': cust.name,
                      'custPhone': cust.phone,
                      'custAddress': cust.address,
                      'paymentMethod': payc.paymentMethod.toString().substring(
                          payc.paymentMethod.toString().indexOf('.') + 1),
                      'orderID': dateStr + orderid.toString(),
                      'amount': payc.amount,
                      'paymentDate': payc.paymentDate,
                      'bankName': payc.bankName,
                      'paymentVerify': payc.paymentVerify,
                      'salesStaff': user?.uid,
                      
                    };

                    Future uploadFile() async{
                        final path = dateStr + orderid.toString()+'/${pickedFile!.name}';
                        final file = File(pickedFile!.path!);

                        Reference ref = FirebaseStorage.instance.ref().child(path);
                        ref.putFile(file);

                    }
                     
                    if (cust.phone != null && payc.paymentMethod != null) {
                      dbRefOrder.push().set(orderb2c);
                      uploadFile();
                      Fluttertoast.showToast(
                          msg: 'Order submitted',
                          gravity: ToastGravity.CENTER,
                          fontSize: 16.0);
                      setState(
                        () {},
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreenSales(),
                      ));
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
      bottomNavigationBar: CurvedNavBar(
        indexnum: 2,
      ),
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Order Summary'),
        preferredSize: const Size.fromHeight(65),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text("${user!.uid}"),
            const Text('Delivery Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(cust.name.toString(), style: TextStyle(fontSize: 16)),
            Text(cust.phone.toString(), style: TextStyle(fontSize: 16)),
            Text(cust.address.toString(), style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
                payc.paymentMethod
                        .toString()
                        .toString()
                        .substring(
                            payc.paymentMethod.toString().indexOf('.') + 1)
                        .toUpperCase() +
                    ' : ' +
                    payc.bankName.toString(),
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            //Text('Order ID : ' + date + orderid.toString(),
             //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Order Date : ' + payc.paymentDate.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Payment Date : ' + payc.paymentDate.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 20),
            Text('Order List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
                product.name.toString() +
                    ', ' +
                    product.quantity.toString() +
                    'x ',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Order Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('RM ' + payc.amount.toString(),
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
    );
  }
}
