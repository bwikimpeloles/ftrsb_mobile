import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2c.dart';
import 'package:ftrsb_mobile/SalesScreen/order/product_details.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:ftrsb_mobile/model/user_model.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({Key? key}) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      
    });
  }

class _OrderSummaryState extends State<OrderSummary> {
  late DatabaseReference dbRefCustomer =
      FirebaseDatabase.instance.ref().child('Customer');

  late DatabaseReference dbRefPayment =
      FirebaseDatabase.instance.ref().child('PaymentB2C');

  late DatabaseReference dbRefOrder =
      FirebaseDatabase.instance.ref().child('OrderB2C');

  String? orderid = 'TEST123456';

  @override
  Widget build(BuildContext context) {

    //submit button
    final submitButton = Column(
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
                Map<String?, String?> customer = {
                  'name': cust.name,
                  'phone': cust.phone,
                  'address': cust.address,
                  'email': cust.email,
                  'channel': cust.channel
                };

                dbRefCustomer.push().set(customer);

                Map<String?, String?> paymentb2c = {
                  'paymentMethod': payc.paymentMethod.toString().substring(payc.paymentMethod.toString().indexOf('.') + 1),
                  'amount': payc.amount,
                  'paymentDate': payc.paymentDate,
                  'bankName': payc.bankName,
                  'paymentVerify': payc.paymentVerify,
                };

                dbRefPayment.push().set(paymentb2c);

                Map<String?, String?> orderb2c = {
                  'custName': cust.name,
                  'custPhone': cust.phone,
                  'custAddress': cust.address,
                  'paymentMethod': payc.paymentMethod.toString().substring(payc.paymentMethod.toString().indexOf('.') + 1),
                  'ID': orderid,
                  'amount': payc.amount,
                  'paymentDate': payc.paymentDate,
                  'bankName': payc.bankName,
                  'paymentVerify': payc.paymentVerify,
                  'salesStaff': user?.uid
                };

                dbRefOrder.push().set(orderb2c);

                Fluttertoast.showToast(msg: 'Order submitted');

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreenSales(),
                ));
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
    );

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      bottomNavigationBar: CurvedNavBar(
        indexnum: 2,
      ),
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Order Summary'),
        preferredSize: Size.fromHeight(65),
      ),
      body: Padding(
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
            Text('Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(payc.paymentMethod.toString().toString().substring(payc.paymentMethod.toString().indexOf('.') + 1).toUpperCase() + ' : ' + payc.bankName.toString(), style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Order ID : 346766SM',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Order Date : ' + payc.paymentDate.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Payment Date : ' + payc.paymentDate.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 20),
            Text('Order List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(product.name.toString() + ', ' + product.quantity.toString() + 'x ',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Order Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('RM ' + payc.amount.toString(), style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            submitButton
          ],
        ),
      ),
    );
  }
}
