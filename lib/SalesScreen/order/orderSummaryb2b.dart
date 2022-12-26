import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/product_details.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';

class OrderSummaryB2B extends StatefulWidget {
  const OrderSummaryB2B({Key? key}) : super(key: key);

  @override
  State<OrderSummaryB2B> createState() => _OrderSummaryB2BState();
}

User? user = FirebaseAuth.instance.currentUser;

class _OrderSummaryB2BState extends State<OrderSummaryB2B> {
  late DatabaseReference dbRefCustomer =
      FirebaseDatabase.instance.ref().child('Customer');

  late DatabaseReference dbRefPayment =
      FirebaseDatabase.instance.ref().child('PaymentB2B');

  late DatabaseReference dbRefOrder =
      FirebaseDatabase.instance.ref().child('OrderB2B');

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
                  'channel': cust.channel,
                  'salesStaff': user?.uid
                };

                dbRefCustomer.push().set(customer);

                Map<String?, String?> paymentb2b = {
                  'orderdate': payb.orderDate,
                  'amount': payb.amount,
                  'collectionDate': payb.collectionDate,
                  'pic': payb.pic,
                  'paymentStatus': payb.status,
                  'custname': cust.name,
                  'custphone': cust.phone,
                  'salesStaff': user?.uid
                };

                dbRefPayment.push().set(paymentb2b);

                Map<String?, String?> orderb2b = {
                  'custName': cust.name,
                  'custPhone': cust.phone,
                  'custAddress': cust.address,
                  'orderDate': payb.orderDate,
                  //'ID': orderid,
                  'amount': payb.amount,
                  'collectionDate': payb.collectionDate,
                  'pic': payb.pic,
                  'paymentStatus': payb.status,
                  'salesStaff': user?.uid
                };

                dbRefOrder.push().set(orderb2b);

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
            Text('Order Date : ' + payb.orderDate.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Collection Date : ' + payb.collectionDate.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Payment Status : ' + payb.status.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            //SizedBox(height: 20),
            //Text('Order ID : 346766SM',
            // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
            Text('RM ' + payb.amount.toString(),
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            submitButton
          ],
        ),
      ),
    );
  }
}
