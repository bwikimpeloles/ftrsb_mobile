import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/add_prospect.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/distrChannelList.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/order_history_b2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/order_history.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';

class CurvedNavBar extends StatelessWidget {
  int indexnum = 0;

  CurvedNavBar({required this.indexnum});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent, //Color.fromARGB(255, 147, 245, 198),
      color: Color.fromARGB(255, 103, 206, 113),
      animationDuration: Duration(milliseconds: 300),
      height: 50,
      index: indexnum,
      items: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text('B2C', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text('B2B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        )
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderHistory()));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderHistoryB2B()));
        }
      },
    );
  }
}
